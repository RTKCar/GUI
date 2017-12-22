import QtQuick 2.7
//import QtQuick 2.5
import QtQuick 2.0
import QtQuick.Controls 1.4
import QtLocation 5.9
import QtPositioning 5.5
import QtQuick.Layouts 1.3
import "./map"
import myPackage 1.0

Item {
    id: appWindow
    property bool foll: false
    property bool approvedTrack: false
    property alias mapMap: map
    property alias delegateIndex: overlay.delegateIndex
    property alias mapComponent: overlay
    property MyTcpSocket myTcpSocket: null
    signal mapDone()

    Plugin {
        id: mapPlugin
        name: "osm"
        //name: "mapboxgl"
        //PluginParameter {name: "mapbox.map_id"; value: "mapbox.streets"}
        //PluginParameter {name: "mapbox.map_id"; value: "mapbox.outdoors"}
        //PluginParameter {name: "mapbox.map_id"; value: "mapbox.streets-basic"}
        //PluginParameter {name: "mapbox.map_id"; value: "mapbox.bright"}
        //PluginParameter {name: "mapbox.map_id"; value: "mapbox.emerald"}
        //PluginParameter {name: "mapbox.access_token"; value: "pk.eyJ1Ijoib2xpb2RkIiwiYSI6ImNqYWIxOGZscTB4M20ycXF1aDluM2NnaTgifQ.wYR97A-knsp-XR8wwrFSQg"}
        //PluginParameter {name: "mapboxgl.access_token"; value: "pk.eyJ1Ijoib2xpb2RkIiwiYSI6ImNqYWIxOGZscTB4M20ycXF1aDluM2NnaTgifQ.wYR97A-knsp-XR8wwrFSQg"}

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

            onApprovedChanged: {
                if(approved) {
                    approvedTrack = true;
                } else {
                    approvedTrack = false;
                }
            }
            onMapCompleted: mapDone()
        }


        /*function calculateScale()
        {
            var coord1, coord2, dist, text, f
            f = 0
            coord1 = map.toCoordinate(Qt.point(0,scale.y))
            coord2 = map.toCoordinate(Qt.point(0+scaleImage.sourceSize.width,scale.y))
            dist = Math.round(coord1.distanceTo(coord2))

            if (dist === 0) {
                // not visible
            } else {
                for (var i = 0; i < scaleLengths.length-1; i++) {
                    if (dist < (scaleLengths[i] + scaleLengths[i+1]) / 2 ) {
                        f = scaleLengths[i] / dist
                        dist = scaleLengths[i]
                        break;
                    }
                }
                if (f === 0) {
                    f = dist / scaleLengths[i]
                    dist = scaleLengths[i]
                }
            }

            text = Helper.formatDistance(dist)
            //scaleImage.width = (scaleImage.sourceSize.width * f) - 2 * scaleImageLeft.sourceSize.width
            //scaleText.text = text
        }*/

        //! [mapnavigation]
        // Enable pan, flick, and pinch gestures to zoom in and out
        gesture.acceptedGestures: MapGestureArea.PanGesture | MapGestureArea.FlickGesture | MapGestureArea.PinchGesture | MapGestureArea.RotationGesture | MapGestureArea.TiltGesture
        gesture.flickDeceleration: 3000
        gesture.enabled: true
        focus: true

        onCenterChanged:{
            scaleTimer.restart()
        }

        onZoomLevelChanged:{
            scaleTimer.restart()
        }

        onWidthChanged:{
            scaleTimer.restart()
        }

        onHeightChanged:{
            scaleTimer.restart()
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
                //map.calculateScale()
            }
        }
        onActiveFocusChanged: {
            console.log("Mapview focus ", activeFocus)
        }
    }
}
