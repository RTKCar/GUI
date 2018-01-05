//Modified from BogoToBogo QTcpSocket Example: http://www.bogotobogo.com/Qt/Qt5_QTcpSocket.php

#ifndef MYTCPSOCKET_H
#define MYTCPSOCKET_H

#include <QObject>
#include <QTcpSocket>
#include <QAbstractSocket>
#include <QDebug>
#include <QString>
#include <QTime>

class MyTcpSocket : public QObject
{
  Q_OBJECT
    Q_PROPERTY(bool isConnected MEMBER _isConnected NOTIFY isConnectedChanged)
public:
  explicit MyTcpSocket(QObject *parent = 0);

signals:
  void socketConnected();
  void socketDisconnected();
  void errorConnecting(QString errorMessage);
  void recieved(QString message);
  void isConnectedChanged();
  void mapSent();

public slots:
  void doConnect(QString host, quint16 port);
  void connected();
  void disconnected();
  void disconnect();
  void bytesWritten(qint64 bytes);
  void readyRead();
  void sendMessage(QByteArray message);

private:
  QTcpSocket *socket;
  bool _isConnected = false;

};

#endif // MYTCPSOCKET_H
