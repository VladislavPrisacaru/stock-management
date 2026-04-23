// HomePage.qml

import QtQuick 
import QtQuick.Controls 
import QtQuick.Layouts 
import "../Components" as UI 

Item { 

    id: root

    signal goToBusinessInfo(string imageSource)

    Rectangle {
        anchors.fill: parent

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 10

            Text {text: "home page"; Layout.alignment: Qt.AlignHCenter}

            GridLayout {
                id: homeGrid
                Layout.alignment: Qt.AlignCenter
                Layout.fillWidth: true
                Layout.fillHeight: true
                columns: 3
                rowSpacing: 25
                columnSpacing: 40

                UI.BusinessInfoCard { imageSource: "../Images/farmpic.png"; width: 620; height: 520; onGoToBusinessInfo: function(imageSource) { root.goToBusinessInfo(imageSource) } }
                UI.BusinessInfoCard { imageSource: "../Images/farmpic2.png"; width: 620; height: 520; onGoToBusinessInfo: function(imageSource) { root.goToBusinessInfo(imageSource) } }
                UI.BusinessInfoCard { imageSource: "../Images/croppic.png"; width: 620; height: 520; onGoToBusinessInfo: function(imageSource) { root.goToBusinessInfo(imageSource) } }
                UI.BusinessInfoCard { imageSource: "../Images/cowspic.png"; width: 620; height: 520; onGoToBusinessInfo: function(imageSource) { root.goToBusinessInfo(imageSource) } }
                UI.BusinessInfoCard { imageSource: "../Images/shoppic.png"; width: 620; height: 520; onGoToBusinessInfo: function(imageSource) { root.goToBusinessInfo(imageSource) } }
                UI.BusinessInfoCard { imageSource: "../Images/farmpic.png"; width: 620; height: 520; onGoToBusinessInfo: function(imageSource) { root.goToBusinessInfo(imageSource) } }
            }
        }
    }
}