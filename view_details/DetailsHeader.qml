import QtQuick 2.0
// Collection's console and controller on left and logo on right
Rectangle {
    color: colorDarkBg
    height: vpx(115)

    Item {
        id: logoOrLabel
        anchors {
            top: parent.top
            topMargin: root.padding
            right: parent.right
            rightMargin: root.padding
            bottom: parent.bottom
            bottomMargin: root.padding
        }
        height: parent.height
        width: parent.width / 3

        Image {
            id: logo
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            source: currentCollection.shortName ?
                "../images/logo/%1.svg".arg(currentCollection.shortName) : undefined
            sourceSize.height: parent.height
            sourceSize.width: parent.width
            width: sourceSize.width
            height: sourceSize.height
            // async causing text label to flash
            // asynchronous: true
        }

        Text {
            id: logoLabel
            anchors.centerIn: parent
            color: "black"
            font.family: "Open Sans"
            font.pixelSize: vpx(28)
            font.weight: Font.Bold
            text: currentCollection.name + "\n (" + currentCollection.shortName + ")"
            horizontalAlignment: Text.AlignHCenter
            visible: logo.status != Image.Ready
        }
    }

    Image {
        id: consoleGame
        anchors {
            top: parent.top
            topMargin: root.padding
            left: parent.left
            leftMargin: root.padding
            bottom: parent.bottom
            bottomMargin: root.padding
        }
        fillMode: Image.PreserveAspectFit
        source: currentCollection.shortName ?
            "../images/consolegame/%1.svg".arg(currentCollection.shortName) : ""
        sourceSize.height: parent.height
        height: sourceSize.height
        asynchronous: true
    }

    Image {
        id: controller
        anchors {
            top: parent.top
            topMargin: root.padding
            left: consoleGame.right
            leftMargin: root.padding
            bottom: parent.bottom
            bottomMargin: root.padding
        }
        fillMode: Image.PreserveAspectFit
        source: currentCollection.shortName ?
            "../images/controller/%1.svg".arg(currentCollection.shortName) : ""
        sourceSize.height: parent.height
        height: sourceSize.height
        asynchronous: true
    }

}
