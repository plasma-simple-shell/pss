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
import PSS.Components 1.0

MouseArea {
    acceptedButtons: Qt.AllButtons
    width: layout.implicitWidth
    height: layout.implicitHeight

    SystemPalette {
        id: palette
    }

    RowLayout {
        id: layout
        spacing: units.smallSpacing

        Icon {
            iconName: "weather-clear-symbolic"
            color: palette.highlightedText
            width: units.iconSizes.small
            height: width

            Layout.alignment: Qt.AlignCenter
        }

        Clock {
            id: clock
            textColor: palette.highlightedText
            style: Text.Raised
            styleColor: palette.shadow
            timeDataSource: PlasmaCore.DataSource {
                engine: "time"
                connectedSources: ["Local"]
                interval: 30000
            }
        }

        PlasmaComponents.Label {
            color: palette.highlightedText
            style: Text.Raised
            styleColor: palette.shadow
            text: "UK"

            Layout.alignment: Qt.AlignCenter
        }
    }
}
