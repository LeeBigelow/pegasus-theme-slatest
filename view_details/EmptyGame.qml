import QtQuick 2.0
// EmptyGame: a dummy game to use when no game selected
// for empty favorites or no match on filter

Item {
    id: root
    readonly property string title: ""
    readonly property string description: ""
    readonly property int rating: 0
    readonly property int released: 0
    readonly property string developer: ""
    readonly property string publisher: ""
    readonly property string genre: ""
    readonly property int players: 0
    readonly property int lastplayed: 0
    readonly property int playtime: 0

    property alias assets: emptyGameAssets

    Item {
        id: emptyGameAssets
        readonly property string cover: ""
        readonly property string screenshot: ""
        readonly property string marquee: ""
        readonly property string wheel: ""
    }
}

