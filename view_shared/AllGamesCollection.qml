import QtQuick 2.0
// AllGamesCollection: all the games!
Item {
    id: root
    readonly property var name: "All Games"
    readonly property var shortName: "auto-allgames"
    readonly property var games: api.allGames
}
