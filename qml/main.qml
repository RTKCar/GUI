import QtQuick 2.5
import QtQuick.Controls 1.4
import QtLocation 5.6
import QtPositioning 5.5
import QtQuick.Window 2.0
import QtQuick.Layouts 1.3
import "map"
import "menus"
//import "helper.js" as Helper


ApplicationWindow {
    id: appWindow
    visible: true
    height: 600
    width: 800
    //height: Screen.height
    //width: Screen.width

    RowLayout{
        visible: true
        anchors.fill: parent

        MapView {
            id: map
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumHeight: 400
            Layout.preferredHeight: appWindow.height
            Layout.minimumWidth: 400
            Layout.preferredWidth: appWindow.width - tools.width
        }

        /*Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumHeight: 400
            Layout.preferredHeight: appWindow.height
            Layout.minimumWidth: 400
            Layout.preferredWidth: appWindow.width - tools.width

            ColumnLayout{
            id: name
            anchors.centerIn: parent
                TextField {
                    placeholderText: qsTr("Enter name")
                }
                Button{
                    text: "hej"
                }

            }
        }*/


        /*SideTools {
            id: tools
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumHeight: 400
            Layout.preferredHeight: appWindow.height
            Layout.minimumWidth: 200
            Layout.preferredWidth: appWindow.width/4
            anchors.left: map.right
        }*/
        TestMenu{

        }
    }
}
