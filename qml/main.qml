import QtQuick 2.7
import QtLocation 5.6
import QtPositioning 5.5
import QtQuick.Window 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import QtQuick.Controls 2.1
import QtQuick.Dialogs 1.1
import "map"
import "menus"
import myPackage 1.0

ApplicationWindow {
    id: appWindow
    visible: true
    height: 630 //Screen.height
    width: 800 //Screen.width
    title: qsTr("RTKCar")
    property bool first: true

    footer: MyStatusBar {
        id: statusBar
    }

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
            statsBar: statusBar

            onApprovedTrackChanged: {
                //Update statusIndicator of state
                testTools.approvedT = approvedTrack
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
                testTools.speedBox.enabled = true
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
            onErrorMessage: {
                errorDialog.text = eMessage
                errorDialog.open()
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
                var _host = "127.0.0.1"
                //var _host = "192.168.80.38"
                var _port = 5001
                //var _port = 9003
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
            first = true
            //mapview.mapComponent.removeCar()
        }
        onErrorConnecting: {
            errorDialog.text = errorMessage
            errorDialog.open()
        }
        onMapSent: {
            testTools.mapSent = true
            console.log("Map successfully sent to host")
        }
        onRecieved: {
            //Split recieved message to extract latitude and longitude for car or baseStation.

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
                if(first) {
                    first = false
                    testTools.carConnected = true
                    //testTools.startButton.enabled = true
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
                testTools.carConnected = false
                first = true
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

    onClosing: {
        //Make sure messageDialog is shown before closing
        close.accepted = false
        messageDialog.open()
    }

    Timer {
        //Times used for debugging and testing
        id:debugTimer
        interval: 1000; running: true; repeat: false
        onTriggered: {
            //testTools.carConnected = !testTools.carConnected
        }
    }
}
