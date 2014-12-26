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
import QtQuick.Layouts 1.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.calendar 2.0 as PlasmaCalendar

Item {
    property color textColor: PlasmaCore.ColorScope.textColor
    property int style: Text.Normal
    property color styleColor: Qt.rgba(0, 0, 0, 0)
    property var timeDataSource
    property string timeFormat

    id: root
    width: mainLayout.implicitWidth
    height: mainLayout.implicitHeight

    ColumnLayout {
        id: mainLayout

        PlasmaComponents.Label {
            text: Qt.formatTime(timeDataSource.data["Local"]["DateTime"], timeFormat)
            font.pointSize: theme.defaultFont.pointSize * 2
            color: root.textColor
            style: root.style
            styleColor: root.styleColor

            Layout.alignment: Qt.AlignCenter
        }

        PlasmaComponents.Label {
            text: Qt.formatDate(timeDataSource.data["Local"]["DateTime"], Locale.LongFormat)
            font.pointSize: theme.defaultFont.pointSize
            color: root.textColor
            style: root.style
            styleColor: root.styleColor

            Layout.alignment: Qt.AlignCenter
        }
    }

    Component.onCompleted: {
        // Remove seconds from time format
        timeFormat = Qt.locale().timeFormat(Locale.ShortFormat).replace(/.ss?/i, "");
    }
}
