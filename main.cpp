#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "Sources/mytcpsocket.h"
//#include "Sources/filereaderwriter.h"
#include <QtQuick>
#include <QtQml>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    qmlRegisterType<MyTcpSocket>("myPackage", 1, 0, "MyTcpSocket");
    //qmlRegisterType<FileReaderWriter>("myFilePackage", 1, 0, "FileReaderWriter");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QLatin1String("qrc:/qml/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
