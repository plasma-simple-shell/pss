/****************************************************************************
 * This file is part of Plasma Simple Shell.
 *
 * Copyright (C) 2014 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
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

import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import PSS.Shell.Controls 1.0 as Controls
import org.kde.plasma.core 2.0 as PlasmaCore

Item {
    id: root
    implicitWidth: mainLayout.implicitWidth
    implicitHeight: mainLayout.implicitHeight

    ExclusiveGroup {
        id: positionGroup
    }

    ExclusiveGroup {
        id: sizeGroup
    }

    ExclusiveGroup {
        id: alignmentGroup
    }

    ExclusiveGroup {
        id: visibilityGroup
    }

    GridLayout {
        id: mainLayout
        rowSpacing: units.smallSpacing
        columnSpacing: units.smallSpacing
        rows: 2
        columns: 4
        flow: plasmoid.formFactor == PlasmaCore.Types.Horizontal ? GridLayout.TopToBottom : GridLayout.LeftToRight

        Controls.GroupBox {
            title: i18nd("org.pss.shells.desktop", "Position")
            flat: true

            RowLayout {
                anchors.fill: parent
                spacing: units.smallSpacing

                Controls.ToolButton {
                    text: i18nd("org.pss.shells.desktop", "Left")
                    iconName: "align-horizontal-left"
                    iconSize: units.iconSizes.small
                    exclusiveGroup: positionGroup
                    checkable: true
                    checked: panel.location === PlasmaCore.Types.LeftEdge
                    onClicked: panel.location = PlasmaCore.Types.LeftEdge
                }

                Controls.ToolButton {
                    text: i18nd("org.pss.shells.desktop", "Top")
                    iconName: "align-vertical-top"
                    iconSize: units.iconSizes.small
                    exclusiveGroup: positionGroup
                    checkable: true
                    checked: panel.location === PlasmaCore.Types.TopEdge
                    onClicked: panel.location = PlasmaCore.Types.TopEdge
                }

                Controls.ToolButton {
                    text: i18nd("org.pss.shells.desktop", "Right")
                    iconName: "align-horizontal-right"
                    iconSize: units.iconSizes.small
                    exclusiveGroup: positionGroup
                    checkable: true
                    checked: panel.location === PlasmaCore.Types.RightEdge
                    onClicked: panel.location = PlasmaCore.Types.RightEdge
                }

                Controls.ToolButton {
                    text: i18nd("org.pss.shells.desktop", "Bottom")
                    iconName: "align-vertical-bottom"
                    iconSize: units.iconSizes.small
                    exclusiveGroup: positionGroup
                    checkable: true
                    checked: panel.location === PlasmaCore.Types.BottomEdge
                    onClicked: panel.location = PlasmaCore.Types.BottomEdge
                }
            }
        }

        Controls.GroupBox {
            title: i18nd("org.pss.shells.desktop", "Visibility")
            flat: true

            RowLayout {
                anchors.fill: parent
                spacing: units.smallSpacing

                Controls.ToolButton {
                    text: i18nd("org.pss.shells.desktop", "Always Visible")
                    exclusiveGroup: visibilityGroup
                    checkable: true
                    checked: configDialog.visibilityMode == 0
                    onClicked: configDialog.visibilityMode = 0
                }

                Controls.ToolButton {
                    text: i18nd("org.pss.shells.desktop", "Auto Hide")
                    exclusiveGroup: visibilityGroup
                    checkable: true
                    checked: configDialog.visibilityMode == 1
                    onClicked: configDialog.visibilityMode = 1
                }

                Controls.ToolButton {
                    text: i18nd("org.pss.shells.desktop", "Windows Can Cover")
                    exclusiveGroup: visibilityGroup
                    checkable: true
                    checked: configDialog.visibilityMode == 2
                    onClicked: configDialog.visibilityMode = 2
                }

                Controls.ToolButton {
                    text: i18nd("org.pss.shells.desktop", "Windows Go Below")
                    exclusiveGroup: visibilityGroup
                    checkable: true
                    checked: configDialog.visibilityMode == 3
                    onClicked: configDialog.visibilityMode = 3
                }
            }

            Layout.columnSpan: 4
        }

        Controls.GroupBox {
            title: i18nd("org.pss.shells.desktop", "Alignment")
            flat: true

            RowLayout {
                anchors.fill: parent
                spacing: units.smallSpacing

                Controls.ToolButton {
                    text: i18nd("org.pss.shells.desktop", "Left")
                    iconName: "align-horizontal-left"
                    iconSize: units.iconSizes.small
                    exclusiveGroup: alignmentGroup
                    enabled: !panel.maximized
                    checkable: true
                    checked: panel.alignment == Qt.AlignLeft
                    onClicked: panel.alignment = Qt.AlignLeft
                }

                Controls.ToolButton {
                    text: i18nd("org.pss.shells.desktop", "Center")
                    iconName: "align-horizontal-center"
                    iconSize: units.iconSizes.small
                    exclusiveGroup: alignmentGroup
                    enabled: !panel.maximized
                    checkable: true
                    checked: panel.alignment == Qt.AlignCenter
                    onClicked: panel.alignment = Qt.AlignCenter
                }

                Controls.ToolButton {
                    text: i18nd("org.pss.shells.desktop", "Right")
                    iconName: "align-horizontal-right"
                    iconSize: units.iconSizes.small
                    exclusiveGroup: alignmentGroup
                    enabled: !panel.maximized
                    checkable: true
                    checked: panel.alignment == Qt.AlignRight
                    onClicked: panel.alignment = Qt.AlignRight
                }
            }
        }

        Controls.GroupBox {
            title: i18nd("org.pss.shells.desktop", "Size")
            flat: true

            RowLayout {
                anchors.fill: parent
                spacing: units.smallSpacing

                // Burger King sizes (small is medium for other people) to
                // to account for borders and such

                Controls.ToolButton {
                    text: i18nd("org.pss.shells.desktop", "Small")
                    iconSize: units.iconSizes.small
                    exclusiveGroup: sizeGroup
                    checkable: true
                    checked: panel.thickness == units.iconSizes.medium
                    onClicked: panel.thickness = units.iconSizes.medium
                }

                Controls.ToolButton {
                    text: i18nd("org.pss.shells.desktop", "Medium")
                    iconSize: units.iconSizes.small
                    exclusiveGroup: sizeGroup
                    checkable: true
                    checked: panel.thickness == units.iconSizes.large
                    onClicked: panel.thickness = units.iconSizes.large
                }

                Controls.ToolButton {
                    text: i18nd("org.pss.shells.desktop", "Large")
                    iconSize: units.iconSizes.small
                    exclusiveGroup: sizeGroup
                    checkable: true
                    checked: panel.thickness == units.iconSizes.huge
                    onClicked: panel.thickness = units.iconSizes.huge
                }

                Controls.ToolButton {
                    text: i18nd("org.pss.shells.desktop", "Huge")
                    iconSize: units.iconSizes.small
                    exclusiveGroup: sizeGroup
                    checkable: true
                    checked: panel.thickness == units.iconSizes.enormous
                    onClicked: panel.thickness = units.iconSizes.enormous
                }
            }
        }

        Controls.GroupBox {
            title: i18nd("org.pss.shells.desktop", "Actions")
            flat: true

            RowLayout {
                anchors.fill: parent
                spacing: units.smallSpacing

                Controls.ToolButton {
                    iconName: "list-add-symbolic"
                    iconSize: units.iconSizes.small
                    text: i18nd("org.pss.shells.desktop", "Add Widgets...")
                    tooltip: i18nd("org.pss.shells.desktop", "Add Widgets...")
                    onClicked: {
                        configDialog.close();
                        configDialog.showAddWidgetDialog();
                    }
                }

                Controls.ToolButton {
                    iconName: "distribute-horizontal-x"
                    iconSize: units.iconSizes.small
                    text: i18nd("org.pss.shells.desktop", "Add Spacer")
                    tooltip: i18nd("org.pss.shells.desktop", "Add Spacer")
                    onClicked: configDialog.addPanelSpacer()
                }

                Controls.ToolButton {
                    iconName: "zoom-fit-best-symbolic"
                    iconSize: units.iconSizes.small
                    text: i18nd("org.pss.shells.desktop", "Maximize Panel")
                    tooltip: i18nd("org.pss.shells.desktop", "Maximize Panel")
                    onClicked: panel.maximize()
                }

                Controls.ToolButton {
                    iconName: "changes-prevent-symbolic"
                    iconSize: units.iconSizes.small
                    text: i18nd("org.pss.shells.desktop", "Lock Widgets")
                    tooltip: i18nd("org.pss.shells.desktop", "Lock Widgets")
                    onClicked: {
                        plasmoid.action("lock widgets").trigger();
                        configDialog.close();
                    }
                }

                Controls.ToolButton {
                    iconName: "list-remove-symbolic"
                    iconSize: units.iconSizes.small
                    text: i18nd("org.pss.shells.desktop", "Remove Panel")
                    tooltip: i18nd("org.pss.shells.desktop", "Remove Panel")
                    onClicked: plasmoid.action("remove").trigger()
                }
            }
        }
    }
}
