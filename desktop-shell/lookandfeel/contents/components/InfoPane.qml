/****************************************************************************
 * This file is part of Plasma Simple Shell.
 *
 * Copyright (C) 2014 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
 * Copyright (C) 2014 David Edmundson <davidedmundson@kde.org>
 * Copyright (C) 2014 Aleix Pol Gonzalez <aleixpol@blue-systems.com>
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
import org.kde.plasma.core 2.0 as PlasmaCore

ColumnLayout {
    property int alignment: Qt.AlignRight

    id: root

    PlasmaCore.DataSource {
        id: timeSource
        engine: "time"
        connectedSources: ["Local"]
        interval: 1000
    }

    PSSLabel {
        text: Qt.formatTime(timeSource.data["Local"]["DateTime"], "hh:mm")
        font.family: "Raleway"
        font.weight: Font.Bold
        font.pointSize: theme.defaultFont.pointSize * 4

        Layout.alignment: root.alignment
    }

    PSSLabel {
        text: Qt.formatDate(timeSource.data["Local"]["DateTime"], Locale.LongFormat)
        font.family: "Raleway"
        font.weight: Font.DemiBold
        font.pointSize: theme.defaultFont.pointSize * 2

        Layout.alignment: root.alignment
    }

    BatteryInfo {
        id: batteryInfo

        Layout.alignment: root.alignment
    }
}
