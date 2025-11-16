import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import TaskGrid

Rectangle {
    id: root
    width: Constants.width
    height: Constants.height
    focus: true

    property color lightBackground: Constants.backgroundColor
    property color darkBackground: "#05070B"

    property color lightToolbarColor: "#FFFFFF"
    property color darkToolbarColor: "#161A25"

    property color lightTextColor: "#202632"
    property color darkTextColor: "#F5F7FA"

    property color lightSearchBg: Qt.rgba(0x20 / 255, 0x26 / 255,
                                          0x32 / 255, 0.25)
    property color darkSearchBg: Qt.rgba(1, 1, 1, 0.06)

    property color lightSearchBorder: Qt.rgba(0x20 / 255, 0x26 / 255,
                                              0x32 / 255, 0.6)
    property color darkSearchBorder: Qt.rgba(1, 1, 1, 0.35)

    property color lightSearchText: Qt.rgba(0x20 / 255, 0x26 / 255,
                                            0x32 / 255, 0.35)
    property color darkSearchText: "#FFFFFF"

    property bool addMenuOpen: false

    property string searchText: ""

    function matchesSearch(title, description, dueDate) {
        var q = searchText.toLowerCase()
        if (q === "")
            return true

        if (title && title.toLowerCase().indexOf(q) !== -1)
            return true
        if (description && description.toLowerCase().indexOf(q) !== -1)
            return true
        if (dueDate && dueDate.toLowerCase().indexOf(q) !== -1)
            return true

        return false
    }

    ListModel {
        id: taskModel
    }

    Component.onCompleted: {
        if (typeof DB !== "undefined" && DB.loadTasks) {
            var tasks = DB.loadTasks()
            for (var i = 0; i < tasks.length; ++i) {
                taskModel.append(tasks[i])
            }
        }
    }

    color: switch1.checked ? darkBackground : lightBackground
    Behavior on color {
        ColorAnimation {
            duration: 1000
            easing.type: Easing.InOutQuad
        }
    }

    ToolBar {
        id: toolBar
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 108
        z: 100

        background: Rectangle {
            id: toolbarBg

            color: switch1.checked ? root.darkToolbarColor : root.lightToolbarColor
            Behavior on color {
                ColorAnimation {
                    duration: 1000
                    easing.type: Easing.InOutQuad
                }
            }

            gradient: Gradient {
                orientation: Gradient.Horizontal

                GradientStop {
                    id: g1
                    position: 0.0
                    color: switch1.checked ? "#243047" : "#FFFFFF"
                    Behavior on color {
                        ColorAnimation {
                            duration: 1000
                            easing.type: Easing.InOutQuad
                        }
                    }
                }

                GradientStop {
                    id: g2
                    position: 1.0
                    color: switch1.checked ? "#161A25" : "#FFFFFF"
                    Behavior on color {
                        ColorAnimation {
                            duration: 1000
                            easing.type: Easing.InOutQuad
                        }
                    }
                }
            }
        }

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 64
            anchors.rightMargin: 64
            anchors.topMargin: 12
            anchors.bottomMargin: 12
            spacing: 16

            Item {
                Layout.preferredWidth: 280
                Layout.preferredHeight: 90
                Layout.alignment: Qt.AlignVCenter

                Image {
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectFit
                    source: "images/Logo.png"
                    opacity: switch1.checked ? 0 : 1
                    Behavior on opacity {
                        NumberAnimation {
                            duration: 1000
                            easing.type: Easing.InOutQuad
                        }
                    }
                }

                Image {
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectFit
                    source: "images/White Logo.png"
                    opacity: switch1.checked ? 1 : 0
                    Behavior on opacity {
                        NumberAnimation {
                            duration: 1000
                            easing.type: Easing.InOutQuad
                        }
                    }
                }
            }

            Item {
                Layout.fillWidth: true
            }

            TextField {
                id: textField
                placeholderText: qsTr("Search tasks…")
                font.pixelSize: 20
                verticalAlignment: TextInput.AlignVCenter

                color: switch1.checked ? darkSearchText : lightSearchText
                placeholderTextColor: switch1.checked ? darkSearchText : lightSearchText
                Behavior on color {
                    ColorAnimation {
                        duration: 1000
                        easing.type: Easing.InOutQuad
                    }
                }
                Behavior on placeholderTextColor {
                    ColorAnimation {
                        duration: 1000
                        easing.type: Easing.InOutQuad
                    }
                }

                onTextChanged: root.searchText = text

                leftPadding: 44
                rightPadding: 14
                Layout.preferredWidth: 480
                Layout.maximumWidth: 520
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                implicitHeight: 44

                background: Rectangle {
                    radius: 26
                    color: switch1.checked ? darkSearchBg : lightSearchBg
                    border.color: switch1.checked ? darkSearchBorder : lightSearchBorder
                    border.width: 1
                    Behavior on color {
                        ColorAnimation {
                            duration: 1000
                            easing.type: Easing.InOutQuad
                        }
                    }
                    Behavior on border.color {
                        ColorAnimation {
                            duration: 1000
                            easing.type: Easing.InOutQuad
                        }
                    }

                    Item {
                        width: 20
                        height: 20
                        anchors.left: parent.left
                        anchors.leftMargin: 14
                        anchors.verticalCenter: parent.verticalCenter

                        Image {
                            anchors.fill: parent
                            fillMode: Image.PreserveAspectFit
                            source: "images/Search-Icon.png"
                            opacity: switch1.checked ? 0 : 1
                            Behavior on opacity {
                                NumberAnimation {
                                    duration: 1000
                                    easing.type: Easing.InOutQuad
                                }
                            }
                        }

                        Image {
                            anchors.fill: parent
                            fillMode: Image.PreserveAspectFit
                            source: "images/White Search Icon.png"
                            opacity: switch1.checked ? 1 : 0
                            Behavior on opacity {
                                NumberAnimation {
                                    duration: 1000
                                    easing.type: Easing.InOutQuad
                                }
                            }
                        }
                    }
                }
            }

            Item {
                Layout.fillWidth: true
            }

            RowLayout {
                spacing: 14
                Layout.alignment: Qt.AlignVCenter | Qt.AlignRight

                Label {
                    text: "☀"
                    font.pixelSize: 36
                    color: switch1.checked ? darkTextColor : lightTextColor
                    Behavior on color {
                        ColorAnimation {
                            duration: 1000
                            easing.type: Easing.InOutQuad
                        }
                    }
                }

                Switch {
                    id: switch1
                    implicitWidth: 56
                    implicitHeight: 32

                    indicator: Item {
                        implicitWidth: 56
                        implicitHeight: 32

                        Rectangle {
                            anchors.fill: parent
                            radius: height / 2
                            color: switch1.checked ? "#18C0DE" : "#202632"
                            Behavior on color {
                                ColorAnimation {
                                    duration: 1000
                                    easing.type: Easing.InOutQuad
                                }
                            }
                        }

                        Rectangle {
                            width: 24
                            height: 24
                            radius: 12
                            y: (parent.height - height) / 2
                            x: switch1.checked ? parent.width - width - 4 : 4
                            color: "#FFFFFF"
                            Behavior on x {
                                NumberAnimation {
                                    duration: 140
                                    easing.type: Easing.InOutQuad
                                }
                            }
                        }
                    }
                }

                Label {
                    text: "🌙"
                    font.pixelSize: 36
                    color: switch1.checked ? darkTextColor : lightTextColor
                    Behavior on color {
                        ColorAnimation {
                            duration: 1000
                            easing.type: Easing.InOutQuad
                        }
                    }
                }
            }
        }
    }

    Item {
        id: backgroundLayer
        anchors.top: toolBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        z: 0

        Image {
            anchors.fill: parent
            source: "images/White Column Grid.png"
            fillMode: Image.PreserveAspectCrop
            smooth: true
            opacity: switch1.checked ? 0 : 1
            Behavior on opacity {
                NumberAnimation {
                    duration: 1000
                    easing.type: Easing.InOutQuad
                }
            }
        }

        Image {
            anchors.fill: parent
            source: "images/Dark Column Grid.png"
            fillMode: Image.PreserveAspectCrop
            smooth: true
            opacity: switch1.checked ? 1 : 0
            Behavior on opacity {
                NumberAnimation {
                    duration: 1000
                    easing.type: Easing.InOutQuad
                }
            }
        }
    }

    Item {
        id: addTaskButton
        width: 64
        height: 64
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: 32
        anchors.bottomMargin: 32
        z: 80

        property real scaleFactor: 1.0
        property real rotationAngle: addMenuOpen ? 45 : 0

        transform: [
            Scale {
                origin.x: addTaskButton.width / 2
                origin.y: addTaskButton.height / 2
                xScale: addTaskButton.scaleFactor
                yScale: addTaskButton.scaleFactor
            },
            Rotation {
                origin.x: addTaskButton.width / 2
                origin.y: addTaskButton.height / 2
                angle: addTaskButton.rotationAngle
            }
        ]

        Behavior on scaleFactor {
            NumberAnimation {
                duration: 120
                easing.type: Easing.InOutQuad
            }
        }
        Behavior on rotationAngle {
            NumberAnimation {
                duration: 180
                easing.type: Easing.InOutQuad
            }
        }

        Text {
            anchors.fill: parent
            text: "+"
            font.pixelSize: 54
            font.family: "Montserrat"
            font.weight: Font.Black
            color: switch1.checked ? "#FFFFFF" : "#202632"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            Behavior on color {
                ColorAnimation {
                    duration: 260
                    easing.type: Easing.InOutQuad
                }
            }
        }

        MouseArea {
            id: addTaskMouseArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor

            onEntered: addTaskButton.scaleFactor = 1.12
            onExited: addTaskButton.scaleFactor = 1.0
            onPressed: addTaskButton.scaleFactor = 0.94
            onReleased: addTaskButton.scaleFactor = containsMouse ? 1.12 : 1.0
            onClicked: addMenuOpen = !addMenuOpen
        }
    }

    Rectangle {
        id: addMenuPanel
        width: 220
        height: 120
        radius: 16
        color: "transparent"
        anchors.right: addTaskButton.left
        anchors.rightMargin: 12
        anchors.verticalCenter: addTaskButton.verticalCenter
        z: 90
        clip: false

        visible: addMenuOpen || btnCreateTask.baseScale > 0.01 || btnCreateTodo.baseScale > 0.01

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 0
            spacing: 8

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 56

                Rectangle {
                    id: btnCreateTask
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width
                    height: 44
                    radius: 12

                    property real baseScale: addMenuOpen ? 1.0 : 0.0
                    property real hoverScale: 1.0

                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop { position: 0.0; color: "#1B88E2" }
                        GradientStop { position: 1.0; color: "#0C406A" }
                    }

                    transform: Scale {
                        origin.x: width / 2
                        origin.y: height / 2
                        xScale: baseScale * hoverScale
                        yScale: baseScale * hoverScale
                    }

                    Behavior on baseScale {
                        NumberAnimation {
                            duration: 260
                            easing.type: Easing.OutBack
                        }
                    }

                    Behavior on hoverScale {
                        NumberAnimation {
                            duration: 120
                            easing.type: Easing.InOutQuad
                        }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "Create Task"
                        font.family: "Montserrat"
                        font.pixelSize: 14
                        font.bold: true
                        color: "#FFFFFF"
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        enabled: addMenuOpen
                        cursorShape: Qt.PointingHandCursor

                        onEntered: hoverScale = 1.06
                        onExited: hoverScale = 1.0
                        onClicked: {
                            var t
                            if (typeof DB !== "undefined" && DB.createTask) {
                                t = DB.createTask("New task", "", "", 0)
                            }
                            if (t && t.id !== undefined) {
                                taskModel.append(t)
                            } else {
                                taskModel.append({
                                    "id": -1,
                                    "title": "New task",
                                    "description": "",
                                    "dueDate": "",
                                    "cardType": 0
                                })
                            }
                            addMenuOpen = false
                        }
                    }
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 56

                Rectangle {
                    id: btnCreateTodo
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width
                    height: 44
                    radius: 12

                    property real baseScale: addMenuOpen ? 1.0 : 0.0
                    property real hoverScale: 1.0

                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop { position: 0.0; color: "#2EBB64" }
                        GradientStop { position: 1.0; color: "#16572F" }
                    }

                    transform: Scale {
                        origin.x: width / 2
                        origin.y: height / 2
                        xScale: baseScale * hoverScale
                        yScale: baseScale * hoverScale
                    }

                    Behavior on baseScale {
                        NumberAnimation {
                            duration: 260
                            easing.type: Easing.OutBack
                        }
                    }

                    Behavior on hoverScale {
                        NumberAnimation {
                            duration: 120
                            easing.type: Easing.InOutQuad
                        }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "Create To Do List"
                        font.family: "Montserrat"
                        font.pixelSize: 14
                        font.bold: true
                        color: "#FFFFFF"
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        enabled: addMenuOpen
                        cursorShape: Qt.PointingHandCursor

                        onEntered: hoverScale = 1.06
                        onExited: hoverScale = 1.0
                        onClicked: {
                            var t
                            if (typeof DB !== "undefined" && DB.createTask) {
                                t = DB.createTask("New to-do list", "", "", 1)
                            }
                            if (t && t.id !== undefined) {
                                taskModel.append(t)
                            } else {
                                taskModel.append({
                                    "id": -1,
                                    "title": "New to-do list",
                                    "description": "",
                                    "dueDate": "",
                                    "cardType": 1
                                })
                            }
                            addMenuOpen = false
                        }
                    }
                }
            }
        }
    }

    MouseArea {
        id: addMenuCloseArea
        anchors.fill: parent
        enabled: addMenuOpen
        z: 70
        hoverEnabled: false
        propagateComposedEvents: true
        onClicked: {
            if (!addMenuPanel.containsMouse && !addTaskButton.containsMouse)
                addMenuOpen = false
        }
    }

    Dialog {
        id: editTaskDialog
        modal: true
        x: (root.width - width) / 2
        y: (root.height - height) / 2
        implicitWidth: 440
        implicitHeight: 280
        title: ""
        standardButtons: Dialog.NoButton

        property int currentIndex: -1

        background: Rectangle {
            id: editBg
            radius: 18
            color: switch1.checked ? "#161A25" : "#FFFFFF"
            border.width: 1
            border.color: switch1.checked ? Qt.rgba(1, 1, 1, 0.16)
                                          : Qt.rgba(0, 0, 0, 0.12)

            property real scaleFactor: editTaskDialog.visible ? 1.0 : 0.8
            opacity: editTaskDialog.visible ? 1.0 : 0.0

            transform: Scale {
                origin.x: editBg.width / 2
                origin.y: editBg.height / 2
                xScale: editBg.scaleFactor
                yScale: editBg.scaleFactor
            }

            Behavior on scaleFactor {
                NumberAnimation {
                    duration: 220
                    easing.type: Easing.OutBack
                }
            }
            Behavior on opacity {
                NumberAnimation {
                    duration: 160
                    easing.type: Easing.InOutQuad
                }
            }
        }

        contentItem: ColumnLayout {
            anchors.fill: parent
            anchors.margins: 18
            spacing: 12

            Text {
                text: "Edit Task"
                font.family: "Montserrat"
                font.pixelSize: 20
                font.bold: true
                color: switch1.checked ? "#F5F7FA" : "#202632"
            }

            TextField {
                id: editTitleField
                placeholderText: "Title"
                font.family: "Montserrat"
                font.pixelSize: 16
                color: switch1.checked ? "#F5F7FA" : "#202632"
                placeholderTextColor: switch1.checked
                                       ? Qt.rgba(1,1,1,0.4)
                                       : Qt.rgba(0,0,0,0.4)
                Layout.fillWidth: true

                background: Rectangle {
                    radius: 10
                    color: switch1.checked ? "#1E2535" : "#F3F4F7"
                    border.width: 1
                    border.color: switch1.checked
                                  ? Qt.rgba(1,1,1,0.18)
                                  : Qt.rgba(0,0,0,0.10)
                }
            }

            TextArea {
                id: editDescriptionField
                placeholderText: "Description"
                font.family: "Montserrat"
                font.pixelSize: 14
                wrapMode: TextArea.Wrap
                implicitHeight: 110
                Layout.fillWidth: true
                color: switch1.checked ? "#F5F7FA" : "#202632"
                placeholderTextColor: switch1.checked
                                       ? Qt.rgba(1,1,1,0.4)
                                       : Qt.rgba(0,0,0,0.4)

                background: Rectangle {
                    radius: 10
                    color: switch1.checked ? "#1E2535" : "#F3F4F7"
                    border.width: 1
                    border.color: switch1.checked
                                  ? Qt.rgba(1,1,1,0.18)
                                  : Qt.rgba(0,0,0,0.10)
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.topMargin: 8
                spacing: 10

                Item { Layout.fillWidth: true }

                Rectangle {
                    id: cancelEditBtn
                    width: 96
                    height: 36
                    radius: 10
                    color: switch1.checked ? "#252A37" : "#E3E5EA"

                    Text {
                        anchors.centerIn: parent
                        text: "Cancel"
                        font.family: "Montserrat"
                        font.pixelSize: 14
                        color: switch1.checked ? Qt.rgba(1,1,1,0.85)
                                               : Qt.rgba(0,0,0,0.75)
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: editTaskDialog.close()
                    }
                }

                Rectangle {
                    id: okEditBtn
                    width: 96
                    height: 36
                    radius: 10

                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop { position: 0.0; color: "#1B88E2" }
                        GradientStop { position: 1.0; color: "#0C406A" }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "OK"
                        font.family: "Montserrat"
                        font.pixelSize: 14
                        font.bold: true
                        color: "#FFFFFF"
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (editTaskDialog.currentIndex >= 0) {
                                var item = taskModel.get(editTaskDialog.currentIndex)

                                if (typeof DB !== "undefined" && DB.updateTaskText) {
                                    DB.updateTaskText(item.id,
                                                      editTitleField.text,
                                                      editDescriptionField.text)
                                }

                                taskModel.setProperty(editTaskDialog.currentIndex,
                                                      "title", editTitleField.text)
                                taskModel.setProperty(editTaskDialog.currentIndex,
                                                      "description", editDescriptionField.text)
                            }
                            editTaskDialog.close()
                        }
                    }
                }
            }
        }
    }

    Dialog {
        id: dueDateDialog
        modal: true
        x: (root.width - width) / 2
        y: (root.height - height) / 2
        implicitWidth: 380
        implicitHeight: 210
        title: ""
        standardButtons: Dialog.NoButton

        property int currentIndex: -1

        background: Rectangle {
            id: dueBg
            radius: 18
            color: switch1.checked ? "#161A25" : "#FFFFFF"
            border.width: 1
            border.color: switch1.checked ? Qt.rgba(1, 1, 1, 0.16)
                                          : Qt.rgba(0, 0, 0, 0.12)

            property real scaleFactor: dueDateDialog.visible ? 1.0 : 0.8
            opacity: dueDateDialog.visible ? 1.0 : 0.0

            transform: Scale {
                origin.x: dueBg.width / 2
                origin.y: dueBg.height / 2
                xScale: dueBg.scaleFactor
                yScale: dueBg.scaleFactor
            }

            Behavior on scaleFactor {
                NumberAnimation {
                    duration: 220
                    easing.type: Easing.OutBack
                }
            }
            Behavior on opacity {
                NumberAnimation {
                    duration: 160
                    easing.type: Easing.InOutQuad
                }
            }
        }

        contentItem: ColumnLayout {
            anchors.fill: parent
            anchors.margins: 18
            spacing: 10

            Text {
                text: "Set Due Date"
                font.family: "Montserrat"
                font.pixelSize: 20
                font.bold: true
                color: switch1.checked ? "#F5F7FA" : "#202632"
            }

            TextField {
                id: dueDateField
                placeholderText: "Due date (e.g. 2025-11-15)"
                Layout.fillWidth: true
                font.family: "Montserrat"
                font.pixelSize: 16
                color: switch1.checked ? "#F5F7FA" : "#202632"
                placeholderTextColor: switch1.checked
                                       ? Qt.rgba(1,1,1,0.4)
                                       : Qt.rgba(0,0,0,0.4)

                background: Rectangle {
                    radius: 10
                    color: switch1.checked ? "#1E2535" : "#F3F4F7"
                    border.width: 1
                    border.color: switch1.checked
                                  ? Qt.rgba(1,1,1,0.18)
                                  : Qt.rgba(0,0,0,0.10)
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.topMargin: 8
                spacing: 10

                Item { Layout.fillWidth: true }

                Rectangle {
                    id: cancelDueBtn
                    width: 96
                    height: 36
                    radius: 10
                    color: switch1.checked ? "#252A37" : "#E3E5EA"

                    Text {
                        anchors.centerIn: parent
                        text: "Cancel"
                        font.family: "Montserrat"
                        font.pixelSize: 14
                        color: switch1.checked ? Qt.rgba(1,1,1,0.85)
                                               : Qt.rgba(0,0,0,0.75)
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: dueDateDialog.close()
                    }
                }

                Rectangle {
                    id: okDueBtn
                    width: 96
                    height: 36
                    radius: 10

                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop { position: 0.0; color: "#2EBB64" }
                        GradientStop { position: 1.0; color: "#16572F" }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: "OK"
                        font.family: "Montserrat"
                        font.pixelSize: 14
                        font.bold: true
                        color: "#FFFFFF"
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (dueDateDialog.currentIndex >= 0) {
                                var item = taskModel.get(dueDateDialog.currentIndex)

                                if (typeof DB !== "undefined" && DB.updateTaskDueDate) {
                                    DB.updateTaskDueDate(item.id, dueDateField.text)
                                }

                                taskModel.setProperty(dueDateDialog.currentIndex,
                                                      "dueDate", dueDateField.text)
                            }
                            dueDateDialog.close()
                        }
                    }
                }
            }
        }
    }

    Repeater {
        model: taskModel

        delegate: TaskCard {
            id: taskCard
            taskId: model.id
            title: model.title
            description: model.description
            dueDate: model.dueDate
            cardType: model.cardType
            darkMode: switch1.checked

            visible: root.matchesSearch(title, description, dueDate)

            topMargin: toolBar.height + 16
            leftMargin: 16
            rightMargin: 16
            bottomMargin: 16

            x: 200 + index * 320
            y: 200

            onDeleteTaskRequested: {
                var item = taskModel.get(index)
                if (typeof DB !== "undefined" && DB.deleteTask) {
                    DB.deleteTask(item.id)
                }
                taskModel.remove(index)
            }

            onChangeTypeRequested: {
                var item = taskModel.get(index)
                var newType = (item.cardType === 0) ? 1 : 0
                if (typeof DB !== "undefined" && DB.updateTaskType) {
                    DB.updateTaskType(item.id, newType)
                }
                taskModel.setProperty(index, "cardType", newType)
            }

            onEditTaskRequested: {
                editTaskDialog.currentIndex = index
                editTitleField.text = model.title
                editDescriptionField.text = model.description
                editTaskDialog.open()
            }

            onDueDateRequested: {
                dueDateDialog.currentIndex = index
                dueDateField.text = model.dueDate
                dueDateDialog.open()
            }
        }
    }
}
