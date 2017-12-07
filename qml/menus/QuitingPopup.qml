import QtQuick 2.6
import QtQuick.Controls 2.0

Popup {
    id: popup
    background: Rectangle {
        //implicitWidth: 300
        //implicitHeight: 200
        border.color: "#444"
    }
    contentItem: Column {
        padding: 5
        spacing: 5
        Text {
            id: name
            text: qsTr("Quiting program, are you sure?")
        }
        ButtonGroup{
            id: bg
        }
        Row {
            padding: 5
            Button {
                id: yesButton
                 text: qsTr("Yes")
            }
            Button {
                id: noButton
                 text: qsTr("No")
            }
        }
    }
}
