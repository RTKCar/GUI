import QtQuick 2.5
import QtLocation 5.6

MapPolyline {
    id:polyline
    line.color: "Black"
    line.width: 5
    opacity: 0.5
    smooth: true

    function addCoord(coordinate1, coordinate2) {
        polyline.addCoordinate(coordinate1)
        polyline.addCoordinate(coordinate2)
    }
}
