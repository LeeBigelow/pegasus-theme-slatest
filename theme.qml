import QtQuick 2.0

FocusScope {
    id: root
    // Loading the fonts here makes them usable in the rest of the theme
    // and can be referred to using their name and weight.
    FontLoader { source: "fonts/OPENSANS.TTF" }
    FontLoader { source: "fonts/OPENSANS-LIGHT.TTF" }

    // Custom collections models we can add to.
    // Defined here and shared with CollectionsView and DetailsView
    // Filled in CollectionsView before being attached to ListViews
    // to avoid incomplete views on start.
    ListModel { id: extendedCollections }
    ListModel { id: allGamesCollection
        readonly property var name: "All Games"
        readonly property var shortName: "auto-allgames"
        readonly property var games: api.allGames
    }
    // auto collections defined in their own QML files.
    FavoritesCollection { id: favoritesCollection }
    LastPlayedCollection { id: lastPlayedCollection }

    // The actual views are defined in their own QML files. They activate
    // each other by setting the focus. The details view is glued to the bottom
    // of the collections view, and the collections view to the bottom of the
    // screen for animation purposes (see below).
    CollectionsView {
        id: collectionsView
        anchors.bottom: parent.bottom

        // pass global variables
        extendedCollections: extendedCollections
        favoritesCollection: favoritesCollection
        lastPlayedCollection: lastPlayedCollection
        allGamesCollection: allGamesCollection

        focus: true
        onCollectionSelected: detailsView.focus = true
    }

    DetailsView {
        id: detailsView
        anchors.top: collectionsView.bottom

        // pass global variables
        currentCollection: collectionsView.currentCollection
        favoritesCollection: favoritesCollection
        lastPlayedCollection: lastPlayedCollection

        onCancel: {
            filterText="";
            collectionsView.focus = true
        }
        onNextCollection: {
            gameList.forceActiveFocus();
            filterText="";
            currentGameIndex=0;
            collectionsView.selectNext();
        }
        onPrevCollection: {
            gameList.forceActiveFocus();
            filterText="";
            currentGameIndex=0;
            collectionsView.selectPrev();
        }
        onLaunchGame: {
            api.memory.set('collectionIndex', collectionsView.currentCollectionIndex);
            api.memory.set('gameIndex', filteredSourceIndex);
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
