// AppButton.qml

import QtQuick 
import QtQuick.Controls 
import QtQuick.Layouts 
import QtQuick.Controls.Material 

Button {
    property string btnText: ""

    text: btnText

    Layout.preferredHeight: 80
    Layout.preferredWidth: 200

    Material.background: '#ffffff'

}