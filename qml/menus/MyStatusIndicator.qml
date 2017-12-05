import QtQuick 2.0
import QtQuick.Extras 1.4

StatusIndicator {
    id: statusI
    active: true
    property bool rlyActive
    //anchors.centerIn: parent
    color: rlyActive ? "green" : "red" //Status active
}
