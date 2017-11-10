import QtQuick 2.5
import QtQuick.Controls 2.2
import QtQuick.Window 2.0
import QtQuick.Layouts 1.3

Item {
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
                id: radioDelegate
                x: 0
                y: 68
                text: qsTr("Mouse")
            }

            RadioDelegate {
                id: radioDelegate1
                x: 0
                y: 126
                text: qsTr("Marker")
            }

            RadioDelegate {
                id: radioDelegate2
                x: 0
                y: 184
                text: qsTr("Hand")
            }

            SwitchDelegate {
                id: switchDelegate
                text: qsTr("Switch Delegate")
            }

            Button {
                id: button
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
                    id: slider
                    x: -75
                    y: 18
                    value: 0.5
                }
            }
        }
    }
}
