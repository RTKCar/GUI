import QtQuick 2.6
import QtQuick.Controls 2.1

RadioDelegate {
    id: control
    text: qsTr("RadioDelegate")
    checked: false

    contentItem: Text {
        rightPadding: control.indicator.width + control.spacing
        text: control.text
        font: control.font
        opacity: enabled ? 1.0 : 0.3
        color: "Black"
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
    }

    indicator: Rectangle {
        //implicitWidth: 26
        implicitWidth: 20
        //implicitHeight: 26
        implicitHeight: 20
        x: control.width - width - control.rightPadding
        y: parent.height / 2 - height / 2
        radius: 13
        color: "transparent"
        border.color: control.enabled ? "#808080" : "#eeeeee"

        Rectangle {
            width: 12
            height: 12
            x: 4
            y: 4
            radius: 7
            color: "Black"
            visible: control.checked
        }
    }

    background: Rectangle {
        implicitWidth: 100
        implicitHeight: 25
        visible: control.down || control.highlighted
        //color: control.down ? "#bdbebf" : "#eeeeee"
        color: "White"
    }
}
