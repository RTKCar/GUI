import QtQuick 2.0

Item {
    focus: true
    signal keyEvent(string message)

    function checkKey(key, state) {
        if (key === Qt.Key_Left || key === Qt.Key_A)
            keyEvent("MANUAL:a:" + state + ";")
        if (key === Qt.Key_Right || key === Qt.Key_D)
            keyEvent("MANUAL:d:" + state + ";")
        if (key === Qt.Key_Up || key === Qt.Key_W)
            keyEvent("MANUAL:w:" + state + ";")
        if (key === Qt.Key_Down || key === Qt.Key_S)
            keyEvent("MANUAL:s:" + state + ";")
    }
}
