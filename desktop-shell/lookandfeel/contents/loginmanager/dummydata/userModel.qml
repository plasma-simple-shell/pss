import QtQuick 2.0

ListModel {
    property int lastIndex: 1

    ListElement {
        name: "plfiorini"
        realName: "Pier Luigi Fiorini"
        icon: "/usr/share/pixmaps/faces/grapes.jpg"
        homeDir: "/home/plfiorini"
    }
    ListElement {
        name: "david"
        realName: "David Edmundson"
        icon: "/home/david/.face.icon"
        homeDir: "/home/david"
    }
    ListElement {
        name: "afiestas"
        realName: "Alex Fiestas"
        icon: ""
        homeDir: ""
    }
    ListElement {
        name: "apol"
        realName: "Aleix Pol"
        icon: ""
        homeDir: ""
    }
    ListElement {
        name: "shadeslayer"
        realName: "Rohan Garg"
        icon: ""
        homeDir:""
    }
}
