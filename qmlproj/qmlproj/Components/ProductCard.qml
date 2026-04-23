// ProductCard.qml

import QtQuick 
import QtQuick.Controls
import QtQuick.Layouts 
import QtQuick.Controls.Material 
import "../Components" as UI

Item {
    id: wrapper
    
    property int productId: 0
    property string name: "" // product card variable properties
    property real price: 0
    property int stock: 0
    property bool isAdmin: true
    

    Rectangle {
        id: productCard
        anchors.fill: parent
        color: '#c7dbf1'
        radius: 8

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 10

            Text { text: "Name: " + wrapper.name; }
            Text { text: "Price: $" + wrapper.price.toFixed(2); }
            Text { text: "Stock: " + wrapper.stock; }

            RowLayout {

                spacing: 8

                UI.AppButton {
                    Layout.fillWidth: true
                    text: wrapper.isAdmin ? "Edit" : "Add to Cart" // changes button text based on user type
                    onClicked: {

                        let productExists = backend.productInCart(wrapper.productId) // check if the product is already in the cart

                        if (wrapper.isAdmin) {
                            productForm.mode = "Edit"
                            productForm.product = { productId: wrapper.productId, productName: wrapper.name, price: wrapper.price, stock: wrapper.stock }
                            productForm.visible = true

                        } else {
                            if (wrapper.stock > 0) {
                                if (productExists) {
                                    console.log("Product already in cart adding more quantity")
                                    backend.addItemCartQuantity(wrapper.productId, 1)
                                    return
                                } else {
                                    console.log("Adding to cart: " + wrapper.name + " (ID: " + wrapper.productId + ")" + typeof(wrapper.productId))
                                    backend.addToCart(wrapper.productId, 1) 
                                    
                                }
                                
                            } else {
                                console.log("Product out of stock")
                            } 
                        }
                    }
                }

                UI.AppButton {
                    Layout.fillWidth: true
                    text: "Delete"
                    visible: wrapper.isAdmin // only vissible to admin users
                    onClicked: {
                        backend.deleteProduct(wrapper.name)
                        console.log("Product deleted")
                    }
                }
            }
        }
    }
}