import QtQuick 2.5
import QtLocation 5.6


MapPolyline {

    line.color: "#46a2da"
    line.width: 4
    opacity: 0.25
    smooth: true

    function setGeometry(coordinate1, coordinate2){
        addCoordinate(coordinate1)
        addCoordinate(coordinate2)
    }
}
