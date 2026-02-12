import QtQuick 2.0
import "view_collections"
import "view_details"
import "view_shared"

FocusScope {
    id: root
    // Slate Colors
    readonly property color colorDarkBg: "#404040"
    readonly property color colorLightBg: "#6D6D6D"
    readonly property color colorSemiDarkBg: "#555555"
    readonly property color colorFocusedBg: "#7D7D7D"
    readonly property color colorLightText: "#AFAFAF"
    readonly property color colorBand1: "#F6DD08"
    readonly property color colorBand2: "#800000"
    readonly property color colorBand3: "#FF0000"
    readonly property color colorBand4: "#303030"

    readonly property int defaultPadding: vpx(20)

    // Loading the fonts here makes them usable in the rest of the theme
    // and can be referred to using their name and weight.
    FontLoader { source: "fonts/OPENSANS.TTF" }
    FontLoader { source: "fonts/OPENSANS-LIGHT.TTF" }

    // Custom collections models we can add to.
    // extendedCollections ListModel won't hold item functions, will
    // need to reference them directly.
    // Fill extendedCollections before attaching to ListViews
    // to avoid incomplete views on start.
    // Auto collections defined in their own QML files.
    AllGamesCollection { id: allGamesCollection }
    FavoritesCollection { id: favoritesCollection }
    LastPlayedCollection { id: lastPlayedCollection }
    ListModel {
        id: extendedCollections
        Component.onCompleted: {
            // add old collections first so indexes match
            // then we can add to it
            for (var i = 0; i < api.collections.count; i++) {
                append(api.collections.get(i));
            }
            append(allGamesCollection);
            append(lastPlayedCollection);
            append(favoritesCollection);
            // attach model and restore saved position after it's filled
            collectionsView.attachModelsRestore();
        }
    }

    // The actual views are defined in their own QML files. They activate
    // each other by setting the focus. The details view is glued to the bottom
    // of the collections view, and the collections view to the bottom of the
    // screen for animation purposes (see below).
    CollectionsView {
        id: collectionsView
        anchors.bottom: parent.bottom

        focus: true
        onCollectionSelected: detailsView.focus = true
    }

    DetailsView {
        id: detailsView
        anchors.top: collectionsView.bottom

        onCancel: {
            filterBox.filterInput.text = "";
            collectionsView.focus = true
        }
        onNextCollection: {
            gameList.forceActiveFocus();
            filterBox.filterInput.text = "";
            currentGameIndex = 0;
            collectionsView.selectNext();
        }
        onPrevCollection: {
            gameList.forceActiveFocus();
            filterBox.filterInput.text = "";
            currentGameIndex = 0;
            collectionsView.selectPrev();
        }
        onLaunchGame: {
            api.memory.set('collectionIndex', collectionsView.currentCollectionIndex);
            api.memory.set('gameIndex', filteredSourceIndex);
            api.memory.set('boxartOrder', boxartOrder);
            currentGame.launch();
        }
        onToggleFavorite: {
            currentGame.favorite = !currentGame.favorite;
        }
    }

    // I animate the collection view's bottom anchor to move it to the top of
    // the screen. This, in turn, pulls up the details view.
    states: [
        State {
            when: detailsView.focus
            AnchorChanges {
                target: collectionsView;
                anchors.bottom: parent.top
            }
        }
    ]

    // Add some animations. There aren't any complex State definitions so I just
    // set a generic smooth anchor animation to get the job done.
    transitions: Transition {
        AnchorAnimation {
            duration: 400
            easing.type: Easing.OutQuad
        }
    }
}
