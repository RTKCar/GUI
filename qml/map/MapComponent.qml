/****************************************************************************
**
** Copyright (C) 2017 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** BSD License Usage
** Alternatively, you may use this file under the terms of the BSD license
** as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

//Modified from Qt Map Viewer (QML) Example: https://doc-snapshots.qt.io/qt5-5.9/qtlocation-mapviewer-example.html
import QtQuick 2.7
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
    property MyStatusBar statusBar
    property variant markers
    property variant mapItems
    property int markerCounter: 0 // counter for total amount of markers. Resets to 0 when number of markers = 0
    property int polylineCounter: 0
    property int currentMarker: -1
    property int previousMarker: -1
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
    // Adds a new Marker to the Map
    {
        var marker = createMarker(mouseArea.lastCoordinate, 1)

        if(mapOverlay.markers.length > 1) {
            //if new Marker was added
            if(currentMarker > 0) {
                //extending from a pressed marker
                if(!markers[currentMarker].isConnectedTo(marker)){
                    markers[currentMarker].connectMarker(marker)
                    addPolyline(markers[currentMarker], marker)
                }
                currentMarker = -1
            } else if(markers[markers.length -2].connectedMarkers() > 1) {
                //add new marker without Polyline
                aprovedTrack();
            } else {
                //extending from previous placed marker
                if(!markers[markers.length -2].isConnectedTo(marker)){
                    markers[markers.length -2].connectMarker(marker)
                    addPolyline(markers[markers.length -2], marker)
                }
            }
        }
        connection = false
    }

    function createMarker(coord, layer) {
        //Creates a new Marker for adding at the specified coordinate and layer
        if(markers !== null) {
            var count = markers.length
            markerCounter++
        }
        var marker = Qt.createQmlObject ('Marker {overlay: mapOverlay}', mapOverlay)
        mapOverlay.addMapItem(marker)
        marker.z = mapOverlay.z+layer
        marker.coordinate = coord

        //update list of markers
        var myArray = new Array()
        for (var i = 0; i<count; i++){
            myArray.push(markers[i])
        }
        myArray.push(marker)
        markers = myArray
        return marker
    }

    function addPolyline(marker1, marker2)
    //Adds a Polyline betseen marker1 and marker2 then connects them accordingly
    {
        var count = mapOverlay.mapItems.length
        var co = Qt.createComponent('Polyline.qml')
        if (co.status === Component.Ready) {
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
        } else {
            console.log(" is not supported right now, please call us later.")
        }
    }

    function deleteMarker(markerArray, polylineArray, markID) {
        //Disconnects Marker with the markID from other Markers in its markerArray
        //and Polylines in its polylineArray before deleting it from the Map
        var count = markerArray.length
        for (var i = count -1; i> -1; i--){
            deletePolyline(markID, markerArray[i], polylineArray[i])
        }
        var mark = markerIndex(markID)
        if(mark > -1){
            mapOverlay.removeMapItem(mapOverlay.markers[mark])
            mapOverlay.markers[mark].destroy()
            var myArray = new Array()
            for (var i = 0; i<markers.length; i++){
                if(i !== mark)
                    myArray.push(markers[i])
            }
            markers = myArray
        }
        aprovedTrack();
    }

    function deleteMarkers()
    //Deletes all Markers avaliable on the Map
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
        //Disconnects a Polyline with given id as polylineNr
        // from its connected Markers, marker1 and marker2 then deletes it
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
                if(i !== polyIndex)
                    myArray.push(mapItems[i])
            }
            mapItems = myArray
            aprovedTrack();
        } else {
            console.log("index to low")
        }
    }

    function deleteAllPolylines()
    // Deletes all Polylines avaliable on the Map
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
                connection = true
            } else if(!connection && !markers[markers.length -1].isConnectedTo(markers[currentMarker])){
                // connection from previously placed node to existing
                markers[markers.length -1].connectMarker(markers[currentMarker])
                addPolyline(markers[markers.length -1], markers[currentMarker])
                currentMarker = -1
                connection = true
            } else {
                console.log("node choosed for next round")
            }
        }
    }

    function polyLineIndex(polyID) {
        // Returns the provided Polylines index in the mapItems List
        var count = mapOverlay.mapItems.length
        for (var i = 0; i<count; i++){
            if(mapOverlay.mapItems[i].polylineID === polyID)
                return i
        }
        return -1
    }

    function markerIndex(markID) {
        // Returns the provided Markers index in the markers List
        var count = mapOverlay.markers.length
        for (var i = 0; i<count; i++){
            if(mapOverlay.markers[i].markerID === markID)
                return i
        }
        return -1
    }

    /*function connectMarkerToExisting() {
      No longeer used ?!?!
        if(markerCounter > 1 && markerCounter != currentMarker) {
            markers[markerCounter].connectMarker(markers[currentMarker])
        }
    }*/

    function aprovedTrack() {
        //Checks whether there are at least 4 Markers and each one of them has at least 2 connections
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
        //Creates a JSON out of each Marker and saves it to jsonMap
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
        //Sends a String containing the jsonMap to the connected TcpSocket
        makeJSONs()
        if(jsonMap !== null && jsonMap.length > 0 && tcpSocket.isConnected)
        {
            tcpSocket.sendMessage("MAP;" + jsonMap + ";")
        }
    }

    function printMap(){
        //Prints the current Track and its connections for debbuging purpose
        for (var i = 0; i< markers.length; i++){
            console.log("marker ", markers[i].getID(), " is connected to ", markers[i].getConnections(),
                        " with lines ", markers[i].getPolylines())
        }
    }

    function createCar(coord) {
        //Creates a Car at the specified coordinates
        if(approved) {
            var co = Qt.createComponent('Car.qml')
            if (co.status === Component.Ready) {
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

    //Sets the cars new bearing
    function setCarBearing(coord) {
        if(firstCar == null) {
            createCar(coord)
        } else {
            firstCar.setCoordinate(coord)
        }
    }

    function removeCar() {
        // Deletes the car
        if(firstCar != null) {
            mapOverlay.removeMapItem(firstCar)
            firstCar = null
        }
    }

    function simulate() {
        //Simulates an non existing car on the approved track
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
        //Returns the next random marker not being the previousMarker connected to the carPosition
        // Used for simulation
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
        //Times used for updating the cars Position when simulating
        id:simulationTimer
        interval: 1000; running: false; repeat: true
        onTriggered: {
            simulate()
        }
    }

    onSimulateCarChanged: {
        //Starts or stops a new simulation of the car
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
      //Return a random integer from min to max
      min = Math.ceil(min);
      max = Math.floor(max);
      return Math.floor(Math.random() * (max - min + 1)) + min; //The maximum is inclusive and the minimum is inclusive
    }

    function saveMap() {
        //Creates a jsonMap and saves it to the computer
        if(approved) {
            makeJSONs()
            var map = "Zoom:" + mapOverlay.zoomLevel + ";" + "Center:" + mapOverlay.center.latitude + "," +
                    mapOverlay.center.longitude + ";" + jsonMap
            fileDialog.save(map)
        }
    }

    function loadMap() {
        //Loads a previously saved Track to the Mao
        if(markers.length > 0)
            messageDialog.open()
        else
            fileDialog.load()
    }

    function loadJsonMarkers(jsonString) {
        //Loads each Marker in the provided jsonString to the Map
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
        //Loads the choosen Track to the Map
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
        hoverEnabled: true

        onClicked : {
            if(delegateIndex == 1) {
                //Adds a new Marker to the Map
                lastCoordinate = parentMap.toCoordinate(Qt.point(mouse.x, mouse.y))
                mapOverlay.addMarker()
            }
        }

        onDoubleClicked: {
            //Zooms in or out
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
        }

        onPositionChanged: {
            // Show current Latitude and Longitude on statusBar
            var mouseGeoPos = mapOverlay.toCoordinate(Qt.point(mouse.x, mouse.y));
            statusBar.lati = mouseGeoPos.latitude
            statusBar.longi = mouseGeoPos.longitude
        }

        onExited: {
            // Clear Latitude and Longitude from statusBar
            statusBar.lati = ""
            statusBar.longi = ""
        }
    }
}
