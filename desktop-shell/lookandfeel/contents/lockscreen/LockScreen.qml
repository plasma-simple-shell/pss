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

Item {
    property bool shutdownSupported: true

    signal shutdown()

    id: root

    LockShield {
        id: lockShield
        x: 0
        y: 0
        z: 1000
        width: parent.width
        height: parent.height
        onYChanged: y < 0 ? timer.restart() : timer.stop()
        onSlideRequested: y = -parent.height

        Behavior on y {
            NumberAnimation {
                easing.type: Easing.InQuad
                duration: 500
            }
        }

        Keys.onPressed: timer.stop()

        Timer {
            id: timer
            running: false
            interval: 5 * 60 * 1000
            onTriggered: lockShield.y = 0
        }
    }

    Greeter {
        id: greeter
        anchors.fill: parent
        powerOffVisible: root.shutdownSupported
        onPowerOffRequested: root.shutdown()
    }
}
