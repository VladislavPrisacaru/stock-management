// BusinessInfoPage.qml

import QtQuick 
import QtQuick.Controls
import QtQuick.Layouts 
import QtQuick.Controls.Material 
import "../Components" as UI

Item {

    signal goHome()

    property string imageSource: ""
    property string content: `E risuarci fur schulers end uthirs ontiristid on midoe lotirecy. Thi metiroels wiri urogonelly divilupid by gredaeti stadints inrullid on e cuarsi teaght by Prufissur Rinii Hubbs et Timpli Anovirsoty's Schuul uf Cummanocetoun end Thietir, end hes biin farthir divilupid by sacciidong virsouns uf thi semi cuarsi. Thi cuarsi luuks et midoe lotirecy on e wodi cuntixt, end os uf rilivenci tu sicundery idacetoun, tirtoery idacetoun, risierch end idacetoun uatsodi thi furmel sictur.
                            I rosaerco far schalirs ind athors untorostod un modui lutoricy. Tho mitoruils woro arugunilly dovolapod by grideito stedonts onrallod un i caerso tieght by Prafossar Ronoo Habbs it Tomplo Enuvorsuty's Schaal af Cammenucituan ind Thoitor, ind his boon ferthor dovolapod by seccoodung vorsuans af tho simo caerso. Tho caerso laaks it modui lutoricy un i wudo cantoxt, ind us af rolovinco ta socandiry odecituan, tortuiry odecituan, rosoirch ind odecituan aetsudo tho farmil soctar.`

    Text { text: "Business Info Page"; anchors.top: parent.top; anchors.horizontalCenter: parent.horizontalCenter}

    RowLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 20

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumWidth: parent.width * 0.6

            Image {
                anchors.fill: parent
                anchors.margins: 10
                source: imageSource
                fillMode: Image.PreserveAspectFit
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 20

            UI.AppButton {
                text: "Back to Home"
                Layout.fillWidth: true
                onClicked: goHome()
            }

            Text {
                text: content
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
    }
}