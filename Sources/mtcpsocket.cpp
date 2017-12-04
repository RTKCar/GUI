#include "mtcpsocket.h"

MyTcpSocket::MyTcpSocket(QObject *parent) :
    QObject(parent)
{}

void MyTcpSocket::doConnect(QString host, quint16 port)
{

    _isConnected = false;
    socket = new QTcpSocket(this);

    //QObject::connect(sender, signal, receiver, slot):
    connect(socket, SIGNAL(connected()),this, SLOT(connected()));
    connect(socket, SIGNAL(disconnected()),this, SLOT(disconnected()));
    connect(socket, SIGNAL(bytesWritten(qint64)),this, SLOT(bytesWritten(qint64)));
    connect(socket, SIGNAL(readyRead()),this, SLOT(readyRead()));

    qDebug() << "connecting...";

    // this is not blocking call
    //socket->connectToHost("localhost", 5001);
    socket->connectToHost(host, port);

    // we need to wait...
    if(!socket->waitForConnected(5000))
    {
        qDebug() << "Error: " << socket->errorString();
        socketDisconnected();
    }
}

void MyTcpSocket::connected()
{
    qDebug() << "connected...";
    socketConnected();
    _isConnected = true;

    //socket->write("{\"connections\":[7,9,8],\"coordinates\":{\"latitude\":56.426121706320544,\"longitude\":12.984074122446202,\"altitude\":0,\"isValid\":true},\"id\":6}");
    //socket->write("M;");
    //socket->write("[{\"connections\":[7,9,8],\"coordinates\":{\"latitude\":56.426121706320544,\"longitude\":12.984074122446202,\"altitude\":0,\"isValid\":true},\"id\":6},{\"connections\":[6,8],\"coordinates\":{\"latitude\":56.41848568851517,\"longitude\":12.977459459756773,\"altitude\":0,\"isValid\":true},\"id\":7}]");
    //qDebug() << "sample JSON sent";

}

void MyTcpSocket::disconnect()
{
    qDebug() << "disconnecting...";
    socket->disconnectFromHost();
}

void MyTcpSocket::disconnected()
{
    _isConnected = false;
    socketDisconnected();
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
