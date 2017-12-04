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
    //Q_PROPERTY(const char Map READ Map WRITE setMap NOTIFY mapChanged)
public:
  explicit MyTcpSocket(QObject *parent = 0);

  //const char Map();
  QByteArray Map();
  //bool isConnected();
  void setMap(QByteArray &Map);



signals:
  //connected();
  void socketConnected();
  void socketDisconnected();
  void recieved();
  void mapChanged();
  void isConnectedChanged();

public slots:
  void doConnect();
  void connected();
  void disconnected();
  void bytesWritten(qint64 bytes);
  void readyRead();
  void sendJSON();
  void newConn();
  void newDisconn();
  //void sendMessage(char &message);

private:
  QTcpSocket *socket;
  QByteArray map;
  bool _isConnected = false;
  //const char map;
  //qint32 num_ber;

};

#endif // MYTCPSOCKET_H
