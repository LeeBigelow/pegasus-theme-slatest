import QtQuick 2.0
// GameInfoText: the game info text properties
Text {
    id: root
    font.pixelSize: vpx(18)
    font.capitalization: Font.Capitalize
    font.family: "Open Sans"
    color: "black"
    height: detailsTextHeight
    width: parent.width
    elide: Text.ElideRight
}
