import QtQuick 2.6
import QtQuick.Controls 2.1

SwitchDelegate {
    id: control
    text: qsTr("MySwitchD")
    checked: false

    contentItem: Text {
        rightPadding: control.indicator.width + control.spacing
        text: control.text
        font: control.font
        opacity: enabled ? 1.0 : 0.3
        color: "Black"
        //color: control.down ? "#17a81a" : "#21be2b"
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
    }

    indicator: Rectangle {
        implicitWidth: 40
        implicitHeight: 10
        x: control.width - width - control.rightPadding
        y: parent.height / 2 - height / 2
        radius: 13
        //Dark lime green : transparent
        //color: control.checked ? "#17a81a" : "transparent"
        color: control.checked ? "Black" : "#cccccc"
        //Dark lime green : Strong lime green
        //border.color: control.checked ? "#17a81a" : "#cccccc"
        border.color: control.checked ? "Black" : "#cccccc"

        Rectangle {
            x: control.checked ? parent.width - width : 0
            y: parent.height / 2 - height / 2
            width: 20
            height: 20
            radius: 13
            // lightgray or white
            color: control.down ? "#cccccc" : "#ffffff"
            //Dark lime green : Strong lime green : Dark gray
            //border.color: control.checked ? (control.down ? "#17a81a" : "#21be2b") : "#999999"
            border.color:  "#999999"
        }
    }

    background: Rectangle {
        implicitWidth: 90
        implicitHeight: 20
        visible: control.down || control.highlighted
        // Grayish blue. or Very light gray.
        color: "White"
        //color: control.down ? "Black" : "#cccccc"
    }
}
