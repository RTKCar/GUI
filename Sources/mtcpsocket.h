#ifndef MYTCPSOCKET_H
#define MYTCPSOCKET_H

#include <QObject>
#include <QTcpSocket>
#include <QAbstractSocket>
#include <QDebug>
#include <QString>

class MyTcpSocket : public QObject
{
  Q_OBJECT
  Q_PROPERTY(QByteArray Map READ Map WRITE setMap NOTIFY mapChanged)
    Q_PROPERTY(bool isConnected MEMBER _isConnected NOTIFY isConnectedChanged)
public:
  explicit MyTcpSocket(QObject *parent = 0);

  QByteArray Map();
  void setMap(QByteArray &Map);

signals:
  //connected();
  void socketConnected();
  void socketDisconnected();
  void recieved();
  void mapChanged();
  void isConnectedChanged();

public slots:
  void doConnect(QString host, quint16 port);
  void connected();
  void disconnected();
  void disconnect();
  void bytesWritten(qint64 bytes);
  void readyRead();
  void sendJSON();

private:
  QTcpSocket *socket;
  QByteArray map;
  bool _isConnected = false;

};

#endif // MYTCPSOCKET_H
