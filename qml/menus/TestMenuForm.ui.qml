import QtQuick 2.5
import QtQuick.Controls 2.2
import QtQuick.Window 2.0
import QtQuick.Layouts 1.3
import QtQuick.Extras 1.4
import QtLocation 5.9


//import "menus"
Item {
    id: menu1
    property alias mouseDelegate: radioDelegate1
    property alias markerDelegate: radioDelegate2
    property alias handDelegate: radioDelegate3
    property alias deleteDelegate: radioDelegate4
    property alias followButton: followButton
    property alias deleteAllButton: deleteAllButton
    property alias centerButton: centerButton
    property alias sendMapButton: sendMButton
    property alias connectButton: connectButton
    property alias disconnectButton: disconnectButton
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

            RadioDelegate {
                id: radioDelegate1
                x: 0
                y: 274
                width: 104
                height: 33
                checked: true
                text: qsTr("Mouse")
            }

            RadioDelegate {
                id: radioDelegate2
                x: 0
                y: 306
                width: 104
                height: 32
                text: qsTr("Marker")
            }

            RadioDelegate {
                id: radioDelegate3
                x: 96
                y: 275
                width: 104
                height: 30
                text: qsTr("Hand")
                enabled: false
            }

            RadioDelegate {
                id: radioDelegate4
                x: 96
                y: 296
                width: 104
                height: 52
                text: qsTr("Delete")
            }

            RowLayout {
                id: rowLayout1
                x: 2
                y: 339
                width: 200
                height: 45

                Button {
                    id: followButton
                    width: 90
                    text: qsTr("Follow")
                    font.wordSpacing: -3
                    spacing: -10
                }

                Button {
                    id: centerButton
                    x: 100
                    width: 90
                    text: qsTr("Center")
                }
            }

            RowLayout {
                id: rowLayout
                x: 0
                y: 384
                width: 200
                height: 45

                Button {
                    id: deleteAllButton
                    width: 60
                    text: qsTr("Delete All")
                }

                Button {
                    id: printButton
                    text: qsTr("Print Track")
                }
            }

            Flow {
                id: flow1
                x: 0
                y: 476
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
                id: flow2
                x: 0
                y: 430
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
                    id: button
                    width: 60
                    text: qsTr("Quit")
                    enabled: false
                }
            }

            RowLayout {
                id: rowLayout2
                x: 0
                y: 0
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
                id: rowLayout3
                x: 0
                y: 185
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
                id: rowLayout4
                x: 0
                y: 34
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
                id: rowLayout5
                x: 0
                y: 68
                width: 200
                height: 40

                Label {
                    id: label3
                    text: qsTr("Host:")
                }

                TextField {
                    id: hostField
                    width: 150
                    placeholderText: qsTr("192.168.0.1")
                    validator: RegExpValidator {
                        regExp: /(\d{1,3})([.]\d{1,3})([.]\d{1,3})([.]\d{1,3})$/
                    }
                }
            }

            RowLayout {
                id: rowLayout6
                x: 2
                y: 114
                width: 200
                height: 40

                Label {
                    id: label4
                    text: qsTr("Port: ")
                }

                TextField {
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
                id: rowLayout7
                x: 0
                y: 231
                width: 200
                height: 45

                Button {
                    id: sendMButton
                    text: qsTr("Send Map")
                    enabled: false
                }
            }

            RowLayout {
                id: rowLayout8
                x: 0
                y: 522
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
                id: rowLayout9
                x: 2
                y: 555
                width: 198
                height: 45

                Button {
                    id: button3
                    text: qsTr("Start")
                    enabled: false
                }

                Button {
                    id: button4
                    text: qsTr("Stop")
                    enabled: false
                }
            }
        }
    }
}
