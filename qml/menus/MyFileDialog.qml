import QtQuick 2.0
import QtQuick.Dialogs 1.1
import QtQuick.Layouts 1.1
import QtQuick.Window 2.0
import QtQuick.Controls 1.2

Item {
    property string savingText: ""
    signal textReceived(string textR)
    FileDialog{
        id: saveDialog
        title: "Please choose a file"
        visible: false
        folder: shortcuts.desktop
        modality: Qt.WindowModal
        selectExisting: false
        nameFilters: [ "text files (*.txt)", "All files (*)" ]
        selectedNameFilter: "text files (*.txt)"
        onAccepted: {
            saveFile(saveDialog.fileUrl, savingText)
        }
        onRejected: {
            console.log("Canceled")
        }
    }
    FileDialog{
         id: loadDialog
         title: "Please choose a file"
         visible: false
         folder: shortcuts.desktop
         modality: Qt.WindowModal
         selectExisting: true
         nameFilters: [ "text files (*.txt)", "All files (*)" ]
         selectedNameFilter: "text files (*.txt)"
         onAccepted: {
            var textInput = loadFile(loadDialog.fileUrl)
            textReceived(textInput)
         }
         onRejected: {
             console.log("Canceled")
         }
     }

    function save(textIn) {
        savingText = textIn
        saveDialog.open()
    }

    function load() {
        loadDialog.open()
    }


    function loadFile(fileUrl){
        console.log(fileUrl, " url")
        var request = new XMLHttpRequest();
        request.open("GET", fileUrl, false);
        request.send(null);
        return request.responseText;
    }

    function saveFile(fileUrl, text) {
        console.log(fileUrl, " url")
        var request = new XMLHttpRequest();
        request.open("PUT", fileUrl, false);
        request.send(text);
        return request.status;
    }
}

