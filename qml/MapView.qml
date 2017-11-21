import QtQuick 2.5
import QtQuick 2.0
import QtQuick.Controls 1.4
import QtLocation 5.9
import QtPositioning 5.5
import QtQuick.Layouts 1.3
import "./map"

Item {
    id: appWindow
    property bool foll: false
    property bool deleteAll: false
    property bool center: false
    property alias mapMap: map
    property alias delegateIndex: overlay.delegateIndex

    Plugin {
        id: mapPlugin
        name: "osm"
    }

    onDeleteAllChanged: {
        overlay.deleteMarkers()
        overlay.deleteAllPolylines()
    }

    onCenterChanged: {
        overlay.fitViewportToVisibleMapItems()
        //overlay.fitViewportToMapItems()
    }

    Map {
        id: map
        property PositionSource positionSource

        anchors.fill: parent
        plugin: mapPlugin
        center: QtPositioning.coordinate(56.41548, 12.987562) // Hasslöv
        maximumZoomLevel: 25
        //maximumZoomLevel: 10
        minimumZoomLevel: 3
        //minimumZoomLevel: 20
        zoomLevel:14
        //zoomLevel: Math.floor((maximumZoomLevel - minimumZoomLevel)/2)

        MapComponent{
            id:overlay
            parentMap: map
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
            /*if (map.followme)
                if (map.center != positionSource.position.coordinate) map.followme = false*/
        }

        onZoomLevelChanged:{
            scaleTimer.restart()
            //if (map.followme) map.center = positionSource.position.coordinate
        }

        onWidthChanged:{
            //followME()
            scaleTimer.restart()
        }

        onHeightChanged:{
            scaleTimer.restart()
        }

        /*onDelegateIndexChanged: {
            console.log("delegate", delegateIndex)
        }*/

        /*Component.onCompleted: {
            markers = new Array();
            mapItems = new Array();
        }*/

        PositionSource{
            id: positionSource
            active: foll
            //active: followme

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

        /*MouseArea {
            id: mouseArea
            property variant lastCoordinate
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton

            onPressed : {
                map.lastX = mouse.x
                map.lastY = mouse.y
                map.pressX = mouse.x
                map.pressY = mouse.y
                lastCoordinate = map.toCoordinate(Qt.point(mouse.x, mouse.y))
            }

            onPositionChanged: {
                if (mouse.button == Qt.LeftButton) {
                    map.lastX = mouse.x
                    map.lastY = mouse.y
                }
            }


            onDoubleClicked: {
                var mouseGeoPos = map.toCoordinate(Qt.point(mouse.x, mouse.y));
                var preZoomPoint = map.fromCoordinate(mouseGeoPos, false);
                if (mouse.button === Qt.LeftButton) {
                    switch (delegateIndex) {
                    case 0:
                        map.zoomLevel = Math.floor(map.zoomLevel + 1)
                        break
                    case 1:
                        map.addMarker()
                        break
                    case 2:
                        console.log("unfinished")
                    default:
                        console.log("Unsupported operation")
                    }

                } else if (mouse.button === Qt.RightButton) {
                    map.zoomLevel = Math.floor(map.zoomLevel - 1)
                }
                var postZoomPoint = map.fromCoordinate(mouseGeoPos, false);
                var dx = postZoomPoint.x - preZoomPoint.x;
                var dy = postZoomPoint.y - preZoomPoint.y;

                var mapCenterPoint = Qt.point(map.width / 2.0 + dx, map.height / 2.0 + dy);
                map.center = map.toCoordinate(mapCenterPoint);

                map.lastX = -1;
                map.lastY = -1;
                //lastX = -1;
                //lastY = -1;
            }
        }*/
    //! [end]
    }


}
