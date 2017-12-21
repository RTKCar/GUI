import QtQuick 2.4
import QtPositioning 5.5
import QtLocation 5.9

TestMenuForm {
    id:testMenu1
    signal followMe()
    signal delegate(var index)
    signal deleteAll()
    signal sendMap()
    signal connect()
    signal disconnect()
    signal printTrack()
    signal simulate(bool value)
    property Map mapSourca
    property bool connected: false
    property bool approvedT: false
    property bool carConnected: false


    mapSource: mapSourca
    conn: connected
    zoomSlider.value: mapSource.zoomLevel

    followButton.onClicked: {
        followMe()
    }

    deleteAllButton.onClicked: {
        deleteAll()
    }

    sendMapButton.onClicked: {
        sendMap()
    }

    connectButton.onClicked: {
        connect()
    }

    disconnectButton.onClicked: {
        disconnect()
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

    simulateSwitch.onCheckedChanged: {
        simulate(simulateSwitch.checked)
    }

    onConnectedChanged: {
        serverIndicator.rlyActive = connected
        connectButton.enabled = !connected
        disconnectButton.enabled = connected
        host.enabled = !connected
        port.enabled = !connected
        sendMapButton.enabled = approvedT && connected
    }
    host.onAccepted: {
        console.log("host okey")
    }
    port.onAccepted: {
        console.log("port okey")
    }

    onApprovedTChanged: {
        sendMapButton.enabled = approvedT && connected
        trackIndicator.rlyActive = approvedT
        saveButton.enabled = approvedT
    }

    onCarConnectedChanged: {
        startButton.enabled = !carConnected
        stopButton.enabled = carConnected
        carIndicator.rlyActive = carConnected
    }
}
