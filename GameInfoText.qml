import QtQuick 2.0

// All the game info text have the same basic properties
// so I've moved them into a new QML type.
Text {
    font.pixelSize: vpx(16)
    font.capitalization: Font.Capitalize
    font.family: "Open Sans"
    color: "black"
    height: detailsTextHeight
    width: parent.width
    elide: Text.ElideRight
}
