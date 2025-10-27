#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "app/App.hpp"
#include "models/TaskModel.hpp"

int main(int argc, char *argv[]) {
  QGuiApplication app(argc, argv);

  TaskModel taskModel;
  taskModel.addTask("Finish C++ assignment", QDateTime::currentDateTime().addDays(1), "CS-202", "todo", "");

  QQmlApplicationEngine engine;
  engine.rootContext()->setContextProperty("taskModel", &taskModel);

  const QUrl url(u"qrc:/TaskGrid/Main.qml"_qs);
  QObject::connect(&engine, &QQmlApplicationEngine::objectCreated, &app,
    [url](QObject *obj, const QUrl &objUrl) {
      if (!obj && url == objUrl) QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
  engine.load(url);

  return app.exec();
}
