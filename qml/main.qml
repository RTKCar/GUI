import QtQuick 2.5
import QtQuick.Controls 1.4
import QtLocation 5.6
import QtPositioning 5.5
import QtQuick.Window 2.0
import QtQuick.Layouts 1.3
import "map"
import "menus"

ApplicationWindow {
    id: appWindow
    visible: true
    height: 600
    width: 800
    title: qsTr("RTKCar")
    //height: Screen.height
    //width: Screen.width

    RowLayout{
        visible: true
        anchors.fill: parent

        MapView {
            id: mapview
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumHeight: 400
            Layout.preferredHeight: appWindow.height
            Layout.minimumWidth: 400
            Layout.preferredWidth: appWindow.width - TestMenu.width
        }

        TestMenu{
            id:testTools
            onFollowMe: {
                mapview.foll = !mapview.foll
            }
            onDeleteAll: {
                mapview.deleteAll = !mapview.deleteAll
            }
            onCenterMap: {
                mapview.center = !mapview.center
            }
            onMakeJSONs: {
                mapview.makeJsons = !mapview.makeJsons
            }

            mapSourca: mapview.mapMap
            onDelegate: {
                mapview.delegateIndex = index
            }
        }
    }
    Component.onCompleted: {
        var JsonString = '{"a":"A whatever, run","b":"B fore something happens"}';
        var JsonObject= JSON.parse(JsonString);
        /*var jsObject = {
            'id' : 2,
            'coord' : {
                'lat': 12,
                'long': 56
            },
            'connections' : []
        }

        console.log(jsObject)
        console.log(jsObject.coord.lat)
        jsObject.connections.push(4)
        jsObject.connections.push(3)
        jsObject.connections.push(7)
        console.log(jsObject.connections)

        var newObj = JSON.stringify(jsObject)
        console.log(newObj)*/

        //retrieve values from JSON again
        var aString = JsonObject.a;
        var bString = JsonObject.b;

        console.log(aString);
        console.log(bString);
    }
}
