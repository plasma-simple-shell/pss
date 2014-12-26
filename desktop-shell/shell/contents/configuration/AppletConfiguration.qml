/*
 *  Copyright 2013 Marco Martin <mart@kde.org>
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  2.010-1301, USA.
 */

import QtQuick 2.0
import QtQuick.Dialogs 1.1
import QtQuick.Controls 1.0 as QtControls
import QtQuick.Layouts 1.0
import org.kde.plasma.configuration 2.0

Rectangle {
    property bool isContainment: false
    property ConfigModel globalConfigModel: globalAppletConfigModel

    id: root
    color: syspal.window
    width: units.gridUnit * 30
    height: units.gridUnit * 20

    ConfigModel {
        id: globalAppletConfigModel

        ConfigCategory {
            name: "Keyboard shortcuts"
            icon: "preferences-desktop-keyboard"
            source: "ConfigurationShortcuts.qml"
        }
    }

    SystemPalette {
        id: syspal
    }

    MessageDialog {
        id: messageDialog
        icon: StandardIcon.Warning
        property Item delegate
        title: i18nd("org.pss.shells.desktop", "Apply Settings")
        text: i18nd("org.pss.shells.desktop", "The settings of the current module have changed. Do you want to apply the changes or discard them?")
        standardButtons: StandardButton.Apply | StandardButton.Discard | StandardButton.Cancel
        onApply: {
            applyAction.trigger()
            delegate.openCategory()
        }
        onDiscard: {
            delegate.openCategory()
        }
    }

    ColumnLayout {
        property int implicitWidth: Math.max(contentRow.implicitWidth, buttonsRow.implicitWidth) + 8
        property int implicitHeight: contentRow.implicitHeight + buttonsRow.implicitHeight + 8

        id: mainColumn
        anchors {
            fill: parent
            margins: mainColumn.spacing //margins are hardcoded in QStyle we should match that here
        }

        RowLayout {
            id: contentRow
            anchors {
                left: parent.left
                right: parent.right
            }
            spacing: units.largeSpacing
            Layout.fillHeight: true
            Layout.preferredHeight: parent.height - buttonsRow.height

            QtControls.ScrollView {
                id: categoriesScroll
                frameVisible: true
                Layout.fillHeight: true
                visible: (configDialog.configModel ? configDialog.configModel.count : 0) + globalConfigModel.count > 1
                width: visible ? units.gridUnit * 7 : 0
                implicitWidth: width
                Flickable {
                    id: categoriesView
                    contentWidth: parent.width
                    contentHeight: categories.height
                    anchors.fill: parent

                    property Item currentItem: categoriesColumn.children[1]

                    Item {
                        id: categories
                        width: parent.width
                        height: categoriesColumn.height

                        Item {
                            width: parent.width
                            height: categoriesView.currentItem.height
                            y: categoriesView.currentItem.y
                            Rectangle {
                                color: syspal.highlight
                                radius: 3
                                anchors {
                                    fill: parent
                                    margins: 2
                                }
                            }
                            Behavior on y {
                                NumberAnimation {
                                    duration: units.longDuration
                                    easing.type: "InOutQuad"
                                }
                            }
                        }
                        Column {
                            id: categoriesColumn
                            width: parent.width
                            Repeater {
                                model: root.isContainment ? globalConfigModel : undefined
                                delegate: ConfigCategoryDelegate {}
                            }
                            Repeater {
                                model: configDialog.configModel
                                delegate: ConfigCategoryDelegate {}
                            }
                            Repeater {
                                model: !root.isContainment ? globalConfigModel : undefined
                                delegate: ConfigCategoryDelegate {}
                            }
                        }
                    }
                }
            }
            QtControls.ScrollView {
                id: scroll
                Layout.fillHeight: true
                Layout.fillWidth: true
                Column {
                    width: scroll.viewport.width
                    spacing: units.largeSpacing / 2
                    QtControls.Label {
                        id: pageTitle
                        anchors {
                            left: parent.left
                            right: parent.right
                        }
                        font.pointSize: theme.defaultFont.pointSize*2
                        font.weight: Font.Light
                        text: main.title
                    }

                    QtControls.StackView {
                        property bool invertAnimations: false
                        property string title: ""

                        id: main
                        anchors {
                            left: parent.left
                        }
                        height: Math.max((scroll.height - pageTitle.height - parent.spacing), (main.currentItem  ? (main.currentItem.implicitHeight ? main.currentItem.implicitHeight : main.currentItem.childrenRect.height) : 0))
                        width: scroll.viewport.width
                        clip: true
                        property string sourceFile

                        onSourceFileChanged: {
                            //print("Source file changed in flickable" + sourceFile);
                            replace(Qt.resolvedUrl(sourceFile));
                            for (var prop in currentItem) {
                                if (prop.indexOf("cfg_") === 0 && prop.indexOf("Changed") > 0)
                                    currentItem[prop].connect(root.settingValueChanged)
                            }
                            if (currentItem["configurationChanged"])
                                currentItem["configurationChanged"].connect(root.settingValueChanged)
                            applyButton.enabled = false;
                            /*
                                * This is not needed on a desktop shell that has ok/apply/cancel buttons, i'll leave it here only for future reference until we have a prototype for the active shell.
                                * root.pageChanged will start a timer, that in turn will call saveConfig() when triggered

                            for (var prop in currentItem) {
                                if (prop.indexOf("cfg_") === 0) {
                                    currentItem[prop+"Changed"].connect(root.pageChanged)
                                }
                            }*/
                        }

                        delegate: QtControls.StackViewDelegate {
                            function transitionFinished(properties)
                            {
                                properties.exitItem.opacity = 1
                            }

                            pushTransition: QtControls.StackViewTransition {
                                PropertyAnimation {
                                    target: enterItem
                                    property: "opacity"
                                    from: 0
                                    to: 1
                                    duration: units.longDuration
                                    easing.type: Easing.InOutQuad
                                }
                                PropertyAnimation {
                                    target: enterItem
                                    property: "x"
                                    from: main.invertAnimations ? -target.width/3: target.width/3
                                    to: 0
                                    duration: units.longDuration
                                    easing.type: Easing.InOutQuad
                                }
                                PropertyAnimation {
                                    target: exitItem
                                    property: "opacity"
                                    from: 1
                                    to: 0
                                    duration: units.longDuration
                                    easing.type: Easing.InOutQuad
                                }
                                PropertyAnimation {
                                    target: exitItem
                                    property: "x"
                                    from: 0
                                    to: main.invertAnimations ? target.width/3 : -target.width/3
                                    duration: units.longDuration
                                    easing.type: Easing.InOutQuad
                                }
                            }
                        }
                    }
                }
            }
        }

        QtControls.Action {
            id: acceptAction
            onTriggered: {
                applyAction.trigger();
                configDialog.close();
            }
            shortcut: "Return"
        }

        QtControls.Action {
            id: applyAction
            onTriggered: {
                if (main.currentItem.saveConfig !== undefined) {
                    main.currentItem.saveConfig();
                } else {
                    root.saveConfig();
                }
            }
        }

        QtControls.Action {
            id: cancelAction
            onTriggered: configDialog.close();
            shortcut: "Escape"
        }

        RowLayout {
            id: buttonsRow

            QtControls.Button {
                iconName: "dialog-cancel"
                text: i18nd("org.pss.shells.desktop", "Cancel")
                onClicked: cancelAction.trigger()
            }

            QtControls.Button {
                id: applyButton
                enabled: false
                iconName: "dialog-ok-apply"
                text: i18nd("org.pss.shells.desktop", "Apply")
                onClicked: applyAction.trigger()
            }

            QtControls.Button {
                iconName: "dialog-ok"
                text: i18nd("org.pss.shells.desktop", "Ok")
                onClicked: acceptAction.trigger()
            }

            Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
        }
    }

    Layout.minimumWidth: units.gridUnit * 20
    Layout.minimumHeight: units.gridUnit * 10

    Component.onCompleted: {
        if (!isContainment && configDialog.configModel && configDialog.configModel.count > 0) {
            main.sourceFile = configDialog.configModel.get(0).source
            main.title = configDialog.configModel.get(0).name
        } else {
            main.sourceFile = globalConfigModel.get(0).source
            main.title = globalConfigModel.get(0).name
        }
        root.restoreConfig()
//         root.width = mainColumn.implicitWidth
//         root.height = mainColumn.implicitHeight
    }

    function saveConfig() {
        if (main.currentItem.saveConfig) {
            main.currentItem.saveConfig()
        } else {
            for (var key in plasmoid.configuration) {
                if (main.currentItem["cfg_" + key] !== undefined)
                    plasmoid.configuration[key] = main.currentItem["cfg_" + key]
            }
        }
    }

    function restoreConfig() {
        for (var key in plasmoid.configuration) {
            if (main.currentItem["cfg_" + key] !== undefined)
                main.currentItem["cfg_" + key] = plasmoid.configuration[key]
        }
    }

    function configurationHasChanged() {
        for (var key in plasmoid.configuration) {
            if (main.currentItem["cfg_" + key] !== undefined) {
                // for objects == doesn't work
                if (typeof plasmoid.configuration[key] == "object") {
                    for (var i in plasmoid.configuration[key]) {
                        if (plasmoid.configuration[key][i] != main.currentItem["cfg_" + key][i])
                            return true;
                    }
                    return false;
                } else if (main.currentItem["cfg_" + key] != plasmoid.configuration[key]) {
                    return true;
                }
            }
        }
        return false;
    }

    function settingValueChanged() {
        applyButton.enabled = true;
    }
}
