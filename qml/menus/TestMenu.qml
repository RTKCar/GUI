import QtQuick 2.4
import QtPositioning 5.5
import QtLocation 5.9

TestMenuForm {
    id:testMenu1
    signal followMe()
    signal delegate(var index)
    signal deleteAll()
    signal centerMap()
    signal makeJSONs()
    signal connect()
    signal printTrack()
    property Map mapSourca
    property bool connected: false
    property bool approvedT: false
    //property alias conLabel: connectedLabel

    mapSource: mapSourca
    conn: connected
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

    jsonButton.onClicked: {
        makeJSONs()
    }

    connectButton.onClicked: {
        connect()
    }

    printButton.onClicked: {
        printTrack()
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

    onConnectedChanged: {
        connectedLabel.color = connected ? "Green" : "Red"
        notCLabel.visible = !connected
        connectButton.enabled = !connected
    }

    onApprovedTChanged: {
        jsonButton.enabled = approvedT
        notALabel.visible = !approvedT
        approvedLabel.color = approvedT ? "Green" : "Red"
    }

    /*onConnectedChanged: {
        connectedLabel.visible = connected
    }*/
}
