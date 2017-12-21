import QtQuick 2.5
import QtQuick.Controls 2.2
//import QtQuick.Controls 1.4
//import QtQuick.Controls.Material 2.2
import QtQuick.Window 2.0
import QtQuick.Layouts 1.3
import QtQuick.Extras 1.4
import QtLocation 5.9

Item {
    id: menu1
    property alias mouseDelegate: mouseDelegate
    property alias markerDelegate: markerDelegate
    property alias handDelegate: handDelegate
    property alias deleteDelegate: deleteDelegate
    property alias followButton: followButton
    property alias deleteAllButton: deleteAllButton
    property alias sendMapButton: sendMButton
    property alias connectButton: connectButton
    property alias disconnectButton: disconnectButton
    property alias quitButton: quitButton
    property alias startButton: startButton
    property alias stopButton: stopButton
    property alias printButton: printButton
    property alias zoomSlider: zoomS
    property alias zoomValue: zoomVal
    property alias speedBox: speedBox
    property alias host: hostField
    property alias port: portField
    property alias serverIndicator: sStatusIndc
    property alias trackIndicator: tStatusIndc
    property alias carIndicator: cStatusIndc
    property alias simulateSwitch: simulateSwitch
    property alias saveButton: saveButton
    property alias loadButton: loadButton
    property Map mapSource
    property bool conn: false
    width: 200
    height: 600

    Column {
        id: column
        x: 0
        y: 0
        width: 200
        height: 600

        ListView {
            id: listView
            x: 0
            y: 0

            RowLayout {
                id: rowLayout1
                x: 2
                y: 305
                width: 200
                height: 45

                Button {
                    id: followButton
                    width: 90
                    text: qsTr("Find Me")
                    //font.wordSpacing: -3
                    //spacing: -10
                }

                Button {
                    id: deleteAllButton
                    width: 60
                    text: qsTr("Delete All")
                }
            }

            Flow {
                id: connectFlow
                x: 0
                y: 155
                width: 200
                height: 92

                RowLayout {
                    id: connDisconnRow
                    width: 200
                    height: 45

                    Button {
                        id: connectButton
                        width: 90
                        text: qsTr("Connect")
                    }

                    Button {
                        id: disconnectButton
                        text: qsTr("Disconnect")
                        enabled: false
                    }
                }

                RowLayout {
                    id: sendRow
                    width: 200
                    height: 45

                    Button {
                        id: sendMButton
                        text: qsTr("Send Map")
                        enabled: false
                        //Material.foreground: Material.Pink
                    }

                    Button {
                        id: printButton
                        text: qsTr("Print Track")
                    }
                }
            }

            RadioDelegate {
                id: mouseDelegate
                x: 0
                y: 236
                width: 104
                height: 47
                checked: true
                text: qsTr("Mouse")
            }

            RadioDelegate {
                id: handDelegate
                x: 98
                y: 245
                width: 104
                height: 30
                text: qsTr("Hand")
                enabled: false
            }

            RadioDelegate {
                id: markerDelegate
                x: 0
                y: 277
                width: 104
                height: 30
                text: qsTr("Marker")
            }

            RadioDelegate {
                id: deleteDelegate
                x: 98
                y: 273
                width: 104
                height: 39
                text: qsTr("Delete")
            }

            Flow {
                id: zoomFlow
                x: 0
                y: 393
                width: 200
                height: 53

                Label {
                    id: label
                    text: qsTr("Zoom")

                    Slider {
                        id: zoomS
                        x: 0
                        y: 13
                        from: mapSource.minimumZoomLevel
                        to: mapSource.maximumZoomLevel
                        //value: mapSource.zoomLevel
                        stepSize: 0.5
                        snapMode: "SnapOnRelease"
                    }
                }

                Label {
                    id: zoomVal
                    width: 66
                    height: 16
                }
            }

            Flow {
                id: saveLoadFlow
                x: 2
                y: 351
                width: 200
                height: 40
                spacing: 10

                Button {
                    id: saveButton
                    x: 5
                    width: 60
                    text: qsTr("Save")
                    //enabled: false
                }

                Button {
                    id: loadButton
                    x: 70
                    width: 60
                    text: qsTr("Load")
                    //enabled: false
                }

                Button {
                    id: quitButton
                    width: 60
                    text: qsTr("Quit")
                    //enabled: false
                }
            }

            RowLayout {
                id: serverConnectedRow
                x: 0
                y: 5
                width: 200
                height: 22

                Label {
                    id: label2
                    text: qsTr("Server connected:")
                }

                MyStatusIndicator {
                    id: sStatusIndc
                }
            }

            RowLayout {
                id: trackApprovedRow
                x: 0
                y: 38
                width: 200
                height: 22

                Label {
                    id: label1
                    text: qsTr("Track approved:    ")
                }

                MyStatusIndicator {
                    id: tStatusIndc
                }
            }

            RowLayout {
                id: hostRow
                x: 0
                y: 74
                width: 200
                height: 40

                Label {
                    id: label3
                    text: qsTr("Host:")
                }

                MyTextField {
                    id: hostField
                    width: 100
                    placeholderText: qsTr("192.168.0.1")
                    validator: RegExpValidator {
                        regExp: /(\d{1,3})([.]\d{1,3})([.]\d{1,3})([.]\d{1,3})$/
                    }
                }
            }

            RowLayout {
                id: portRow
                x: 0
                y: 114
                width: 200
                height: 40

                Label {
                    id: label4
                    text: qsTr("Port: ")
                }

                MyTextField {
                    id: portField
                    width: 100
                    placeholderText: qsTr("9000")
                    validator: IntValidator {
                        bottom: 0
                        top: 9999
                    }
                }
            }

            RowLayout {
                id: carConnectedRow
                x: 0
                y: 441
                width: 200
                height: 22

                Label {
                    id: label5
                    text: qsTr("Car connected: ")
                }

                MyStatusIndicator {
                    id: cStatusIndc
                }
            }

            RowLayout {
                id: startStopRow
                x: 0
                y: 505
                width: 200
                height: 45

                Button {
                    id: startButton
                    text: qsTr("Start")
                    //highlighted: true
                    //Material.background: Material.Teal
                    //enabled: false
                }

                Button {
                    id: stopButton
                    text: qsTr("Stop")
                    //Material.elevation: 6
                    //enabled: false
                }
            }

            Row {
                id: row
                x: 0
                y: 479
                width: 200
                height: 25
                spacing: 70

                Label {
                    id: label7
                    text: qsTr("Speed:")
                }

                ComboBox {
                    id: speedBox
                    width: 80
                    height: 25
                    model: ["Low", "Mid", "High"]
                }
            }

            RowLayout {
                id: rowLayout
                x: 0
                y: 541
                width: 200
                height: 37

                SwitchDelegate {
                    id: simulateSwitch
                    width: 140
                    text: qsTr("Simulate:")
                    padding: 9
                    bottomPadding: 9
                    leftPadding: 9
                    topPadding: 9
                }
            }
        }
    }
}
