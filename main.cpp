#include <QtQml>
#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "Process.h"

int main(int argc, char *argv[])
{
    qmlRegisterType<Process>("Process", 1, 0, "Process");
    
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engin(QUrl("quickPhone.qml"));

    return app.exec();
}
