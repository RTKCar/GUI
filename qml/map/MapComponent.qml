import QtQuick 2.5
import QtQuick.Controls 1.4
import QtLocation 5.9
import QtPositioning 5.5

Map {
    id: mapOverlay

    property Map parentMap: null
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

    anchors.fill: parent
    plugin: Plugin { name: "itemsoverlay" }
    gesture.enabled: false
    center: parentMap.center
    color: 'transparent' // Necessary to make this map transparent
    minimumFieldOfView: parentMap.minimumFieldOfView
    maximumFieldOfView: parentMap.maximumFieldOfView
    minimumTilt: parentMap.minimumTilt
    maximumTilt: parentMap.maximumTilt
    minimumZoomLevel: parentMap.minimumZoomLevel
    maximumZoomLevel: parentMap.maximumZoomLevel
    zoomLevel: parentMap.zoomLevel
    tilt: parentMap.tilt;
    bearing: parentMap.bearing
    fieldOfView: parentMap.fieldOfView
    z: parentMap.z + 1

    function addMarker()
    {
        var count = mapOverlay.markers.length
        markerCounter++
        //var marker = Qt.createQmlObject('import QtQuick 2.0; Rectangle {color: "red"; width: 20; height: 20}',
                                        //map)
        var marker = Qt.createQmlObject ('Marker {overlay: mapOverlay}', map)
        //var marker = Qt.createQmlObject ('Mark {overlay: mapOverlay}', map)
        //var marker = Qt.createQmlObject ('Marker {}', map)
        //var marker = Qt.createQmlObject ('Circle {overlay: mapOverlay}', map)
        //var marker = Circle {center: mouseArea.lastCoordinate}
        mapOverlay.addMapItem(marker)
        marker.z = mapOverlay.z+1
        //marker.center = mouseArea.lastCoordinate
        marker.coordinate = mouseArea.lastCoordinate

        //update list of markers
        var myArray = new Array()
        for (var i = 0; i<count; i++){
            myArray.push(markers[i])
        }
        myArray.push(marker)
        markers = myArray
        console.log("marker added, nr: ", markers.length)
        console.log("at coordinate", marker.coordinate)
    }

    function deleteMarkers()
    {
        var count = mapOverlay.markers.length
        for (var i = 0; i<count; i++){
            mapOverlay.removeMapItem(mapOverlay.markers[i])
            mapOverlay.markers[i].destroy()
        }
        mapOverlay.markers = []
        markerCounter = 0
        console.log("markersDeleted")
    }


    Component.onCompleted: {
        markers = new Array();
        mapItems = new Array();
    }

    onDelegateIndexChanged: {
        console.log("delegate", delegateIndex)
    }

    MouseArea {
        id: mouseArea
        property variant lastCoordinate
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onPressed : {
            mapOverlay.lastX = mouse.x
            mapOverlay.lastY = mouse.y
            mapOverlay.pressX = mouse.x
            mapOverlay.pressY = mouse.y
            lastCoordinate = parentMap.toCoordinate(Qt.point(mouse.x, mouse.y))
        }

        onPositionChanged: {
            if (mouse.button == Qt.LeftButton) {
                parentMap.lastX = mouse.x
                parentMap.lastY = mouse.y
            }
        }


        onDoubleClicked: {
            var mouseGeoPos = parentMap.toCoordinate(Qt.point(mouse.x, mouse.y));
            var preZoomPoint = parentMap.fromCoordinate(mouseGeoPos, false);
            if (mouse.button === Qt.LeftButton) {
                switch (delegateIndex) {
                case 0:
                    parentMap.zoomLevel = Math.floor(parentMap.zoomLevel + 1)
                    break
                case 1:
                    mapOverlay.addMarker()
                    break
                case 2:
                    console.log("unfinished")
                    mapOverlay.deleteMarkers()
                    break
                default:
                    console.log("Unsupported operation")
                }

            } else if (mouse.button === Qt.RightButton) {
                parentMap.zoomLevel = Math.floor(parentMap.zoomLevel - 1)
            }
            var postZoomPoint = parentMap.fromCoordinate(mouseGeoPos, false);
            var dx = postZoomPoint.x - preZoomPoint.x;
            var dy = postZoomPoint.y - preZoomPoint.y;

            var mapCenterPoint = Qt.point(parentMap.width / 2.0 + dx, parentMap.height / 2.0 + dy);
            parentMap.center = parentMap.toCoordinate(mapCenterPoint);

            mapOverlay.lastX = -1;
            mapOverlay.lastY = -1;
            //lastX = -1;
            //lastY = -1;
        }
    }

}
