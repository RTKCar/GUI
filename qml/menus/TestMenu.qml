import QtQuick 2.4
import QtPositioning 5.5

TestMenuForm {
    id:testMenu1
    signal followMe()
    property var mapSourca


    Component.onCompleted: {
        mapSourca.zoomLevel = 14
        mapSource = mapSourca
    }

    followButton.onClicked: {
        //follow = !follow
        followMe()
    }

    zoomSlider.onValueChanged: {
        mapSource.zoomLevel = zoomSlider.value
        zoomValue.text = zoomSlider.value
        //zoomValue.text = Math.floor(zoomSlider.value)
    }

    //switchDelegate.
    //mouseDelegate:
    //markerDelegate:
    //handDelegate:
}
