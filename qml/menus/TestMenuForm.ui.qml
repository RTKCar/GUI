import QtQuick 2.5
import QtQuick.Controls 2.2
import QtQuick.Window 2.0
import QtQuick.Layouts 1.3

Item {
    id: menu1
    property alias mouseDelegate: radioDelegate1
    property alias markerDelegate: radioDelegate2
    property alias handDelegate: radioDelegate3
    property alias followButton: followButton
    property alias zoomSlider: zoomS
    property alias zoomValue: zoomVal
    property alias tab0: tabButton
    property alias tab1: tabButton1
    property alias page0: page0
    property alias page1: page1
    property alias stackLayout: stackLayout
    property var mapSource
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
                y: 68
                width: 120
                height: 33
                checked: true
                text: qsTr("Mouse")
            }

            RadioDelegate {
                id: radioDelegate2
                x: 0
                y: 112
                width: 120
                height: 32
                text: qsTr("Marker")
            }

            RadioDelegate {
                id: radioDelegate3
                x: 0
                y: 155
                width: 120
                height: 30
                text: qsTr("Hand")
            }

            RowLayout {
                id: rowLayout1
                x: 0
                y: 197
                width: 200
                height: 45

                Button {
                    id: followButton
                    width: 90
                    text: qsTr("Follow")
                }

                Button {
                    id: button
                    x: 100
                    width: 90
                    text: qsTr("Center")
                }
            }

            Flow {
                id: flow1
                x: 0
                y: 290
                width: 200
                height: 64

                Label {
                    id: label
                    text: qsTr("Zoom")

                    Slider {
                        id: zoomS
                        x: 0
                        y: 13
                        from: mapSource.minimumZoomLevel
                        to: mapSource.maximumZoomLevel
                        value: mapSource.zoomLevel
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
                y: 410
                width: 200
                height: 150

                Page {
                    id: page0
                    width: 200
                    height: 150
                    visible: false

                    Image {
                        id: image4
                        x: 50
                        y: 25
                        width: 100
                        height: 100
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
                        x: 75
                        y: 10
                        width: 50
                        height: 50
                        source: "qrc:/qml/resources/up-arrow.svg"
                    }

                    Image {
                        id: image1
                        x: 35
                        y: 50
                        width: 50
                        height: 50
                        source: "qrc:/qml/resources/left-arrow.svg"
                    }

                    Image {
                        id: image2
                        x: 115
                        y: 50
                        width: 50
                        height: 50
                        source: "qrc:/qml/resources/right-arrow.svg"
                    }

                    Image {
                        id: image3
                        x: 75
                        y: 90
                        width: 50
                        height: 50
                        source: "qrc:/qml/resources/down-arrow.svg"
                    }
                }
            }

            TabBar {
                id: tabBar
                x: 0
                y: 560
                width: 200
                height: 40

                TabButton {
                    id: tabButton
                    x: 0
                    y: 0
                    text: qsTr("Start/Stopp")
                }

                TabButton {
                    id: tabButton1
                    x: 100
                    text: qsTr("Steer")
                }
            }

            Flow {
                id: flow2
                x: 0
                y: 243
                width: 200
                height: 45
                spacing: 10

                Button {
                    id: button1
                    x: 5
                    width: 60
                    text: qsTr("Save")
                }

                Button {
                    id: button2
                    x: 70
                    width: 60
                    text: qsTr("Load")
                }

                Button {
                    id: button3
                    x: 135
                    width: 60
                    text: qsTr("Delete")
                }
            }
        }
    }
}
