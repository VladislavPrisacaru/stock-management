// CartPage.qml

import QtQuick 
import QtQuick.Controls 
import QtQuick.Layouts 
import "../Components" as UI 

Item { 

    Rectangle {
        
        anchors.fill: parent

        ColumnLayout {
            anchors.centerIn: parent

            width: parent.width * 0.7 // 70% of the parent width
            height: parent.height * 0.8 // 80% of the parent height

            spacing: 20

            Text {text: "Your Cart"}

            Item { Layout.fillWidth: true}

            ListView {
                id: cartList


                Layout.fillWidth: true
                Layout.fillHeight: true

                width: parent.width
                clip: true
                model: backend.cartItems

                onCountChanged: console.log("cartView model count:", count)

                delegate: UI.CartProduct {
                    width: cartList.width
                    height: 100
                    productId: modelData.productId
                    quantity: modelData.quantity
                }

                ScrollBar.vertical: ScrollBar { }
            }

            RowLayout {
                Layout.fillWidth: true

                spacing: 10

                RadioButton {
                    id: deliveryOption
                    text: "Delivery"
                    checked: true

                }
                RadioButton {
                    id: collectionOption
                    text: "Collection"

                }

                Item { Layout.fillWidth: true }

                Text { text: "Total: $" + backend.cartTotalPrice.toFixed(2);  }
            }
 
            RowLayout { // not implemented yet
                Layout.fillWidth: true

                spacing: 40

                UI.AppButton {
                    text: "Place Order"
                    Layout.fillWidth: true
                    onClicked: {
                        if (backend.cartItems.length > 0) {
                            backend.placeOrder(deliveryOption.checked ? "Delivery" : "Collection")
                            console.log("placing the order")
                            backend.clearCart() // clear the cart after placing the order
                        } else {
                            console.log("Cart is empty, cannot checkout")
                        }
                    }
                }

                UI.AppButton {
                    text: "Clear Cart"
                    Layout.fillWidth: true
                    onClicked: {
                        backend.clearCart()
                    }
                }
            }

            Item { Layout.fillWidth: true}
        }
    }
}