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

import QtQuick 2.1
import QtQuick.Controls 1.1
import PSS.Components 1.0 as Components
import org.kde.plasma.core 2.0 as PlasmaCore

Item {
    state: "normal"
    states: [
        State {
            name: "normal"
            when: notificationsApplet.totalCount == 0
        },
        State {
            name: "notifications"
            when: notificationsApplet.totalCount > 0
        }
    ]
    transitions: [
        Transition {
            to: "normal"

            ParallelAnimation {
                NumberAnimation { target: icon; property: "opacity"; to: 1.0; easing.type: Easing.InQuad; duration: units.longDuration }
                NumberAnimation { target: badge; property: "opacity"; to: 0.0; easing.type: Easing.OutQuad; duration: units.longDuration }
            }
        },
        Transition {
            to: "notifications"

            ParallelAnimation {
                NumberAnimation { target: badge; property: "opacity"; to: 1.0; easing.type: Easing.InQuad; duration: units.longDuration }
                NumberAnimation { target: icon; property: "opacity"; to: 0.0; easing.type: Easing.OutQuad; duration: units.longDuration }
            }
        }
    ]

    Components.Icon {
        id: icon
        anchors.centerIn: parent
        iconName: "dialog-information-symbolic"
        color: PlasmaCore.ColorScope.textColor
        width: Math.min(parent.width, parent.height) - units.largeSpacing
        height: width
    }

    NotificationBadge {
        id: badge
        anchors.centerIn: parent
        text: notificationsApplet.totalCount
        width: Math.min(parent.width, parent.height) - units.largeSpacing
        height: width
    }

    BusyIndicator {
        anchors.fill: parent
        running: visible
        visible: jobs ? jobs.count > 0 : false
    }

    MouseArea {
        property bool wasExpanded: false

        anchors.fill: parent
        onPressed: wasExpanded = plasmoid.expanded
        onClicked: plasmoid.expanded = !wasExpanded
    }

    Component.onCompleted: badge.opacity = 0.0
}
