// RegisterPage.qml

import QtQuick 
import QtQuick.Controls 
import QtQuick.Layouts 
import "../Components" as UI 

Item { 

    signal goToLogin()
    signal goToProfile()

    property string errorMessage: ""

    Rectangle {
        
        anchors.centerIn: parent

        ColumnLayout {
            anchors.centerIn: parent

            Text {text: "Register"}
            
            Label { // error message
                text: errorMessage
                color: "red"
                visible: errorMessage !== ""
            }

            UI.InputRow { id: usernameRow; labelText: "Username"} // labeled inputs
            UI.InputRow { id: emailRow; labelText: "Email:" }
            UI.InputRow { id: passwordRow; labelText: "Password:"; isPassword: true }
            UI.InputRow { id: confirmRow; labelText: "Confirm Password:"; isPassword: true }

            Item {Layout.fillHeight: true}

            RowLayout { 

                spacing: 30

                UI.AppButton { 
                    btnText: "Back" 
                    Layout.fillWidth: true 
                    onClicked: goToLogin()
                } 

                UI.AppButton { 
                    btnText: "Register" 
                    Layout.fillWidth: true 
                    onClicked: handleRegister()
                } 
            }
        }
    }

    function handleRegister() {
        
        try {
            if (!usernameRow.inputText || !emailRow.inputText || !passwordRow.inputText || !confirmRow.inputText) {
                console.log("All fields are required."); // if a field is empty, show error message and return
                errorMessage = "All fields are required"
                return;
            }
            
            if (passwordRow.inputText !== confirmRow.inputText) {
                console.log("Passwords do not match.");
                errorMessage = "Passwords do not match"
                return; 
            }

            if (backend.register(usernameRow.inputText, emailRow.inputText, passwordRow.inputText)) {
                if (backend.logIn(emailRow.inputText, passwordRow.inputText)) {
                    console.log("going profile") // if registration and login are successful, go to profile page
                    goToProfile()
                    errorMessage = ""
                    clearFields()
                }

            } else { 
                console.log("registration failed") 
                errorMessage = "User already exists"
            }

        } catch (err) {
            console.log(err)
        }      
    }

    function clearFields() {
        usernameRow.inputText = ""
        emailRow.inputText = "" 
        passwordRow.inputText = ""
        confirmRow.inputText = "" 
    }
}