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
    property int polylineCounter: 0
    property int currentMarker: -1
    property int previousMarker: -1
    property int lastX : -1
    property int lastY : -1
    property int pressX : -1
    property int pressY : -1
    property int jitterThreshold : 30
    property int delegateIndex : 0
    property bool connection: false
    property bool approved: false

    anchors.fill: parent
    plugin: Plugin { name: "itemsoverlay" }
    //gesture.enabled: true
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

        if(mapOverlay.markers.length > 1) {
            console.log("count > <", mapOverlay.markers.length)
        //if(markerCounter > 1) {
            /*console.log(markers[markerCounter -2].returnID(), " has ",
                        markers[markerCounter -2].connectedMarkers(), " connections")
            console.log(markers[markerCounter -2].returnID(), " has ",
                        markers[markerCounter -2].connectedMarks(), " connections")*/
            //if new Marker was added
            if(currentMarker > 0) {
                //extending from a pressed marker
                console.log("extending?")
                if(!markers[currentMarker].isConnectedTo(marker)){
                    markers[currentMarker].connectMarker(marker)
                    addPolyline(markers[currentMarker], marker)
                }
                currentMarker = -1
            } else if(markers[markers.length -2].connectedMarkers() > 1) {
                //} else if(markers[markerCounter -2].connectedMarkers() > 1) {
                //add new marker without Polyline
                //console.log(markers[markerCounter -2].connectedMarkers())
                console.log("new mark")
            } else {
                //extending from previous placed marker
                if(!markers[markers.length -2].isConnectedTo(marker)){
                    markers[markers.length -2].connectMarker(marker)
                    addPolyline(markers[markers.length -2], marker)
                }
                /*if(!markers[markerCounter -2].isConnectedTo(marker)){
                    markers[markerCounter -2].connectMarker(marker)
                    addPolyline(markers[markerCounter -2], marker)
                }*/
                console.log("extending connect")
            }
        }
        connection = false
        //printApproved()
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
            polylineCounter++
            var o = co.createObject(mapOverlay)
            o.setID(polylineCounter)
            o.setOverlay(mapOverlay)
            o.addCoord(coordinate1, coordinate2)
            mapOverlay.addMapItem(o)
            //update list of items
            var myArray = new Array()
            for (var i = 0; i<count; i++){
                myArray.push(mapItems[i])
            }
            myArray.push(o)
            mapItems = myArray

            //console.log("connected between ", coordinate1, " and ", coordinate2)

        } else {
            console.log(" is not supported right now, please call us later.")
        }
    }

    function deleteMarker(markerArray, polylineArray, markID) {
        //var mark = markerIndex(markID)
        console.log("marker ID ", markID)
        console.log("arrayLength ", markerArray.length)
        var count = markerArray.length
        for (var i = count -1; i> -1; i--){
            console.log("round ", i)
            //var tempMark = markerIndex(markerArray[i])
            //console.log("tempMarkIndex ", tempMark)
            deletePolyline(markID, markerArray[i], polylineArray[i])
            /*if(mark > -1 && tempMark > -1) {
                deletePolyline(mark, tempMark, polylineArray[i])
            }*/
        }
        var mark = markerIndex(markID)
        if(mark > -1){
            mapOverlay.removeMapItem(mapOverlay.markers[mark])
            mapOverlay.markers[mark].destroy()
            var myArray = new Array()
            for (var i = 0; i<markers.length; i++){
                if(i != mark)
                    myArray.push(markers[i])
            }
            markers = myArray
        }
        console.log("markers after deletion ", markers.length)
        console.log("polylines after deletion ", mapItems.length)
    }

    function deleteMarkers()
    {
        var count = mapOverlay.markers.length
        for (var i = 0; i<count; i++){
            mapOverlay.removeMapItem(mapOverlay.markers[i])
            mapOverlay.markers[i].destroy()
        }
        mapOverlay.markers = []
        //markerCounter = 0
        console.log("markersDeleted")
        //printApproved()
    }

    function deletePolyline(marker1, marker2, polylineNr) {
        var mark1 = markerIndex(marker1)
        var mark2 = markerIndex(marker2)
        console.log(marker1, " ", marker2, " ",  polylineNr)
        if(mark1 > -1 && mark2 > -1){
            markers[mark1].disconnectMarker(marker2)
            markers[mark1].disconnectPolyline(polylineNr)
            markers[mark2].disconnectMarker(marker1)
            markers[mark2].disconnectPolyline(polylineNr)
        }
        var polyIndex = polyLineIndex(polylineNr)
        if(polyIndex > -1){
            console.log("removing line at index ", polyIndex)
            mapOverlay.removeMapItem(mapOverlay.mapItems[polyIndex])
            mapOverlay.mapItems[polyIndex].destroy()
            var myArray = new Array()
            for (var i = 0; i<mapItems.length; i++){
                if(i != polyIndex)
                    myArray.push(mapItems[i])
            }
            mapItems = myArray
            //mapOverlay.mapItems.pop(mapItems[polyIndex])
        } else {
            console.log("index to low")
        }
        //polylineCounter--
    }

    function deleteAllPolylines()
    {
        var count = mapOverlay.mapItems.length
        for (var i = 0; i<count; i++){
            mapOverlay.removeMapItem(mapOverlay.mapItems[i])
            mapOverlay.mapItems[i].destroy()
        }
        mapOverlay.mapItems = []
        //polylineCounter = 0
        //console.log("ItemsDeleted")
    }

    function connectMarkers() {
        // if connection to node from previousMarker or existing
        if(markers.length > 1 && currentMarker > -1) {
            if(previousMarker > -1 && !markers[previousMarker].isConnectedTo(markers[currentMarker])) {
                // connection between two existing nodes
                markers[previousMarker].connectMarker(markers[currentMarker])
                addPolyline(markers[previousMarker], markers[currentMarker])
                previousMarker = -1
                currentMarker = -1
                console.log("connection between existing")
                connection = true
            } else if(!connection && !markers[markers.length -1].isConnectedTo(markers[currentMarker])){
                //} else if(!connection && !markers[markerCounter -1].isConnectedTo(markers[currentMarker])){
                //} else if(!markers[markerCounter -1].isConnectedTo(markers[currentMarker])){
                //} else if((markerCounter -1) != currentMarker){
                // connection from previously placed node to existing
                markers[markers.length -1].connectMarker(markers[currentMarker])
                addPolyline(markers[markers.length -1], markers[currentMarker])
                /*markers[markerCounter -1].connectMarker(markers[currentMarker])
                addPolyline(markers[markerCounter -1], markers[currentMarker])*/
                currentMarker = -1
                console.log("connect to existing")
                connection = true
            } else {
                console.log("node choosed for next round")
            }
        }
        //printApproved()
    }

    function polyLineIndex(polyID) {
        var count = mapOverlay.mapItems.length
        for (var i = 0; i<count; i++){
            if(mapOverlay.mapItems[i].polylineID == polyID)
                return i
        }
        return -1
    }

    function markerIndex(markID) {
        var count = mapOverlay.markers.length
        for (var i = 0; i<count; i++){
            if(mapOverlay.markers[i].markerID == markID)
                return i
        }
        return -1
    }

    function connectMarkerToExisting() {
        if(markerCounter > 1 && markerCounter != currentMarker) {
            markers[markerCounter].connectMarker(markers[currentMarker])
        }
    }

    function aprovedTrack() {
        if(markers.length < 3) {
            approved = false
            return false
        }
        for (var i = 0; i< markers.length; i++){
            if (markers[i].connectedMarkers() < 2){
                approved = false
                return false
            }
        }
        approved = true
        return true
    }

    function printApproved() {
        console.log("The track is ")
        if(!aprovedTrack()) {
            console.log("not ")
        }
        console.log("approved")
    }

    function makeJSONs() {
        var jarr = new Array()
        for (var i = 0; i< markers.length; i++){
            markers[i].createJson()
            jarr.push(markers[i].json)
        }
        if(jarr.length > 0){
            console.log("json attributes: ", Object.keys(jarr[0]))
        }
        jarr = JSON.stringify(jarr)
        console.log(jarr)
        jarr = JSON.parse(jarr)
        delete jarr[0].id
        for (var i = 0; i< jarr.length; i++){
            console.log(jarr[i].id, " is connected to ", jarr[i].connections)
        }
    }

    Component.onCompleted: {
        markers = new Array();
        mapItems = new Array();
        console.log("maxZoom", overlay.maximumZoomLevel)
        console.log("minZoom", overlay.minimumZoomLevel)
    }

    onDelegateIndexChanged: {
        console.log("delegate", delegateIndex)
    }

    MouseArea {
        id: mouseArea
        property variant lastCoordinate
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked : {
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
        }
    }

}
