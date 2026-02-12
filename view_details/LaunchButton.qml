import QtQuick 2.0
// LaunchButton: A clickable button that launches the current game
Rectangle {
    id: root
    focus: true
    color: activeFocus ? "black" :
        (launchButtonArea.containsMouse ? "black" : colorDarkBg)
    height: vpx(30)
    // fixed width so games without art don't get a stretched launch button
    width: vpx(270)
    visible: currentGameIndex >= 0

    Text {
        anchors.centerIn: parent
        text: "LAUNCH"
        color: colorLightText
        font.family: "Open Sans"
        font.pixelSize: vpx(18)
        verticalAlignment: Text.AlignVCenter
    }

    MouseArea {
        id: launchButtonArea
        anchors.fill: parent
        onClicked: launchGame()
        hoverEnabled: true
    }

    // change game and focus gameList on up/down
    Keys.onUpPressed: {
        if (currentGameIndex > 0) currentGameIndex--;
        gameList.forceActiveFocus();
    }
    Keys.onDownPressed: {
        if (currentGameIndex < gameList.count - 1) currentGameIndex++;
        gameList.forceActiveFocus();
    }
    // Move focus on tab and details key (i)
    // launch game on accept
    KeyNavigation.tab: favoriteButton
    Keys.onPressed: {
        if (event.isAutoRepeat) {
            return;
        } else if (api.keys.isAccept(event)) {
            event.accepted = true;
            launchGame();
            return;
        } else if (api.keys.isDetails(event)) {
            event.accepted = true;
            descriptionScroll.forceActiveFocus();
            return;
        }
    }
}
