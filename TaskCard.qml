import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: card
    width: 280
    radius: 20
    clip: false

    signal deleteTaskRequested()
    signal changeTypeRequested()
    signal editTaskRequested()
    signal dueDateRequested()

    property bool darkMode: false
    property string title: "New task"
    property string description: ""
    property string dueDate: ""
    property real topMargin: 0
    property real bottomMargin: 0
    property real leftMargin: 0
    property real rightMargin: 0
    property int cardType: 0
    property bool editMenuOpen: false
    property int taskId: -1

    ListModel {
        id: gradientModel
        ListElement { start: "#1B89E3"; end: "#0C3E68" }
        ListElement { start: "#2FBC65"; end: "#16562E" }
        ListElement { start: "#7C4EDD"; end: "#432A77" }
        ListElement { start: "#EFBA30"; end: "#896B1C" }
        ListElement { start: "#F08438"; end: "#8A4C20" }
        ListElement { start: "#BB2E2E"; end: "#571616" }
    }

    property int gradientIndex: Math.floor(Math.random() * gradientModel.count)
    property bool dragging: dragArea.pressed
    property real scaleFactor: dragging ? 1.04 : 1.0

    gradient: Gradient {
        orientation: Gradient.Horizontal
        GradientStop { position: 0.0; color: gradientModel.get(card.gradientIndex).start }
        GradientStop { position: 1.0; color: gradientModel.get(card.gradientIndex).end }
    }

    transform: Scale {
        origin.x: card.width / 2
        origin.y: card.height / 2
        xScale: card.scaleFactor
        yScale: card.scaleFactor
    }

    Behavior on scaleFactor {
        NumberAnimation {
            duration: 140
            easing.type: Easing.InOutQuad
        }
    }

    ListModel {
        id: todoModel
    }

    function saveTodoItems() {
        if (card.cardType !== 1)
            return
        if (taskId < 0)
            return
        if (typeof DB === "undefined" || !DB.saveTodoItems)
            return

        var items = []
        for (var i = 0; i < todoModel.count; ++i) {
            var row = todoModel.get(i)
            items.push({ "text": row.text, "done": row.done })
        }
        DB.saveTodoItems(taskId, items)
    }

    Component.onCompleted: {
        if (card.cardType === 1 &&
                taskId >= 0 &&
                typeof DB !== "undefined" &&
                DB.loadTodoItems) {

            var rows = DB.loadTodoItems(taskId)
            todoModel.clear()
            for (var i = 0; i < rows.length; ++i) {
                todoModel.append({
                    "text": rows[i].text,
                    "done": rows[i].done
                })
            }
        }
    }

    onCardTypeChanged: {
        if (cardType !== 1) {
            todoModel.clear()
            saveTodoItems()
        }
    }

    implicitHeight: contentLayout.implicitHeight + 24

    ColumnLayout {
        id: contentLayout
        anchors.fill: parent
        anchors.margins: 14
        spacing: 8

        RowLayout {
            id: headerRow
            Layout.fillWidth: true
            spacing: 8

            Label {
                id: titleLabel
                text: title
                font.pixelSize: 18
                font.family: "Montserrat"
                font.weight: Font.DemiBold
                color: "#FFFFFF"
                Layout.fillWidth: true
                wrapMode: Text.Wrap
            }

            Item {
                id: menuButton
                Layout.alignment: Qt.AlignVCenter
                width: 34
                height: 34
                z: 3

                scale: 1.0
                Behavior on scale {
                    NumberAnimation {
                        duration: 100
                        easing.type: Easing.InOutQuad
                    }
                }

                Row {
                    anchors.centerIn: parent
                    spacing: 4
                    Rectangle { width: 6; height: 6; radius: 3; color: "#FFFFFF" }
                    Rectangle { width: 6; height: 6; radius: 3; color: "#FFFFFF" }
                    Rectangle { width: 6; height: 6; radius: 3; color: "#FFFFFF" }
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onEntered: menuButton.scale = 1.18
                    onExited: menuButton.scale = 1.0
                    onClicked: card.editMenuOpen = !card.editMenuOpen
                }
            }
        }

        Loader {
            id: bodyLoader
            Layout.fillWidth: true
            sourceComponent: card.cardType === 1 ? todoBodyComponent : standardBodyComponent
        }

        RowLayout {
            id: dueRow
            visible: dueDate !== ""
            spacing: 4
            Layout.alignment: Qt.AlignRight

            Label {
                text: "🕒"
                font.pixelSize: 13
                font.family: "Montserrat"
                color: "#FFFFFF"
            }

            Label {
                id: dueLabel
                text: dueDate
                font.pixelSize: 13
                font.family: "Montserrat"
                font.weight: Font.DemiBold
                color: "#FFFFFF"
            }
        }
    }

    Rectangle {
        id: editMenuContainer
        width: 200
        height: 4 * 36 + 3 * 8 + 12
        radius: 0
        color: "transparent"
        anchors.left: card.right
        anchors.leftMargin: 12
        anchors.verticalCenter: card.verticalCenter
        z: 10

        property real menuScale: editMenuOpen ? 1.0 : 0.0
        opacity: editMenuOpen ? 1.0 : 0.0
        visible: opacity > 0.01

        transform: Scale {
            origin.x: 0
            origin.y: editMenuContainer.height / 2
            xScale: editMenuContainer.menuScale
            yScale: editMenuContainer.menuScale
        }

        Behavior on menuScale {
            NumberAnimation {
                duration: 220
                easing.type: Easing.OutBack
            }
        }

        Behavior on opacity {
            NumberAnimation {
                duration: 140
                easing.type: Easing.InOutQuad
            }
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 6
            spacing: 8

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 36

                Rectangle {
                    id: btnEditTask
                    anchors.fill: parent
                    radius: 10

                    scale: 1.0
                    Behavior on scale {
                        NumberAnimation {
                            duration: 100
                            easing.type: Easing.InOutQuad
                        }
                    }

                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop { position: 0.0; color: "#EEB930" }
                        GradientStop { position: 1.0; color: "#896B1B" }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "Edit Task"
                        font.family: "Montserrat"
                        font.pixelSize: 13
                        font.bold: true
                        color: "#FFFFFF"
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onEntered: btnEditTask.scale = 1.18
                        onExited: btnEditTask.scale = 1.0
                        onClicked: {
                            card.editMenuOpen = false
                            card.editTaskRequested()
                        }
                    }
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 36

                Rectangle {
                    id: btnChangeTask
                    anchors.fill: parent
                    radius: 10

                    scale: 1.0
                    Behavior on scale {
                        NumberAnimation {
                            duration: 100
                            easing.type: Easing.InOutQuad
                        }
                    }

                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop { position: 0.0; color: "#F08438" }
                        GradientStop { position: 1.0; color: "#8A4C20" }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "Change Task"
                        font.family: "Montserrat"
                        font.pixelSize: 13
                        font.bold: true
                        color: "#FFFFFF"
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onEntered: btnChangeTask.scale = 1.18
                        onExited: btnChangeTask.scale = 1.0
                        onClicked: {
                            card.editMenuOpen = false
                            card.changeTypeRequested()
                        }
                    }
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 36

                Rectangle {
                    id: btnDueDate
                    anchors.fill: parent
                    radius: 10

                    scale: 1.0
                    Behavior on scale {
                        NumberAnimation {
                            duration: 100
                            easing.type: Easing.InOutQuad
                        }
                    }

                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop { position: 0.0; color: "#2FBC65" }
                        GradientStop { position: 1.0; color: "#16562E" }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "Due Date"
                        font.family: "Montserrat"
                        font.pixelSize: 13
                        font.bold: true
                        color: "#FFFFFF"
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onEntered: btnDueDate.scale = 1.18
                        onExited: btnDueDate.scale = 1.0
                        onClicked: {
                            card.editMenuOpen = false
                            card.dueDateRequested()
                        }
                    }
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 36

                Rectangle {
                    id: btnDeleteTask
                    anchors.fill: parent
                    radius: 10

                    scale: 1.0
                    Behavior on scale {
                        NumberAnimation {
                            duration: 100
                            easing.type: Easing.InOutQuad
                        }
                    }

                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop { position: 0.0; color: "#BB2E2E" }
                        GradientStop { position: 1.0; color: "#571616" }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "Delete Task"
                        font.family: "Montserrat"
                        font.pixelSize: 13
                        font.bold: true
                        color: "#FFFFFF"
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onEntered: btnDeleteTask.scale = 1.18
                        onExited: btnDeleteTask.scale = 1.0
                        onClicked: {
                            card.editMenuOpen = false
                            card.deleteTaskRequested()
                        }
                    }
                }
            }
        }
    }

    Component {
        id: standardBodyComponent
        ColumnLayout {
            spacing: 6
            Layout.fillWidth: true

            Label {
                id: descriptionLabel
                text: description
                visible: description !== ""
                font.pixelSize: 14
                font.family: "Montserrat"
                color: Qt.rgba(1, 1, 1, 0.6)
                Layout.fillWidth: true
                wrapMode: Text.WordWrap
            }
        }
    }

    Component {
        id: todoBodyComponent
        ColumnLayout {
            spacing: 10
            Layout.fillWidth: true

            Repeater {
                model: todoModel
                delegate: Item {
                    id: rowItem
                    Layout.fillWidth: true
                    implicitHeight: Math.max(checkboxText.implicitHeight, itemText.implicitHeight) + 6
                    property bool rowHover: false

                    Text {
                        id: checkboxText
                        text: model.done ? "▣" : "▢"
                        font.family: "Montserrat"
                        font.pixelSize: 34
                        color: Qt.rgba(1, 1, 1, 0.98)
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                model.done = !model.done
                                card.saveTodoItems()
                            }
                        }
                    }

                    Text {
                        id: removeText
                        text: "✕"
                        visible: rowHover
                        font.family: "Montserrat"
                        font.pixelSize: 16
                        color: Qt.rgba(1, 1, 1, 0.9)
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    TextField {
                        id: itemText
                        anchors.left: checkboxText.right
                        anchors.leftMargin: 10
                        anchors.right: removeText.left
                        anchors.rightMargin: 10
                        anchors.verticalCenter: parent.verticalCenter

                        text: model.text
                        font.family: "Montserrat"
                        font.pixelSize: 14
                        selectByMouse: true
                        color: model.done
                               ? Qt.rgba(1, 1, 1, 0.5)
                               : Qt.rgba(1, 1, 1, 1.0)
                        background: null

                        onTextChanged: {
                            model.text = text
                            card.saveTodoItems()
                        }

                        Behavior on color {
                            NumberAnimation {
                                duration: 160
                                easing.type: Easing.InOutQuad
                            }
                        }
                    }

                    Rectangle {
                        id: strikeLine
                        anchors.left: itemText.left
                        anchors.verticalCenter: itemText.verticalCenter
                        height: 2
                        radius: 1
                        color: Qt.rgba(1, 1, 1, 0.9)
                        width: model.done ? itemText.width : 0
                        visible: width > 0

                        Behavior on width {
                            NumberAnimation {
                                duration: 160
                                easing.type: Easing.InOutQuad
                            }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        acceptedButtons: Qt.NoButton
                        onEntered: rowHover = true
                        onExited: rowHover = false
                    }

                    MouseArea {
                        anchors.fill: removeText
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            todoModel.remove(index)
                            card.saveTodoItems()
                        }
                    }
                }
            }

            Item {
                Layout.alignment: Qt.AlignLeft
                implicitWidth: addLabel.implicitWidth
                implicitHeight: addLabel.implicitHeight

                Text {
                    id: addLabel
                    text: "+ Add item"
                    font.family: "Montserrat"
                    font.pixelSize: 14
                    font.weight: Font.DemiBold
                    color: Qt.rgba(1, 1, 1, 0.95)
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        todoModel.append({ "text": "", "done": false })
                        card.saveTodoItems()
                    }
                }
            }
        }
    }

    MouseArea {
        id: dragArea
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: headerRow.height + 8
        z: -1

        drag.target: card
        drag.axis: Drag.XAndYAxis

        drag.minimumX: leftMargin
        drag.maximumX: card.parent ? card.parent.width - card.width - rightMargin : 0
        drag.minimumY: topMargin
        drag.maximumY: card.parent ? card.parent.height - card.height - bottomMargin : 0

        hoverEnabled: true

        cursorShape: pressed
                     ? Qt.ClosedHandCursor
                     : (containsMouse ? Qt.OpenHandCursor : Qt.ArrowCursor)
    }
}
