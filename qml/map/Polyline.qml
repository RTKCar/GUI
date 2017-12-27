import QtQuick 2.5
import QtLocation 5.6

MapPolyline {
    id:polyline

    property int polylineID: 0
    property MapComponent overlay: null
    property variant markersConnected
    property int firstMarker
    property int secondMarker

    line.color: "Black"
    line.width: 3
    opacity: 0.5
    smooth: true

    MouseArea {
        id: polyMouseArea
        property int pressX : -1
        property int pressY : -1
        property int jitterThreshold : 10
        property int lastX: -1
        property int lastY: -1
        anchors.fill: parent
        hoverEnabled : false
        //drag.target: marker
        preventStealing: true

        onClicked: {
            if(overlay != null && overlay.delegateIndex == 3) {
                //disconnect Markers connected and delete Polyline
                console.log("delete poly")
                if(overlay != null) {
                    overlay.deletePolyline(firstMarker, secondMarker, polylineID)
                }
            }
        }
    }

    function addCoord(Marker1, Marker2) {
        polyline.addCoordinate(Marker1.coordinate)
        polyline.addCoordinate(Marker2.coordinate)
        firstMarker = Marker1.markerID
        secondMarker = Marker2.markerID
        Marker1.connectPolyline(polylineID)
        Marker2.connectPolyline(polylineID)
        //markersConnected.push(Marker1.markerID)
        //markersConnected.push(Marker2.markerID)
        //console.log("polyline nr ", polylineID, " drawn")
    }

    function setID(number) {
        polylineID = number
    }

    function setOverlay(overlayMap) {
        overlay = overlayMap
    }
}
