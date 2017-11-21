import QtQuick 2.4
import QtPositioning 5.5
import QtLocation 5.9

TestMenuForm {
    id:testMenu1
    signal followMe()
    signal delegate(var index)
    signal deleteAll()
    signal centerMap()
    property Map mapSourca

    mapSource: mapSourca
    zoomSlider.value: mapSource.zoomLevel

    followButton.onClicked: {
        followMe()
    }

    deleteAllButton.onClicked: {
        deleteAll()
    }

    centerButton.onClicked: {
        centerMap()
    }

    zoomSlider.onValueChanged: {
        mapSource.zoomLevel = zoomSlider.value
        zoomValue.text = zoomSlider.value
        //zoomValue.text = Math.floor(zoomSlider.value)
    }

    mouseDelegate.onCheckedChanged: {
        if(mouseDelegate.checked)
            delegate(0)
    }

    markerDelegate.onCheckedChanged: {
        if(markerDelegate.checked)
            delegate(1)
    }

    handDelegate.onCheckedChanged: {
        if(handDelegate.checked)
            delegate(2)
    }

    deleteDelegate.onCheckedChanged: {
        if(deleteDelegate.checked)
            delegate(3)
    }

    tab0.onClicked: {
        stackLayout.currentIndex = 0
    }

    tab1.onClicked: {
        stackLayout.currentIndex = 1
    }
}
