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
    //signal sendJson()

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
                mtpSocket.num = 0
            }
            onDeleteAll: {
                mapview.deleteAll = !mapview.deleteAll
            }
            onCenterMap: {
                mapview.center = !mapview.center
            }
            onMakeJSONs: {
                mapview.makeJsons = !mapview.makeJsons
                //sendJson()
                //var m = "newMao"
                //mytcpSocket.Map = m
            }
            onConnect: {
                mytcpSocket.doConnect()
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
            console.log("conn")
            testTools.connected = true
        }
        onSocketDisconnected: {
            console.log("notconn")
            testTools.connected = false
        }
    }

    /*function sendToMe() {
        console.log("sent to me")
    }*/
}
