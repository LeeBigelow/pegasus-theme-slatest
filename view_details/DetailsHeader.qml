import QtQuick 2.0
// DetailsHeader: Collection's Console and Ccontroller images on left and Logo image on right
// Will present collection's name if no logo image found
Rectangle {
    id: root
    color: colorDarkBg
    height: vpx(115)

    MouseArea {
        // left and right swipe switches collection
        // down swipe focuses collectionsView
        anchors.fill: parent
        property int startX
        property int startY
        onPressed: { startX = mouse.x; startY = mouse.y; }
        onReleased: {
            if (mouse.y - startY > vpx(100)) { cancel(); return; }
            if (mouse.x - startX > vpx(50)) nextCollection();
            else if (startX - mouse.x > vpx(50)) prevCollection();
        }
    }

    Item {
        // logo image or fallback text
        id: logoOrLabel
        anchors {
            top: parent.top
            topMargin: defaultPadding
            right: parent.right
            rightMargin: defaultPadding
            bottom: parent.bottom
            bottomMargin: defaultPadding
        }
        height: parent.height
        width: parent.width / 3

        Image {
            id: logoImage
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            source: currentCollection.shortName ?
                "../images/logo/%1.svg".arg(currentCollection.shortName) : undefined
            sourceSize.height: parent.height
            sourceSize.width: parent.width
            width: sourceSize.width
            height: sourceSize.height
            // async may cause text label to flash
            asynchronous: true
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
            visible: logoImage.status != Image.Ready
        }
    }

    Image {
        id: consoleImage
        anchors {
            top: parent.top
            topMargin: defaultPadding
            left: parent.left
            leftMargin: defaultPadding
            bottom: parent.bottom
            bottomMargin: defaultPadding
        }
        fillMode: Image.PreserveAspectFit
        source: currentCollection.shortName ?
            "../images/consolegame/%1.svg".arg(currentCollection.shortName) : ""
        sourceSize.height: parent.height
        height: sourceSize.height
        asynchronous: true
    }

    Image {
        id: controllerImage
        anchors {
            top: parent.top
            topMargin: defaultPadding
            left: consoleImage.right
            leftMargin: defaultPadding
            bottom: parent.bottom
            bottomMargin: defaultPadding
        }
        fillMode: Image.PreserveAspectFit
        source: currentCollection.shortName ?
            "../images/controller/%1.svg".arg(currentCollection.shortName) : ""
        sourceSize.height: parent.height
        height: sourceSize.height
        asynchronous: true
    }

}
