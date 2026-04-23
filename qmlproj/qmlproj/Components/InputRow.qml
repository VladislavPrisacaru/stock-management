// InputForm.qml

import QtQuick 
import QtQuick.Controls 
import QtQuick.Layouts 

RowLayout {
                
    spacing: 10

    property alias labelText: label.text // access to the label and text
    property alias inputText: textField.text
    property bool isPassword: false

    Label { 
        id: label
        Layout.preferredWidth: 200
    }

    TextField {
        id: textField 
        Layout.fillWidth: true 
        echoMode: isPassword ? TextInput.Password : TextInput.Normal
    }
}