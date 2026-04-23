//Main.qml

import QtQuick 
import QtQuick.Controls 
import QtQuick.Layouts 
import QtQuick.Controls.Material 
import "Pages" as Pages


ApplicationWindow {
    id: mainWindow
    visible: true

    width: Screen.width    // full screen width
    height: Screen.height
    visibility: Window.Maximized

    Item {
        anchors.fill: parent

        Navbar { // define the navbar object
            id: navbar
            anchors.top: parent.top
        }

        StackView { // the widget to control the switching of the pages
            id: stack

            anchors.top: navbar.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            initialItem: Pages.HomePage {} // the starting page
        }
        Connections { // the connections that the app will have including the navbar connections
            target: navbar
            ignoreUnknownSignals: true

            // the navbar connections

            function onGoToLogin() {
                stack.push(Qt.resolvedUrl("Pages/LoginPage.qml"))
            }
            
            function onGoHome () {
                stack.pop(null)                
            }

            function onGoToOrders() {
                if (backend.loggedIn) {
                    stack.push(Qt.resolvedUrl("Pages/OrdersPage.qml"))
                }
                else {
                    stack.push(Qt.resolvedUrl("Pages/LoginPage.qml"))
                }
            }

            function onGoToProducts() {
                stack.push(Qt.resolvedUrl("Pages/ProductsPage.qml"))
            }

            function onGoToDashboard() {
                if (backend.loggedIn && backend.isAdmin) {
                    stack.push(Qt.resolvedUrl("Pages/DashboardPage.qml"))
                }
                else {
                    stack.push(Qt.resolvedUrl("Pages/LoginPage.qml"))
                }
            }

            function onGoToCart() {
                if (backend.loggedIn) { // if not logged in sen the user to log in
                    stack.push(Qt.resolvedUrl("Pages/CartPage.qml"))
                }
                else {
                    stack.push(Qt.resolvedUrl("Pages/LoginPage.qml"))
                }
            }

            function onGoToProfile() {
                if (backend.loggedIn) {
                    stack.push(Qt.resolvedUrl("Pages/ProfilePage.qml"))
                }
                else {
                    stack.push(Qt.resolvedUrl("Pages/LoginPage.qml"))
                }
            }
        }

        Connections { // on page connections
            target: stack.currentItem
            ignoreUnknownSignals: true

            function onGoToRegister() {
                stack.push(Qt.resolvedUrl("Pages/RegisterPage.qml"))
            }

            function onGoToLogin() {
                stack.pop()
            }

            function onGoToProfile() {
                stack.push(Qt.resolvedUrl("Pages/ProfilePage.qml"))
            }

            function onGoToBusinessInfo(imageSource) {
                var page = stack.push(Qt.resolvedUrl("Pages/BusinessInfoPage.qml"))
                if (page)
                    page.imageSource = imageSource
            }

            function onGoHome () {
                stack.pop(null)                
            }
        }
    }
} 