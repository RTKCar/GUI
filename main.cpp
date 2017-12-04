#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "Sources/mtcpsocket.h"
#include <QtQuick>
//#include "qml/MapView.qml"
//#include "../Headers/mytcpsocket.h"
//#include "../Headers/Sources/mytcpsocket.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    qmlRegisterType<MyTcpSocket>("myPackage", 1, 0, "MyTcpSocket");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QLatin1String("qrc:/qml/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    //QObject *item2 = engine.rootObjects().first()->findChild<QQuickRowLayout*>("rowL");
    /*qDebug() << engine.rootObjects();
    qDebug() << engine.rootObjects().first()->children();
    //qDebug() << item2;
    //qDebug() << item2->children();
    QObject *item = engine.rootObjects().first();
    MyTcpSocket s;
    s.doConnect();
    //QObject::connect(item2, SIGNAL(mapVsignal()), &s, SLOT(sendJSON()));
    QObject::connect(item, SIGNAL(sendJson()), &s, SLOT(sendJSON()));*/
    //QObject::connect(item, SIGNAL(sendM(char)), &s, SLOT(sendMessage (char)));

    //QObject::connect(s, SIGNAL(connected()), &item, SLOT());
    //MyTcpSocket s;

    // Register our component type with QML.
    //qmlRegisterType<mtcpsocket>("com.ics.demo", 1, 0, "mtcpSocket");


    return app.exec();
}
