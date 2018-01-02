//Modified from BogoToBogo QTcpSocket Example: http://www.bogotobogo.com/Qt/Qt5_QTcpSocket.php

#include "mytcpsocket.h"

MyTcpSocket::MyTcpSocket(QObject *parent) :
    QObject(parent)
{}

void MyTcpSocket::doConnect(QString host, quint16 port)
{

    _isConnected = false;
    //create new socket
    socket = new QTcpSocket(this);

    //connect sockets signals and slots
    //QObject::connect(sender, signal, receiver, slot):
    connect(socket, SIGNAL(connected()),this, SLOT(connected()));
    connect(socket, SIGNAL(disconnected()),this, SLOT(disconnected()));
    //connect(socket, SIGNAL(bytesWritten(qint64)),this, SLOT(bytesWritten(qint64)));
    connect(socket, SIGNAL(readyRead()),this, SLOT(readyRead()));

    qDebug() << "connecting...";

    // connect socket to specified hos and port
    socket->connectToHost(host, port);

    if(!socket->waitForConnected(5000))
    {   //connection timed out for some reason
        qDebug() << "Error: " << socket->errorString();
        socketDisconnected();
        errorConnecting(socket->errorString());
    }
}


void MyTcpSocket::connected()
// called when the socket is connected to the host to notify others modules of the state
{
    qDebug() << "connected...";
    socketConnected();
    _isConnected = true;
}

void MyTcpSocket::disconnect()
// called when the socket is disconnected from the host
{
    qDebug() << "disconnecting...";
    //socket->write("EXIT;");
    socket->disconnectFromHost();
}

void MyTcpSocket::disconnected()
// called when the socket is disconnected from the host to notify others modules of the state
{
    _isConnected = false;
    socketDisconnected();
    qDebug() << "disconnected...";
}

void MyTcpSocket::bytesWritten(qint64 bytes)
// Used for debug purpose, to know how many bytes have been written to the host.
{
    qDebug() << bytes << " bytes written...";
}

void MyTcpSocket::readyRead()
// Called when socket is ready to read data
{
    qDebug() << "reading...";

    // Read the data from the socket and pass is along in recieved
    if(_isConnected){
        QByteArray message = socket->readAll();
        emit recieved(message);
    }
}

void MyTcpSocket::sendMessage(QByteArray message)
// Sends provided message along to the host
{
    if(_isConnected){
        socket->write(message);
        qDebug() << message;
        if(message.startsWith("MAP")) {
            emit mapSent();
        }
    }
}
