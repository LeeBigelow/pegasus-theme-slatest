import QtQuick 2.15 // note the version: Text padding is used below and that was added in 2.7 as per docs
import QtQuick.Controls 2.15
import "utils.js" as Utils // some helper functions
import "collections.js" as Collections // collection definitions

// The details "view". Consists of some images, a bunch of textual info and a game list.
FocusScope {
    id: root

    // set from theme.qml
    property var currentCollection
    property var favoritesCollection
    property var lastPlayedCollection
    property color clrDarkBg
    property color clrSemiDarkBg
    property color clrLightBg
    property color clrFocusedBg
    property color clrLightText
    property color clrBand1
    property color clrBand2
    property color clrBand3
    property color clrBand4


    property var collectionInfo: Collections.COLLECTIONS[currentCollection.shortName]

    // Shortcuts for the game list's currently selected game
    readonly property var gameList: gameList
    property alias currentGameIndex: gameList.currentIndex
    readonly property var currentGame: switch(currentCollection.shortName) {
        case "auto-lastplayed":
            return lastPlayedCollection.sourceGame(currentGameIndex);
        case "auto-favorites":
            return favoritesCollection.sourceGame(currentGameIndex);
        default:
            return currentCollection.games.get(currentGameIndex);
    }

    readonly property int padding: vpx(20)
    readonly property int halfPadding: vpx(10)
    readonly property int detailsTextHeight: vpx(30)

    // Nothing particularly interesting, see CollectionsView for more comments
    width: parent.width
    height: parent.height
    enabled: focus
    visible: y < parent.height

    signal cancel
    signal nextCollection
    signal prevCollection
    signal launchGame
    signal toggleFavorite

    // Key handling. In addition, pressing left/right also moves to the prev/next collection.
    Keys.onLeftPressed: prevCollection()
    Keys.onRightPressed: nextCollection()
    Keys.onPressed:
        if (event.isAutoRepeat) {
            return;
        } else if (api.keys.isAccept(event)) {
            event.accepted = true;
            launchGame();
            return;
        } else if (api.keys.isCancel(event)) {
            event.accepted = true;
            cancel();
            return;
        } else if (api.keys.isNextPage(event)) {
            event.accepted = true;
            nextCollection();
            return;
        } else if (api.keys.isPrevPage(event)) {
            event.accepted = true;
            prevCollection();
            return;
        } else if (api.keys.isFilters(event)) {
            event.accepted = true;
            toggleFavorite();
            return;
        } else if (api.keys.isPageUp(event)) {
            event.accepted = true;
            // don't go past first game
            if ( (currentGameIndex - 15) < 0 ) {
                currentGameIndex = 0;
            } else {
                currentGameIndex -= 15;
            }
            return;
        } else if (api.keys.isPageDown(event)) {
            event.accepted = true;
            // dont go past last game
            if ((currentGameIndex + 15) > (currentCollection.games.count - 1)) {
                currentGameIndex = (currentCollection.games.count - 1);
            } else {
                currentGameIndex += 15;
            }
            return;
        }


    Rectangle {
        // dark background
        width: root.width
        height: root.height
        // background
        anchors.fill: parent
        color: clrDarkBg
    }

    // bands
    Rectangle {
        id: band4
        anchors {
            top: parent.top
            bottom: parent.bottom
            right: parent.right
            rightMargin: vpx(80)
        }
        width: root.padding
        color: collectionInfo.colors[3] ?
            ("#" + collectionInfo.colors[3]) : crlBand4
    }

    Rectangle {
        id: band3
        anchors {
            top: parent.top
            bottom: parent.bottom
            right: band4.left
        }
        width: root.padding
        color: collectionInfo.colors[2] ?
            ("#" + collectionInfo.colors[2]) : clrBand3
    }

    Rectangle {
        id: band2
        anchors {
            top: parent.top
            bottom: parent.bottom
            right: band3.left
        }
        width: root.padding
        color: collectionInfo.colors[1] ?
            ("#" + collectionInfo.colors[1]) : clrBand2
    }

    Rectangle {
        id: band1
        anchors {
            top: parent.top
            bottom: parent.bottom
            right: band2.left
        }
        width: root.padding
        color: collectionInfo.colors[0] ?
            ("#" + collectionInfo.colors[0]) : clrBand1
    }

    //
    // Header
    //
    // The header bar on the top, with the collection's consolegame and controller on left and logo on right

    Rectangle {
        id: header
        anchors {
            top: parent.top
            right: band1.left
            left: parent.left
        }

        color: clrDarkBg
        height: vpx(115)

        Image {
            id: logo
            anchors {
                top: parent.top
                topMargin: root.padding
                right: parent.right
                rightMargin: root.padding
                bottom: parent.bottom
                bottomMargin: root.padding
            }
            fillMode: Image.PreserveAspectFit
            source: currentCollection.shortName ?
                "logo/%1.svg".arg(currentCollection.shortName) : undefined
            asynchronous: true
        }

        Image {
            id: consoleGame
            anchors {
                top: parent.top
                topMargin: root.padding
                left: parent.left
                leftMargin: root.padding
                bottom: parent.bottom
                bottomMargin: root.padding
            }
            fillMode: Image.PreserveAspectFit
            source: currentCollection.shortName ?
                "consolegame/%1.svg".arg(currentCollection.shortName) : ""
            asynchronous: true
        }

        Image {
            id: controller
            anchors {
                top: parent.top
                topMargin: root.padding
                left: consoleGame.right
                leftMargin: root.padding
                bottom: parent.bottom
                bottomMargin: root.padding
            }
            fillMode: Image.PreserveAspectFit
            source: currentCollection.shortName ?
                "controller/%1.svg".arg(currentCollection.shortName) : ""
            asynchronous: true
        }
    }

    //
    // Main content
    //
    Rectangle {
        // gamelist background
        id: gameListBg
        anchors {
            top: header.bottom
            left: parent.left
            leftMargin: root.padding
            bottom: footer.top
        }
        width: parent.width * 0.35
        height: parent.height
        color: clrLightBg
        opacity: 0.95


        ListView {
            id: gameList
            width: parent.width
            anchors.fill: parent
            focus: true

            model: currentCollection.games

            delegate: Rectangle {
                readonly property bool selected: ListView.isCurrentItem

                width: ListView.view.width
                height: gameTitle.height
                color:
                    if (selected) {
                        gameList.activeFocus ? "black" : "transparent";
                    } else {
                        return "transparent";
                    }

                Text {
                    id: gameTitle
                    text: (modelData.favorite ? "★" : "") + " " + modelData.title
                    color: parent.selected ? clrLightText : "black"

                    font.pixelSize: vpx(20)
                    font.capitalization: Font.AllUppercase
                    font.family: "Open Sans"
                    font.weight: Font.DemiBold

                    lineHeight: 1.2
                    verticalAlignment: Text.AlignVCenter

                    width: parent.width
                    elide: Text.ElideRight
                    leftPadding: vpx(10)
                    rightPadding: leftPadding
                }
            }

            clip: true
            highlightMoveDuration: 0
            highlightRangeMode: ListView.ApplyRange
            preferredHighlightBegin: height * 0.5 - vpx(15)
            preferredHighlightEnd: height * 0.5 + vpx(15)

            // toggle focus on tab and details key (i)
            KeyNavigation.tab: descriptionScroll
            Keys.onPressed:
                if (event.isAutoRepeat) {
                    return;
                } else if (api.keys.isDetails(event)) {
                    event.accepted = true;
                    descriptionScroll.forceActiveFocus();
                    return;
                }
        }
    }

    Rectangle {
        // art, details, description background
        anchors {
            top: header.bottom
            left: gameListBg.right
            leftMargin: root.padding
            right: parent.right
            rightMargin: root.padding
            bottom: footer.top
        }

        color: clrLightBg
        opacity: 0.95

        RatingBar {
            id: ratingBar

            anchors {
                left: parent.left
                leftMargin: root.halfPadding
                top: parent.top
                topMargin: root.halfPadding
            }

            percentage: currentGame.rating
        }

        Image {
            id: boxart
            anchors {
                top: ratingBar.bottom;
                topMargin: root.padding
                left: parent.left;
                leftMargin: root.padding
            }
            height: vpx(288)
            width: vpx(384)

            asynchronous: true
            // skyscraper screenshoot is nice mixed image 3:4 ratio
            source: currentGame.assets.screenshot ||
                    currentGame.assets.boxFront ||
                    currentGame.assets.logo ||
                    currentGame.assets.marquee
            sourceSize { width: vpx(400); height: vpx(400) } // optimization (max size)
            fillMode: Image.PreserveAspectFit
        }

        // While the game details could be a grid, I've separated them to two
        // separate columns to manually control the width of the second one below.
        Column {
            id: gameLabels
            anchors {
                top: boxart.top
                left: boxart.right;
                leftMargin: root.padding
            }

            GameInfoLabel { text: "Released:" }
            GameInfoLabel { text: "Developer:" }
            GameInfoLabel { text: "Publisher:" }
            GameInfoLabel { text: "Genre:" }
            GameInfoLabel { text: "Players:" }
            GameInfoLabel { text: "Last played:" }
            GameInfoLabel { text: "Play time:" }
        }

        Column {
            id: gameDetails
            anchors {
                top: gameLabels.top
                left: gameLabels.right
                leftMargin: root.padding
                right: parent.right
                rightMargin: root.padding
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
        }

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
            color: descriptionScroll.activeFocus ? clrFocusedBg : "transparent"
        }

        Flickable {
            id: descriptionScroll
            anchors {
                fill: descriptionBg
                topMargin: root.padding
                bottomMargin: root.padding
            }
            clip: true
            focus: true
            onFocusChanged: { contentY = 0; }
            contentWidth: descriptionBg.width
            contentHeight: gameDescription.height
            flickableDirection: Flickable.VerticalFlick

            Text {
                id: gameDescription
                leftPadding: root.padding
                rightPadding: root.padding
                text: currentGame.description
                wrapMode: Text.WordWrap
                width: descriptionScroll.width
                font.pixelSize: vpx(16)
                font.family: "Open Sans"
                font.weight: Font.DemiBold
                color: "black"
            }

            ScrollBar.vertical: ScrollBar {
                policy: descriptionScroll.activeFocus ? ScrollBar.AlwaysOn : ScrollBar.AsNeeded
            }

            // Keybindings for descriptionScroll
            // scroll description on up and down
            Keys.onUpPressed:
                // don't go past first line
                if ((contentY - 10) < 0) {
                    contentY = 0;
                } else {
                    contentY -= 10;
                }
            Keys.onDownPressed:
                // don't go past last screenfull
                if ((contentY + 10) > (gameDescription.height - height)) {
                    contentY = gameDescription.height - height;
                } else {
                    contentY += 10;
                }
            // Toggle focus on tab and details key (i)
            KeyNavigation.tab: gameList
            Keys.onPressed:
                if (event.isAutoRepeat) {
                    return;
                } else if (api.keys.isDetails(event)) {
                    event.accepted = true;
                    gameList.forceActiveFocus();
                    return;
                }
        }
    }

    Rectangle {
        id: footer
        anchors {
            bottom: parent.bottom
            left: parent.left
            leftMargin: root.padding
            right: parent.right
            rightMargin: root.padding
        }
        height: vpx(40)
        color: "transparent"

        FooterImage {
            id: leftRightButton
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            imageSource: "assets/dpad_leftright.svg"
            imageLabel: "Collection Switch"
        }

        FooterImage {
            id: upDownButton
            anchors.left: leftRightButton.right
            anchors.bottom: parent.bottom
            imageSource: "assets/dpad_updown.svg"
            imageLabel: "Scroll"
        }

        FooterImage {
            id: bButton
            anchors.left: upDownButton.right
            anchors.bottom: parent.bottom
            imageSource: "assets/button_b.svg"
            imageLabel: "Select"
        }

        FooterImage {
            id: aButton
            anchors.left: bButton.right
            anchors.bottom: parent.bottom
            imageSource: "assets/button_a.svg"
            imageLabel: "Back"
        }

        FooterImage {
            id: xButton
            anchors.left: aButton.right
            anchors.bottom: parent.bottom
            imageSource: "assets/button_x.svg"
            imageLabel: "Toggle Favorite"
        }

        FooterImage {
            id: yButton
            anchors.left: xButton.right
            anchors.bottom: parent.bottom
            imageSource: "assets/button_y.svg"
            imageLabel: "Toggle Focus"
        }

        FooterImage {
            id: startButton
            anchors.left: yButton.right
            anchors.bottom: parent.bottom
            imageSource: "assets/button_start.svg"
            imageLabel: "Settings"
        }
    }
}
