import QtQuick 2.5;
import QtLocation 5.6
//import QtQuick 2.0
import QtPositioning 5.6

MapQuickItem {
    id: car
    //property MapComponent overlay: null
    property variant _thisCoord
    property variant _lastCoord

    anchorPoint.x: body.width/2
    anchorPoint.y: body.height/2

    /*sourceItem: CarComponent{
        id: carComp
    }*/

    sourceItem: Rectangle {
        id:body
        color: "Orange"
        width: 15
        height: 30
        //border.color: "Black"
        smooth: true

        Rectangle {
            id: window
            width: 15
            height: 10
            color: "#0099ff"

            Rectangle {
                id: light1
                width: 5
                height: 5
                color: "Yellow"
            }
            Rectangle {
                id: light2
                width: 5
                height: 5
                color: "Yellow"
                x: window.width - width
            }
        }
    }

    function setCoordinate(coord) {
        _lastCoord = QtPositioning.coordinate(coordinate.latitude, coordinate.longitude)
        //_thisCoord = QtPositioning.coordinate(coord.latitude, coord.longitude)
        coordinate.latitude = coord.latitude
        coordinate.longitude = coord.longitude
        console.log("Coord1: lat: " + _lastCoord.latitude + " long: " + _lastCoord.longitude)
        console.log("Coord2: lat: " + coordinate.latitude + " long: " + coordinate.longitude)
        //console.log("Coord2: lat: " + _thisCoord.latitude + " long: " + _thisCoord.longitude)
        calculateBearing()
    }

    function calculateBearing() {
        var bear = coordinate.azimuthTo(_thisCoord)
        var _bear = _lastCoord.azimuthTo(coordinate)
        //var _bear2 = _thisCoord.azimuthTo(_lastCoord)
        //console.log("bearing " + bear)
        console.log("bearing cord1 to cord2 " + _bear)
        //console.log("reversed bearing: cord2 to cord1 " + _bear2)
        car.rotation = _bear
    }
}
