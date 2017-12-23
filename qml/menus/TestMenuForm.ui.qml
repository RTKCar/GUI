import QtQuick 2.5
import QtQuick.Controls 1.4
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
    property alias manualSwitch: manualSwitch
    property alias stackLayout: stackLayout
    property Map mapSource
    property bool conn: false
    width: 200
    height: 630

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
                x: 5
                y: 305
                width: 200
                height: 45

                Button {
                    id: followButton
                    width: 90
                    text: qsTr("Find Me")
                    Layout.preferredWidth: 85
                    Layout.preferredHeight: 30
                    //font.wordSpacing: -3
                    //spacing: -10
                }

                Button {
                    id: deleteAllButton
                    width: 60
                    text: qsTr("Delete All")
                    Layout.preferredWidth: 85
                    Layout.preferredHeight: 30
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
                font.weight: Font.ExtraLight
                spacing: 2
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
                    width: 25
                    height: 25
                    Layout.preferredHeight: 25
                    Layout.preferredWidth: 25
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
                    width: 25
                    height: 25
                    Layout.preferredHeight: 25
                    Layout.preferredWidth: 25
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
                    width: 25
                    height: 25
                    Layout.preferredHeight: 25
                    Layout.preferredWidth: 25
                }
            }

            RowLayout {
                id: startStopRow
                x: 5
                y: 505
                width: 200
                height: 45
                spacing: 5

                Button {
                    id: startButton
                    text: qsTr("Start")
                    Layout.preferredWidth: 85
                    Layout.preferredHeight: 30
                    enabled: false
                }

                Button {
                    id: stopButton
                    text: qsTr("Stop")
                    Layout.preferredWidth: 85
                    Layout.preferredHeight: 30
                    enabled: false
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

            StackLayout {
                id: stackLayout
                x: 0
                y: 74
                width: 200
                height: 165

                Page {
                    id: autoPage
                    width: 200
                    height: 165
                    visible: true

                    RowLayout {
                        id: hostRow
                        x: 0
                        y: 0
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
                        y: 40
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

                    Flow {
                        id: connectFlow
                        x: 0
                        y: 81
                        width: 200
                        height: 92

                        RowLayout {
                            id: connDisconnRow
                            x: 5
                            width: 200
                            height: 45

                            Button {
                                id: connectButton
                                width: 90
                                text: qsTr("Connect")
                                Layout.preferredWidth: 85
                                Layout.preferredHeight: 30
                            }

                            Button {
                                id: disconnectButton
                                text: qsTr("Disconnect")
                                Layout.preferredWidth: 85
                                Layout.preferredHeight: 30
                                enabled: false
                            }
                        }

                        RowLayout {
                            id: sendRow
                            x: 5
                            width: 200
                            height: 45

                            Button {
                                id: sendMButton
                                text: qsTr("Send Map")
                                Layout.preferredWidth: 85
                                Layout.preferredHeight: 30
                                enabled: false
                                //Material.foreground: Material.Pink
                            }

                            Button {
                                id: printButton
                                text: qsTr("Print Track")
                                Layout.preferredWidth: 85
                                Layout.preferredHeight: 30
                            }
                        }
                    }
                }

                Page {
                    id: manualPage
                    width: 200
                    height: 165
                    visible: false

                    Text {
                        id: text1
                        width: 200
                        height: 70
                        color: "LimeGreen"
                        text: qsTr("To control the car please use the arrow-keys or w, s, a and d. \n To change the speed use the speedbox.")
                        visible: true
                        wrapMode: Text.WordWrap
                        font.pixelSize: 12
                    }
                }
            }

            RowLayout {
                id: rowLayout
                x: 0
                y: 551
                width: 200
                height: 39

                SwitchDelegate {
                    id: simulateSwitch
                    width: 140
                    text: qsTr("Simulate:")
                    rightPadding: 6
                    padding: 9
                    bottomPadding: 6
                    leftPadding: 6
                    topPadding: 6
                    enabled: false
                }
            }

            RowLayout {
                id: rowLayout2
                x: 0
                y: 583
                width: 200
                height: 36

                SwitchDelegate {
                    id: manualSwitch
                    text: qsTr("Manual switch")
                    rightPadding: 6
                    bottomPadding: 6
                    topPadding: 6
                    leftPadding: 6
                    font.capitalization: Font.MixedCase
                    font.weight: Font.Normal
                    font.letterSpacing: 0
                    spacing: 8
                }
            }

            RowLayout {
                id: rowLayout3
                x: 0
                y: 351
                width: 200
                height: 45

                Button {
                    id: quitButton
                    width: 60
                    text: qsTr("Quit")
                    Layout.preferredHeight: 30
                    Layout.preferredWidth: 60
                    //enabled: false
                }

                Button {
                    id: loadButton
                    width: 60
                    text: qsTr("Load")
                    Layout.preferredHeight: 30
                    Layout.preferredWidth: 60
                    //enabled: false
                }

                Button {
                    id: saveButton
                    width: 60
                    text: qsTr("Save")
                    Layout.preferredWidth: 60
                    Layout.preferredHeight: 30
                    //enabled: false
                }
            }
        }
    }
}
