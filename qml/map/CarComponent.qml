import QtQuick 2.0

Item {
    Rectangle {
        id: body
        width: 10
        height: 20
        color: "Black"

        Rectangle {
            id: window
            width: 10
            height: 5
            color: "Blue"

            Rectangle {
                id: light1
                width: 3
                height: 3
                color: "Yellow"
            }
            Rectangle {
                id: light2
                width: 3
                height: 3
                color: "Yellow"
                //anchors.left: window.right - width
            }
        }
    }

    function getWidth() {
        return body.width
    }

    function getHeight() {
        return body.height
    }
}
