/****************************************************************************
 * This file is part of Plasma Simple Shell.
 *
 * Copyright (C) 2014 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
 * Copyright (C) 2011 Marco Martin <mart@kde.org>
 *
 * Author(s):
 *    Pier Luigi Fiorini
 *
 * $BEGIN_LICENSE:GPL2+$
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * $END_LICENSE$
 ***************************************************************************/

import QtQuick 2.2
import QtQuick.Window 2.1
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import PSS.Shell.Controls 1.0 as Controls
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.kquickcontrolsaddons 2.0
import org.kde.plasma.private.shell 2.0

Item {
    id: main
    width: minimumWidth
    height: 800//Screen.height

    // The +4 is for the gap and cross button
    property int minimumWidth: theme.mSize(heading.font).width * (heading.text.length + 6)
    property int minimumHeight: 800//width will be set by the dialog anyway

    property alias containment: widgetExplorer.containment

    // External drop events can cause a raise event causing us to lose focus and
    // therefore get deleted whilst we are still in a drag exec()
    // this is a clue to the owning dialog that hideOnWindowDeactivate should be deleted
    // See https://bugs.kde.org/show_bug.cgi?id=332733
    property bool preventWindowHide: false

    property Item getWidgetsButton
    property Item categoryButton

    signal closed()

    WidgetExplorer {
        id: widgetExplorer
        onShouldClose: main.closed()
    }

    PlasmaComponents.ModelContextMenu {
        id: categoriesDialog
        visualParent: main.categoryButton
        model: widgetExplorer.filterModel
        onClicked: {
            list.contentX = 0
            list.contentY = 0
            main.categoryButton.text = model.display
            widgetExplorer.widgetsModel.filterQuery = model.filterData
            widgetExplorer.widgetsModel.filterType = model.filterType
        }
        onStatusChanged: {
            if (status == PlasmaComponents.DialogStatus.Opening) {
                main.preventWindowHide = true;
            } else if (status == PlasmaComponents.DialogStatus.Closed) {
                main.preventWindowHide = false;
            }
        }
    }

    PlasmaComponents.ModelContextMenu {
        id: getWidgetsDialog
        visualParent: main.getWidgetsButton
        model: widgetExplorer.widgetsMenuActions
        onClicked: model.trigger()
        onStatusChanged: {
            if (status == PlasmaComponents.DialogStatus.Opening)
                main.preventWindowHide = true;
            else if (status == PlasmaComponents.DialogStatus.Closed)
                main.preventWindowHide = false;
        }
    }

    Controls.ToolButton {
        id: closeButton
        anchors {
            top: parent.top
            right: parent.right
        }
        iconName: "window-close-symbolic"
        iconSize: units.iconSizes.small
        flat: true
        onClicked: main.closed()
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: units.smallSpacing

        PlasmaExtras.Title {
            id: heading
            text: i18nd("org.pss.shells.desktop", "Widgets")
            elide: Text.ElideRight

            Layout.fillWidth: true
        }

        RowLayout {
            Controls.ToolButton {
                id: categoryButton
                iconName: "view-list-symbolic"
                iconSize: units.iconSizes.small
                onClicked: {
                    main.preventWindowHide = true;
                    categoriesDialog.open(0, categoryButton.height)
                }
            }

            Controls.ToolButton {
                id: getWidgetsButton
                iconName: "system-software-install-symbolic"
                iconSize: units.iconSizes.small
                onClicked: {
                    main.preventWindowHide = true;
                    getWidgetsDialog.open();
                }
            }

            Repeater {
                model: widgetExplorer.extraActions.length

                Controls.ToolButton {
                    iconName: widgetExplorer.extraActions[modelData].icon
                    text: widgetExplorer.extraActions[modelData].text
                    onClicked: widgetExplorer.extraActions[modelData].trigger()
                }
            }

            Controls.TextField {
                clearButtonShown: true
                placeholderText: i18nd("org.pss.shells.desktop", "Search...")
                focus: true
                onTextChanged: {
                    list.contentX = 0
                    list.contentY = 0
                    widgetExplorer.widgetsModel.searchTerm = text
                }

                Layout.fillWidth: true

                Component.onCompleted: forceActiveFocus()
            }

            Layout.fillWidth: true
        }

        Controls.ScrollView {
            ListView {
                property int delegateWidth: list.width
                property int delegateHeight: units.iconSizes.huge + backgroundHint.margins.top + backgroundHint.margins.bottom

                id: list
                snapMode: ListView.SnapToItem
                model: widgetExplorer.widgetsModel
                clip: true //TODO work out why this is this needed
                cacheBuffer: delegateHeight * 5 // keep 5 delegates either side
                delegate: AppletDelegate {}

                // Slide in to view from the left
                add: Transition {
                    NumberAnimation {
                        properties: "x"
                        from: -list.width
                        to: 0
                        duration: units.shortDuration * 3

                    }
                }

                // Slide out of view to the right
                remove: Transition {
                    NumberAnimation {
                        properties: "x"
                        to: list.width
                        duration: units.shortDuration * 3
                    }
                }

                // If we are adding other items into the view use the same animation as normal adding
                // this makes everything slide in together, if we make it move everything ends up weird
                addDisplaced: list.add

                // Moved due to filtering
                displaced: Transition {
                    NumberAnimation {
                        properties: "y"
                        duration: units.shortDuration * 3
                    }
                }
            }

            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }

    PlasmaCore.FrameSvgItem {
        id: backgroundHint
        imagePath: "widgets/viewitem"
        prefix: "normal"
        visible: false
    }

    Component.onCompleted: {
        main.getWidgetsButton = getWidgetsButton
        main.categoryButton = categoryButton
    }
}
