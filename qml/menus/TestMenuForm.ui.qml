import QtQuick 2.5
//import QtQuick.Controls 1.4
import QtQuick.Controls 2.2
import QtQuick.Window 2.0
import QtQuick.Layouts 1.3
import QtQuick.Extras 1.4
import QtLocation 5.9
import "controls"

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
    property alias stackLayout1: stackLayout1
    property alias stackLayout2: stackLayout2
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

            Flow {
                id: zoomFlow
                x: 0
                y: 328
                width: 200
                height: 43

                Label {
                    id: label
                    text: qsTr("Zoom")

                    MySlider {
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
                y: 33
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

            StackLayout {
                id: stackLayout1
                x: 0
                y: 65
                width: 200
                height: 132

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
                        height: 29

                        Label {
                            id: label3
                            text: qsTr("Host:")
                        }

                        MyTextField {
                            id: hostField
                            width: 100
                            Layout.preferredHeight: 25
                            placeholderText: qsTr("192.168.0.1")
                            validator: RegExpValidator {
                                regExp: /(\d{1,3})([.]\d{1,3})([.]\d{1,3})([.]\d{1,3})$/
                            }
                        }
                    }

                    RowLayout {
                        id: portRow
                        x: 0
                        y: 30
                        width: 200
                        height: 27

                        Label {
                            id: label4
                            text: qsTr("Port: ")
                        }

                        MyTextField {
                            id: portField
                            width: 100
                            Layout.preferredHeight: 25
                            placeholderText: qsTr("9000")
                            validator: IntValidator {
                                bottom: 0
                                top: 9999
                            }
                            //text: "9905"
                            //enabled:false
                        }
                    }

                    Flow {
                        id: connectFlow
                        x: 0
                        y: 61
                        width: 200
                        height: 69
                        spacing: 3

                        RowLayout {
                            id: connDisconnRow
                            x: 5
                            width: 200
                            height: 30

                            Button {
                                id: connectButton
                                width: 85
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
                            height: 30

                            Button {
                                id: sendMButton
                                text: qsTr("Send Map")
                                Layout.preferredWidth: 85
                                Layout.preferredHeight: 30
                                enabled: false
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

                Page {
                    id: page
                    width: 200
                    height: 200
                }
            }

            ToolSeparator {
                id: secondSeparator
                x: 0
                y: 193
                width: 200
                height: 5
                rightPadding: 0
                leftPadding: 0
                font.capitalization: Font.MixedCase
            }

            ToolSeparator {
                id: fourthSeparator
                x: 0
                y: 370
                width: 200
                height: 5
                rightPadding: 0
                leftPadding: 0
            }

            Flow {
                id: carFlow
                x: 0
                y: 381
                width: 200
                height: 101
                spacing: 3

                RowLayout {
                    id: carConnectedRow
                    width: 200
                    height: 27

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

                Row {
                    id: speedRow
                    width: 200
                    height: 30
                    spacing: 61

                    Label {
                        id: label7
                        text: qsTr("Speed:")
                    }

                    ComboBox {
                        id: speedBox
                        width: 85
                        height: 30
                        model: ["Low", "Mid", "High"]
                        enabled: false
                    }
                }

                RowLayout {
                    id: startStopRow
                    width: 200
                    height: 30
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
            }

            RowLayout {
                id: rowLayout4
                x: 0
                y: 474
                width: 200
                height: 39
                spacing: 0

                MySwitchDelegate {
                    id: manualSwitch
                    height: 35
                    text: "Manual"
                    rightPadding: 3
                    leftPadding: 3
                    spacing: 6
                    enabled: false
                }

                MySwitchDelegate {
                    id: simulateSwitch
                    x: 99
                    height: 35
                    text: "Simulate"
                    rightPadding: 3
                    leftPadding: 3
                    spacing: 6
                    enabled: false
                }
            }

            ToolSeparator {
                id: firstSeparator
                y: 58
                width: 200
                height: 5
                rightPadding: 0
                leftPadding: 0
            }

            StackLayout {
                id: stackLayout2
                x: 0
                y: 199
                width: 200
                height: 120

                Page {
                    id: normalPage
                    width: 200
                    height: 120
                    visible: false

                    Column {
                        id: column1
                        width: 200
                        height: 400

                        Flow {
                            id: markerFlow
                            width: 200
                            height: 52

                            MyRadioDelegate {
                                id: mouseDelegate
                                width: 100
                                height: 25
                                checked: true
                                text: qsTr("Mouse")
                                Layout.preferredHeight: 30
                                padding: 5
                            }

                            MyRadioDelegate {
                                id: handDelegate
                                width: 100
                                height: 25
                                text: qsTr("Hand")
                                padding: 5
                                Layout.preferredHeight: 30
                                enabled: false
                            }

                            MyRadioDelegate {
                                id: markerDelegate
                                width: 100
                                height: 25
                                text: qsTr("Marker")
                                padding: 5
                                Layout.preferredHeight: 30
                                font.weight: Font.ExtraLight
                                spacing: -4
                            }

                            MyRadioDelegate {
                                id: deleteDelegate
                                width: 100
                                height: 25
                                text: qsTr("Delete")
                                padding: 5
                                Layout.preferredHeight: 30
                            }
                        }

                        Flow {
                            id: saveLoadFlow
                            width: 200
                            height: 69
                            spacing: 3

                            RowLayout {
                                id: rowLayout1
                                x: 5
                                width: 200
                                height: 30

                                Button {
                                    id: followButton
                                    width: 85
                                    text: qsTr("Find Me")
                                    Layout.preferredWidth: 85
                                    Layout.preferredHeight: 30
                                }

                                Button {
                                    id: deleteAllButton
                                    width: 85
                                    text: qsTr("Delete All")
                                    Layout.preferredWidth: 85
                                    Layout.preferredHeight: 30
                                }
                            }

                            RowLayout {
                                id: rowLayout3
                                x: 5
                                width: 200
                                height: 30

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
                                    enabled: false
                                }
                            }
                        }
                    }
                }

                Page {
                    id: simulatePage
                    width: 200
                    height: 120
                }
            }

            ToolSeparator {
                id: thirdSeparator
                y: 320
                width: 200
                height: 5
                rightPadding: 0
                leftPadding: 0
            }
        }
    }
}
