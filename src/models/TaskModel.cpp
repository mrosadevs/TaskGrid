#include "models/TaskModel.hpp"

int TaskModel::rowCount(const QModelIndex &parent) const {
  if (parent.isValid()) return 0;
  return m_items.size();
}

QVariant TaskModel::data(const QModelIndex &index, int role) const {
  if (!index.isValid() || index.row() < 0 || index.row() >= m_items.size()) return {};
  const auto &t = m_items.at(index.row());
  switch (role) {
    case TitleRole:  return t.title;
    case DueRole:    return t.due;
    case CourseRole: return t.course;
    case StatusRole: return t.status;
    case RRuleRole:  return t.rrule;
  }
  return {};
}

QHash<int, QByteArray> TaskModel::roleNames() const {
  return {
    { TitleRole, "title" },
    { DueRole, "due" },
    { CourseRole, "course" },
    { StatusRole, "status" },
    { RRuleRole, "rrule" }
  };
}

void TaskModel::addTask(const QString &title, const QDateTime &due,
                        const QString &course, const QString &status,
                        const QString &rrule) {
  beginInsertRows(QModelIndex(), m_items.size(), m_items.size());
  m_items.push_back(TaskItem{title, due, course, status, rrule});
  endInsertRows();
}

void TaskModel::removeTask(int index) {
  if (index < 0 || index >= m_items.size()) return;
  beginRemoveRows(QModelIndex(), index, index);
  m_items.removeAt(index);
  endRemoveRows();
}
