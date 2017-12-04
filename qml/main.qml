import QtQuick 2.5
import QtQuick.Controls 1.4
import QtLocation 5.6
import QtPositioning 5.5
import QtQuick.Window 2.0
import QtQuick.Layouts 1.3
import "map"
import "menus"
import myPackage 1.0

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
            onCenterMap: {
                mapview.center = !mapview.center
            }
            onSendMap: {
                mapview.mapComponent.sendMap()
                //mapview.sendMap = !mapview.sendMap
            }
            printButton.onClicked: {
                mapview.mapComponent.printMap()
            }
            disconnectButton.onClicked: {
                mytcpSocket.disconnect()
            }

            onConnect: {
                var _host = "0.0.0.0"
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

    MyTcpSocket {
        id: mytcpSocket
        onSocketConnected: {
            testTools.connected = true
        }
        onSocketDisconnected: {
            testTools.connected = false
        }
    }
}
