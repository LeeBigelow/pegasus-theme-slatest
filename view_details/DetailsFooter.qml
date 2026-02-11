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
        function imageAction() { nextCollection(); }
    }

    // Up/Down Scroll
    FooterImage {
        id: upDownButton
        anchors.left: leftRightButton.right
        anchors.bottom: parent.bottom
        imageSource: "images/assets/dpad_updown.svg"
        imageLabel: "Scroll"
        opacity: 0.45 // no need to scroll with button
    }

    // Select/Accept
    FooterImage {
        id: bButton
        anchors.left: upDownButton.right
        anchors.bottom: parent.bottom
        imageSource: "images/assets/button_b.svg"
        imageLabel: "Select"
        function imageAction() { launchGame(); }
    }

    // Back
    FooterImage {
        id: aButton
        anchors.left: bButton.right
        anchors.bottom: parent.bottom
        imageSource: "images/assets/button_a.svg"
        imageLabel: "Back"
        function imageAction() { cancel(); }
    }

    // Favorite
    FooterImage {
        id: xButton
        anchors.left: aButton.right
        anchors.bottom: parent.bottom
        imageSource: "images/assets/button_x.svg"
        imageLabel: "Toggle Favorite"
        function imageAction() { toggleFavorite(); }
    }

    // Focus
    FooterImage {
        id: yButton
        anchors.left: xButton.right
        anchors.bottom: parent.bottom
        imageSource: "images/assets/button_y.svg"
        imageLabel: "Move Focus"
        opacity: 0.45 // need to figure out how to trigger details button
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
        opacity: 0.45 // need to figure out how to trigger esc
    }
}
