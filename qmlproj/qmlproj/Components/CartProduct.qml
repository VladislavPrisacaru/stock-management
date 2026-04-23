// CartProduct.qml

import QtQuick 
import QtQuick.Controls
import QtQuick.Layouts 
import QtQuick.Controls.Material 
import "../Components" as UI

Item {
    property real productId: 0
    property real quantity: 0
    property var product: backend.getProductById(productId) // fetches the product from the database using the id

    Rectangle {
        anchors.fill: parent
        height: 100
        width: parent.width

        Loader { // dynamically loads the product depending on the product id
            anchors.fill: parent
            active: product !== null
            sourceComponent: productUI
        

            Component {
                id: productUI

                RowLayout {
                    anchors.fill: parent

                    spacing: 15

                    RowLayout {
                        
                        Layout.fillWidth: true

                        Text { text: "Product Name: " + product.productName; Layout.fillWidth: true } // product details displayed
                        Text { text: "Quantity: " + quantity; Layout.fillWidth: true }
                        Text { text: "Price: $" + (product.price * quantity).toFixed(2); Layout.fillWidth: true }
                    }

                    UI.AppButton {
                        text: "+"
                        onClicked: {
                            backend.addItemCartQuantity(productId, 1)
                        }
                    }

                    UI.AppButton {
                        text: "-"
                        onClicked: {
                            backend.addItemCartQuantity(productId, -1)
                        }
                    }

                    UI.AppButton {
                        text: "Remove"
                        onClicked: {
                            backend.removeFromCart(productId)
                        }
                    }
                }
            }
        }
    }
}