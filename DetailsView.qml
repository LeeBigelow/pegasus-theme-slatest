import QtQuick 2.15 // note the version: Text padding is used below and that was added in 2.7 as per docs
import SortFilterProxyModel 0.2
import "utils.js" as Utils // some helper functions
import "collections.js" as Collections // collection definitions

// The details "view". Consists of some images, a bunch of textual info and a game list.
FocusScope {
    id: root

    // Nothing particularly interesting, see CollectionsView for more comments
    width: parent.width
    height: parent.height
    enabled: focus
    visible: y < parent.height

    readonly property int padding: vpx(20)
    readonly property int detailsTextHeight: vpx(30)
    readonly property var collectionInfo: Collections.COLLECTIONS[currentCollection.shortName]
    property var currentCollection: collectionsView.currentCollection
    // for theme.qml access
    property alias filterText: filterInput.text
    property alias gameList: gameList
    property alias currentGameIndex: gameList.currentIndex
    property var filteredSourceIndex: filteredGames.mapToSource(currentGameIndex)
    readonly property var currentGame: {
        switch(currentCollection.shortName) {
            // extendedCollections ListModel can't hold item functions so need
            // to reference items directly.
            // "lastplayed" and "favorites" are self filtered so need their
            // item functions to get source game.
            case "auto-lastplayed":
                return lastPlayedCollection.sourceGame(filteredSourceIndex);
            case "auto-favorites":
                return favoritesCollection.sourceGame(filteredSourceIndex);
                // "all games" and original collection not self filtered so
                // can reference their games directly
            default:
                return currentCollection.games.get(filteredSourceIndex);
        }
    }

    SortFilterProxyModel {
        id: filteredGames
        sourceModel: currentCollection.games
        filters: RegExpFilter {
                roleName: "title"
                pattern: filterText
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
    Keys.onPressed: {
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
    } // end Keys.onPressed

    // dark background
    Rectangle {
        width: root.width
        height: root.height
        anchors.fill: parent
        color: colorDarkBg
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
            ("#" + collectionInfo.colors[3]) : colorBand4
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
            ("#" + collectionInfo.colors[2]) : colorBand3
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
            ("#" + collectionInfo.colors[1]) : colorBand2
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
            ("#" + collectionInfo.colors[0]) : colorBand1
    }

    //
    // Header
    //
    // The header bar on the top, with the collection's consolegame and
    // controller on left and logo on right
    Rectangle {
        id: header
        anchors {
            top: parent.top
            right: band1.left
            left: parent.left
        }


        color: colorDarkBg
        height: vpx(115)

        MouseArea {
            // swipe gestures for detailsView header
            // left and right swipe switches current collection
            // down swipe switches to collectionsView
            anchors.fill: parent
            property int startX
            property int startY
            onPressed: {
                startX = mouse.x;
                startY = mouse.y;
            }
            onReleased: {
                if (mouse.y - startY > vpx(100)) {
                    cancel();
                    return;
                }
                if (mouse.x - startX > vpx(50)) nextCollection();
                else if (startX - mouse.x > vpx(50)) prevCollection();
            }
        }

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
            sourceSize.height: parent.height
            sourceSize.width: parent.width / 3
            width: sourceSize.width
            height: sourceSize.height
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
            sourceSize.height: parent.height
            height: sourceSize.height
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
            sourceSize.height: parent.height
            height: sourceSize.height
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
            anchors.fill: parent
            focus: true

            model: filteredGames

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
                    color: parent.selected ? colorLightText : "black"

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

                MouseArea {
                    // gameList mouse actions
                    // focus on click, launch on double click
                    anchors.fill: parent
                    onClicked: {
                        gameList.currentIndex=index;
                        gameList.forceActiveFocus();
                    }
                    onDoubleClicked: launchGame()
                }
            } // end gameList delegate

            clip: true
            highlightMoveDuration: 0
            // highlightRangeMode: ListView.ApplyRange
            // preferredHighlightBegin: height * 0.5 - vpx(15)
            // preferredHighlightEnd: height * 0.5 + vpx(15)

            // focus filterInput on tab and details key (i)
            KeyNavigation.tab: filterInput
            Keys.onPressed: {
                if (event.isAutoRepeat) {
                    return;
                } else if (api.keys.isDetails(event)) {
                    event.accepted = true;
                    filterInput.forceActiveFocus();
                    return;
                }
            }
        } // end gameList ListView
    } // end gameListBg

    Item {
        // box for filterLabel and filterInput
        anchors {
            top: gameListBg.bottom
            topMargin: vpx(5)
            bottom: footer.top
            left: parent.left
            leftMargin: root.padding
        }
        width: gameListBg.width

        Text {
            id: filterLabel
            anchors {
                top: parent.top
                left: parent.left
                verticalCenter: parent.verticalCenter
            }
            verticalAlignment: Text.AlignVCenter
            font.family: "Open Sans"
            font.pixelSize: vpx(20)
            font.weight: Font.DemiBold
            color: colorLightBg
            text: "Filter:"
        }

        Rectangle {
            id: filterInputBg
            color: filterInput.activeFocus ? colorFocusedBg : colorLightBg
            anchors {
                top: parent.top
                left: filterLabel.right
                leftMargin: vpx(5)
                bottom: parent.bottom
                right: parent.right
            }

            TextInput {
                id: filterInput
                anchors {
                    fill: parent
                    leftMargin: vpx(5)
                    rightMargin: vpx(5)
                    verticalCenter: parent.verticalCenter
                }
                focus: true
                color: "black"
                font.family: "Open Sans"
                font.pixelSize: vpx(16)
                font.capitalization: Font.AllUppercase
                verticalAlignment: Text.AlignVCenter
                KeyNavigation.tab: descriptionScroll
                Keys.onUpPressed: {
                    if (currentGameIndex > 0) currentGameIndex--;
                    gameList.forceActiveFocus();
                }
                Keys.onDownPressed: {
                    if (currentGameIndex < gameList.count - 1) currentGameIndex++;
                    gameList.forceActiveFocus();
                }
                Keys.onPressed: {
                    if (event.isAutoRepeat) return;
                    if (event.key != Qt.Key_Tab && !api.keys.isDetails(event))
                        // keep game index on last item when typing so details refresh properly
                        // but dont move index when switching focus
                        currentGameIndex = gameList.count - 1;
                    if (event.key == Qt.Key_I) {
                        // catch i key so it doesn't shift focus as Details Key
                        event.accepted= true;
                        filterInput.insert(cursorPosition,"i");
                        return;
                    } else if (event.key == Qt.Key_Left && cursorPosition == 0) {
                        // catch left key to stop acidental collection switching
                        event.accepted=true;
                        return;
                    } else if (event.key == Qt.Key_Right && cursorPosition == text.length) {
                        // catch right key to stop acidental collection switching
                        event.accepted=true;
                        return;
                    } else if (api.keys.isDetails(event)) {
                        event.accepted = true;
                        descriptionScroll.forceActiveFocus();
                    }
                } // end Keys.onPressed
            } // end filterInput
        } // end filterInputBg
    } // end box for filterLabel and filterInput

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

        color: colorLightBg
        opacity: 0.95

        Rectangle {
            // need container to control boxart size
            id: boxart
            anchors {
                top: parent.top;
                topMargin: root.padding / 2
                left: parent.left;
                leftMargin: root.padding / 2
            }
            focus: true
            property var order: 0
            width: boxartImage.status === Image.Ready ? vpx(384) : vpx(5)
            height: vpx(288)
            color: activeFocus ? colorFocusedBg : "transparent"
            KeyNavigation.tab: gameList
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
                    event.accepted = true;
                    (order < 2) ? order++ : order=0;
                    return;
                } else if (api.keys.isDetails(event)) {
                    event.accepted = true;
                    gameList.forceActiveFocus();
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
                fillMode: Image.PreserveAspectFit
                // keep alternative images available when
                // switching art preference
                source:
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
                sourceSize.width: vpx(384)
                sourceSize.height: vpx(288)
                width: sourceSize.width
                height: sourceSize.height
            } // end boxartImage
        } // end baxart rectangle

        RatingBar {
            id: ratingBar
            anchors {
                top: parent.top
                topMargin: root.padding
                left: boxart.right
                leftMargin: root.padding
            }
            percentage: currentGame.rating
        }

        // While the game details could be a grid, I've separated them to two
        // separate columns to manually control the width of the second one below.
        Column {
            id: gameLabels
            anchors {
                top: ratingBar.bottom
                topMargin: root.padding / 2
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
            color: descriptionScroll.activeFocus ? colorFocusedBg : "transparent"
        }

        Flickable {
            id: descriptionScroll
            anchors {
                fill: descriptionBg
                topMargin: root.padding / 2
                bottomMargin: root.padding / 2
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
                horizontalAlignment: Text.AlignJustify
                width: descriptionScroll.width
                font.pixelSize: vpx(16)
                font.family: "Open Sans"
                font.weight: Font.DemiBold
                color: "black"
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
            KeyNavigation.tab: boxart
            Keys.onPressed: {
                if (event.isAutoRepeat) {
                    return;
                } else if (api.keys.isDetails(event)) {
                    event.accepted = true;
                    boxart.forceActiveFocus();
                    return;
                }
            }

            MouseArea {
                // just focus description on click
                anchors.fill: parent
                onClicked: descriptionScroll.forceActiveFocus()
            }
        } // end Flickable
    } // end art, details, description background

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
            MouseArea {
                // can also swipe header area
                anchors.fill: parent
                onClicked: nextCollection()
            }
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
            MouseArea {
                // can also double click game in list
                anchors.fill: parent
                onClicked: launchGame()
            }
        }

        FooterImage {
            id: aButton
            anchors.left: bButton.right
            anchors.bottom: parent.bottom
            imageSource: "assets/button_a.svg"
            imageLabel: "Back"
            MouseArea {
                // can also swipe down on header area
                anchors.fill: parent
                onClicked: cancel()
            }
        }

        FooterImage {
            id: xButton
            anchors.left: aButton.right
            anchors.bottom: parent.bottom
            imageSource: "assets/button_x.svg"
            imageLabel: "Toggle Favorite"
            MouseArea {
                anchors.fill: parent
                onClicked: toggleFavorite()
            }
        }

        FooterImage {
            id: yButton
            anchors.left: xButton.right
            anchors.bottom: parent.bottom
            imageSource: "assets/button_y.svg"
            imageLabel: "Toggle Focus"
        }

        FooterImage {
            // can swipe in from right to get pegasus settions
            // not sure how to trigger that with alternate mouse action?
            id: startButton
            anchors.left: yButton.right
            anchors.bottom: parent.bottom
            imageSource: "assets/button_start.svg"
            imageLabel: "Settings"
        }
    }
}
