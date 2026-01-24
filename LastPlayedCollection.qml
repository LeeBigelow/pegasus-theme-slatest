import QtQuick 2.0
import SortFilterProxyModel 0.2

Item {
    readonly property var name: "Last Played"
    readonly property var shortName: "auto-lastplayed"
    readonly property var games: gamesFiltered

    function sourceGame(index) {
        return api.allGames.get(lastPlayedGames.mapToSource(index));
    }

    SortFilterProxyModel {
        id: lastPlayedGames
        sourceModel: api.allGames
        sorters: RoleSorter {
            roleName: "lastPlayed"
            sortOrder: Qt.DescendingOrder
        }
    }

    SortFilterProxyModel {
        id: gamesFiltered
        sourceModel: lastPlayedGames
        filters: IndexFilter { maximumIndex: 16 }
    }
}
