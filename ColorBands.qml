import QtQuick 2.0

Item {
    width: root.padding * 4

    Rectangle {
        id: band4
        anchors {
            top: parent.top
            bottom: parent.bottom
            right: parent.right
        }
        width: root.padding
        color: collectionInfo.colors[3] ?
            ("#" + collectionInfo.colors[3]) : colorBand4
    }

    Rectangle {
        id: band3
        anchors {
            top: parent.top
            bottom: parent.bottom
            right: band4.left
        }
        width: root.padding
        color: collectionInfo.colors[2] ?
            ("#" + collectionInfo.colors[2]) : colorBand3
    }

    Rectangle {
        id: band2
        anchors {
            top: parent.top
            bottom: parent.bottom
            right: band3.left
        }
        width: root.padding
        color: collectionInfo.colors[1] ?
            ("#" + collectionInfo.colors[1]) : colorBand2
    }

    Rectangle {
        id: band1
        anchors {
            top: parent.top
            bottom: parent.bottom
            right: band2.left
        }
        width: root.padding
        color: collectionInfo.colors[0] ?
            ("#" + collectionInfo.colors[0]) : colorBand1
    }
}

