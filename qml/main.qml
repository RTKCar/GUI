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
    height: 600
    width: 800
    title: qsTr("RTKCar")
    //height: Screen.height
    //width: Screen.width


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
                mytcpSocket.sendMessage("START;")
            }
            stopButton.onClicked: {
                mytcpSocket.sendMessage("STOP;")
            }


            onConnect: {
                //var _host = "192.168.80.14"
                var _host = "0.0.0.0"
                //var _port = 2008
                var _port = 5001
                if(host.acceptableInput) {
                    _host = host.text
                }
                if(port.acceptableInput) {
                    _port = parseInt(port.text)
                }
                mytcpSocket.doConnect(_host, _port)
            }

            mapSourca: mapview.mapMap
            onDelegate: {
                mapview.delegateIndex = index
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
            //testTools.ServerIndicator.rlyActive = true
            testTools.connected = true
        }
        onSocketDisconnected: {
            //testTools.ServerIndicator.rlyActive = false
            testTools.connected = false
        }
        onErrorConnecting: {
            errorDialog.text = errorMessage
            errorDialog.open()
        }
    }
    onClosing: {
        close.accepted = false
        messageDialog.open()
    }
}
