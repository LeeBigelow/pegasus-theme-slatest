import QtQuick 2.0
import SortFilterProxyModel 0.2
// FavoritesCollection: filtered to hold only games marked favorite
Item {
    id: root
    readonly property var name: "Favorites"
    readonly property var shortName: "auto-favorites"
    readonly property var games: favoriteGames

    SortFilterProxyModel {
        id: favoriteGames
        sourceModel: api.allGames
        filters: ValueFilter { roleName: "favorite"; value: true }
    }
}
