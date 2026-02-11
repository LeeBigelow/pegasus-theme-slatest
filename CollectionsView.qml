import QtQuick 2.0
import "collections.js" as CollectionsData // platform info and band colors
import "view_collections"
import "view_shared"

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
    // if system isn't in collections.js show the "DUMMY" empty system
    readonly property var collectionInfo:
        (CollectionsData.COLLECTIONS[currentCollection.shortName] === undefined) ?
            CollectionsData.COLLECTIONS["DUMMY"] :
            CollectionsData.COLLECTIONS[currentCollection.shortName]

    // called from theme.qml after custom ListModel filled
    function attachModelsRestore() {
        bgAxis.model = extendedCollections;
        logoAxis.model = extendedCollections;
        // restore saved settings
        currentCollectionIndex = api.memory.get('collectionIndex') || 0;
        detailsView.focus = true;
        // force redraw
        detailsView.gameList.forceLayout();
        if (extendedCollections.get(currentCollectionIndex).shortName == "auto-lastplayed") {
            // if lauched from lastplayed game will be at top of list on return
            detailsView.currentGameIndex = 0
        } else {
            detailsView.currentGameIndex = api.memory.get('gameIndex') || 0;
        }
        // scroll gameList to selection
        detailsView.gameList.positionViewAtIndex(detailsView.currentGameIndex, ListView.Center);
        detailsView.boxartOrder = api.memory.get('boxartOrder') || 0;
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

        // highlightMoveDuration: 500 // if it's moving a little bit slower than the main bar
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

            // controller
            Image {
                id: controllerImage
                anchors {
                    top: parent.top
                    topMargin: defaultPadding
                    right: colorBands.left
                    rightMargin: defaultPadding
                }
                fillMode: Image.PreserveAspectFit
                source: currentCollection.shortName ?
                    "images/controller/%1.svg".arg(currentCollection.shortName) : ""
                sourceSize.width: vpx(150)
                sourceSize.height: vpx(235)
                width: sourceSize.width
                height: sourceSize.height
                asynchronous: true
                horizontalAlignment: Image.AlignRight
                verticalAlignment: Image.AlignBottom
            }

            // console
            Image {
                id: consoleGameImage
                anchors {
                    top: parent.top
                    topMargin: defaultPadding
                    left: parent.left
                    leftMargin: defaultPadding
                    right: controllerImage.left
                    rightMargin: defaultPadding
                }
                fillMode: Image.PreserveAspectFit
                source: currentCollection.shortName ?
                    "images/consolegame/%1.svg".arg(currentCollection.shortName) : ""
                sourceSize.height: vpx(235)
                height: sourceSize.height
                asynchronous: true
                horizontalAlignment: Image.AlignLeft
                verticalAlignment: Image.AlignBottom
            }

        } // end Item
    } // end bgAxisItem scomponent

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

        // logoBar background
        Rectangle {
            anchors.fill: parent
            color: colorFocusedBg
            opacity: 0.85
        }

        // The main carousel that we actually control
        Carousel {
            id: logoAxis
            anchors.fill: parent
            itemWidth: vpx(480)
            focus: true

            model: undefined
            delegate: CollectionLogo {
                longName: model.name
                shortName: model.shortName
                MouseArea {
                    anchors.fill: parent
                    onClicked: collectionSelected()
                }
            }

            Keys.onPressed: {
                if (event.isAutoRepeat) {
                    return;
                } else if (api.keys.isNextPage(event)) {
                    event.accepted = true;
                    incrementCurrentIndex();
                } else if (api.keys.isPrevPage(event)) {
                    event.accepted = true;
                    decrementCurrentIndex();
                }
            }
            onItemSelected: collectionSelected()
        }
    }

    // Game count bar
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
            color: colorSemiDarkBg
            opacity: 0.85
        }

        Text {
            id: label
            anchors.centerIn: parent
            text: "%1 GAMES".arg(currentCollection.games.count)
            color: colorLightText
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
            bottom: footer.top
        }

        Text {
            id: collectionInfoLabel
            anchors.centerIn: parent
            text: collectionInfo.info.join("\n")
            color: colorLightText
            font.pixelSize: vpx(15)
            lineHeight: 0.8
            font.family: "Open Sans"
        }

        MouseArea {
            // swipe up on colleciton info area to switch to detailsView
            anchors.fill: parent
            property int startY
            onPressed: startY = mouse.y;
            onReleased: if (startY - mouse.y > vpx(100)) collectionSelected();
        }
    } // end collection info

    // Footer
    CollectionsFooter {
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
