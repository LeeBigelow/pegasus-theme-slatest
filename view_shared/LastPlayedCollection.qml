import QtQuick 2.0
import SortFilterProxyModel 0.2
// LastPlayedCollection: filtered to show last 20 games played
Item {
    id: root
    readonly property var name: "Last Played"
    readonly property var shortName: "auto-lastplayed"
    readonly property var games: lastPlayedGames

    SortFilterProxyModel {
        id: lastPlayedGames
        sourceModel: api.allGames
        sorters: RoleSorter {
            roleName: "lastPlayed"
            sortOrder: Qt.DescendingOrder
        }
        filters: IndexFilter { maximumIndex: 19 }
    }
}
