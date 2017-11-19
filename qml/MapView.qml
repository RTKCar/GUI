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
    property alias mapMap: map
    //property IntValidator validator : 0
    property alias delegateIndex: overlay.delegateIndex

    Plugin {
        id: mapPlugin
        name: "osm"
    }

    onDeleteAllChanged: {
        console.log("bool changed")
        overlay.deleteMarkers()
        overlay.deletePolylines()
    }

    /*onDeletAllaChanged: {
        overlay.deleteMarkers()
    }*/

    Map {
        id: map
        /*property variant markers
        property variant mapItems
        property int markerCounter: 0 // counter for total amount of markers. Resets to 0 when number of markers = 0
        property int currentMarker
        property int lastX : -1
        property int lastY : -1
        property int pressX : -1
        property int pressY : -1
        property int jitterThreshold : 30
        property int delegateIndex : 0*/
        //property bool followme: false
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

        /*onDelegateIndexChanged: {
            console.log("delegate", delegateIndex)
        }*/

        /*Map {
                id: mapOverlay
                anchors.fill: parent
                plugin: Plugin { name: "itemsoverlay" }
                gesture.enabled: false
                center: map.center
                color: 'transparent' // Necessary to make this map transparent
                minimumFieldOfView: map.minimumFieldOfView
                maximumFieldOfView: map.maximumFieldOfView
                minimumTilt: map.minimumTilt
                maximumTilt: map.maximumTilt
                minimumZoomLevel: map.minimumZoomLevel
                maximumZoomLevel: map.maximumZoomLevel
                zoomLevel: map.zoomLevel
                tilt: map.tilt;
                bearing: map.bearing
                fieldOfView: map.fieldOfView
                z: map.z + 1

                /*MapCircle {
                    id: circle
                    center: QtPositioning.coordinate(44, 10)
                    radius: 200000
                    border.width: 5

                    MouseArea {
                        anchors.fill: parent
                        drag.target: parent
                    }
                }*/
                /*Marker{
                    coordinate: QtPositioning.coordinate(44, 10)
                }
                Circle {
                    center: QtPositioning.coordinate(56.41548, 12.987562)
                }
        }*/

        /*MapCircle {
            id: circle
            center: QtPositioning.coordinate(44, 10)
            radius: 200000
            border.width: 5

            MouseArea {
                anchors.fill: parent
                drag.target: parent
            }
        }*/

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

        /*function addMarker()
        {
            var count = map.markers.length
            markerCounter++
            //var marker = Qt.createQmlObject('import QtQuick 2.0; Rectangle {color: "red"; width: 20; height: 20}',
                                            //map)
            var marker = Qt.createQmlObject ('MapComponent {}', map)
            //var marker = Qt.createQmlObject ('Marks {}', map)
            //var marker = Qt.createQmlObject ('Marker {}', map)
            //var marker = Qt.createQmlObject ('Circle {}', map)
            //var marker = Circle {center: mouseArea.lastCoordinate}
            map.addMapItem(marker)
            marker.z = map.z+1
            marker.coordinate = mouseArea.lastCoordinate

            //update list of markers
            var myArray = new Array()
            for (var i = 0; i<count; i++){
                myArray.push(markers[i])
            }
            myArray.push(marker)
            markers = myArray
        }*/

        //! [mapnavigation]
        // Enable pan, flick, and pinch gestures to zoom in and out
        gesture.acceptedGestures: MapGestureArea.PanGesture | MapGestureArea.FlickGesture | MapGestureArea.PinchGesture | MapGestureArea.RotationGesture | MapGestureArea.TiltGesture
        gesture.flickDeceleration: 3000
        gesture.enabled: true

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
