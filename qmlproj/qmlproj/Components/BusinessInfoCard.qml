// BusinessInfoCard.qml

import QtQuick 
import QtQuick.Controls
import QtQuick.Layouts 
import QtQuick.Controls.Material 
import "../Components" as UI

Item {

    signal goToBusinessInfo(string imageSource) 

    property string imageSource: ""

    Rectangle {
        anchors.fill: parent
        radius: 12
        color: '#c7dbf1'

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 15

            Text { text: "Whosickliethe comer a sling and makesoled"} // gibberish

            Image {
                source: imageSource
                fillMode: Image.PreserveAspectFit // prevents distortion
                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            UI.AppButton {
                text: "More Info"
                Layout.fillWidth: true
                onClicked: goToBusinessInfo(imageSource) // signal to navigate to business info page
            }
        }
    }
}