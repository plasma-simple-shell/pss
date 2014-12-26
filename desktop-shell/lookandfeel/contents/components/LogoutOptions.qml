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
import PSS.Shell.Controls 1.0 as Controls

Item {
    property bool canLogOut
    property bool canPowerOff
    property bool canRestart
    property string mode: "poweroff"

    id: root
    width: row.implicitWidth
    height: row.implicitHeight
    visible: canLogOut || canPowerOff || canRestart

    ExclusiveGroup {
        id: group
    }

    Row {
        id: row
        spacing: units.smallSpacing

        Controls.ToolButton {
            id: logoutButton
            action: logoutAction
            exclusiveGroup: group
            iconName: "system-log-out-symbolic"
            iconSize: units.iconSizes.smallMedium
            checkable: true
            checked: root.mode == "logout"
            visible: root.canLogOut
            onClicked: root.mode = "logout"
        }

        Controls.ToolButton {
            id: poweroffButton
            action: poweroffAction
            exclusiveGroup: group
            iconName: "system-shutdown-symbolic"
            iconSize: units.iconSizes.smallMedium
            checkable: true
            checked: root.mode == "poweroff"
            visible: root.canPowerOff
            onClicked: root.mode = "poweroff"
        }

        Controls.ToolButton {
            id: restartButton
            action: restartAction
            exclusiveGroup: group
            iconName: "system-reboot-symbolic"
            iconSize: units.iconSizes.smallMedium
            checkable: true
            checked: root.mode == "restart"
            visible: root.canRestart
            onClicked: root.mode = "restart"
        }
    }
}
