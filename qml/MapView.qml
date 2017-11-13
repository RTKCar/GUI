import QtQuick 2.5
import QtQuick.Controls 1.4
import QtLocation 5.6
import QtPositioning 5.5
import QtQuick.Layouts 1.3
import "map"

Item {
    id: appWindow
    property bool foll: false
    property alias mapMap: map
    //property IntValidator validator : 0
    property alias delegateIndex: map.delegateIndex

    Plugin {
        id: mapPlugin
        name: "osm"
    }

    Map {
        id: map
        property variant markers
        property variant mapItems
        property int markerCounter: 0 // counter for total amount of markers. Resets to 0 when number of markers = 0
        property int currentMarker
        property int lastX : -1
        property int lastY : -1
        property int pressX : -1
        property int pressY : -1
        property int jitterThreshold : 30
        property int delegateIndex : 0
        //property bool followme: false
        property PositionSource positionSource

        anchors.fill: parent
        plugin: mapPlugin
        center: QtPositioning.coordinate(56.41548, 12.987562) // Hasslöv
        maximumZoomLevel: 20
        //maximumZoomLevel: 10
        minimumZoomLevel: 3
        //minimumZoomLevel: 20
        zoomLevel:14
        //zoomLevel: Math.floor((maximumZoomLevel - minimumZoomLevel)/2)

        function calculateScale()
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
        }

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

        onDelegateIndexChanged: {
            console.log("delegate", delegateIndex)
        }

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

        MouseArea {
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
                    map.zoomLevel = Math.floor(map.zoomLevel + 1)
                } else if (mouse.button === Qt.RightButton) {
                    map.zoomLevel = Math.floor(map.zoomLevel - 1)
                }
                var postZoomPoint = map.fromCoordinate(mouseGeoPos, false);
                var dx = postZoomPoint.x - preZoomPoint.x;
                var dy = postZoomPoint.y - preZoomPoint.y;

                var mapCenterPoint = Qt.point(map.width / 2.0 + dx, map.height / 2.0 + dy);
                map.center = map.toCoordinate(mapCenterPoint);

                lastX = -1;
                lastY = -1;
            }
        }
    //! [end]
    }


}
