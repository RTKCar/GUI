import QtQuick 2.5
import QtQuick.Controls 2.2
import QtQuick.Window 2.0
import QtQuick.Layouts 1.3
import QtLocation 5.9

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
    property alias tab0: tabButton
    property alias tab1: tabButton1
    property alias page0: page0
    property alias page1: page1
    property alias stackLayout: stackLayout
    property alias connectedLabel: cLabel
    property alias notCLabel: nLabel
    property alias notALabel: nLabel2
    property alias approvedLabel: aLabel
    property alias host: hostField
    property alias port: portField
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
                y: 227
                width: 104
                height: 33
                checked: true
                text: qsTr("Mouse")
            }

            RadioDelegate {
                id: radioDelegate2
                x: 0
                y: 266
                width: 104
                height: 32
                text: qsTr("Marker")
            }

            RadioDelegate {
                id: radioDelegate3
                x: 96
                y: 229
                width: 104
                height: 30
                text: qsTr("Hand")
                enabled: false
            }

            RadioDelegate {
                id: radioDelegate4
                x: 96
                y: 256
                width: 104
                height: 52
                text: qsTr("Delete")
            }

            RowLayout {
                id: rowLayout1
                x: 0
                y: 299
                width: 200
                height: 45

                Button {
                    id: followButton
                    width: 90
                    text: qsTr("Follow")
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
                y: 345
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
                y: 437
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

            StackLayout {
                id: stackLayout
                x: 0
                y: 488
                width: 200
                height: 84

                Page {
                    id: page0
                    width: 200
                    height: 150
                    visible: false

                    Image {
                        id: image4
                        x: 70
                        y: 15
                        width: 60
                        height: 60
                        source: "../resources/play-button.svg"
                    }
                }

                Page {
                    id: page1
                    width: 200
                    height: 150
                    visible: true

                    Image {
                        id: image
                        x: 87
                        y: 5
                        width: 25
                        height: 25
                        source: "qrc:/qml/resources/up-arrow.svg"
                    }

                    Image {
                        id: image1
                        x: 47
                        y: 30
                        width: 25
                        height: 25
                        source: "qrc:/qml/resources/left-arrow.svg"
                    }

                    Image {
                        id: image2
                        x: 127
                        y: 30
                        width: 25
                        height: 25
                        source: "qrc:/qml/resources/right-arrow.svg"
                    }

                    Image {
                        id: image3
                        x: 87
                        y: 55
                        width: 25
                        height: 25
                        source: "qrc:/qml/resources/down-arrow.svg"
                    }
                }
            }

            TabBar {
                id: tabBar
                x: 0
                y: 571
                width: 200
                height: 30

                TabButton {
                    id: tabButton
                    x: 0
                    y: 0
                    height: 30
                    text: qsTr("Start/Stopp")
                }

                TabButton {
                    id: tabButton1
                    x: 100
                    height: 30
                    text: qsTr("Steer")
                }
            }

            Flow {
                id: flow2
                x: 0
                y: 391
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
                width: 200
                height: 22

                Label {
                    id: label2
                    text: qsTr("Server:")
                }

                Label {
                    id: nLabel
                    text: qsTr("Not")
                    color: "Red"
                }

                Label {
                    id: cLabel
                    text: qsTr(" Connected")
                    color: "Red"
                }
            }

            RowLayout {
                id: rowLayout3
                x: 0
                y: 133
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
                y: 19
                width: 200
                height: 22

                Label {
                    id: label1
                    text: qsTr("Track:")
                }

                Label {
                    id: nLabel2
                    text: qsTr("Not")
                    color: "Red"
                }

                Label {
                    id: aLabel
                    text: qsTr("Approved")
                    color: "Red"
                }
            }

            RowLayout {
                id: rowLayout5
                x: 0
                y: 42
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
                x: 0
                y: 87
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
                y: 178
                width: 200
                height: 45

                Button {
                    id: sendMButton
                    text: qsTr("Send Map")
                    enabled: false
                }
            }
        }
    }
}
