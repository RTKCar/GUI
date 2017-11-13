import QtQuick 2.4
import QtPositioning 5.5

TestMenuForm {
    id:testMenu1
    //signal followMe(QtPositioning.coordinate cord)
    signal followMe()
    property bool follow: false
    //property variant follow: Boolean
    //property variant followCoordinate: QtPositioning.coordinate

    /*Component.onCompleted: {
        followButton.clicked.connect(followMe)
        //testMenu1
        //followButton.
    }*/

    /*followButton: {

        onClicked : testMenu1.followME()
    }*/

    followButton.onClicked: {
        //follow = !follow
        followMe()

    }

    //switchDelegate.
}
