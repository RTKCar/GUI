import QtQuick 2.7
//import QtQuick 2.5
import QtLocation 5.6
import QtPositioning 5.5
import QtQuick.Window 2.0
import QtQuick.Layouts 1.3
import "map"
import "menus"
import myPackage 1.0
import QtQuick.Controls 1.4
import QtQuick.Controls 2.1
import QtQuick.Dialogs 1.1

ApplicationWindow {
    id: appWindow
    visible: true
    height: 630
    width: 800
    title: qsTr("RTKCar")
    //height: Screen.height
    //width: Screen.width
    property string testJson: "[{\"conns\":[2,4],\"coord\":{\"lat\":56.67507440022754,\"long\":12.863477416073408},\"id\":1},{\"conns\":[1,3],\"coord\":{\"lat\":56.67501716123367,\"long\":12.862938208261255},\"id\":2},{\"conns\":[2,4],\"coord\":{\"lat\":56.67521716922783,\"long\":12.862889771317356},\"id\":3},{\"conns\":[3,1],\"coord\":{\"lat\":56.675154300977404,\"long\":12.863227111490545},\"id\":4}]"
    property string testJson2: "[{\"conns\":[2,11],\"coord\":{\"lat\":56.67515246104728,\"long\":12.863372800241422},\"id\":1},{\"conns\":[1,3],\"coord\":{\"lat\":56.67511042678674,\"long\":12.863445719230384},\"id\":2},{\"conns\":[2,4],\"coord\":{\"lat\":56.67505591647124,\"long\":12.863421784811521},\"id\":3},{\"conns\":[3,5],\"coord\":{\"lat\":56.6749451487393,\"long\":12.863330007246901},\"id\":4},{\"conns\":[4,6],\"coord\":{\"lat\":56.67494359676431,\"long\":12.863260661334266},\"id\":5},{\"conns\":[5,7],\"coord\":{\"lat\":56.67503008569954,\"long\":12.862736793919197},\"id\":6},{\"conns\":[6,8],\"coord\":{\"lat\":56.67506342121084,\"long\":12.862680372970487},\"id\":7},{\"conns\":[7,9],\"coord\":{\"lat\":56.67510218150271,\"long\":12.862707545068304},\"id\":8},{\"conns\":[8,10],\"coord\":{\"lat\":56.67520350942087,\"long\":12.862794814376713},\"id\":9},{\"conns\":[9,11],\"coord\":{\"lat\":56.6752114570436,\"long\":12.862890068275703},\"id\":10},{\"conns\":[10,1],\"coord\":{\"lat\":56.67519952675279,\"long\":12.863073339644728},\"id\":11}]"
    property int trackCount: 0
    property bool baseStation
    property bool baseFixed: false
    property bool first: true

    //menuBar: MyMenuBar {}

    footer: MyStatusBar {
        id: statusBar
    }



    //Frame {
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
                //Update statusIndicator of state
                testTools.approvedT = approvedTrack
            }
            onMapDone: {
                //Make sure the map is fully loaded before adding Markers to it
                //mapComponent.loadJsonMarkers(testJson3)
            }
            Keys.onPressed: {
                if(!event.isAutoRepeat && testTools.manualSwitch.checked){
                myKeyboard.checkKey(event.key, 1)
                }
            }
            Keys.onReleased: {
                if(!event.isAutoRepeat && testTools.manualSwitch.checked){
                myKeyboard.checkKey(event.key, 0)
                }
            }
            MouseArea {
                id: mouseArea
                anchors.fill: parent
                focus: true
                hoverEnabled: true

                onPositionChanged: {
                    var mouseGeoPos = mapview.mapMap.toCoordinate(Qt.point(mouse.x, mouse.y));
                    statusBar.lati = mouseGeoPos.latitude
                    statusBar.longi = mouseGeoPos.longitude
                }

                onExited: {
                    statusBar.lati = ""
                    statusBar.longi = ""
                }

            }
        }

        TestMenu{
            id:testTools
            onFollowMe: {
                mapview.foll = !mapview.foll
            }
            onDeleteAll: {
                //Call apropriate functions at signal
                mapview.mapComponent.deleteAllPolylines()
                mapview.mapComponent.deleteMarkers()
            }
            onSendMap: {
                //Call apropriate function at signal
                mapview.mapComponent.sendMap()
            }
            printButton.onClicked: {
                //Call apropriate function at signal
                mapview.mapComponent.printMap()
            }
            disconnectButton.onClicked: {
                //Call apropriate function at signal
                mytcpSocket.disconnect()
            }
            quitButton.onClicked: {
                //Call apropriate functions at signal
                messageDialog.open()
                //mytcpSocket.sendMessage("EXIT;")
            }
            startButton.onClicked: {
                //Call apropriate functions at signal
                //Speed 3-5
                //speedBox.currentIndex
                if(mytcpSocket.isConnected)
                    mytcpSocket.sendMessage("START:" + (speedBox.currentIndex+3))
                testTools.startButton.enabled = false
                testTools.stopButton.enabled = true
            }
            speedBox.onCurrentIndexChanged: {
                //Updates speed to car
                if(testTools.carConnected && mytcpSocket.isConnected) {
                    mytcpSocket.sendMessage("START:" + (speedBox.currentIndex+3))
                    testTools.startButton.enabled = false
                    testTools.stopButton.enabled = true
                }
            }
            stopButton.onClicked: {
                //Call apropriate functions at signal
                if(mytcpSocket.isConnected)
                    mytcpSocket.sendMessage("STOP")
                testTools.startButton.enabled = true
                testTools.stopButton.enabled = false
            }

            onSimulate: {
                //Simulate Car on the map
                mapview.mapComponent.simulateCar = value
            }
            saveButton.onClicked: {
                mapview.mapComponent.saveMap()
            }
            loadButton.onClicked: {
                mapview.mapComponent.loadMap()
            }

            MyKeyboard {
                id: myKeyboard
                onKeyEvent: {
                    if(mytcpSocket.isConnected) {
                        mytcpSocket.sendMessage(message + ":" + (testTools.speedBox.currentIndex+3))
                    } else {
                        console.log("could not send: " + message + ".\nServer not connected.")
                    }
                }
            }

            Keys.onPressed: {
                if(!event.isAutoRepeat && testTools.manualSwitch.checked){
                myKeyboard.checkKey(event.key, 1)
                }
            }
            Keys.onReleased: {
                if(!event.isAutoRepeat && testTools.manualSwitch.checked){
                myKeyboard.checkKey(event.key, 0)
                }
            }

            onConnect: {
                //specifies default host & port and checks input before connecting
                //var _host = "127.0.0.1"
                var _host = "192.168.80.38"
                var _port = 9003
                if(host.acceptableInput) {
                    _host = host.text
                } else {
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
                // forwards which RadioButton is pressed
                mapview.delegateIndex = index
            }
        }
    }

    MessageDialog {
        //MessageDialog to check weather the user really wants to quit the program
        id: messageDialog
        icon: StandardIcon.Warning
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
        //MessageDialog used for errrors in TCP-connection
        id: errorDialog
        icon: StandardIcon.Warning
        standardButtons: StandardButton.Ok
    }

    MyTcpSocket {
        id: mytcpSocket
        onSocketConnected: {
            testTools.connected = true
        }
        onSocketDisconnected: {
            testTools.connected = false
            testTools.carConnected = false
            //mapview.mapComponent.removeCar()
        }
        onErrorConnecting: {
            errorDialog.text = errorMessage
            errorDialog.open()
        }
        onRecieved: {
            //Split recieved message to extract latitude and longitude for car or baseStation.
            console.log("Received ", message)
            //console.log("end")

            var obj = message.split(";")
            var data = obj[0].split(":")
            var state = parseInt(data[0])

            switch (state){
            case 0:
                // Rover position received
                var latlong = data[1].split(",")
                //Check latlong.length?
                mapview.mapComponent.setCarBearing(QtPositioning.coordinate(latlong[0], latlong[1]))
                var not = ""
                if(latlong[2] === 0)
                    not = "not"
                console.log(latlong[2])
                console.log("BaseStation is " + not + " fixed")
                testTools.carConnected = true
                if(first) {
                    first = false
                    testTools.startButton.enabled = true
                }
                break
            case 1:
                // Object in front of Rover, at 0 = left, 1 = in front, 2 = right of object
                var distObj = data[1].split(",")
                var position = ""
                var pos = parseInt(distObj[1])
                switch (pos) {
                    case 0:
                        position = "left"
                        break
                    case 1:
                        position = "in front"
                        break
                    case 2:
                        position = "right"
                        break
                    default:
                        position = "in unknown position"
                }

                console.log("Object detected " + distObj[0] + " cm " + position + " of vehicle")
                console.log("popup-window instead?")
                break
            case 2:
                // Rover disconnected
                //testTools.carConnected = false
                break
            case 3:
                // baseStation position received
                //Check latlong.length?
                var latlong = data[1].split(",")
                var baseCoord = QtPositioning.coordinate(latlong[0], latlong[1])
                console.log("BaseStation is at coordinate ", baseCoord)
                //Push to track
                break
            default:
                console.log("default reception")
            }
        }
    }

    MyFileDialog{
        id: fileDialog

        onTextReceived: {
            console.log("text Received ", textR)
        }
    }

    //}

    onClosing: {
        //Make sure messageDialog is shown before closing
        close.accepted = false
        messageDialog.open()
    }
}
