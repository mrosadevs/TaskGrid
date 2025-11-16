import QtQuick
import QtQuick.Controls
import QtQuick.Window
import TaskGrid

ApplicationWindow {
    id: mainWindow
    visible: true
    width: Constants.width
    height: Constants.height
    title: qsTr("Task Grid")
    visibility: Window.Maximized

    App {
        anchors.fill: parent
    }
}
