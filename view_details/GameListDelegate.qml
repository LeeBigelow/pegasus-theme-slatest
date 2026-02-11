import QtQuick 2.7 // need verstion 2.7+ for text padding
// GameListDelegate: Shows game title in a rectangle and alters colors based on focus
Rectangle {
    id: root
    readonly property bool selected: ListView.isCurrentItem

    width: ListView.view.width
    height: gameTitle.height
    color: selected ?
        (gameList.activeFocus ? "black" : colorSemiDarkBg) :
        "transparent"

    Text {
        id: gameTitle
        text: (modelData.favorite ? "★" : "") + " " + modelData.title
        color: parent.selected ? colorLightText : "black"

        font.pixelSize: vpx(20)
        font.capitalization: Font.AllUppercase
        font.family: "Open Sans"
        font.weight: Font.DemiBold

        lineHeight: 1.2
        verticalAlignment: Text.AlignVCenter

        width: parent.width
        elide: Text.ElideRight
        leftPadding: vpx(10)
        rightPadding: leftPadding
    }

    MouseArea {
        // gameList mouse actions
        // focus on click, launch on double click
        anchors.fill: parent
        onClicked: {
            gameList.currentIndex=index;
            gameList.forceActiveFocus();
        }
        onDoubleClicked: launchGame()
    }
} // end gameList delegate

