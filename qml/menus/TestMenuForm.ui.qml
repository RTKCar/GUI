import QtQuick 2.5
import QtQuick.Controls 2.2
import QtQuick.Window 2.0
import QtQuick.Layouts 1.3

Item {
    property alias mouseDelegate: radioDelegate1
    property alias markerDelegate: radioDelegate2
    property alias handDelegate: radioDelegate3
    property alias followButton: followButton
    property alias zoomSlider: zoomSlider
    property alias switchDelegate: switchDelegate
    width: 200
    height: 400

    Column {
        id: column
        x: 0
        y: 0
        width: 200
        height: 400

        ListView {
            id: listView
            x: 0
            y: 0

            RadioDelegate {
                id: radioDelegate1
                x: 0
                y: 68
                text: qsTr("Mouse")
            }

            RadioDelegate {
                id: radioDelegate2
                x: 0
                y: 126
                text: qsTr("Marker")
            }

            RadioDelegate {
                id: radioDelegate3
                x: 0
                y: 184
                text: qsTr("Hand")
            }

            SwitchDelegate {
                id: switchDelegate
                text: qsTr("Switch Delegate")
            }

            Button {
                id: followButton
                x: 0
                y: 253
                text: qsTr("Follow")
            }

            Label {
                id: label
                x: 76
                y: 299
                text: qsTr("Zoom")

                Slider {
                    id: zoomSlider
                    x: -75
                    y: 18
                    value: 0.5
                }
            }
        }
    }
}
