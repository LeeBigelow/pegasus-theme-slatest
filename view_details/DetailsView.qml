import QtQuick 2.7 // Text padding is used below, only added in 2.7
import SortFilterProxyModel 0.2
import "../view_details/utils.js" as Utils // some helper functions
import "../view_shared"

// The details "view". Consists of some images, a bunch of textual info and a game list.
FocusScope {
    id: root
    // Nothing particularly interesting, see CollectionsView for more comments
    width: parent.width
    height: parent.height
    enabled: focus
    visible: y < parent.height

    readonly property int detailsTextHeight: vpx(30)
    readonly property var collectionInfo: collectionsView.collectionInfo
    property var currentCollection: collectionsView.currentCollection
    // for theme.qml access
    property alias boxartOrder: boxart.order
    property alias gameList: gameList
    property alias filterBox: filterBox
    property alias currentGameIndex: gameList.currentIndex
    property var filteredSourceIndex: filteredGames.mapToSource(currentGameIndex)
    readonly property var currentGame: {
        if (filteredSourceIndex < 0) return emptyGame;
        switch(currentCollection.shortName) {
            case "auto-lastplayed":
            case "auto-favorites":
                // map from detailsView filter,
                // then the collection filter to get real index
                return api.allGames.get(currentCollection.games.mapToSource(filteredSourceIndex));
            default:
                // map from detailsView filter to get real colection index
                // the allgames collection is unfiltered api.allGames so can
                // also access directly
                return currentCollection.games.get(filteredSourceIndex);
        }
    }

    EmptyGame { id: emptyGame }

    SortFilterProxyModel {
        id: filteredGames
        sourceModel: currentCollection.games
        filters: RegExpFilter {
            roleName: "title"
            pattern: filterBox.filterInput.text
            caseSensitivity: Qt.CaseInsensitive
        }
    }

    signal cancel
    signal nextCollection
    signal prevCollection
    signal launchGame
    signal toggleFavorite

    // Key handling. In addition, pressing left/right also moves to the prev/next collection.
    Keys.onLeftPressed: prevCollection()
    Keys.onRightPressed: nextCollection()
    Keys.onPressed: switch (true) {
        case (event.isAutoRepeat): return;
        case (api.keys.isAccept(event)):   { event.accepted = true; launchGame(); return;}
        case (api.keys.isCancel(event)):   { event.accepted = true; cancel(); return; }
        case (api.keys.isNextPage(event)): { event.accepted = true; nextCollection(); return; }
        case (api.keys.isPrevPage(event)): { event.accepted = true; prevCollection(); return; }
        case (api.keys.isFilters(event)):  { event.accepted = true; toggleFavorite(); return; }
        case (api.keys.isPageUp(event)): {
            event.accepted = true;
            (currentGameIndex - 15) < 0 ?  currentGameIndex = 0 : currentGameIndex -= 15;
            return;
        }
        case (api.keys.isPageDown(event)): {
            event.accepted = true;
            (currentGameIndex + 15) > (currentCollection.games.count - 1) ?
                currentGameIndex = (currentCollection.games.count - 1) :
                currentGameIndex += 15;
            return;
        }
    } // end Keys.onPressed

    // Background
    Rectangle {
        width: root.width
        height: root.height
        anchors.fill: parent
        color: colorDarkBg
    }

    ColorBands {
        id: colorBands
        anchors {
            top: parent.top
            bottom: parent.bottom
            right: parent.right
            rightMargin: vpx(80)
        }
    }

    // Header
    // Collection's console and controller on left and logo on right
    DetailsHeader {
        id: header
        anchors {
            top: parent.top
            right: colorBands.left
            left: parent.left
        }
    }

    // Game List
    Rectangle {
        // gamelist background
        id: gameListBg
        anchors {
            top: header.bottom
            left: parent.left
            leftMargin: defaultPadding
            bottom: footer.top
            // space for filter box
            bottomMargin: vpx(30)
        }
        width: parent.width * 0.35
        height: parent.height
        color: colorLightBg
        opacity: 0.95

        ListView {
            id: gameList
            width: parent.width
            anchors {
                fill: parent
                margins: defaultPadding / 4
            }
            focus: true

            model: filteredGames
            delegate: GameListDelegate {}

            clip: true
            highlightMoveDuration: 0

            // move focus on tab and details key (i)
            KeyNavigation.tab: filterBox.filterInput
            Keys.onPressed: {
                if (event.isAutoRepeat) {
                    return;
                } else if (api.keys.isDetails(event)) {
                    event.accepted = true;
                    boxart.forceActiveFocus();
                    return;
                }
            }
        } // end gameList ListView
    } // end gameListBg

    // Game Filter
    Text {
        id: filterLabel
        anchors {
            top: gameListBg.bottom
            topMargin: defaultPadding / 4
            bottom: footer.top
            left: parent.left
            leftMargin: defaultPadding
        }
        verticalAlignment: Text.AlignVCenter
        font.family: "Open Sans"
        font.pixelSize: vpx(20)
        font.weight: Font.DemiBold
        color: colorLightBg
        text: "Filter:"
    }

    FilterBox {
        id: filterBox
        // has property alias filterInput for focus and text access
        anchors {
            top: gameListBg.bottom
            topMargin: defaultPadding / 4
            left: filterLabel.right
            leftMargin: defaultPadding / 4
            bottom: footer.top
            right: gameListBg.right
        }
    }

    // Details and Game Art
    Rectangle {
        // background for boxart, rating, details, and description
        anchors {
            top: header.bottom
            left: gameListBg.right
            leftMargin: defaultPadding
            right: parent.right
            rightMargin: defaultPadding
            bottom: footer.top
        }
        color: colorLightBg
        opacity: 0.95

        Boxart {
            id: boxart
            anchors {
                top: parent.top;
                topMargin: defaultPadding / 2
                left: parent.left;
                leftMargin: defaultPadding / 2
            }
        }

        RatingBar {
            id: ratingBar
            anchors {
                top: parent.top
                topMargin: defaultPadding
                left: boxart.right
                leftMargin: defaultPadding
            }
            percentage: currentGame.rating
        }

        // While the game details could be a grid, I've separated them to two
        // separate columns to manually control the width of the second one below.
        Column {
            id: gameLabels
            anchors {
                top: ratingBar.bottom
                topMargin: defaultPadding / 2
                left: boxart.right;
                leftMargin: defaultPadding
            }

            GameInfoLabel { text: "Released:" }
            GameInfoLabel { text: "Developer:" }
            GameInfoLabel { text: "Publisher:" }
            GameInfoLabel { text: "Genre:" }
            GameInfoLabel { text: "Players:" }
            GameInfoLabel { text: "Last played:" }
            GameInfoLabel { text: "Play time:" }
            GameInfoLabel { text: "Favorite:" }
        }

        Column {
            id: gameDetails
            anchors {
                top: gameLabels.top
                left: gameLabels.right
                leftMargin: defaultPadding / 2
                right: parent.right
                rightMargin: defaultPadding
            }

            // 'width' is set so if the text is too long it will be cut. I also use some
            // JavaScript code to make some text pretty.

            GameInfoText { text: Utils.formatDate(currentGame.release) || "unknown" }
            GameInfoText { text: currentGame.developer || "unknown" }
            GameInfoText { text: currentGame.publisher || "unknown" }
            GameInfoText { text: currentGame.genre || "unknown" }
            GameInfoText { text: Utils.formatPlayers(currentGame.players) }
            GameInfoText { text: Utils.formatLastPlayed(currentGame.lastPlayed) }
            GameInfoText { text: Utils.formatPlayTime(currentGame.playTime) }
            FavoriteButton { id: favoriteButton }
        } // end gameDetails column

        LaunchButton {
            id: launchButton
            anchors {
                top: gameLabels.bottom
                topMargin: defaultPadding / 2
                left: boxart.right
                leftMargin: defaultPadding
                right: parent.right
                rightMargin: defaultPadding
            }
        }

        //
        // Game Description
        //
        Rectangle {
            id: descriptionBg
            anchors {
                top: boxart.bottom
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }
            width: parent.contentWidth
            height: parent.contentHeight
            color: descriptionScroll.activeFocus ? colorFocusedBg : "transparent"
        }

        DescriptionScroll {
            id: descriptionScroll
            anchors {
                fill: descriptionBg
                topMargin: defaultPadding / 2
                bottomMargin: defaultPadding / 2
            }
        }
    } // end art, details, description background

    //
    // Help Footer
    //
    DetailsFooter {
        id: footer
        anchors {
            bottom: parent.bottom
            left: parent.left
            leftMargin: defaultPadding
            right: parent.right
            rightMargin: defaultPadding
        }
    }
}
