import QtQuick 2.5;
import QtLocation 5.6
import QtQuick 2.0

MapQuickItem {
    id: marker
    property alias lastMouseX: markerMouseArea.lastX
    property alias lastMouseY: markerMouseArea.lastY
    property Map overlay: null

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

            onPressed : {
                overlay.pressX = mouse.x
                overlay.pressY = mouse.y
                overlay.currentMarker = -1
                for (var i = 0; i< overlay.markers.length; i++){
                    if (marker == overlay.markers[i]){
                        overlay.currentMarker = i
                        break
                    }
                }
                if(overlay.currentMarker == -1) {
                    overlay.addMarker(marker.coordinate)
                }
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

    Component.onCompleted: coordinate = overlay.toCoordinate(Qt.point(markerMouseArea.mouseX,
                                                                  markerMouseArea.mouseY));
}
