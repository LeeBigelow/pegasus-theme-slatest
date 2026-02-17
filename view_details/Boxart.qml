import QtQuick 2.0
// Boxart: Present game images that can be cycled through with a swipe or a click
Rectangle {
    id: root
    focus: true
    property int order: 0
    property var boxWidth: vpx(480)
    property var boxHeight: vpx(400)
    width: boxartImage.status === Image.Ready ? boxWidth : vpx(5)
    height: boxHeight
    color: activeFocus ? colorFocusedBg : "transparent"
    KeyNavigation.tab: gameList
    // move focus to gameList on boxart up/down
    Keys.onUpPressed: {
        if (currentGameIndex > 0) currentGameIndex--;
        gameList.forceActiveFocus();
    }
    Keys.onDownPressed: {
        if (currentGameIndex < gameList.count - 1) currentGameIndex++;
        gameList.forceActiveFocus();
    }
    Keys.onPressed: {
        if (api.keys.isAccept(event)) {
            // cycle art on boxart select
            event.accepted = true;
            (order < 2) ? order++ : order=0;
            return;
        } else if (api.keys.isDetails(event)) {
            event.accepted = true;
            favoriteButton.forceActiveFocus();
            return;
        }
    }

    MouseArea {
        // swipe gestures for box art
        // left, right, and double click switches art
        anchors.fill: parent
        property int startX
        onPressed: startX = mouse.x
        onReleased: {
            if (mouse.x - startX > vpx(50))
                (boxart.order < 2) ? boxart.order++ : boxart.order=0;
            else if (startX - mouse.x > vpx(50))
                (boxart.order > 0) ? boxart.order-- : boxart.order=2;
        }
        onClicked: boxart.forceActiveFocus()
        onDoubleClicked: (boxart.order < 2) ? boxart.order++ : boxart.order=0;
    }

    Image {
        id: boxartImage
        anchors.fill: parent
        anchors.margins: vpx(2)
        anchors.centerIn: parent
        // keep alternative images available when
        // switching art preference
        source: {
            switch (boxart.order) {
                case 0: return (
                    currentGame.assets.boxFront ||
                    currentGame.assets.screenshot ||
                    currentGame.assets.marquee
                );
                case 1: return (
                    currentGame.assets.screenshot ||
                    currentGame.assets.marquee ||
                    currentGame.assets.boxFront
                );
                case 2: return (
                    currentGame.assets.marquee ||
                    currentGame.assets.screenshot ||
                    currentGame.assets.boxFront
                );
            }
        }
        fillMode: Image.PreserveAspectFit
        sourceSize.width: boxart.boxWidth
        sourceSize.height: boxart.boxHeight
        width: sourceSize.width
        height: sourceSize.height
    }
}


