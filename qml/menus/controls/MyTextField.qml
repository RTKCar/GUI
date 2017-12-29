import QtQuick 2.6
import QtQuick.Controls 2.1

TextField {
    id: control
    placeholderText: qsTr("Enter description")    

    //textColor: control.enabled ? "#21be2b" : "LightGray"
    background: Rectangle {
        implicitWidth: 140
        implicitHeight: 35
        color: control.enabled ? "transparent" : "#353637"
        border.color: control.activeFocus ? "#21be2b" : "LightGray"
        border.width: control.activeFocus ? 2 : 1
    }
}
