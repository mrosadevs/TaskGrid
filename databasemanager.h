#ifndef DATABASEMANAGER_H
#define DATABASEMANAGER_H

#include <QObject>
#include <QSqlDatabase>
#include <QVariantList>
#include <QVariantMap>

class DatabaseManager : public QObject
{
    Q_OBJECT

public:
    explicit DatabaseManager(QObject *parent = nullptr);
    ~DatabaseManager();

    Q_INVOKABLE QVariantList loadTasks();
    Q_INVOKABLE QVariantMap createTask(const QString &title,
                                       const QString &description,
                                       const QString &dueDate,
                                       int cardType);
    Q_INVOKABLE void updateTaskText(int id,
                                    const QString &title,
                                    const QString &description);
    Q_INVOKABLE void updateTaskDueDate(int id,
                                       const QString &dueDate);
    Q_INVOKABLE void updateTaskType(int id,
                                    int cardType);
    Q_INVOKABLE void deleteTask(int id);

    Q_INVOKABLE QVariantList loadTodoItems(int taskId);
    Q_INVOKABLE void saveTodoItems(int taskId,
                                   const QVariantList &items);

private:
    QSqlDatabase m_db;

    void openDatabase();
    void initDatabase();
};

#endif
