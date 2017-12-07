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
    //property alias connectedLabel: cLabel
    //property alias notCLabel: nLabel
    //property alias notALabel: nLabel2
    //property alias approvedLabel: aLabel
    property alias host: hostField
    property alias port: portField
    property alias serverIndicator: sStatusIndc
    property alias trackIndicator: tStatusIndc
    property alias carIndicator: cStatusIndc
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
                y: 316
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
                x: 2
                y: 160
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
                y: 244
                width: 104
                height: 47
                checked: true
                text: qsTr("Mouse")
            }

            RadioDelegate {
                id: handDelegate
                x: 98
                y: 253
                width: 104
                height: 30
                text: qsTr("Hand")
                enabled: false
            }

            RadioDelegate {
                id: markerDelegate
                x: 0
                y: 285
                width: 104
                height: 30
                text: qsTr("Marker")
            }

            RadioDelegate {
                id: deleteDelegate
                x: 98
                y: 280
                width: 104
                height: 39
                text: qsTr("Delete")
            }

            Flow {
                id: zoomFlow
                x: 0
                y: 408
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
                y: 362
                width: 200
                height: 40
                spacing: 10

                Button {
                    id: button1
                    x: 5
                    width: 60
                    text: qsTr("Save")
                    enabled: false
                }

                Button {
                    id: button2
                    x: 70
                    width: 60
                    text: qsTr("Load")
                    enabled: false
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
                x: 2
                y: 8
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
                x: 2
                y: 45
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
                y: 79
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
                y: 120
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
                y: 459
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
                x: 1
                y: 525
                width: 198
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
                x: 2
                y: 494
                width: 198
                height: 25
                spacing: 90

                Label {
                    id: label7
                    text: qsTr("Speed:")
                }

                ComboBox {
                    id: comboBox1
                    width: 60
                    height: 25
                    model: ["0", "3", "5", "7"]
                }
            }
        }
    }
}
