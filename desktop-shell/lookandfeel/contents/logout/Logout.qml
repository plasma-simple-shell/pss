/****************************************************************************
 * This file is part of Plasma Simple Shell.
 *
 * Copyright (C) 2013-2014 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
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
import QtGraphicalEffects 1.0
import org.kde.plasma.core 2.0 as PlasmaCore
import "../components"

Item {
    property string mode: "poweroff"

    signal logoutRequested()
    signal haltRequested()
    signal suspendRequested(int spdMethod)
    signal rebootRequested()
    signal rebootRequested2(int opt)
    signal cancelRequested()
    signal lockScreenRequested()

    id: root
    width: screenGeometry.width
    height: screenGeometry.height

    // TODO: Replace with a picture selected by the user
    Image {
        id: background
        anchors.fill: parent
        source: theme.wallpaperPathForSize(width, height)
        visible: false
    }

    FastBlur {
        id: fastBlurEffect
        anchors.fill: parent
        source: background
        radius: 32
    }

    PlasmaCore.ColorScope {
        anchors.fill: parent
        colorGroup: PlasmaCore.Theme.ComplementaryColorGroup

        LogoutScreen {
            anchors.fill: parent
            mode: {
                switch (sdtype) {
                case ShutdownType.ShutdownTypeNone:
                    return "logout";
                case ShutdownType.ShutdownTypeHalt:
                    return "poweroff";
                case ShutdownType.ShutdownTypeReboot:
                    return maysd ? "restart" : "logout";
                default:
                    return "logout";
                }
            }
            canLogOut: true
            canPowerOff: maysd && choose
            canRestart: maysd && choose
            onCancel: root.cancelRequested()
            onLogOutRequested: root.logoutRequested()
            onPowerOffRequested: root.haltRequested()
            onRestartRequested: root.rebootRequested()
        }
    }
}
