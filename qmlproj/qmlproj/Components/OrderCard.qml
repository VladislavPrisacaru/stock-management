// orderCard.qml

import QtQuick 
import QtQuick.Controls
import QtQuick.Layouts 
import QtQuick.Controls.Material 
import "../Components" as UI

Item {
    property real orderId: 0
    property var order: backend.getOrderById(orderId) // fetches the order from the database using the id

    Rectangle {
        anchors.fill: parent
        height: 100
        width: parent.width

        Loader { // dynamically loads the product depending on the product id
            anchors.fill: parent
            active: order !== null
            sourceComponent: orderUI
        

            Component {
                id: orderUI

                RowLayout {
                    anchors.fill: parent

                    RowLayout {
                        
                        Layout.fillWidth: true


                        Text { text: "Order ID: " + order.orderId; Layout.fillWidth: true } // order details displayed
                        Text { text: "Total Price: $" + order.totalPrice; Layout.fillWidth: true }
                        Text { text: "Date: " + order.date; Layout.fillWidth: true }
                    }

                    Rectangle {
                        width: 140
                        height: 60
                        color: order.typeOfOrder === "Delivery" ? '#c04caf4f' : '#b52195f3' // green for delivery, blue for pickup
                        radius: 5

                        Text {
                            anchors.centerIn: parent
                            text: order.typeOfOrder
                            color: "white"
                            font.bold: true
                        }
                    }

                    Rectangle {
                        width: 140
                        height: 60
                        color: order.status === "Processing" ? '#c0e8e8f3' : order.status === "Shipped" ? '#c0b5e8f3' : '#c0a9e8f3' // different colors for different statuses
                        radius: 5

                        Text {
                            anchors.centerIn: parent
                            text: order.status
                            color: "black"
                            font.bold: true
                        }
                    }

                    UI.AppButton {
                        text: "Edit"
                        onClicked: {
                            // not implemented yet
                        }
                    }
                }
            }
        }
    }
}