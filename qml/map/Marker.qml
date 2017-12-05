import QtQuick 2.5;
import QtLocation 5.6
import QtQuick 2.0

MapQuickItem {
    id: marker
    property MapComponent overlay: null
    property variant markersConnected
    property variant polylinesConnected
    property int connectedCount: 0
    property int markerID: 0
    property var json

    anchorPoint.x: rect.width/2
    anchorPoint.y: rect.height/2

    sourceItem: Rectangle {
        id:rect
        color: "LimeGreen"
        width: 10
        height: 10
        rotation: 45
        border.color: "Black"
        smooth: true
        opacity: markerMouseArea.pressed ? 0.6 : 1.0


        MouseArea  {
            id: markerMouseArea
            property int lastX: -1
            property int lastY: -1
            anchors.fill: parent
            hoverEnabled : false
            //drag.target: marker
            preventStealing: true
            //Drag.active: markerMouseArea.drag.active

            onClicked : {
                overlay.pressX = mouse.x
                overlay.pressY = mouse.y
                if(overlay.delegateIndex == 3) {
                    //disconnect Marker, then delete it
                    overlay.deleteMarker(markersConnected, polylinesConnected, markerID)
                } else if(overlay.delegateIndex == 1){
                    // marker has been pressed
                    if(overlay.currentMarker != -1) {
                        overlay.previousMarker = overlay.currentMarker
                    } else {
                        rect.color = "yellow"
                    }

                    overlay.currentMarker = -1
                    for (var i = 0; i< overlay.markers.length; i++){
                        if (marker == overlay.markers[i]){
                            overlay.currentMarker = i
                            if(overlay.previousMarker != overlay.currentMarker) {
                                overlay.connectMarkers()
                            } else {
                                //same marker was pressed twice
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
        connectedCount ++
        markersConnected.push(Marker.markerID)
        if(markersConnected.length > 2) {
            rect.color = "Red"
        } else {
            rect.color = "LimeGreen"
        }

        //createJson()
        //printConnections()
    }

    function connectMarker(MarkerTo) {
        connectMark(MarkerTo)
        MarkerTo.connectMark(this)
    }

    function isConnectedTo(Marker) {
        //return markersConnected.contains(Marker)
        if(this == Marker) {
            return true
        }
        for (var i = 0; i< markersConnected.length; i++){
            if (Marker.markerID == markersConnected[i]){
                return true
            }
        }
        return false
    }

    function connectedMarkers() {
        return connectedCount
    }

    function returnID() {
        return markerID
    }

    function printConnections() {
        console.log(markerID, " is connected to: ")
        for (var i = 0; i< markersConnected.length; i++){
            console.log(markersConnected[i], ", ")
        }
    }

    function disconnectMarkers() {
        for(var i = 0; i<markersConnected.length; i++) {
            var marker = markersConnected(i)
            marker.disconnectMarker(this)
        }
    }

    function disconnectMarker(MarkerID){
        markersConnected.pop(MarkerID)
        if(markersConnected.length < connectedCount)
            connectedCount --
        if(markersConnected.length < 3) {
            rect.color = "LimeGreen"
        }
    }

    function connectPolyline(polylineID) {
        polylinesConnected.push(polylineID)
        //console.log(markerID, "is connected to line nr ", polylineID)
    }

    function disconnectPolyline(polylineID) {
        polylinesConnected.pop(polylineID)
        //console.log(markerID, "is disconnected from line nr ", polylineID)
    }

    function createJson(){
        var jsObject = {
            'id' : markerID,
            //'coord' : coordinate,
            'coord' : {
                'lat' : coordinate.latitude,
                'long' : coordinate.longitude},
            'conns' : []
        }
        for(var i = 0; i<markersConnected.length; i++) {
            jsObject.conns.push(markersConnected[i])
        }
        //console.log(jsObject.id)
        json = jsObject
        //json = JSON.stringify(jsObject)
    }

    Component.onCompleted: {
        markerID = overlay.markerCounter
        markersConnected = new Array();
        polylinesConnected = new Array();
    }
}
