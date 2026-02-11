import QtQuick 2.0
// FilterBox: Text input box that catches some of the UI nav keys
Rectangle {
    id: root
    // alias for assigning focus and collecting text
    property alias filterInput: filterInput
    // filterInput background
    color: filterInput.activeFocus ? colorFocusedBg : colorLightBg

    TextInput {
        id: filterInput
        anchors {
            fill: parent
            leftMargin: vpx(5)
            rightMargin: vpx(5)
            verticalCenter: parent.verticalCenter
        }
        focus: true
        color: "black"
        font.family: "Open Sans"
        font.pixelSize: vpx(16)
        font.capitalization: Font.AllUppercase
        verticalAlignment: Text.AlignVCenter
        KeyNavigation.tab: descriptionScroll
        Keys.onUpPressed: {
            if (currentGameIndex > 0) currentGameIndex--;
            gameList.forceActiveFocus();
        }
        Keys.onDownPressed: {
            if (currentGameIndex < gameList.count - 1) currentGameIndex++;
            gameList.forceActiveFocus();
        }
        Keys.onPressed: {
            // change game index to last item on each keypress so detials refresh
            // but not on focus switching keys
            if (event.key != Qt.Key_Tab && !api.keys.isDetails(event))
                currentGameIndex = gameList.count - 1;
            if (event.isAutoRepeat) return;
            if (event.key == Qt.Key_I) {
                // insert i rather than switch focus as a "details" key
                event.accepted= true;
                filterInput.insert(cursorPosition,"i");
                return;
            } else if (event.key == Qt.Key_Left && cursorPosition == 0) {
                // catch left key to stop acidental collection switching
                event.accepted=true;
                return;
            } else if (event.key == Qt.Key_Right && cursorPosition == text.length) {
                // catch right key to stop acidental collection switching
                event.accepted=true;
                return;
            } else if (api.keys.isDetails(event)) {
                event.accepted = true;
                gameList.forceActiveFocus();
                return;
            } else if (api.keys.isAccept(event)) {
                // focus gameList on enter (nice for tablet onscreen keyboards)
                event.accepted = true;
                currentGameIndex = gameList.count - 1;
                gameList.forceActiveFocus();
                return;
            }
        } // end filterInput Keys.onPressed
    } // end filterInput TextInput
} // end filterBox rectangle
