import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3

StatusBar {
        property string lati: ""
        property string longi: ""

        Row {
            anchors.fill: parent

            RowLayout {
                width: 200
            Label {
                id:firstText
                text: "Latitude:"
            }
            Label {
                id: latText
                anchors.left: firstText.right
                text: ""
            }
            }
            RowLayout {
            Label {
                id: thirdText
                text: "Longitude:"
            }
            Label {
                anchors.left: thirdText.right
                id: longText
                text: ""
            }
            }
        }
        onLatiChanged: latText.text = lati
        onLongiChanged: longText.text = longi
}
