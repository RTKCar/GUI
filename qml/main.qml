import QtQuick 2.5
import QtQuick.Controls 1.4
import QtLocation 5.6
import QtPositioning 5.5
import QtQuick.Window 2.0
import QtQuick.Layouts 1.3
import "map"
import "menus"
import myPackage 1.0
import QtQuick.Controls 2.1
import QtQuick.Dialogs 1.1

ApplicationWindow {
    id: appWindow
    visible: true
    height: 560
    //height: 600
    width: 800
    title: qsTr("RTKCar")
    //height: Screen.height
    //width: Screen.width
    property variant testTrack
    property string testJson: "[{\"conns\":[2,4],\"coord\":{\"lat\":56.67507440022754,\"long\":12.863477416073408},\"id\":1},{\"conns\":[1,3],\"coord\":{\"lat\":56.67501716123367,\"long\":12.862938208261255},\"id\":2},{\"conns\":[2,4],\"coord\":{\"lat\":56.67521716922783,\"long\":12.862889771317356},\"id\":3},{\"conns\":[3,1],\"coord\":{\"lat\":56.675154300977404,\"long\":12.863227111490545},\"id\":4}]"
    property int trackCount: 0


    RowLayout{
        id: rowL
        visible: true
        anchors.fill: parent

        MapView {
            id: mapview
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumHeight: 400
            Layout.preferredHeight: appWindow.height
            Layout.minimumWidth: 400
            Layout.preferredWidth: appWindow.width - TestMenu.width

            myTcpSocket: mytcpSocket

            onApprovedTrackChanged: {
                testTools.approvedT = approvedTrack
            }
            onMapDone: {
                mapComponent.loadJsonMarkers(testJson)
            }
        }

        TestMenu{
            id:testTools
            onFollowMe: {
                mapview.foll = !mapview.foll
            }
            onDeleteAll: {
                //mapview.deleteAll = !mapview.deleteAll
                mapview.mapComponent.deleteAllPolylines()
                mapview.mapComponent.deleteMarkers()
            }
            onSendMap: {
                console.log("sendMapPressed")
                mapview.mapComponent.sendMap()
                //mapview.sendMap = !mapview.sendMap
            }
            printButton.onClicked: {
                mapview.mapComponent.printMap()
            }
            disconnectButton.onClicked: {
                mytcpSocket.disconnect()
            }
            quitButton.onClicked: {
                //popup.open()
                messageDialog.open()
                //quitPop.open()
                mytcpSocket.sendMessage("EXIT;")
            }
            startButton.onClicked: {
                mytcpSocket.sendMessage("START;" + speedBox.currentText + ";")
                //mapview.mapComponent.setCarBearing()
                //console.log(speedBox.currentText)
            }
            stopButton.onClicked: {
                mytcpSocket.sendMessage("STOP;")
                //mapview.mapComponent.createCar()
            }


            onConnect: {
                var _host = "192.168.80.238"
                //var _host = "0.0.0.0"
                var _port = 2009
                //var _port = 5001
                if(host.acceptableInput) {
                    _host = host.text
                } else {
                    //host.text = _host
                    host.placeholderText = _host
                }
                if(port.acceptableInput) {
                    _port = parseInt(port.text)
                } else {
                    port.placeholderText = "" + _port
                }

                mytcpSocket.doConnect(_host, _port)
            }

            mapSourca: mapview.mapMap
            onDelegate: {
                mapview.delegateIndex = index
            }
        }

        Timer {
                interval: 5000; running: true; repeat: true
                onTriggered: {
                    mapview.mapComponent.setCarBearing(testTrack[trackCount])
                    trackCount++
                    if(trackCount === testTrack.length)
                        trackCount = 0
                }
            }
    }

    Popup {
            id: popup
            x: 100
            y: 100
            width: 200
            height: 300
            modal: true
            focus: true
            closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent

            ColumnLayout {
                    anchors.fill: parent
                    CheckBox { text: qsTr("E-mail") }
                    CheckBox { text: qsTr("Calendar") }
                    CheckBox { text: qsTr("Contacts") }
                }

        }
    MessageDialog {
        id: messageDialog
        icon: StandardIcon.Warning
        //title: "May I have your attention please"
        text: "Quiting the program, are you sure?"
        standardButtons: StandardButton.Yes | StandardButton.No
        onYes: {
            if(mytcpSocket.isConnected) {
                mytcpSocket.disconnect()
            }
            Qt.quit()
        }
    }

    MessageDialog {
        id: errorDialog
        icon: StandardIcon.Warning
        standardButtons: StandardButton.Ok
    }

    QuitingPopup {
        id: quitPop
        x: appWindow.width/2 - width/2
        y: appWindow.height/2 - height/2
    }

    MyTcpSocket {
        id: mytcpSocket
        onSocketConnected: {
            testTools.connected = true
        }
        onSocketDisconnected: {
            testTools.connected = false
        }
        onErrorConnecting: {
            errorDialog.text = errorMessage
            errorDialog.open()
        }
        onRecieved: {
            var obj = message.split(";")
            for (var i = 0; i< obj.length; i++){
                var latlong = obj[i].split(",")
                if(latlong.length > 1) {
                    console.log("lat: " + latlong[0])
                    console.log("long: " + latlong[1])
                }
            }
        }
    }
    onClosing: {
        close.accepted = false
        messageDialog.open()
    }

    Component.onCompleted: {
        testTrack = new Array();
        var jsonObj = JSON.parse(testJson)
        for (var i = 0; i<jsonObj.length; i++){
            var lat = jsonObj[i].coord.lat
            var longi = jsonObj[i].coord.long
            testTrack.push(QtPositioning.coordinate(lat, longi))
        }

        /*testTrack.push(QtPositioning.coordinate(56.67536504986881, 12.863066860046104))
        testTrack.push(QtPositioning.coordinate(56.675342353618866, 12.863252623981936))
        testTrack.push(QtPositioning.coordinate(56.675310649077716, 12.863454523057811))
        testTrack.push(QtPositioning.coordinate(56.67528108001073, 12.863682427008001))
        testTrack.push(QtPositioning.coordinate(56.675256973467086, 12.86382895316757))
        testTrack.push(QtPositioning.coordinate(56.6751956709352, 12.863804886611604))
        testTrack.push(QtPositioning.coordinate(56.675100833141435, 12.863759006186967))
        testTrack.push(QtPositioning.coordinate(56.67501936085384, 12.86374713531842))
        testTrack.push(QtPositioning.coordinate(56.6749412499883, 12.863720260835038))*/
    }
}
