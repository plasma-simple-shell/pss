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
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.plasma.plasmoid 2.0

Controls.ScrollView {
    property alias jobs: jobs
    property alias notifications: notifications

    Flickable {
        id: popupFlickable
        contentWidth: width
        contentHeight: contentsColumn.height
        clip: true

        ColumnLayout {
            id: contentsColumn
            width: popupFlickable.width
            spacing: units.smallSpacing

            PlasmaExtras.Heading {
                level: 2
                text: i18nd("org.pss.notifications", "There are no notifications to read.")
                visible: notificationsApplet.totalCount == 0
            }

            Jobs {
                id: jobs

                Layout.fillWidth: true
            }

            Notifications {
                id: notifications

                Layout.fillWidth: true
            }
        }
    }
}
