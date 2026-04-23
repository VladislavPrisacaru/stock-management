// ProductsPage.qml

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

            Text {text: "Browse Products"}

            Item { Layout.fillWidth: true}

            GridView {
                id: productGrid


                Layout.fillWidth: true
                Layout.fillHeight: true

                width: parent.width
                clip: true
                model: backend.products

                onCountChanged: console.log("GridView model count:", count)

                delegate: UI.ProductCard {
                    
                    width: productGrid.cellWidth * 0.9 // 90% of the cell width
                    height: productGrid.cellHeight * 0.9 // 90% of the cell height
                    name: modelData.productName
                    price: modelData.price
                    stock: modelData.stock
                    isAdmin: false
                    productId: modelData.productId
                }

                cellWidth: 250 
                cellHeight: 170

                ScrollBar.vertical: ScrollBar { }
            }

            Item { Layout.fillWidth: true}
        }
    }
}