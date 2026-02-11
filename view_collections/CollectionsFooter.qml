import QtQuick 2.0
import "../view_shared"
// CollectionsFooter: help footer for CollectionsView with clickable images
Rectangle {
    id: root
    anchors {
        bottom: parent.bottom
        left: parent.left
        leftMargin: defaultPadding
        right: parent.right
        rightMargin: defaultPadding
    }
    height: vpx(40)
    color: "transparent"

    FooterImage {
        id: leftRightButton
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        imageSource: "images/assets/dpad_leftright.svg"
        imageLabel: "Collection Switch"
        opacity: switchHelpArea.containsMouse ? 1 : 0.45
        MouseArea {
            id: switchHelpArea
            anchors.fill: parent
            onClicked: selectNext()
            hoverEnabled: true
        }
    }

    FooterImage {
        id: bButton
        anchors.left: leftRightButton.right
        anchors.bottom: parent.bottom
        imageSource: "images/assets/button_b.svg"
        imageLabel: "Select"
        opacity: selectHelpArea.containsMouse ? 1 : 0.45
        MouseArea {
            id: selectHelpArea
            anchors.fill: parent
            onClicked: collectionSelected()
            hoverEnabled: true
        }
    }

    FooterImage {
        // swiping in from right edge opens pegasus settings
        // not sure how to trigger that with a different mouse action
        id: startButton
        anchors.left: bButton.right
        anchors.bottom: parent.bottom
        imageSource: "images/assets/button_start.svg"
        imageLabel: "Settings"
    }
}
