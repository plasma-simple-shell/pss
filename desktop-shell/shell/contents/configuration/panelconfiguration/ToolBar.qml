/****************************************************************************
 * This file is part of Plasma Simple Shell.
 *
 * Copyright (C) 2014 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
 * Copyright (C) 2013 Marco Martin <mart@kde.org>
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
import QtQuick.Layouts 1.0
import PSS.Shell.Controls 1.0 as Controls
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.configuration 2.0

Item {
    id: root
    state: parent.state
    implicitWidth: units.gridUnit * 10
    implicitHeight: row.implicitHeight + units.largeSpacing

    PanelOptions {
        id: row
        anchors {
            left: parent.left
            top: parent.top
            margins: units.smallSpacing
        }
    }

    GridLayout {
        id: buttonsLayout
        anchors.margins: rowSpacing
        rows: 1
        columns: 1
        rowSpacing: units.smallSpacing
        columnSpacing: units.smallSpacing
        flow: plasmoid.formFactor == PlasmaCore.Types.Horizontal ? GridLayout.TopToBottom : GridLayout.LeftToRight

        Controls.ToolButton {
            iconName: "window-close-symbolic"
            iconSize: units.iconSizes.small
            tooltip: i18nd("org.pss.shells.desktop", "Close")
            flat: true
            onClicked: configDialog.close()
        }
    }
    states: [
        State {
            name: "TopEdge"
            PropertyChanges {
                target: root
                height: root.implicitHeight
            }
            AnchorChanges {
                target: root
                anchors {
                    top: undefined
                    bottom: root.parent.bottom
                    left: root.parent.left
                    right: root.parent.right
                }
            }
            AnchorChanges {
                target: buttonsLayout
                anchors {
                    verticalCenter: root.verticalCenter
                    top: undefined
                    bottom: undefined
                    left: undefined
                    right: root.right
                }
            }
            PropertyChanges {
                target: buttonsLayout
                width: buttonsLayout.implicitWidth
            }
        },
        State {
            name: "BottomEdge"
            PropertyChanges {
                target: root
                height: root.implicitHeight
            }
            AnchorChanges {
                target: root
                anchors {
                    top: root.parent.top
                    bottom: undefined
                    left: root.parent.left
                    right: root.parent.right
                }
            }
            AnchorChanges {
                target: buttonsLayout
                anchors {
                    verticalCenter: root.verticalCenter
                    top: undefined
                    bottom: undefined
                    left: undefined
                    right: root.right
                }
            }
            PropertyChanges {
                target: buttonsLayout
                width: buttonsLayout.implicitWidth
            }
        },
        State {
            name: "LeftEdge"
            PropertyChanges {
                target: root
                width: root.implicitWidth
            }
            AnchorChanges {
                target: root
                anchors {
                    top: root.parent.top
                    bottom: root.parent.bottom
                    left: undefined
                    right: root.parent.right
                }
            }
            AnchorChanges {
                target: buttonsLayout
                anchors {
                    verticalCenter: undefined
                    top: undefined
                    bottom: root.bottom
                    left: root.left
                    right: root.right
                }
            }
        },
        State {
            name: "RightEdge"
            PropertyChanges {
                target: root
                width: root.implicitWidth
            }
            AnchorChanges {
                target: root
                anchors {
                    top: root.parent.top
                    bottom: root.parent.bottom
                    left: root.parent.left
                    right: undefined
                }
            }
            AnchorChanges {
                target: buttonsLayout
                anchors {
                    verticalCenter: undefined
                    top: undefined
                    bottom: root.bottom
                    left: root.left
                    right: root.right
                }
            }
        }
    ]
}
