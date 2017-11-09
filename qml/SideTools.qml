import QtQuick 2.5
import QtQuick.Controls 2.2
import QtLocation 5.6
import QtPositioning 5.5
import QtQuick.Window 2.0
import QtQuick.Layouts 1.3

Item {
    Layout.fillWidth: true
    Layout.fillHeight: true
    Layout.minimumHeight: 400
    Layout.preferredHeight: appWindow.height
    Layout.minimumWidth: 200
    Layout.preferredWidth: appWindow.width/4

    ColumnLayout {
        spacing: 10

        Button {
            text: "Ok"
            onClicked: console.log("pressed")
        }

        ButtonGroup {
            id: buttonGroup
        }

        ListView {
            model: ["Option 1", "Option 2", "Option 3"]
            delegate: RadioDelegate {
                text: modelData
                checked: index == 0
                ButtonGroup.group: buttonGroup
            }
        }
    }

}
