/****************************************************************************
 * This file is part of Plasma Simple Shell.
 *
 * Copyright (C) 2014 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
 * Copyright (C) 2011 Davide Bettio <davide.bettio@kdemail.net>
 * Copyright (C) 2011 Marco Martin <mart@kde.org>
 *
 * Author(s):
 *    Pier Luigi Fiorini
 *
 * $BEGIN_LICENSE:LGPL2.1+$
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 2.1 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * $END_LICENSE$
 ***************************************************************************/

import QtQuick 2.0
import QtQuick.Layouts 1.1
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.kquickcontrolsaddons 2.0 as KQuickControls

KQuickControls.MouseEventListener {
    id: notificationsApplet

    property bool wasVisible: false

    property real globalProgress: 0

    property Item notifications: panel.notifications
    property Item jobs: panel.jobs

    // Total count sums notifications and jobs
    property int totalCount: (notifications ? notifications.count : 0) + (jobs ? jobs.count : 0)

    property Item notificationIcon

    // Never switch from compact to full representation
    Plasmoid.switchWidth: 10000
    Plasmoid.switchHeight: 10000

    Plasmoid.compactRepresentation: Component {
        NotificationIcon {
            id: notificationIcon
            Component.onCompleted: notificationsApplet.notificationIcon = notificationIcon
        }
    }

    FullRepresentation {
        id: panel
        width: units.gridUnit * 24 + (units.smallSpacing * 2)
    }
}
