# GUI
Graphical User Interface for creating maps and controlling the remote car

![Alt text](https://github.com/RTKCar/GUI/blob/master/resources/GUI.png)


## Getting started
Currently you need to pull this code and deploy it from Qt Creator, hopefully there will be a dmg/AppImage in the future for easier deployment.

### Installing

### Prerequisites
Other components used for controlling the car:

* RTKCar/TcpServer: Server that handles the communication between the devices.
* RTKCar/RTKCar: Main program for the RPi inside the car, client that talks to the server.
* RTK-client?: Client pushing all the RTK-data to the server such as the cars location.
* RTKCar/Sensorsystem: The cars internal sensorsystem, detecting objects in the cars path.
* RTKCar/Styrsystem: The cars internal control system for steering and driving
* RTKCar/CAN-Buss: Cars internal comminucation system.

## Deployment

## Built With
* [Qt Creator](https://www.qt.io)

## Authors
* [RaZp29](https://github.com/RaZp29) - *Initial work gui*

Contributors who participated in this project with the other parts:
* [Alexan89](https://github.com/Alexan89)
* [Fartman3000](https://github.com/Fartman3000)
* [joande15](https://github.com/joande15)
* [Vassast](https://github.com/Vassast)

## License
This project is licensed under the GNU General Public License/Open Source? / BSD license for Qt code? - see the LICENSE.md file for details

## Acknowledgments
* Inspiration from Benjamin Vedders [RISE Self-Driving Model Vehicle Platform](https://github.com/vedderb/rise_sdvp)
* TCP-client from [BogoToBogo Qt tutorial QTcpSocket](http://www.bogotobogo.com/Qt/Qt5_QTcpSocket.php)
* Map based on [Qt Location Map Viewer (QML) Example](https://doc-snapshots.qt.io/qt5-5.9/qtlocation-mapviewer-example.html)
