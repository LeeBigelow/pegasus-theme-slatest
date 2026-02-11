import QtQuick 2.7 // need 2.7+ for text padding
// DescriptionScroll: A scrollable description box that returns focus to gameList on "accept"
Flickable {
    id: root
    clip: true
    focus: true
    onFocusChanged: { contentY = 0; }
    contentWidth: descriptionBg.width
    contentHeight: gameDescription.height
    flickableDirection: Flickable.VerticalFlick

    Text {
        id: gameDescription
        leftPadding: defaultPadding
        rightPadding: defaultPadding
        text: currentGame.description
        wrapMode: Text.WordWrap
        horizontalAlignment: Text.AlignJustify
        width: descriptionScroll.width
        font.pixelSize: vpx(18)
        font.family: "Open Sans"
        font.weight: Font.DemiBold
        color: "black"
    }

    // Keybindings for descriptionScroll
    // scroll description on up and down
    // don't go back past first line
    Keys.onUpPressed: (contentY - 10) < 0 ? contentY = 0 : contentY -= 10
    // don't go past last screenfull
    Keys.onDownPressed: (contentY + 10) > (gameDescription.height - height) ?
            contentY = gameDescription.height - height :
            contentY += 10
    // Move focus on tab and details key (i)
    KeyNavigation.tab: launchButton
    Keys.onPressed: {
        if (event.isAutoRepeat) {
            return;
        } else if (api.keys.isAccept(event)) {
            // move focus to gameList on accept (nice for tablet nav)
            event.accepted = true;
            gameList.forceActiveFocus();
            return;
        } else if (api.keys.isDetails(event)) {
            event.accepted = true;
            filterBox.filterInput.forceActiveFocus();
            return;
        }
    }

    MouseArea {
        // focus description on click
        anchors.fill: parent
        onClicked: descriptionScroll.forceActiveFocus()
    }
} // end Flickable
