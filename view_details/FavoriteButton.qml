import QtQuick 2.0
import QtGraphicalEffects 1.12 // for coloring star
// FavoriteButton: A clickable buttom for toggling game's favorite status
Rectangle {
    id: root
    anchors {
        left: parent.left
    }
    // fixed width so games without art don't get a stetched favorite button
    width: vpx(140)
    focus: true
    height: detailsTextHeight
    color: activeFocus ? "black" :
        (favoriteButtonArea.containsMouse ? "black" : colorDarkBg)
    visible: currentGameIndex >= 0

    Image {
        id: favoriteStar
        anchors.centerIn: parent
        fillMode: Image.PreserveAspectFit
        source: currentGame.favorite ?
            "../images/assets/star_filled.svg" : "../images/assets/star_hollow.svg"
        sourceSize.height: detailsTextHeight
        height: vpx(20)
        asynchronous: true
    }

    ColorOverlay {
        anchors.fill: favoriteStar
        source: favoriteStar
        color: colorLightText
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
