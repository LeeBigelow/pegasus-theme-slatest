import QtQuick 2.0

FocusScope {
    id: root
    // Loading the fonts here makes them usable in the rest of the theme
    // and can be referred to using their name and weight.
    FontLoader { source: "fonts/OPENSANS.TTF" }
    FontLoader { source: "fonts/OPENSANS-LIGHT.TTF" }

    // Slate Colors
    property color clrDarkBg: "#404040"
    property color clrLightBg: "#6D6D6D"
    property color clrSemiDarkBg: "#555555"
    property color clrFocusedBg: "#7D7D7D"
    property color clrLightText: "#AFAFAF"
    // Default band colors if not in collections.js
    property color clrBand1: "#F6DD08"
    property color clrBand2: "#800000"
    property color clrBand3: "#FF0000"
    property color clrBand4: "#303030"

    // Custom collections models we can add to.
    // Filling extendedCollections happens in collectionsView.
    // It needs to be filled before being attached to a ListView or
    // you get incomplete views on start.
    ListModel { id: extendedCollections }
    FavoritesCollection { id: favoritesCollection }
    LastPlayedCollection { id: lastPlayedCollection }

    // The actual views are defined in their own QML files. They activate
    // each other by setting the focus. The details view is glued to the bottom
    // of the collections view, and the collections view to the bottom of the
    // screen for animation purposes (see below).
    CollectionsView {
        id: collectionsView
        anchors.bottom: parent.bottom

        // pass shared variables
        extendedCollections: extendedCollections
        favoritesCollection: favoritesCollection
        lastPlayedCollection: lastPlayedCollection

        clrDarkBg: root.clrDarkBg
        clrSemiDarkBg: root.clrSemiDarkBg
        clrLightBg: root.clrLightBg
        clrFocusedBg: root.clrFocusedBg
        clrLightText: root.clrLightText
        clrBand1: root.clrBand1
        clrBand2: root.clrBand2
        clrBand3: root.clrBand3
        clrBand4: root.clrBand4

        focus: true
        onCollectionSelected: detailsView.focus = true
    }

    DetailsView {
        id: detailsView
        anchors.top: collectionsView.bottom

        // pass shared variables
        currentCollection: collectionsView.currentCollection
        favoritesCollection: favoritesCollection
        lastPlayedCollection: lastPlayedCollection

        clrDarkBg: root.clrDarkBg
        clrSemiDarkBg: root.clrSemiDarkBg
        clrLightBg: root.clrLightBg
        clrFocusedBg: root.clrFocusedBg
        clrLightText: root.clrLightText
        clrBand1: root.clrBand1
        clrBand2: root.clrBand2
        clrBand3: root.clrBand3
        clrBand4: root.clrBand4

        onCancel: collectionsView.focus = true
        onNextCollection: {
            collectionsView.selectNext();
            detailsView.gameList.forceActiveFocus();
        }
        onPrevCollection: {
            collectionsView.selectPrev();
            detailsView.gameList.forceActiveFocus();
        }
        onLaunchGame: {
            api.memory.set('collectionIndex', collectionsView.currentCollectionIndex);
            api.memory.set('gameIndex', currentGameIndex);
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
