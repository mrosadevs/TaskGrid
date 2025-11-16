cmake_minimum_required(VERSION 3.16)

project(TaskGrid VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick Sql)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appTaskGrid
    main.cpp
    databasemanager.cpp
)

qt_add_qml_module(appTaskGrid
    URI TaskGrid
    VERSION 1.0
    QML_FILES
        Main.qml
        App.qml
        TaskCard.qml
    RESOURCES
        "images/Logo.png"
        "images/White Logo.png"
        "images/Search-Icon.png"
        "images/White Search Icon.png"
        "images/White Column Grid.png"
        "images/Dark Column Grid.png"
)

set_target_properties(appTaskGrid PROPERTIES
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING
        ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
)

target_link_libraries(appTaskGrid
    PRIVATE Qt6::Quick Qt6::Sql
)

include(GNUInstallDirs)
install(TARGETS appTaskGrid
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
