import QtQuick 2.0

// The collection logo on the collection carousel. Just an image that gets scaled
// and more visible when selected. Also has a fallback text if there's no image.
Item {
    property string imageSource
    property string imageLabel
    height: vpx(40)
    width: vpx(15) + label.contentWidth + image.paintedWidth
    opacity: 0.45

    Image {
        id: image
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter

        source: imageSource
        sourceSize.height: vpx(30)
        height: sourceSize.height
        fillMode: Image.PreserveAspectFit
        asynchronous: true
    }

    Text {
        id: label
        anchors.left: image.right
        anchors.leftMargin: vpx(5)
        anchors.verticalCenter: parent.verticalCenter
        color: "white"
        font.family: "Open Sans"
        font.pixelSize: vpx(16)
        text: imageLabel
    }
}
