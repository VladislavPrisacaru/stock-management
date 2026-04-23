# Database.py

import sqlite3
import bcrypt

class Database:
    def __init__(self, dbName):
        self.dbName = dbName
        self.connection = sqlite3.connect(self.dbName) # set up the database connection
        self.cursor = self.connection.cursor()
        self.createTables()
    
    def createTables(self):
        self.cursor.execute("""
            CREATE TABLE IF NOT EXISTS userAccount (
                userId INTEGER PRIMARY KEY AUTOINCREMENT,
                username STRING NOT NULL UNIQUE,
                email STRING NOT NULL UNIQUE,
                passwordHash BLOB NOT NULL,
                isAdmin BOOL NOT NULL
            );
        """)

        self.cursor.execute("""
            CREATE TABLE IF NOT EXISTS orders (
                orderId INTEGER PRIMARY KEY AUTOINCREMENT,
                userId INTEGER NOT NULL,
                totalPriceAtTime REAL NOT NULL,
                dateOfOrder STRING NOT NULL,
                typeOfOrder STRING NOT NULL,
                status STRING NOT NULL,
                FOREIGN KEY (userId) REFERENCES userAccount(userId) ON DELETE CASCADE
            );
        """)

        self.cursor.execute("""
            CREATE TABLE IF NOT EXISTS ordersProducts (
                orderProductsId INTEGER PRIMARY KEY AUTOINCREMENT,
                orderId INTEGER NOT NULL,
                productId INTEGER NOT NULL,
                quantity INTEGER NOT NULL,
                priceAtTime REAL NOT NULL,
                FOREIGN KEY (orderId) REFERENCES orders(orderId) ON DELETE CASCADE,
                FOREIGN KEY (productId) REFERENCES products(productId) ON DELETE CASCADE
            );
        """)
        
        self.cursor.execute("""
            CREATE TABLE IF NOT EXISTS products (
                productId INTEGER PRIMARY KEY AUTOINCREMENT,
                productName STRING NOT NULL UNIQUE,
                price REAL NOT NULL,
                stock INTEGER NOT NULL
            );
        """)

        self.cursor.execute("""
            CREATE TABLE IF NOT EXISTS cart (
                cartId INTEGER PRIMARY KEY AUTOINCREMENT,
                userId INTEGER NOT NULL,
                productId INTEGER NOT NULL,
                quantity INTEGER NOT NULL,
                FOREIGN KEY (userId) REFERENCES userAccount(userId) ON DELETE CASCADE,
                FOREIGN KEY (productId) REFERENCES products(productId) ON DELETE CASCADE
            );
        """)

        self.connection.commit()

    def createUser(self, username, email, password):
        try:
            hashedPassword = self.hashPassword(password) 
            self.cursor.execute( "INSERT INTO userAccount (username, email, passwordHash, isAdmin) VALUES (?, ?, ?, ?);", (username, email, hashedPassword, False) ) 
            self.connection.commit()
            return True # successfuly created the user
        except sqlite3.IntegrityError:
            return False
    
    def logInUser(self, email, password): 
        self.cursor.execute( "SELECT passwordHash FROM userAccount WHERE email = ?", (email,) ) 
        row = self.cursor.fetchone()

        if row is None: 
            return False 
        
        storedHash = row[0] 

        if self.verifyPassword(password, storedHash): # if submitted password matches the stored hash return true
            return True 
        
        return False
    
    def getUserDetails(self, email):
        self.cursor.execute( "SELECT userId, username, email, isAdmin FROM userAccount WHERE email = ?", (email,))
        row = self.cursor.fetchone()

        if row is None: 
            return False 
        
        return { "userId": row[0], "username": row[1], "email": row[2], "isAdmin": row[3]}
    
    def becomeAdmin(self, userId):
        self.cursor.execute( "UPDATE userAccount SET isAdmin = ? WHERE userId = ?", (True, userId) )
        self.connection.commit()

    def deleteUser(self, userId):
        self.cursor.execute( "DELETE FROM userAccount WHERE userId = ?", (userId,) )
        self.connection.commit()


    # products functions
    def createProduct(self, productName, price, stock):
        try:
            self.cursor.execute( "INSERT INTO products (productName, price, stock) VALUES (?, ?, ?);", (productName, price, stock) ) 
            self.connection.commit() 
            return True 
        except sqlite3.IntegrityError:
            print("Error creating product")
            return False
    
    def getProducts(self):
        self.cursor.execute( "SELECT productId, productName, price, stock FROM products" )
        rows = self.cursor.fetchall()

        products = []
        for row in rows:
            products.append({ "productId": row[0], "productName": row[1], "price": row[2], "stock": row[3] })
        
        return products
    
    def updateProduct(self, productId, newName, newPrice, newStock):
        try:
            self.cursor.execute( "UPDATE products SET productName = ?, price = ?, stock = ? WHERE productId = ?", (newName, newPrice, newStock, productId) )
            self.connection.commit()
            
             # Check if any rows were actually updated
            if self.cursor.rowcount == 0:
                print(f"No product found with ID: {productId}")
                return False
            
            print(f"Updated product: {newName}")
            return True
        except sqlite3.IntegrityError as e:
            print(f"IntegrityError: {e}")
            return False
        except Exception as e:
            print(f"Error updating product: {e}")
            return False
        
    def getProductById(self, productId):
        self.cursor.execute( "SELECT productId, productName, price, stock FROM products WHERE productId = ?", (productId,) )
        row = self.cursor.fetchone()

        if row is None:
            print(f"No product found with ID: {productId}")
            return None
        
        return { "productId": row[0], "productName": row[1], "price": row[2], "stock": row[3] }
    
    def deleteProduct(self, productId):
        self.cursor.execute( "DELETE FROM products WHERE productId = ?", (productId,))
        self.connection.commit()

    def subtractFromStock(self, productId, quantity):
        self.cursor.execute( "UPDATE products SET stock = stock - ? WHERE productId = ?", (quantity, productId) )
        self.connection.commit()

    def addToStock(self, productId, quantity):
        self.cursor.execute( "UPDATE products SET stock = stock + ? WHERE productId = ?", (quantity, productId) )
        self.connection.commit()

    def addToCart(self, userId, productId, quantity):
        self.cursor.execute( "INSERT INTO cart (userId, productId, quantity) VALUES (?, ?, ?);", (userId, productId, quantity) ) 
        self.connection.commit()
    
    def deleteFromCart(self, userId, productId):
        self.cursor.execute( "DELETE FROM cart WHERE userId = ? AND productId = ?", (userId, productId) )
        self.connection.commit()

    def productInCart(self, userId, productId):# can only be true or false
        try:
            self.cursor.execute(
                "SELECT COUNT(*) FROM cart WHERE userId = ? AND productId = ?",
                (userId, productId)
            )
            count = self.cursor.fetchone()[0]

            print(count > 0)
            
            return True if count > 0 else False

        except Exception as e:
            print(f"error: {e}")
            return False
        
    def addItemCartQuantity(self, userId, productId, quantity): 
        self.cursor.execute( "UPDATE cart SET quantity = quantity + ? WHERE userId = ? AND productId = ?", (quantity, userId, productId) )
        self.connection.commit()
    
    def subtractItemCartQuantity(self, userId, productId, quantity):
        self.cursor.execute( "UPDATE cart SET quantity = quantity - ? WHERE userId = ? AND productId = ?", (quantity, userId, productId) )
        self.connection.commit()

    def getCartItems(self, userId):
        self.cursor.execute( "SELECT productId, quantity FROM cart WHERE userId = ?", (userId,) )
        rows = self.cursor.fetchall()

        cartItems = []
        for row in rows:
            cartItems.append({ "productId": row[0], "quantity": row[1] })
        
        return cartItems

    def cartTotalPrice(self, userId):
        self.cursor.execute( """
            SELECT SUM(p.price * c.quantity) 
            FROM cart c 
            JOIN products p ON c.productId = p.productId 
            WHERE c.userId = ?;
        """, (userId,) )
        totalPrice = self.cursor.fetchone()[0]

        return totalPrice if totalPrice is not None else 0.0
    
    def clearCart(self, userId):
        self.cursor.execute( "DELETE FROM cart WHERE userId = ?", (userId,) )
        self.connection.commit()
 
    def placeOrder(self, userId, totalPrice, typeOfOrder):
        try:
            # create the order
            self.cursor.execute( "INSERT INTO orders (userId, totalPriceAtTime, dateOfOrder, typeOfOrder, status) VALUES (?, ?, datetime('now'), ?, ?);", (userId, totalPrice, typeOfOrder, "Pending") ) 
            orderId = self.cursor.lastrowid # get the id of the created order

            cartItems = self.getCartItems(userId)
            for item in cartItems:
                product = self.getProductById(item["productId"])
                # insert the cart items into the order
                self.cursor.execute( "INSERT INTO ordersProducts (orderId, productId, quantity, priceAtTime) VALUES (?, ?, ?, ?);", (orderId, item["productId"], item["quantity"], product["price"]) )

            self.connection.commit()
            print(f"Order placed with ID: {orderId} for userId: {userId}")
            return True
        except Exception as e:
            print(f"Error placing order: {e}")
            return False
    
    def getOrders(self, userId):
        self.cursor.execute( "SELECT orderId, totalPriceAtTime, dateOfOrder, typeOfOrder, status FROM orders WHERE userId = ?", (userId,) )
        rows = self.cursor.fetchall()

        orders = []
        for row in rows:
            orders.append({ "orderId": row[0], "totalPriceAtTime": row[1], "dateOfOrder": row[2], "typeOfOrder": row[3], "status": row[4] })
        
        return orders
    
    def getOrderById(self, orderId):
        self.cursor.execute( "SELECT orderId, totalPriceAtTime, dateOfOrder, typeOfOrder, status FROM orders WHERE orderId = ?", (orderId,) )
        row = self.cursor.fetchone()

        if row is None:
            print(f"No order found with ID: {orderId}")
            return None
        
        return { "orderId": row[0], "totalPriceAtTime": row[1], "dateOfOrder": row[2], "typeOfOrder": row[3], "status": row[4] }


    def hashPassword(self, password): 
        return bcrypt.hashpw(password.encode("utf-8"), bcrypt.gensalt()) 
    
    def verifyPassword(self, password, storedHash): 
        return bcrypt.checkpw(password.encode("utf-8"), storedHash)
    
