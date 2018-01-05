import QtQuick 2.7
import QtQuick 2.0
import QtQuick.Controls 1.4
import QtLocation 5.9
import QtPositioning 5.5
import QtQuick.Layouts 1.3
import "./map"
import "./menus"
import myPackage 1.0

Item {
    id: appWindow
    property bool foll: false
    property bool approvedTrack: false
    property alias mapMap: map
    property alias delegateIndex: overlay.delegateIndex
    property alias mapComponent: overlay
    property MyTcpSocket myTcpSocket: null
    property MyStatusBar statsBar: null

    Plugin {
        id: mapPlugin
        //name: "osm"
        name: "mapboxgl"
        //PluginParameter {name: "mapbox.map_id"; value: "mapbox.outdoors"}
        PluginParameter {name: "mapboxgl.access_token"; value: "pk.eyJ1Ijoib2xpb2RkIiwiYSI6ImNqYWIxOGZscTB4M20ycXF1aDluM2NnaTgifQ.wYR97A-knsp-XR8wwrFSQg"}

    }

    Map {
        id: map
        property PositionSource positionSource

        anchors.fill: parent
        plugin: mapPlugin
        center: QtPositioning.coordinate(56.675186674134046, 12.863582808095572) // KungsG
        maximumZoomLevel: 25
        minimumZoomLevel: 3
        zoomLevel:14

        MapComponent{
            id:overlay
            parentMap: map
            tcpSocket: myTcpSocket
            statusBar: statsBar

            onApprovedChanged: {
                if(approved) {
                    approvedTrack = true;
                } else {
                    approvedTrack = false;
                }
            }
        }

        function calculateScale() {
            if(zoomLevel%1 > 0.5) {
                zoomLevel = zoomLevel - (zoomLevel%1) + 1
            }
            else {
                zoomLevel = zoomLevel - (zoomLevel%1)
            }
        }

        // Enable pan, flick, and pinch gestures to zoom in and out
        gesture.acceptedGestures: MapGestureArea.PanGesture | MapGestureArea.FlickGesture | MapGestureArea.PinchGesture | MapGestureArea.RotationGesture | MapGestureArea.TiltGesture
        gesture.flickDeceleration: 3000
        gesture.enabled: true
        focus: true

        onZoomLevelChanged:{
            //scaleTimer.restart()
        }

        PositionSource{
            id: positionSource
            active: foll

            onPositionChanged: {
                map.center = positionSource.position.coordinate
                foll = false
            }
        }

        Timer {
            id: scaleTimer
            interval: 100
            running: false
            repeat: false
            onTriggered: {
                map.calculateScale()
            }
        }
    }
}
