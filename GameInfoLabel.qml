import QtQuick 2.0

// All the game detail labels text have the same basic properties
// so I've moved them into a new QML type.
Text {
    font.pixelSize: vpx(18)
    font.capitalization: Font.AllUppercase
    font.family: "Open Sans"
    font.weight: Font.DemiBold
    height: root.detailsTextHeight
    color: "black"
}
