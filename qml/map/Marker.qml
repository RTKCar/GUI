import QtQuick 2.5;
import QtLocation 5.6
import QtQuick 2.0

MapQuickItem {
    id: marker
    property alias lastMouseX: markerMouseArea.lastX
    property alias lastMouseY: markerMouseArea.lastY
    //property Map overlay: null
    property MapComponent overlay: null
    property variant markersConnected
    property variant polylinesConnected
    property int connectedCount: 0

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
            property int pressX : -1
            property int pressY : -1
            property int jitterThreshold : 10
            property int lastX: -1
            property int lastY: -1
            anchors.fill: parent
            hoverEnabled : false
            drag.target: marker
            preventStealing: true

            onClicked : {
                overlay.pressX = mouse.x
                overlay.pressY = mouse.y
                var prev = false
                if(overlay.currentMarker != -1) {
                    overlay.previousMarker = overlay.currentMarker
                } else if(overlay.currentMarker > -1) {

                } else {
                    prev = true
                }
                overlay.currentMarker = -1
                for (var i = 0; i< overlay.markers.length; i++){
                    if (marker == overlay.markers[i]){
                        overlay.currentMarker = i
                        overlay.connectMarkers()
                        /*if(!prev) {
                            overlay.connectMarkers()
                        }*/
                        //console.log("currentMarker set to: ", i)
                        break
                    }
                }
                /*if(overlay.currentMarker == -1) {
                    overlay.addMarker(marker.coordinate)
                }*/
            }

            /*onPressAndHold:{
                if (Math.abs(map.pressX - mouse.x ) < map.jitterThreshold
                        && Math.abs(map.pressY - mouse.y ) < map.jitterThreshold) {
                    var p = map.fromCoordinate(marker.coordinate)
                    lastX = p.x
                    lastY = p.y
                    map.showMarkerMenu(marker.coordinate)
                }
            }*/
        }
    }

    function connectMarker(Marker) {
        //console.log("connectMarker")
        //console.log("lat ",Marker.coordinate.latitude)
        //console.log("coord ",Marker.coordinate)
        markersConnected.push(Marker)
        Marker.markersConnected.push(this)
        if(markersConnected.length > 2) {
            rect.color = "Red"
            //create new Polyline
        }
        else {
            //extend existing Polyline
        }
        //console.log("end connect")
        connectedCount ++
        /*var polyline = Qt.createQmlObject ('Polyline
            {path:[{latitude: this.coordinate.latitude, longitude: this.coordinate.lingitude},
            {latitude: Marker.coordinate.latitude, longitude: Marker.coordinate.longitude}]}', overlay)*/
        //var polyline = Qt.createQmlObject ('Polyline{}', overlay)
        /*polyline.path = [{latitude: this.coordinate.latitude, longitude: this.coordinate.lingitude},
                         {latitude: Marker.coordinate.latitude, longitude: Marker.coordinate.longitude}]*/
        /*var polyline = Qt.createQmlObject ('Polyline {}', overlay)
        polyline.addLine(this)
        polyline.addLine(Marker)
        polyline.z = overlay.z+1
        overlay.addMapItem(polyline)
        polylinesConnected.push(polyline)
        console.log(polyline.path)*/
    }

    function disconnectMarkers() {
        for(var i = 0; i<markersConnected.length; i++) {
            var marker = markersConnected(i)
            marker.disconnectMarker(this)
        }
    }

    function disconnectMarker(Marker){
        connectedCount --
        //disconnect Marker from 1 or more Polylines
        markersConnected.pop(Marker)
        if(markersConnected.length < 3) {
            rect.color = "LimeGreen"
        }
    }

    onConnectedCountChanged: {

    }

    /*onMarkersConnectedChanged: {
        console.log("connectedMarkersChanged")
        console.log("markers length", markersConnected.length)
        console.log("connected count", connectedCount)
        if(markersConnected.length > connectedCount) {
            console.log("adding polyline")
            //create Polyline and add coordinates
            var polyline = Qt.createQmlObject ('Polyline {}', MapComponent)
            polyline.addLine(this)
            polyline.addLine(markersConnected[connectedCount-1])
            polylinesConnected.push(polyline)
        } else if(markersConnected.length < connectedCount){
            //remove Polyline
            console.log("not adding polyline")
        } else {
            console.log("unknown polyline")
        }
    }*/

    Component.onCompleted: {
        //coordinate = overlay.toCoordinate(Qt.point(markerMouseArea.mouseX,
                                                              //markerMouseArea.mouseY));
        markersConnected = new Array();
        polylinesConnected = new Array();
    }
}
