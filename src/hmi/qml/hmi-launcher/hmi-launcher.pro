lessThan(QT_MAJOR_VERSION, 5): error(This project requires Qt 5 or later)

TARGET = hmi-launcher
OBJECTS_DIR = tmp
MOC_DIR = tmp
INCLUDEPATH += compat /home/user/usrfs/include/ilm
CONFIG += qt plugin
QT += qml quick widgets dbus
#CONFIG+=qml_debug
TEMPLATE = app
LIBS += -L/home/user/usrfs/lib -lilmCommon -lilmClient -lilmControl

SOURCES += main.cpp \
    dbusif.cpp \
    wheelareaplugin.cpp \
    lm_control.cpp
unix {
        CONFIG += link_pkgconfig
        PKGCONFIG += dbus-1
}

INCLUDEPATH += $$PWD/../../../bin/hmi/qml
DEPENDPATH += $$PWD/../../../bin/hmi/qml

HEADERS += \
    dbusif.h \
    dbusifsignal.h \
    wheelarea.h \
    lm_control.h
