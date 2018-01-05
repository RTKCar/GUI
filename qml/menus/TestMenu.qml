//import QtQuick 2.4
import QtQuick 2.7
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
    signal errorMessage(string eMessage)
    property Map mapSourca
    property bool connected: false
    property bool approvedT: false
    property bool carConnected: false
    property bool mapSent: false

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
        if(simulateSwitch.checked) {
            stackLayout1.currentIndex = 2
            stackLayout2.currentIndex = 1
            speedBox.enabled = false
            startButton.enabled = false
            mouseDelegate.checked = true
        } else {
            stackLayout1.currentIndex = stackLayout2.currentIndex = 0
            //stackLayout2.currentIndex = 0
            //for testing
            //speedBox.enabled = startButton.enabled = stopButton.enabled = carConnected && mapSent
            startButton.enabled = stopButton.enabled = connected && mapSent
            speedBox.enabled = connected
            //startButton.enabled = carConnected && mapSent
            //stopButton.enabled = carConnected && mapSent
        }
        manualSwitch.enabled = !simulateSwitch.checked
        if(!carConnected && approvedT)
            simulate(simulateSwitch.checked)
    }

    manualSwitch.onCheckedChanged: {
        if(manualSwitch.checked) {
            stackLayout1.currentIndex = 1
            stopButton.clicked()
            stopButton.enabled = startButton.enabled = sendMapButton.enabled = false
            speedBox.enabled = true
            //startButton.enabled = false
            //sendMapButton.enabled = false
        } else {
            stackLayout1.currentIndex = 0
            //for testing
            //startButton.enabled = stopButton.enabled = speedBox.enabled = carConnected && mapSent
            startButton.enabled = stopButton.enabled = connected && mapSent
            speedBox.enabled = connected
            //stopButton.enabled = carConnected && mapSent
            sendMapButton.enabled = approvedT && connected
        }
    }

    onConnectedChanged: {
        serverIndicator.rlyActive = connected
        connectButton.enabled = !connected
        disconnectButton.enabled = connected
        host.enabled = port.enabled = !connected
        //port.enabled = !connected
        sendMapButton.enabled = approvedT && connected
        //if(connected && startButton.enabled)
        if(connected)
            manualSwitch.enabled = startButton.enabled = stopButton.enabled = true
            //manualSwitch.toggle()
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
        simulateSwitch.enabled = !carConnected && approvedT
    }

    onCarConnectedChanged: {
        //for testing
        //startButton.enabled = carConnected && !manualSwitch.checked && mapSent

        //speedBox.enabled = carConnected && !manualSwitch.checked && mapSent
        //stopButton.enabled = carConnected && !manualSwitch.checked && mapSent
        speedBox.enabled = stopButton.enabled = startButton.enabled = carConnected
        carIndicator.rlyActive = carConnected
        simulateSwitch.enabled = !carConnected && approvedT
        if(!mapSent) {
            errorMessage("send map before controlling the car")
        }
    }

    onMapSentChanged: {
        //for testing
        //startButton.enabled = carConnected && !manualSwitch.checked && mapSent
        //speedBox.enabled = carConnected
        //stopButton.enabled = carConnected && !manualSwitch.checked && mapSent
    }
    speedBox.onCurrentIndexChanged: {
        speedBox.focus = false
    }
}
