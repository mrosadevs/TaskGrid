cmake_minimum_required(VERSION 3.21)
project(TaskGrid VERSION 1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

set(CMAKE_PREFIX_PATH "C:/Qt/6.10.0/mingw_64" CACHE STRING "" FORCE)

find_package(Qt6 REQUIRED COMPONENTS Core Gui Qml Quick Sql)

qt_policy(SET QTP0001 NEW)
qt_policy(SET QTP0004 NEW)

set(SRC_DIR ${CMAKE_SOURCE_DIR}/src)

qt_add_executable(TaskGrid
        ${SRC_DIR}/main.cpp
)

qt_add_qml_module(TaskGrid
        URI TaskGrid
        VERSION 1.0
        QML_FILES
        qml/TaskGrid/Main.qml
)

target_link_libraries(TaskGrid PRIVATE
        Qt6::Core
        Qt6::Gui
        Qt6::Qml
        Qt6::Quick
        Qt6::Sql
)

set_target_properties(TaskGrid PROPERTIES
        WIN32_EXECUTABLE TRUE
)
