import QtQuick 2.5
import QtQuick.Controls 1.4
import QtLocation 5.6
import QtPositioning 5.5
import QtQuick.Window 2.0
import QtQuick.Layouts 1.3
import "map"
//import "helper.js" as Helper


ApplicationWindow {
    id: appWindow
    visible: true
    height: 600
    width: 600
    //height: Screen.height
    //width: Screen.width

    RowLayout{
        visible: true
        anchors.fill: parent

        MapView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumHeight: 400
            Layout.preferredHeight: appWindow.height
            Layout.minimumWidth: 400
            Layout.preferredWidth: appWindow.width - tools.width
        }

        SideTools {
            id: tools
            /*Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumHeight: 400
            Layout.preferredHeight: appWindow.height
            Layout.minimumWidth: 200
            Layout.preferredWidth: appWindow.width/4*/
        }
    }
}
