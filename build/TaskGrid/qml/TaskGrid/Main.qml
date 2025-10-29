import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {
  id: win
  width: 1100
  height: 700
  visible: true
  title: "TaskGrid"

  header: ToolBar {
    RowLayout {
      anchors.fill: parent
      Label { text: "TaskGrid"; font.bold: true; Layout.alignment: Qt.AlignVCenter }
      Item { Layout.fillWidth: true }
      Button { text: "Add Task"; onClicked: addDialog.open() }
    }
  }

  Dialog {
    id: addDialog
    title: "New Task"
    standardButtons: Dialog.Ok | Dialog.Cancel
    modal: true
    onAccepted: {
      taskModel.addTask(titleField.text, dueField.dateTime, courseField.text, statusBox.currentText, "");
      titleField.text = ""; courseField.text = ""; statusBox.currentIndex = 0;
    }
    contentItem: ColumnLayout {
      spacing: 8
      TextField { id: titleField; placeholderText: "Title" }
      TextField { id: courseField; placeholderText: "Course / Category" }
      ComboBox { id: statusBox; model: ["todo","doing","done"] }
      DateTimeEdit { id: dueField; dateTime: new Date() }
    }
  }

  ColumnLayout {
    anchors.fill: parent
    anchors.margins: 12
    TableView {
      id: table
      Layout.fillWidth: true
      Layout.fillHeight: true
      clip: true
      model: taskModel
      TableViewColumn { role: "title";  title: "Title"; width: 360 }
      TableViewColumn { role: "course"; title: "Course"; width: 160 }
      TableViewColumn { role: "due";    title: "Due"; width: 220; delegate: Text { text: styleData.value.toLocaleString() } }
      TableViewColumn { role: "status"; title: "Status"; width: 120 }
      RowDelegate {
        onPressed: if (mouse.button === Qt.RightButton) contextMenu.popup()
      }
    }
  }

  Menu {
    id: contextMenu
    MenuItem {
      text: "Delete"
      onTriggered: {
        if (table.currentRow >= 0) taskModel.removeTask(table.currentRow)
      }
    }
  }
}
