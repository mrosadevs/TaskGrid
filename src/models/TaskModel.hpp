#pragma once
#include <QAbstractListModel>
#include <QDateTime>
#include <QVector>

struct TaskItem {
  QString title;
  QDateTime due;
  QString course;
  QString status; // "todo", "doing", "done"
  QString rrule;  // optional: recurrence rule
};

class TaskModel : public QAbstractListModel {
  Q_OBJECT
public:
  enum Roles { TitleRole = Qt::UserRole + 1, DueRole, CourseRole, StatusRole, RRuleRole };
  Q_ENUM(Roles)

  int rowCount(const QModelIndex &parent = QModelIndex()) const override;
  QVariant data(const QModelIndex &index, int role) const override;
  QHash<int, QByteArray> roleNames() const override;

  Q_INVOKABLE void addTask(const QString &title, const QDateTime &due,
                           const QString &course, const QString &status,
                           const QString &rrule);
  Q_INVOKABLE void removeTask(int index);
private:
  QVector<TaskItem> m_items;
};
