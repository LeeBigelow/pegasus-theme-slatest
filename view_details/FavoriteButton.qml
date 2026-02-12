import QtQuick 2.0
// FavoriteButton: A clickable buttom for toggling game's favorite status
Rectangle {
    id: root
    anchors {
        left: parent.left
        right:  parent.right
    }
    focus: true
    height: detailsTextHeight
    color: activeFocus ? "black" :
        (favoriteButtonArea.containsMouse ? "black" : colorDarkBg)
    visible: currentGameIndex >= 0

    Image {
        anchors.centerIn: parent
        fillMode: Image.PreserveAspectFit
        source: currentGame.favorite ?
            "../images/assets/fav_filled.svg" : "../images/assets/fav_hollow.svg"
        sourceSize.height: detailsTextHeight
        height: vpx(20)
    }

    MouseArea {
        id: favoriteButtonArea
        anchors.fill: parent
        onClicked: toggleFavorite()
        hoverEnabled: true
    }

    // favoriteButton move focus
    KeyNavigation.tab: boxart
    Keys.onUpPressed: {
        if (currentGameIndex > 0) currentGameIndex--;
        gameList.forceActiveFocus();
    }
    Keys.onDownPressed: {
        if (currentGameIndex < gameList.count - 1) currentGameIndex++;
        gameList.forceActiveFocus();
    }
    Keys.onPressed: {
        if (event.isAutoRepeat) {
            return;
        } else if (api.keys.isAccept(event)) {
            event.accepted = true;
            toggleFavorite();
            return;
        } else if (api.keys.isDetails(event)) {
            event.accepted = true;
            launchButton.forceActiveFocus();
            return;
        }
    }
} // end favoriteButton rectangle
