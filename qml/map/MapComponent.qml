import QtQuick 2.7
//import QtQuick 2.5
import QtQuick.Controls 1.4
import QtLocation 5.9
import QtPositioning 5.5
import myPackage 1.0
import QtQuick.Dialogs 1.1
import "../menus"

Map {
    id: mapOverlay

    property Map parentMap: null
    property MyTcpSocket tcpSocket: null
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
    property int delegateIndex : 0
    property bool connection: false
    property bool approved: false
    property variant jsonMap
    property Car firstCar: null
    property variant carPosition: null
    property bool simulateCar: false
    property int previousCarPosition: -1

    signal trackApproved()
    signal mapCompleted()

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
        var marker = createMarker(mouseArea.lastCoordinate, 1)
        /*var count = mapOverlay.markers.length
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
        markers = myArray*/

        if(mapOverlay.markers.length > 1) {
            //console.log("count > <", mapOverlay.markers.length)
        //if(markerCounter > 1) {
            /*console.log(markers[markerCounter -2].returnID(), " has ",
                        markers[markerCounter -2].connectedMarkers(), " connections")
            console.log(markers[markerCounter -2].returnID(), " has ",
                        markers[markerCounter -2].connectedMarks(), " connections")*/
            //if new Marker was added
            if(currentMarker > 0) {
                //extending from a pressed marker
                //console.log("extending?")
                if(!markers[currentMarker].isConnectedTo(marker)){
                    markers[currentMarker].connectMarker(marker)
                    addPolyline(markers[currentMarker], marker)
                }
                currentMarker = -1
            } else if(markers[markers.length -2].connectedMarkers() > 1) {
                //} else if(markers[markerCounter -2].connectedMarkers() > 1) {
                //add new marker without Polyline
                aprovedTrack();
                //console.log(markers[markerCounter -2].connectedMarkers())
                //console.log("new mark")
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
                //console.log("extending connect")
            }
        }
        connection = false
        //printApproved()
    }

    function createMarker(coord, layer) {
        if(markers !== null) {
            var count = markers.length
            markerCounter++
            //console.log(markerCounter)
        }
        var marker = Qt.createQmlObject ('Marker {overlay: mapOverlay}', mapOverlay)
        mapOverlay.addMapItem(marker)
        marker.z = mapOverlay.z+layer
        //marker.z = mapOverlay.z+1
        marker.coordinate = coord

        //update list of markers
        var myArray = new Array()
        for (var i = 0; i<count; i++){
            myArray.push(markers[i])
            //console.log("list updated")
        }
        myArray.push(marker)
        markers = myArray
        return marker
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

            //console.log(item, "connected between ", cordi1, " and ", cordi2)

        } else {
            console.log(item + " is not supported right now, please call us later.")
        }
    }

    function addPolyline(marker1, marker2)
    {

        var count = mapOverlay.mapItems.length
        var co = Qt.createComponent('Polyline.qml')
        if (co.status == Component.Ready) {
            polylineCounter++
            var o = co.createObject(mapOverlay)
            o.setID(polylineCounter)
            o.setOverlay(mapOverlay)
            o.addCoord(marker1, marker2)
            mapOverlay.addMapItem(o)
            //update list of items
            var myArray = new Array()
            for (var i = 0; i<count; i++){
                myArray.push(mapItems[i])
            }
            myArray.push(o)
            mapItems = myArray
            aprovedTrack();

            //console.log("connected between ", coordinate1, " and ", coordinate2)

        } else {
            console.log(" is not supported right now, please call us later.")
        }
    }

    function deleteMarker(markerArray, polylineArray, markID) {
        //var mark = markerIndex(markID)
        //console.log("marker ID ", markID)
        //console.log("arrayLength ", markerArray.length)
        var count = markerArray.length
        for (var i = count -1; i> -1; i--){
            //console.log("round ", i)
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
        aprovedTrack();
    }

    function deleteMarkers()
    {
        var count = mapOverlay.markers.length
        for (var i = 0; i<count; i++){
            mapOverlay.removeMapItem(mapOverlay.markers[i])
            mapOverlay.markers[i].destroy()
        }
        mapOverlay.markers = []
        aprovedTrack();
    }

    function deletePolyline(marker1, marker2, polylineNr) {
        var mark1 = markerIndex(marker1)
        var mark2 = markerIndex(marker2)
        if(mark1 > -1 && mark2 > -1){
            markers[mark1].disconnectMarker(marker2)
            markers[mark1].disconnectPolyline(polylineNr)
            markers[mark2].disconnectMarker(marker1)
            markers[mark2].disconnectPolyline(polylineNr)
        }
        var polyIndex = polyLineIndex(polylineNr)
        if(polyIndex > -1){
            mapOverlay.removeMapItem(mapOverlay.mapItems[polyIndex])
            mapOverlay.mapItems[polyIndex].destroy()
            var myArray = new Array()
            for (var i = 0; i<mapItems.length; i++){
                if(i != polyIndex)
                    myArray.push(mapItems[i])
            }
            mapItems = myArray
            aprovedTrack();
        } else {
            console.log("index to low")
        }
    }

    function deleteAllPolylines()
    {
        var count = mapOverlay.mapItems.length
        for (var i = 0; i<count; i++){
            mapOverlay.removeMapItem(mapOverlay.mapItems[i])
            mapOverlay.mapItems[i].destroy()
        }
        mapOverlay.mapItems = []
        aprovedTrack();
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
                //console.log("connection between existing")
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
                //console.log("connect to existing")
                connection = true
            } else {
                console.log("node choosed for next round")
            }
        }
    }

    function polyLineIndex(polyID) {
        var count = mapOverlay.mapItems.length
        for (var i = 0; i<count; i++){
            if(mapOverlay.mapItems[i].polylineID === polyID)
                return i
        }
        return -1
    }

    function markerIndex(markID) {
        var count = mapOverlay.markers.length
        for (var i = 0; i<count; i++){
            if(mapOverlay.markers[i].markerID === markID)
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
        if(markers.length < 4) {
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

    function makeJSONs() {
        if(markers.length > 0){
            var jarr = new Array()
            for (var i = 0; i< markers.length; i++){
                markers[i].createJson()
                jarr.push(markers[i].json)
            }
            jsonMap = JSON.stringify(jarr)
        }
    }

    function sendMap() {
        makeJSONs()
        if(jsonMap !== null && jsonMap.length > 0 && tcpSocket.isConnected)
        {
            tcpSocket.sendMessage("MAP;" + jsonMap + ";")
        }
    }

    function printMap(){
        if(approved){
            makeJSONs()
            var jarr = JSON.parse(jsonMap)
            for (var i = 0; i< jarr.length; i++){
                console.log(jarr[i].id, " is connected to ", jarr[i].conns)
                console.log(" and has coordinates: lat: " + jarr[i].coord.lat + " long: " + jarr[i].coord.long)
            }
        }
    }

    function createCar(coord) {
        if(approved) {
            var co = Qt.createComponent('Car.qml')
            if (co.status == Component.Ready) {
                var o = co.createObject(mapOverlay)
                o.coordinate = coord
                mapOverlay.addMapItem(o)
                o.z = mapOverlay.z+2
                firstCar = o
            } else {
                console.log(" is not supported right now, please call us later.")
            }
        }
    }

    function setCarBearing(coord) {
        if(firstCar == null) {
            createCar(coord)
        } else {
            firstCar.setCoordinate(coord)
        }
    }

    function removeCar() {
        if(firstCar != null) {
            mapOverlay.removeMapItem(firstCar)
            firstCar = null
        }
    }

    function simulate() {
        if(approved) {
            if(carPosition == null) {
                carPosition = markers[0]
                previousCarPosition = carPosition.getID()
            }
            var index = markerIndex(nextMarker())
            carPosition = markers[index]
            setCarBearing(carPosition.getCoordinates())
        }
    }

    function nextMarker() {
        var random = -1
        var markerID = -1
        while(true) {
            random = getRandomIntInclusive(0, carPosition.connectedMarkers() -1)
            markerID = carPosition.getConnections()[random]
            if(markerID != previousCarPosition) {
                previousCarPosition = carPosition.getID()
                break
            }
        }
        return markerID
    }

    Timer {
        id:simulationTimer
        interval: 1000; running: false; repeat: true
        onTriggered: {
            simulate()
        }
    }

    onSimulateCarChanged: {
        if(simulateCar) {
            simulationTimer.start()
        } else {
            simulationTimer.stop()
            removeCar()
            carPosition = null
            previousCarPosition = -1
        }
    }

    function getRandomIntInclusive(min, max) {
      min = Math.ceil(min);
      max = Math.floor(max);
      return Math.floor(Math.random() * (max - min + 1)) + min; //The maximum is inclusive and the minimum is inclusive
    }

    function saveMap() {
        if(approved) {
            makeJSONs()
            var map = "Zoom:" + mapOverlay.zoomLevel + ";" + "Center:" + mapOverlay.center.latitude + "," +
                    mapOverlay.center.longitude + ";" + jsonMap
            fileDialog.save(map)
        }
    }

    function loadMap() {
        if(markers.length > 0)
            messageDialog.open()
        else
            fileDialog.load()
    }

    function loadJsonMarkers(jsonString) {
        //console.log("loading json")
        var jsonObjects = JSON.parse(jsonString)
        var list = new Array();
        for (var i = 0; i<jsonObjects.length; i++){
            var coord = QtPositioning.coordinate(jsonObjects[i].coord.lat, jsonObjects[i].coord.long)
            var marker = createMarker(coord, 0)
            marker.loadJson(jsonObjects[i])

            for (var j = 0; j<jsonObjects[i]["conns"].length; j++){
                var num1 = jsonObjects[i]["id"]
                var num2 = jsonObjects[i]["conns"][j]
                if (num1 < num2) {
                    var conn = {'conns': []}
                    conn.conns.push(num1)
                    conn.conns.push(num2)
                    list.push(conn)
                }
            }
        }
        //console.log("list")
        for (var i = 0; i<list.length; i++){
            var mark1 = markers[markerIndex(list[i]["conns"][0])]
            var mark2 = markers[markerIndex(list[i]["conns"][1])]
            addPolyline(mark1, mark2)
        }

    }

    Component.onCompleted: {
        markers = new Array();
        mapItems = new Array();
        console.log("maxZoom", overlay.maximumZoomLevel)
        console.log("minZoom", overlay.minimumZoomLevel)
        mapCompleted()
    }

    MessageDialog {
        //MessageDialog to check weather the user really wants load to clear the track and load a new one
        id: messageDialog
        icon: StandardIcon.Warning
        text: "This clears any existing track, are you sure?"
        standardButtons: StandardButton.Yes | StandardButton.No
        onYes: {
            deleteMarkers()
            deleteAllPolylines()
            fileDialog.load()
        }
    }

    MyFileDialog{
        id: fileDialog
        onTextReceived: {
            // try catch ?
            var params = textR.split(";")
            var zoom = params[0].split(":")
            parentMap.zoomLevel = parseFloat(zoom[1])
            console.log("new zoom ", zoom[1])
            var centrCoord = params[1].split(":")
            var latlong = centrCoord[1].split(",")
            var point = QtPositioning.coordinate(latlong[0], latlong[1])
            console.log("new center ", point)
            parentMap.center = point
            loadJsonMarkers(params[2])
        }
    }

    MouseArea {
        id: mouseArea
        property variant lastCoordinate
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked : {
            mapOverlay.lastX = mouse.x
            mapOverlay.lastY = mouse.y
            mapOverlay.pressX = mouse.x
            mapOverlay.pressY = mouse.y
            lastCoordinate = parentMap.toCoordinate(Qt.point(mouse.x, mouse.y))
            if(delegateIndex == 1) {
                mapOverlay.addMarker()
            }
        }

        /*onPositionChanged: {
            if (mouse.button == Qt.LeftButton) {
                parentMap.lastX = mouse.x
                parentMap.lastY = mouse.y
            }
        }*/

        onDoubleClicked: {
            var mouseGeoPos = parentMap.toCoordinate(Qt.point(mouse.x, mouse.y));
            var preZoomPoint = parentMap.fromCoordinate(mouseGeoPos, false);
            if (delegateIndex == 0 && mouse.button === Qt.LeftButton) {
                parentMap.zoomLevel = Math.floor(parentMap.zoomLevel + 1)
            } else if (delegateIndex == 0 && mouse.button === Qt.RightButton) {
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
