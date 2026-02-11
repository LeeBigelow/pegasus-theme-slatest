import QtQuick 2.7
import "../view_shared"
// DetailsFooter: help footer for DetailsView with clickable images
Rectangle {
    id: root
    height: vpx(40)
    color: "transparent"

    // Left/Right Collection Switch
    FooterImage {
        id: leftRightButton
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        imageSource: "images/assets/dpad_leftright.svg"
        imageLabel: "Collection Switch"
        opacity: switchHelpArea.containsMouse ? 1 : 0.45
        MouseArea {
            id: switchHelpArea
            // can also swipe header area
            anchors.fill: parent
            onClicked: nextCollection()
            hoverEnabled: true
        }
    }

    // Up/Down Scroll
    FooterImage {
        id: upDownButton
        anchors.left: leftRightButton.right
        anchors.bottom: parent.bottom
        imageSource: "images/assets/dpad_updown.svg"
        imageLabel: "Scroll"
    }

    // Select/Accept
    FooterImage {
        id: bButton
        anchors.left: upDownButton.right
        anchors.bottom: parent.bottom
        imageSource: "images/assets/button_b.svg"
        imageLabel: "Select"
        opacity: selectHelpArea.containsMouse ? 1 : 0.45
        MouseArea {
            id: selectHelpArea
            // can also double click game in list
            anchors.fill: parent
            onClicked: launchGame()
            hoverEnabled: true
        }
    }

    // Back
    FooterImage {
        id: aButton
        anchors.left: bButton.right
        anchors.bottom: parent.bottom
        imageSource: "images/assets/button_a.svg"
        imageLabel: "Back"
        opacity: backHelpArea.containsMouse ? 1 : 0.45
        MouseArea {
            id: backHelpArea
            // can also swipe down on header area
            anchors.fill: parent
            onClicked: cancel()
            hoverEnabled: true
        }
    }

    // Favorite
    FooterImage {
        id: xButton
        anchors.left: aButton.right
        anchors.bottom: parent.bottom
        imageSource: "images/assets/button_x.svg"
        imageLabel: "Toggle Favorite"
        opacity: favoriteHelpArea.containsMouse ? 1 : 0.45
        MouseArea {
            id: favoriteHelpArea
            anchors.fill: parent
            onClicked: toggleFavorite()
            hoverEnabled: true
        }
    }

    // Focus
    FooterImage {
        id: yButton
        anchors.left: xButton.right
        anchors.bottom: parent.bottom
        imageSource: "images/assets/button_y.svg"
        imageLabel: "Move Focus"
    }

    // Pegasus Settings
    FooterImage {
        // can swipe in from right to get pegasus settions
        // not sure how to trigger that with alternate mouse action?
        id: startButton
        anchors.left: yButton.right
        anchors.bottom: parent.bottom
        imageSource: "images/assets/button_start.svg"
        imageLabel: "Settings"
    }
}
