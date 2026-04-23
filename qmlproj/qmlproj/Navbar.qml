// NavBar.qml

import QtQuick 
import QtQuick.Controls
import QtQuick.Layouts 
import QtQuick.Controls.Material 
import "Components" as UI

Item { 

    // navigation functions
    signal goToRegister()
    signal goToLogin()
    signal goToProfile()

    signal goHome()
    signal goToOrders()
    signal goToProducts()
    signal goToCart()
    signal goToDashboard()

    height: parent.height * 0.1
    width: parent.width

    Rectangle {
        anchors.fill: parent

        color: "#3F51B5"

        RowLayout {
            id: navbar

            anchors.fill: parent
            spacing: parent.width * 0.012
            anchors.margins: parent.width * 0.005
            anchors.rightMargin: parent.width * 0.015
            anchors.leftMargin: parent.width * 0.01

            Image { // logo
                Layout.fillHeight: true  
                Layout.alignment: Qt.AlignVCenter
                source: "Images/glhlogo.png"
                Layout.preferredHeight: parent.height * 0.8
                Layout.preferredWidth: parent.width * 0.05
            }

            Item { Layout.fillWidth: true} // space between the logo and buttons

            // buttons with linked connections

            UI.AppButton {
                btnText: "Home"
                onClicked: goHome()
            }

            UI.AppButton {
                btnText: "Orders"
                onClicked: goToOrders()
            }

            UI.AppButton {
                btnText: "Products"
                onClicked: goToProducts()
            }

            UI.AppButton {
                btnText: "Cart"
                onClicked: goToCart()
            }
            
            UI.AppButton {
                btnText: "Dashboard"
                visible: backend.isAdmin && backend.loggedIn // only show dashboard button if user is admin and logged in 
                onClicked: goToDashboard()
            }

            Item { Layout.fillWidth: true} // created space between the main buttons and the profile

            // changes the button depending where the user is logged in or not
            UI.AppButton {
                btnText: backend.loggedIn ? "Profile" : "Log In" 
                onClicked:  backend.loggedIn ? goToProfile() : goToLogin()
            }
        }
    }
}