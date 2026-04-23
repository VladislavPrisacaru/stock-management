// profilePage.qml

import QtQuick 
import QtQuick.Controls 
import QtQuick.Layouts 
import "../Components" as UI 

Item { 

    signal goHome()

    Rectangle {
        
        anchors.centerIn: parent

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 15

            Label { text: "Profile"; }

            Label { text: "username: " + backend.username; }
            Label { text: "email: " + backend.email; }
    
            
            RowLayout {
                
                UI.AppButton {
                    btnText: "Log Out"
                    onClicked: {
                        backend.logOut()
                        goHome()
                    }
                }

                UI.AppButton {
                    btnText: "Become Admin"
                    onClicked: backend.becomeAdmin()
                }

                UI.AppButton {
                    btnText: "Delete Account"
                    onClicked: {
                         backend.deleteAccount()
                         goHome()
                    }
                }
            }
        }
    }
}