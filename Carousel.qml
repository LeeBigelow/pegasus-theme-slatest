import QtQuick 2.0

// A carousel is a PathView that goes horizontally and keeps its
// current item in the center.
PathView {
    property int itemWidth
    readonly property int pathWidth: pathItemCount * itemWidth

    signal itemSelected

    // Handle keys
    Keys.onLeftPressed: decrementCurrentIndex()
    Keys.onRightPressed: incrementCurrentIndex()
    Keys.onPressed: {
        if (api.keys.isAccept(event)) {
            event.accepted = true;
            itemSelected();
        }
    }

    // Center the current item
    snapMode: PathView.SnapOneItem
    preferredHighlightBegin: 0.5
    preferredHighlightEnd: 0.5

    // Create and position the path
    pathItemCount: Math.ceil(width / itemWidth) + 2

    path: Path {
        startX: (width - pathWidth) / 2
        startY: height / 2
        PathLine {
            x: path.startX + pathWidth
            y: path.startY
        }
    }
}
