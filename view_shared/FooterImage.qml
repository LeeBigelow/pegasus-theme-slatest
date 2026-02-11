import QtQuick 2.0
// FooterImage: presents and image and label side by side
Item {
    id: root
    property string imageSource
    property string imageLabel
    height: vpx(40)
    width: vpx(15) + label.contentWidth + image.paintedWidth
    opacity: 0.45

    Image {
        id: image
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter

        // image source given as relative to parent, not here, so step up a dir
        source: "../" + imageSource
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
