// LoginPage.qml

import QtQuick 
import QtQuick.Controls 
import QtQuick.Layouts 
import "../Components" as UI 

Item { 

    signal goToRegister()
    signal goToLogin()
    signal goToProfile()
    signal goHome()

    property string errorMessage: ""

    Rectangle {
        
        anchors.centerIn: parent

        ColumnLayout {
            anchors.centerIn: parent

            Text {text: "login page"}

            Label {
                text: errorMessage
                color: "red"
                visible: errorMessage !== ""
            }

            UI.InputRow { id: emailRow; labelText: "Email:" } // labeled inputs
            UI.InputRow { id: passwordRow; labelText: "Password:"; isPassword: true }

            Item {Layout.fillHeight: true}

            RowLayout {

                spacing: 30

                UI.AppButton {

                    btnText: "Register"
                    Layout.fillWidth: true
                    onClicked: {
                        goToRegister()
                        clearFields()
                    }
                }

                UI.AppButton {

                    btnText: "Log In"
                    Layout.fillWidth: true
                    onClicked: handleLogin()
                }
            }
        }
    }

    function handleLogin() {
        try {        

            if (backend.logIn(emailRow.inputText, passwordRow.inputText)) {
                console.log("going profile") // if login is successful, go to profile page
                goHome()
                errorMessage = ""
                clearFields()

            } else {
                console.log("login failed")
                errorMessage = "email or password are wrong"
            }

        } catch (err) {
            console.log(err)
        }
    }

    function clearFields() {
        emailRow.inputText = "" 
        passwordRow.inputText = ""
    }  
}