// ordersPage.qml

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

            Text {text: "Your Orders"}

            Item { Layout.fillWidth: true}

            ListView {
                id: orderList

                Layout.fillWidth: true
                Layout.fillHeight: true

                width: parent.width
                clip: true
                model: backend.getOrders

                onCountChanged: console.log("orderList model count:", count)

                delegate: UI.OrderCard {
                    width: orderList.width
                    height: 100
                    orderId: modelData.orderId
                }

                ScrollBar.vertical: ScrollBar { }
            }
        }
    }
}