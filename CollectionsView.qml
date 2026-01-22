import QtQuick 2.0
import "collections.js" as Collections // collection definitions

// The collections view consists of two carousels, one for the collection logo bar
// and one for the background images. They should have the same number of elements
// to be kept in sync.
FocusScope {
    id: root

    // This element has the same size as the whole screen (ie. its parent).
    // Because this screen itself will be moved around when a collection is
    // selected, I've used width/height instead of anchors.
    width: parent.width
    height: parent.height
    enabled: focus // do not receive key/mouse events when unfocused
    visible: y + height >= 0 // optimization: do not render the item when it's not on screen

    signal collectionSelected

    // Shortcut for the currently selected collection. They will be used
    // by the Details view too, for example to show the collection's logo.
    property alias currentCollectionIndex: logoAxis.currentIndex
    readonly property var currentCollection: logoAxis.model.get(logoAxis.currentIndex)
    property var collectionInfo: Collections.COLLECTIONS[currentCollection.shortName]

    // set from theme.qml
    property var extendedCollections
    property var lastPlayedCollection
    property var favoritesCollection

    readonly property int padding: vpx(20)

    Component.onCompleted: {
        // clone collections so we can add to it
        for (var i = 0; i < api.collections.count; i++) {
            extendedCollections.append(api.collections.get(i));
        }
        extendedCollections.append(lastPlayedCollection);
        extendedCollections.append(favoritesCollection);
        // only attach model after it's filled
        bgAxis.model = extendedCollections;
        logoAxis.model = extendedCollections;
        // When the theme loads, try to restore the last selected game
        currentCollectionIndex = api.memory.get('collectionIndex') || 0;
        if (extendedCollections.get(currentCollectionIndex).shortName == "auto-lastplayed") {
            // if lauched from lastplayed game will be at top of list on return
            detailsView.currentGameIndex = 0
        } else {
            detailsView.currentGameIndex = api.memory.get('gameIndex') || 0;
        }
        detailsView.focus = true;
    } 



    // These functions can be called by other elements of the theme if the collection
    // has to be changed manually. See the connection between the Collection and
    // Details views in the main theme file.
    function selectNext() {
        logoAxis.incrementCurrentIndex();
    }

    function selectPrev() {
        logoAxis.decrementCurrentIndex();
    }

    // The carousel of background images. This isn't the item we control with the keys,
    // however it reacts to mouse and so should still update the Index.
    Carousel {
        id: bgAxis

        anchors.fill: parent
        itemWidth: width

        model: undefined
        delegate: bgAxisItem
        currentIndex: logoAxis.currentIndex

        // highlightMoveDuration: 500 // it's moving a little bit slower than the main bar
    }

    Component {
        // Either the image for the collection or a single colored rectangle
        id: bgAxisItem

        Item {
            width: root.width
            height: root.height
            visible: PathView.onPath // optimization: do not draw if not visible

            // background
            Rectangle {
                anchors.fill: parent
                color: "#404040"
            }

            Item {
                id: hiddenBar
                anchors {
                    left: parent.left
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }
                height: vpx(170)
                visible: false
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
                    ("#" + collectionInfo.colors[3]) : "#303030"
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
                    ("#" + collectionInfo.colors[2]) : "#FF0000"
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
                    ("#" + collectionInfo.colors[1]) : "#800000"
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
                    ("#" + collectionInfo.colors[0]) : "#F6DD08"
            }

            // controller
            Image {
                id: controllerImage
                anchors {
                    top: parent.top
                    topMargin: root.padding
                    right: band1.left
                    rightMargin: root.padding
                    bottom: hiddenBar.top
                    bottomMargin: root.padding
                }
                fillMode: Image.PreserveAspectFit
                source: model.shortName ? "controller/%1.svg".arg(model.shortName) : ""
                asynchronous: true
            }

            // console + game
            Image {
                id: consoleGameImage
                anchors {
                    top: parent.top
                    topMargin: root.padding
                    left: parent.left
                    leftMargin: root.padding
                    bottom: hiddenBar.top
                    bottomMargin: root.padding
                    right: controllerImage.left
                }
                fillMode: Image.PreserveAspectFit
                source: model.shortName ? "consolegame/%1.svg".arg(model.shortName) : ""
                asynchronous: true
                sourceSize.height: 1024
                horizontalAlignment: Image.AlignLeft
            }
        }
    }

    // I've put the main bar's parts inside this wrapper item to change the opacity
    // of the background separately from the carousel. You could also use a Rectangle
    // with a color that has alpha value.
    Item {
        id: logoBar
        anchors {
            left: parent.left
            right: parent.right
            verticalCenter: parent.verticalCenter
        }
        height: vpx(170)

        // Background
        Rectangle {
            anchors.fill: parent
            color: "#747474"
            opacity: 0.85
        }

        // The main carousel that we actually control
        Carousel {
            id: logoAxis

            anchors.fill: parent
            itemWidth: vpx(480)

            model: undefined
            delegate: CollectionLogo {
                longName: model.name
                shortName: model.shortName
            }

            focus: true

            Keys.onPressed: {
                if (event.isAutoRepeat)
                    return;

                if (api.keys.isNextPage(event)) {
                    event.accepted = true;
                    incrementCurrentIndex();
                }
                else if (api.keys.isPrevPage(event)) {
                    event.accepted = true;
                    decrementCurrentIndex();
                }
            }

            onItemSelected: root.collectionSelected()
        }
    }

    // Game count bar -- like above, I've put it in an Item to separately control opacity
    Item {
        id: gameCountBar
        anchors {
            left: parent.left
            right: parent.right
            top: logoBar.bottom
        }
        height: label.height * 1.5

        Rectangle {
            anchors.fill: parent
            color: "#555"
            opacity: 0.85
        }

        Text {
            id: label
            anchors.centerIn: parent
            text: "%1 GAMES".arg(currentCollection.games.count)
            color: "#c6c6c6"
            font.pixelSize: vpx(25)
            font.family: "Open Sans"
        }
    }

    // Collection Info section
    Item {
        anchors {
            left: parent.left
            right: parent.right
            top: gameCountBar.bottom
            bottom: parent.bottom
        }

        Text {
            id: collectionInfoLabel
            anchors.centerIn: parent
            text: collectionInfo.info.join("\n")
            color: "#b6b6b6"
            font.pixelSize: vpx(12)
            font.family: "Open Sans"
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
        color: "#00000000"

        FooterImage {
            id: leftRightButton
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            imageSource: "assets/dpad_leftright.svg"
            imageLabel: "Collection Switch"
        }

        FooterImage {
            id: bButton
            anchors.left: leftRightButton.right 
            anchors.bottom: parent.bottom
            imageSource: "assets/button_b.svg"
            imageLabel: "Select"
        }

        FooterImage {
            id: startButton
            anchors.left: bButton.right
            anchors.bottom: parent.bottom
            imageSource: "assets/button_start.svg"
            imageLabel: "Settings"
        }
    }
}
