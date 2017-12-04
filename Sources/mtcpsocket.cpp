#include "mtcpsocket.h"

MyTcpSocket::MyTcpSocket(QObject *parent) :
    QObject(parent)
{
    //doConnect();
}

void MyTcpSocket::doConnect()
{
    _isConnected = false;
    //emit isConnected();
    socket = new QTcpSocket(this);

    //QObject::connect(sender, signal, receiver, slot):
    //connect(socket, SIGNAL(connected()),this, SLOT(newConn()));
    connect(socket, SIGNAL(connected()),this, SLOT(connected()));

    //connect(socket, SIGNAL(connected()),parent(), SLOT(sendToMe()));
    //connect(socket, SIGNAL(disconnected()),this, SLOT(newDisconn()));
    connect(socket, SIGNAL(disconnected()),this, SLOT(disconnected()));

    connect(socket, SIGNAL(bytesWritten(qint64)),this, SLOT(bytesWritten(qint64)));
    connect(socket, SIGNAL(readyRead()),this, SLOT(readyRead()));

    //QTimer *timer = new QTimer(this);
    //connect(timer, SIGNAL(connected()), this, SLOT(connected()));

    qDebug() << "connecting...";

    // this is not blocking call
    //socket->connectToHost("google.com", 80);
    socket->connectToHost("localhost", 5001);
    //socket->connectToHost("localhost", 3333);


    // we need to wait...
    if(!socket->waitForConnected(5000))
    {
        qDebug() << "Error: " << socket->errorString();
        //socketDisconnected();
        socketDisconnected();
        //newDisconn();
    }
    //timer->start(1000);
    //num << 1;
}

void MyTcpSocket::connected()
{
    qDebug() << "connected...";
    socketConnected();
    _isConnected = true;
    //emit isConnected();
    //socketConnected();

    //socket->write("{\"connections\":[7,9,8],\"coordinates\":{\"latitude\":56.426121706320544,\"longitude\":12.984074122446202,\"altitude\":0,\"isValid\":true},\"id\":6}");
    //socket->write("M;");
    //socket->write("[{\"connections\":[7,9,8],\"coordinates\":{\"latitude\":56.426121706320544,\"longitude\":12.984074122446202,\"altitude\":0,\"isValid\":true},\"id\":6},{\"connections\":[6,8],\"coordinates\":{\"latitude\":56.41848568851517,\"longitude\":12.977459459756773,\"altitude\":0,\"isValid\":true},\"id\":7}]");
    //qDebug() << "sample JSON sent";

}

void MyTcpSocket::disconnected()
{
    _isConnected = false;
    //emit isConnected();
    socketDisconnected();
    //socketDisconnected();
    qDebug() << "disconnected...";
}

void MyTcpSocket::bytesWritten(qint64 bytes)
{
    qDebug() << bytes << " bytes written...";
}

void MyTcpSocket::readyRead()
{
    qDebug() << "reading...";
    //QMetaObject::invokeMethod()

    // read the data from the socket
    qDebug() << socket->readAll();
    emit recieved();
}

void MyTcpSocket::sendJSON()
{
    //socket->waitForReadyRead();
    socket->write("JSON is comming");
    //socket->write("" + num_ber);
}

void MyTcpSocket::setMap(QByteArray &Map)
{
    if (Map == map)
        return;

    map = Map;
    emit mapChanged();
    //qDebug() << map;
    socket->write(map);
}

QByteArray MyTcpSocket::Map()
{
    return map;
}

/*bool MyTcpSocket::isConnected()
{
    return _isConnected;
}*/

void MyTcpSocket::newConn()
{
    qDebug() << "newCon";
    socketConnected();
}

void MyTcpSocket::newDisconn()
{
    qDebug() << "newDiscon";
    socketDisconnected();
}

/*void MyTcpSocket::sendMessage(char &message)
{
    //const char * c = message;
    socket->write(message);
}*/
