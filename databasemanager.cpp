#include "databasemanager.h"

#include <QStandardPaths>
#include <QDir>
#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>

DatabaseManager::DatabaseManager(QObject *parent)
    : QObject(parent)
{
    openDatabase();
    initDatabase();
}

DatabaseManager::~DatabaseManager()
{
    if (m_db.isOpen()) {
        m_db.close();
    }
}

void DatabaseManager::openDatabase()
{
    if (QSqlDatabase::contains("taskgrid_connection")) {
        m_db = QSqlDatabase::database("taskgrid_connection");
        return;
    }

    m_db = QSqlDatabase::addDatabase("QSQLITE", "taskgrid_connection");

    const QString dataDir =
        QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);

    QDir().mkpath(dataDir);
    const QString dbPath =
        dataDir + QDir::separator() + QStringLiteral("taskgrid.sqlite");

    m_db.setDatabaseName(dbPath);

    if (!m_db.open()) {
        qWarning() << "Failed to open database:" << m_db.lastError().text();
    }
}

void DatabaseManager::initDatabase()
{
    if (!m_db.isOpen())
        return;

    QSqlQuery query(m_db);

    const char *tasksSql =
        "CREATE TABLE IF NOT EXISTS tasks ("
        "  id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "  title TEXT NOT NULL,"
        "  description TEXT,"
        "  dueDate TEXT,"
        "  cardType INTEGER NOT NULL"
        ")";

    if (!query.exec(QString::fromUtf8(tasksSql))) {
        qWarning() << "Failed to create tasks table:"
                   << query.lastError().text();
    }

    const char *todoSql =
        "CREATE TABLE IF NOT EXISTS todo_items ("
        "  id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "  task_id INTEGER NOT NULL,"
        "  text TEXT NOT NULL,"
        "  done INTEGER NOT NULL DEFAULT 0,"
        "  FOREIGN KEY(task_id) REFERENCES tasks(id)"
        ")";

    if (!query.exec(QString::fromUtf8(todoSql))) {
        qWarning() << "Failed to create todo_items table:"
                   << query.lastError().text();
    }
}

QVariantList DatabaseManager::loadTasks()
{
    QVariantList list;

    if (!m_db.isOpen())
        return list;

    QSqlQuery query(m_db);
    if (!query.exec(QStringLiteral(
            "SELECT id, title, description, dueDate, cardType "
            "FROM tasks ORDER BY id"))) {
        qWarning() << "Failed to load tasks:" << query.lastError().text();
        return list;
    }

    while (query.next()) {
        QVariantMap map;
        map["id"] = query.value(0).toInt();
        map["title"] = query.value(1).toString();
        map["description"] = query.value(2).toString();
        map["dueDate"] = query.value(3).toString();
        map["cardType"] = query.value(4).toInt();
        list.push_back(map);
    }

    return list;
}

QVariantMap DatabaseManager::createTask(const QString &title,
                                        const QString &description,
                                        const QString &dueDate,
                                        int cardType)
{
    QVariantMap map;

    if (!m_db.isOpen())
        return map;

    QSqlQuery query(m_db);
    query.prepare(QStringLiteral(
        "INSERT INTO tasks (title, description, dueDate, cardType) "
        "VALUES (:title, :description, :dueDate, :cardType)"));
    query.bindValue(":title", title);
    query.bindValue(":description", description);
    query.bindValue(":dueDate", dueDate);
    query.bindValue(":cardType", cardType);

    if (!query.exec()) {
        qWarning() << "Failed to insert task:" << query.lastError().text();
        return map;
    }

    int id = query.lastInsertId().toInt();

    map["id"] = id;
    map["title"] = title;
    map["description"] = description;
    map["dueDate"] = dueDate;
    map["cardType"] = cardType;
    return map;
}

void DatabaseManager::updateTaskText(int id,
                                     const QString &title,
                                     const QString &description)
{
    if (!m_db.isOpen())
        return;

    QSqlQuery query(m_db);
    query.prepare(QStringLiteral(
        "UPDATE tasks SET title = :title, description = :description "
        "WHERE id = :id"));
    query.bindValue(":title", title);
    query.bindValue(":description", description);
    query.bindValue(":id", id);

    if (!query.exec()) {
        qWarning() << "Failed to update task text:"
                   << query.lastError().text();
    }
}

void DatabaseManager::updateTaskDueDate(int id,
                                        const QString &dueDate)
{
    if (!m_db.isOpen())
        return;

    QSqlQuery query(m_db);
    query.prepare(QStringLiteral(
        "UPDATE tasks SET dueDate = :dueDate WHERE id = :id"));
    query.bindValue(":dueDate", dueDate);
    query.bindValue(":id", id);

    if (!query.exec()) {
        qWarning() << "Failed to update task due date:"
                   << query.lastError().text();
    }
}

void DatabaseManager::updateTaskType(int id,
                                     int cardType)
{
    if (!m_db.isOpen())
        return;

    QSqlQuery query(m_db);
    query.prepare(QStringLiteral(
        "UPDATE tasks SET cardType = :cardType WHERE id = :id"));
    query.bindValue(":cardType", cardType);
    query.bindValue(":id", id);

    if (!query.exec()) {
        qWarning() << "Failed to update task type:"
                   << query.lastError().text();
    }
}

void DatabaseManager::deleteTask(int id)
{
    if (!m_db.isOpen())
        return;

    {
        QSqlQuery q(m_db);
        q.prepare(QStringLiteral(
            "DELETE FROM todo_items WHERE task_id = :task_id"));
        q.bindValue(":task_id", id);
        if (!q.exec()) {
            qWarning() << "Failed to delete task's todo_items:"
                       << q.lastError().text();
        }
    }

    QSqlQuery query(m_db);
    query.prepare(QStringLiteral("DELETE FROM tasks WHERE id = :id"));
    query.bindValue(":id", id);

    if (!query.exec()) {
        qWarning() << "Failed to delete task:"
                   << query.lastError().text();
    }
}

QVariantList DatabaseManager::loadTodoItems(int taskId)
{
    QVariantList list;

    if (!m_db.isOpen())
        return list;

    QSqlQuery query(m_db);
    query.prepare(QStringLiteral(
        "SELECT text, done FROM todo_items "
        "WHERE task_id = :task_id ORDER BY id"));
    query.bindValue(":task_id", taskId);

    if (!query.exec()) {
        qWarning() << "Failed to load todo items:"
                   << query.lastError().text();
        return list;
    }

    while (query.next()) {
        QVariantMap row;
        row["text"] = query.value(0).toString();
        row["done"] = (query.value(1).toInt() != 0);
        list.push_back(row);
    }

    return list;
}

void DatabaseManager::saveTodoItems(int taskId,
                                    const QVariantList &items)
{
    if (!m_db.isOpen())
        return;

    if (!m_db.transaction()) {
        qWarning() << "Failed to start transaction for saveTodoItems:"
                   << m_db.lastError().text();
        return;
    }

    {
        QSqlQuery del(m_db);
        del.prepare(QStringLiteral(
            "DELETE FROM todo_items WHERE task_id = :task_id"));
        del.bindValue(":task_id", taskId);

        if (!del.exec()) {
            qWarning() << "Failed to delete old todo items:"
                       << del.lastError().text();
            m_db.rollback();
            return;
        }
    }

    QSqlQuery ins(m_db);
    ins.prepare(QStringLiteral(
        "INSERT INTO todo_items (task_id, text, done) "
        "VALUES (:task_id, :text, :done)"));

    for (const QVariant &v : items) {
        const QVariantMap map = v.toMap();
        ins.bindValue(":task_id", taskId);
        ins.bindValue(":text", map.value("text").toString());
        ins.bindValue(":done", map.value("done").toBool() ? 1 : 0);

        if (!ins.exec()) {
            qWarning() << "Failed to insert todo item:"
                       << ins.lastError().text();
            m_db.rollback();
            return;
        }
    }

    if (!m_db.commit()) {
        qWarning() << "Failed to commit saveTodoItems transaction:"
                   << m_db.lastError().text();
    }
}
