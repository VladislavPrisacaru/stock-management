# logic.py 

from PySide6.QtCore import QObject, Slot, Property, Signal

class Backend(QObject):

    userChanged = Signal()
    productsChanged = Signal()
    cartChanged = Signal()
    ordersChanged = Signal()

    def __init__(self, db):
        super().__init__()
        self.db = db
        self.currentUser = None
        self.currentUserId = self.currentUser["userId"] if self.currentUser else None
        # ^ be able to track the user by his id
    
    @Slot(str, str, str, result=bool) 
    def register(self, username, email, password): 
        return self.db.createUser(username, email, password) 
    
    @Slot(str, str, result=bool) 
    def logIn(self, email, password): 
        if self.db.logInUser(email, password):
            self.currentUser = self.db.getUserDetails(email)
            self.currentUserId = self.currentUser["userId"]
            self.userChanged.emit() # update the signals
            return True
        return False
    
    @Slot()
    def becomeAdmin(self):
        if self.currentUser:
            self.db.becomeAdmin(self.currentUserId)
            self.currentUser["isAdmin"] = True
            self.userChanged.emit() # update the signals to reflect the change in admin status

    @Slot()
    def logOut(self):
        self.currentUser = None
        self.userChanged.emit()

    @Slot()
    def deleteAccount(self):
        if self.currentUser:
            self.db.deleteUser(self.currentUserId) 
            self.logOut() # log out the user after deleting the account

    
    # products functions
    @Slot(str, float, int)
    def createProduct(self, name, price, stock):
        try:
            self.db.createProduct(name, price, stock)
            self.productsChanged.emit()
        except Exception as e:
            print(e)
    
    @Slot(int, str, float, int)
    def updateProduct(self, productId, newName, newPrice, newStock):
        try:
            self.db.updateProduct(productId, newName, newPrice, newStock)
            self.productsChanged.emit() # signal that the products are changed so it can update
        except Exception as e:
            print(e)
    
    @Slot(int)
    def deleteProduct(self, productId):
        self.db.deleteProduct(productId)
        self.productsChanged.emit()    

    @Slot(int, int)
    def subtractFromStock(self, productId, quantity): # used inside the cart
        self.db.subtractFromStock(productId, quantity) # subtract from stock without removing from cart
        self.productsChanged.emit()
    
    @Slot(int, int)
    def addToStock(self, productId, quantity): # used inside the cart
        self.db.addToStock(productId, quantity) # add to stock while in the cart
        self.productsChanged.emit()

    @Property('QVariant', notify=productsChanged) # qml list
    def products(self):
        products = self.db.getProducts()
        print("Products loaded:", len(products), products) # check whats being read from the db
        return products
    
    @Slot(int, result='QVariant')
    def getProductById(self, productId):
        return self.db.getProductById(productId)
    
    @Slot(int, int)
    def addToCart(self, productId, quantity):
        self.db.addToCart(self.currentUserId, productId, quantity)
        self.db.subtractFromStock(productId, quantity) # immediately subtract from stock when adding to cart
        self.cartChanged.emit() # signal that the cart is changed so it can update
        self.productsChanged.emit() # also update the products to reflect the change in stock
        return True
    
    @Slot(int)
    def removeFromCart(self, productId):
        cartItems = self.db.getCartItems(self.currentUserId)
        itemToRemove = next((item for item in cartItems if item["productId"] == productId), None)
        if itemToRemove:
            quantity = itemToRemove["quantity"] # get the quantity to add back to stock
            self.db.deleteFromCart(self.currentUserId, productId)
            self.db.addToStock(productId, quantity) # add back to stock when removing from cart
            self.cartChanged.emit() # signal that the cart is changed so it can update
            self.productsChanged.emit() # also update the products to reflect the change in stock

    @Slot(int, result=bool)
    def productInCart(self, productId): # can only be true or false
        return self.db.productInCart(self.currentUserId, productId)
    
    @Slot(int, int)
    def addItemCartQuantity(self, productId, quantity):
        try:
            cartItems = self.db.getCartItems(self.currentUserId)
            itemToUpdate = next((item for item in cartItems if int(item["productId"]) == productId), None) # find the item in the cart
            if itemToUpdate:
                self.db.addItemCartQuantity(self.currentUserId, productId, quantity) # add quantity to the cart item
                self.db.subtractFromStock(productId, quantity) 
                self.cartChanged.emit() # signal that the cart is changed so it can update
                self.productsChanged.emit() # also update the products to reflect the change in stock
        except Exception as e:
            print(f"Error adding item quantity: {e}")
    
    @Slot(int, int)
    def subtractItemCartQuantity(self, productId, quantity):
        cartItems = self.db.getCartItems(self.currentUserId)
        itemToUpdate = next((item for item in cartItems if int(item["productId"]) == productId), None) # find the item in the cart
        if itemToUpdate:
            self.db.subtractItemCartQuantity(self.currentUserId, productId, quantity) # subtract quantity from the cart item
            self.db.addToStock(productId, quantity) 
            self.cartChanged.emit() # signal that the cart is changed so it can update
            self.productsChanged.emit() # also update the products to reflect the change in stock
    
    @Property(float, notify=cartChanged)
    def cartTotalPrice(self):
        return self.db.cartTotalPrice(self.currentUserId)
    
    @Property('QVariant', notify=cartChanged) # qml list
    def cartItems(self):
        if not self.currentUser:
            return []
        cartItems = self.db.getCartItems(self.currentUserId)
        print("Cart items loaded:", len(cartItems), cartItems) # check whats being read from the db
        return cartItems
    
    @Slot()
    def clearCart(self):
        self.db.clearCart(self.currentUserId)
        self.cartChanged.emit() # signal that the cart is changed so it can update

    @Slot(str)
    def placeOrder(self, typeOfOrder):
        self.db.placeOrder(self.currentUserId, self.cartTotalPrice, typeOfOrder) # place the order with the current cart items and total price
        self.cartChanged.emit() # signal that the cart is changed so it can update
        self.ordersChanged.emit() # signal that the orders are changed so it can update
        print("Order placed for userId:", self.currentUserId)
    
    @Property('QVariant', notify=ordersChanged) # qml list
    def getOrders(self):
        if not self.currentUser:
            return []
        orders = self.db.getOrders(self.currentUserId)
        print("Orders loaded:", len(orders), orders) # check whats being read from the db
        return orders
    
    @Slot(int, result='QVariant')
    def getOrderById(self, orderId):
        return self.db.getOrderById(orderId)


    @Property(str, notify=userChanged)
    def username(self):
        return self.currentUser["username"] if self.currentUser else ""
    
    @Property(str, notify=userChanged)
    def email(self):
        return self.currentUser["email"] if self.currentUser else ""
    

    @Property(bool, notify=userChanged)
    def loggedIn(self):
        return bool(self.currentUser)
    
    @Property(bool, notify=userChanged)
    def isAdmin(self):
        return self.currentUser["isAdmin"] if self.currentUser else False

        
    