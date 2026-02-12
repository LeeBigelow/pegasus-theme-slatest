import QtQuick 2.0
// EmptyGame: a dummy game to use when no game selected
// for empty favorites or no match on filter

Item {
    id: root
    readonly property string title: ""
    readonly property string description: ""
    property alias assets: emptyGameAssets

    Item {
        id: emptyGameAssets
        readonly property string cover: ""
        readonly property string screenshot: ""
        readonly property string marquee: ""
        readonly property string wheel: ""
    }
}

