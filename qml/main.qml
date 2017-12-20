import QtQuick 2.5
//import QtQuick.Controls 1.4
import QtLocation 5.6
import QtPositioning 5.5
import QtQuick.Window 2.0
import QtQuick.Layouts 1.3
import "map"
import "menus"
import myPackage 1.0
import QtQuick.Controls 2.1
import QtQuick.Dialogs 1.1
//import myFilePackage 1.0

ApplicationWindow {
    id: appWindow
    visible: true
    height: 600
    width: 800
    title: qsTr("RTKCar")
    //height: Screen.height
    //width: Screen.width
    property variant testTrack
    property string testJson: "[{\"conns\":[2,4],\"coord\":{\"lat\":56.67507440022754,\"long\":12.863477416073408},\"id\":1},{\"conns\":[1,3],\"coord\":{\"lat\":56.67501716123367,\"long\":12.862938208261255},\"id\":2},{\"conns\":[2,4],\"coord\":{\"lat\":56.67521716922783,\"long\":12.862889771317356},\"id\":3},{\"conns\":[3,1],\"coord\":{\"lat\":56.675154300977404,\"long\":12.863227111490545},\"id\":4}]"
    property string testJson2: "[{\"conns\":[2,11],\"coord\":{\"lat\":56.67515246104728,\"long\":12.863372800241422},\"id\":1},{\"conns\":[1,3],\"coord\":{\"lat\":56.67511042678674,\"long\":12.863445719230384},\"id\":2},{\"conns\":[2,4],\"coord\":{\"lat\":56.67505591647124,\"long\":12.863421784811521},\"id\":3},{\"conns\":[3,5],\"coord\":{\"lat\":56.6749451487393,\"long\":12.863330007246901},\"id\":4},{\"conns\":[4,6],\"coord\":{\"lat\":56.67494359676431,\"long\":12.863260661334266},\"id\":5},{\"conns\":[5,7],\"coord\":{\"lat\":56.67503008569954,\"long\":12.862736793919197},\"id\":6},{\"conns\":[6,8],\"coord\":{\"lat\":56.67506342121084,\"long\":12.862680372970487},\"id\":7},{\"conns\":[7,9],\"coord\":{\"lat\":56.67510218150271,\"long\":12.862707545068304},\"id\":8},{\"conns\":[8,10],\"coord\":{\"lat\":56.67520350942087,\"long\":12.862794814376713},\"id\":9},{\"conns\":[9,11],\"coord\":{\"lat\":56.6752114570436,\"long\":12.862890068275703},\"id\":10},{\"conns\":[10,1],\"coord\":{\"lat\":56.67519952675279,\"long\":12.863073339644728},\"id\":11}]"
    property string testJson3: "[{\"conns\":[2,11,12,14],\"coord\":{\"lat\":56.67515246104728,\"long\":12.863372800241422},\"id\":1},{\"conns\":[1,3],\"coord\":{\"lat\":56.67511042678674,\"long\":12.863445719230384},\"id\":2},{\"conns\":[2,4],\"coord\":{\"lat\":56.67505591647124,\"long\":12.863421784811521},\"id\":3},{\"conns\":[3,5],\"coord\":{\"lat\":56.6749451487393,\"long\":12.863330007246901},\"id\":4},{\"conns\":[4,6],\"coord\":{\"lat\":56.67494359676431,\"long\":12.863260661334266},\"id\":5},{\"conns\":[5,7],\"coord\":{\"lat\":56.67503008569954,\"long\":12.862736793919197},\"id\":6},{\"conns\":[6,8],\"coord\":{\"lat\":56.67506342121084,\"long\":12.862680372970487},\"id\":7},{\"conns\":[7,9],\"coord\":{\"lat\":56.67510218150271,\"long\":12.862707545068304},\"id\":8},{\"conns\":[8,10],\"coord\":{\"lat\":56.67520350942087,\"long\":12.862794814376713},\"id\":9},{\"conns\":[9,11],\"coord\":{\"lat\":56.6752114570436,\"long\":12.862890068275703},\"id\":10},{\"conns\":[10,1],\"coord\":{\"lat\":56.67519952675279,\"long\":12.863073339644728},\"id\":11},{\"conns\":[1,13],\"coord\":{\"lat\":56.6752096601713,\"long\":12.863366193609892},\"id\":12},{\"conns\":[12,14],\"coord\":{\"lat\":56.67520735982367,\"long\":12.863462849169679},\"id\":13},{\"conns\":[13,1],\"coord\":{\"lat\":56.67516926592788,\"long\":12.863456232162662},\"id\":14}]"
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
                //Update statusIndicator of state
                testTools.approvedT = approvedTrack
            }
            onMapDone: {
                //Make sure the map is fully loaded before adding Markers to it
                //mapComponent.loadJsonMarkers(testJson3)
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
                mytcpSocket.sendMessage("EXIT;")
            }
            startButton.onClicked: {
                //Call apropriate functions at signal
                mytcpSocket.sendMessage("START;" + speedBox.currentText + ";")
                testTools.startButton.enabled = false
                testTools.stopButton.enabled = true
            }
            stopButton.onClicked: {
                //Call apropriate functions at signal
                mytcpSocket.sendMessage("STOP;")
                testTools.carConnected = false
            }

            onSimulate: {
                //Simulate Car on the map
                mapview.mapComponent.simulateCar = value
            }
            saveButton.onClicked: {
                //var ans = fileDialog.saveFile("provTex")
                //console.log("save answer ", ans)
                //fileDialog.selectExisting = false
                //fileDialog.open()
                fileDialog.save("nyText")
            }
            loadButton.onClicked: {
                //var ans = fileDialog.loadFile()
                //console.log("load answer ", ans)
                //fileDialog.selectExisting = true
                //fileDialog.open()
                fileDialog.load()
            }


            onConnect: {
                //specifies default host & port and checks input before connecting
                var _host = "192.168.81.52"
                //var _host = "0.0.0.0"
                var _port = 2009
                //var _port = 5001
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

        Timer {
            //Timer used to simulate car and predefined Markers on map
                interval: 1000; running: true; repeat: true
                onTriggered: {
                    /*mapview.mapComponent.setCarBearing(testTrack[trackCount])
                    trackCount++
                    if(trackCount === testTrack.length)
                        trackCount = 0*/
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
            testTrack = []
            mapview.mapComponent.removeCar()
            //OR ?????? testTrack = new Array();
        }
        onErrorConnecting: {
            errorDialog.text = errorMessage
            errorDialog.open()
        }
        onRecieved: {
            //Split recieved message to extract latitude and longitude for car.
            var obj = message.split(";")
            for (var i = 0; i< obj.length; i++){
                var latlong = obj[i].split(",")
                if(latlong.length > 1) {
                    //console.log("lat: " + latlong[0])
                    //console.log("long: " + latlong[1])
                    testTrack.push(QtPositioning.coordinate(latlong[0], latlong[1]))
                    mapview.mapComponent.setCarBearing(testTrack[trackCount])
                    trackCount++
                    if(trackCount === testTrack.length)
                        trackCount = 0
                    console.log(testTrack.length, " length of testTrack")
                    if(testTrack.length === 1) {
                        console.log("tracklength == 1")
                        testTools.carConnected = true
                    }

                    //!!!!!!!!!!!!!!!!
                    // set Start/Stop buttons depending on car_data
                    //!!!!!!!!!!!!!!!!
                }
            }
        }
    }
    onClosing: {
        //Make sure messageDialog is shown before closing
        close.accepted = false
        messageDialog.open()
    }

    MyFileDialog{
        id: fileDialog

        onTextReceived: {
            console.log("text Received ", textR)
        }

        /*onSaveFile: {
            fileReaderWriter.write(filePath, "testMessage")
        }
        onLoadFile: {
            fileReaderWriter.read(filePath)
        }*/
    }

    /*FileReaderWriter {
        //id: fileReaderWriter
    }*/

    Component.onCompleted: {
        testTrack = new Array();
        //populate testTrack for simulation of track.
        /*var jsonObj = JSON.parse(testJson2)
        for (var i = 0; i<jsonObj.length; i++){
            var lat = jsonObj[i].coord.lat
            var longi = jsonObj[i].coord.long
            testTrack.push(QtPositioning.coordinate(lat, longi))
        }*/
    }
}
