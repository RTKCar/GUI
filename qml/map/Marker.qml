import QtQuick 2.5;
import QtLocation 5.6

MapQuickItem {
    id: marker
    property MapComponent overlay: null
    property variant markersConnected
    property variant polylinesConnected
    property int markerID: 0
    property var json

    anchorPoint.x: rect.width/2
    anchorPoint.y: rect.height/2
    rotation: 45

    sourceItem: Rectangle {
        id:rect
        color: "LimeGreen"
        width: 10
        height: 10
        border.color: "Black"
        smooth: true

        Rectangle {
            id: innerRect
            width: 1
            height: 1
            color: "Black"
            anchors.centerIn: rect
        }


        MouseArea  {
            id: markerMouseArea
            anchors.fill: parent
            hoverEnabled : false
            preventStealing: true

            onClicked : {
                if(overlay.delegateIndex == 3) {
                    //Disconnect Marker, then delete it
                    overlay.deleteMarker(markersConnected, polylinesConnected, markerID)
                } else if(overlay.delegateIndex == 1){
                    // Marker has been pressed
                    if(overlay.currentMarker != -1) {
                        //Two markers in a row have been pressed
                        overlay.previousMarker = overlay.currentMarker
                    } else {
                        //Change the color on the Marker to notify the user that it has been pressed
                        rect.color = "yellow"
                    }

                    overlay.currentMarker = -1
                    for (var i = 0; i< overlay.markers.length; i++){
                        if (marker == overlay.markers[i]){
                            overlay.currentMarker = i
                            if(overlay.previousMarker != overlay.currentMarker) {
                                //Different Markers has been pressed
                                overlay.connectMarkers()
                            } else {
                                //Same marker was pressed twice
                                overlay.currentMarker = -1
                                overlay.previousMarker = -1
                                if(markersConnected.length > 2) {
                                    rect.color = "Red"
                                } else {
                                    rect.color = "LimeGreen"
                                }
                            }
                            break
                        }
                    }
                }
            }
        }
    }

    function connectMark(Marker) {
        //Adds the provided Marker to this Markers connections
        markersConnected.push(Marker.markerID)
        connectionColor()
    }

    function connectMarker(MarkerTo) {
        //Connects two Markers to each others connections
        connectMark(MarkerTo)
        MarkerTo.connectMark(this)
    }

    function isConnectedTo(Marker) {
        //Checks weather this Marker is connected to the provided Marker
        if(this === Marker) {
            return true
        }
        for (var i = 0; i< markersConnected.length; i++){
            if (Marker.markerID === markersConnected[i]){
                return true
            }
        }
        return false
    }

    function connectedMarkers() {
        //return number of connection of this Marker
        return markersConnected.length
    }

    function getConnections() {
        return markersConnected
    }

    function getPolylines() {
        return polylinesConnected
    }

    function getCoordinates() {
        return coordinate
    }

    function getID() {
        //returns the ID of this Marker
        return markerID
    }

    function printConnections() {
        //prints this Markers connections
        console.log(markerID, " is connected to: ")
        for (var i = 0; i< markersConnected.length; i++){
            console.log(markersConnected[i], ", ")
        }
    }

    function disconnectMarkers() {
        //Disconnects this Marker from all its connections
        for(var i = 0; i<markersConnected.length; i++) {
            var marker = markersConnected(i)
            marker.disconnectMarker(this)
        }
    }

    function disconnectMarker(MarkerID){
        //Disconnects this Marker to the Marker with the specified MarkerID
        markersConnected.pop(MarkerID)
        connectionColor()
    }

    function connectPolyline(polylineID) {
        //Adds the Polyline with specified polylineID to this Marker
        polylinesConnected.push(polylineID)
    }

    function disconnectPolyline(polylineID) {
        //Disconnects the Polyline with specified polylineID from this Marker
        var myArray = new Array()
        for (var i = 0; i<polylinesConnected.length; i++){
            if(polylinesConnected[i] !== polylineID)
                myArray.push(polylinesConnected[i])
        }
        polylinesConnected = myArray
    }

    function polyLineIndex(polyID) {
        var count = polylinesConnected.length
        for (var i = 0; i<count; i++){
            if(polylinesConnected[i] === polyID)
                return i
        }
        return -1
    }

    function connectionColor() {
        //Changes the color of this Marker depending on number of connections
        if(markersConnected.length > 2) {
            rect.color = "Red"
        } else {
            rect.color = "LimeGreen"
        }
    }

    function createJson(){
        //Saves important information about this Marker to a JSON-object
        var jsObject = {
            'id' : markerID,
            'coord' : {
                'lat' : coordinate.latitude,
                'long' : coordinate.longitude},
            'conns' : []
        }
        for(var i = 0; i<markersConnected.length; i++) {
            jsObject.conns.push(markersConnected[i])
        }
        json = jsObject
    }

    function loadJson(jsonObj) {
        //Loads important information to this Marker from a JSON-object
        markerID = jsonObj.id
        for(var i = 0; i<jsonObj.conns.length; i++) {
            markersConnected.push(jsonObj.conns[i])
        }
        connectionColor()

    }

    Component.onCompleted: {
        markerID = overlay.markerCounter
        markersConnected = new Array();
        polylinesConnected = new Array();
    }
}
