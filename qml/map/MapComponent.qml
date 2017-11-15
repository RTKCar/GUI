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
    property int currentMarker: -1
    property int previousMarker: -1
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
        var marker = Qt.createQmlObject ('Marker {overlay: mapOverlay}', this)
        mapOverlay.addMapItem(marker)
        marker.z = mapOverlay.z+1
        marker.coordinate = mouseArea.lastCoordinate

        //update list of markers
        var myArray = new Array()
        for (var i = 0; i<count; i++){
            myArray.push(markers[i])
        }
        myArray.push(marker)
        markers = myArray

        if(markerCounter > 1) {
            //if new Marker was added
            if(currentMarker > 0) {
                //extending from a pressed marker

                markers[currentMarker].connectMarker(marker)
                //addGeoItem("PolylineItem", markers[currentMarker].coordinate, marker.coordinate)
                //addQuickPoly(markers[currentMarker].coordinate, marker.coordinate)
                addPolyline(markers[currentMarker].coordinate, marker.coordinate)
                currentMarker = -1
            } else {
                ///NEVER GETS EXECUTED

                //extending from previous placed marker
                console.log(markerCounter -1)
                console.log(markerCounter -2)
                markers[markerCounter -2].connectMarker(marker)
                //addGeoItem("PolylineItem", markers[markerCounter -1].coordinate, marker.coordinate)
                //addQuickPoly(markers[markerCounter -1].coordinate, marker.coordinate)
                addPolyline(markers[markerCounter -2].coordinate, marker.coordinate)
                console.log("extending connect")
            }
        }
    }

    function addGeoItem(item, cordi1, cordi2)
    {
        var count = mapOverlay.mapItems.length
        var co = Qt.createComponent(item+'.qml')
        if (co.status == Component.Ready) {
            var o = co.createObject(mapOverlay)
            o.setGeometry(cordi1, cordi2)
            mapOverlay.addMapItem(o)
            //update list of items
            var myArray = new Array()
            for (var i = 0; i<count; i++){
                myArray.push(mapItems[i])
            }
            myArray.push(o)
            mapItems = myArray

            console.log(item, "connected between ", cordi1, " and ", cordi2)

        } else {
            console.log(item + " is not supported right now, please call us later.")
        }
    }

    function addPolyline(coordinate1, coordinate2)
    {
        var count = mapOverlay.mapItems.length
        var co = Qt.createComponent('Polyline.qml')
        if (co.status == Component.Ready) {
            var o = co.createObject(mapOverlay)
            o.addCoord(coordinate1, coordinate2)
            mapOverlay.addMapItem(o)
            //update list of items
            var myArray = new Array()
            for (var i = 0; i<count; i++){
                myArray.push(mapItems[i])
            }
            myArray.push(o)
            mapItems = myArray

            console.log("connected between ", coordinate1, " and ", coordinate2)

        } else {
            console.log(" is not supported right now, please call us later.")
        }

        /*console.log("cord1 ",coordinate1)
        console.log("cord2 ",coordinate2)
        var count = mapOverlay.mapItems.length
        //var polyline = Qt.createQmlObject ('Polyline{}', mapOverlay)
        var polyline = Qt.createQmlObject ('Polyline
                    {path:[{latitude: coordinate1.latitude, longitude: coordinate1.lingitude},
                    {latitude: coordinate2.latitude, longitude: coordinate2.longitude}]}', mapOverlay)

        /*if (polyline.status == Component.Ready) {
            var o = co.createObject(map)
            //o.setGeometry(map.markers, currentMarker)
            polyline.addCoord(coordinate1)
            polyline.addCoord(coordinate2)
            //mapOverlay.addMapItems(polyline)
            mapOverlay.addMapItem(o)
            //update list of items
            var myArray = new Array()
            for (var i = 0; i<count; i++){
                myArray.push(mapItems[i])
            }
            myArray.push(o)
            mapItems = myArray

        } else {
            console.log(" is not supported right now, please call us later.")
        }*/

        /*polyline.addCoord(coordinate1)
        polyline.addCoord(coordinate2)
        mapOverlay.addMapItems(polyline)*/
        //mapOverlay.addMapItems(polyline)
        //update list of items
        /*var myArray = new Array()
        for (var i = 0; i<count; i++){
            myArray.push(mapItems[i])
        }
        myArray.push(o)
        mapItems = myArray


        /*var co = Qt.createComponent(item+'.qml')
        if (co.status == Component.Ready) {
            var o = co.createObject(map)
            o.setGeometry(map.markers, currentMarker)
            map.addMapItem(o)
            //update list of items
            var myArray = new Array()
            for (var i = 0; i<count; i++){
                myArray.push(mapItems[i])
            }
            myArray.push(o)
            mapItems = myArray

        } else {
            console.log(item + " is not supported right now, please call us later.")
        }*/
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

    function connectMarkers() {
        // if connection to node from previousMarker or existing
        if(markerCounter > 1 && currentMarker > -1) {
            if(previousMarker > -1) {
                // connection between two existing nodes
                markers[previousMarker].connectMarker(markers[currentMarker])
                addPolyline(markers[previousMarker].coordinate, markers[currentMarker].coordinate)
                previousMarker = -1
                currentMarker = -1
            } else {
                // connection from previously placed node to existing
                markers[markerCounter -1].connectMarker(markers[currentMarker])
                addPolyline(markers[markerCounter -1].coordinate, markers[currentMarker].coordinate)
                currentMarker = -1
            }
        }
    }

    function connectMarkerToExisting() {
        if(markerCounter > 1 && markerCounter != currentMarker) {
            markers[markerCounter].connectMarker(markers[currentMarker])
        }
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
            //console.log("first?")
            mapOverlay.lastX = mouse.x
            mapOverlay.lastY = mouse.y
            mapOverlay.pressX = mouse.x
            mapOverlay.pressY = mouse.y
            lastCoordinate = parentMap.toCoordinate(Qt.point(mouse.x, mouse.y))
            switch (delegateIndex) {
            case 0:
                //parentMap.zoomLevel = Math.floor(parentMap.zoomLevel + 1)
                break
            case 1:
                /*console.log(currentMarker)
                if(currentMarker > 0 && markerCounter > 1) {
                    console.log("connecting")
                    markers[markerCounter -1].connectMarker(markers[currentMarker])

                }
                else {
                    console.log("adding")
                    mapOverlay.addMarker()

                }*/
                mapOverlay.addMarker()
                break
            case 2:
                console.log("unfinished")
                //mapOverlay.deleteMarkers()
                break
            default:
                console.log("Unsupported operation")
            }
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
                    if(currentMarker != -1 && markerCounter > 1) {
                        markers[markerCounter -1].connectMarker(markers[currentMarker])
                        console.log("connecting")
                    }
                    else {
                        mapOverlay.addMarker()
                        console.log("adding")
                    }
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
