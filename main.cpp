#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QCoreApplication>

#include "databasemanager.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    DatabaseManager db;
    engine.rootContext()->setContextProperty(QStringLiteral("DB"), &db);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [](QObject *obj, const QUrl &objUrl) {
            Q_UNUSED(objUrl);
            if (!obj) {
                QCoreApplication::exit(-1);
            }
        },
        Qt::QueuedConnection);

    engine.loadFromModule("TaskGrid", "Main");

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
