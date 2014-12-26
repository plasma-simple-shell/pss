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
import org.kde.plasma.core 2.0 as PlasmaCore

Item {
    property alias iconName: iconButton.iconName
    property color color: PlasmaCore.ColorScope.backgroundColor
    property color textColor: PlasmaCore.ColorScope.textColor

    signal clicked()

    id: root
    width: units.iconSizes.large + units.smallSpacing * 2
    height: width

    Rectangle {
        id: rect
        anchors.fill: parent
        radius: height
        color: Qt.lighter(root.color, 0.5)
        opacity: 0.7
        border.color: Qt.rgba(root.color.r, root.color.g, root.color.b, 0.267)
        antialiasing: true
    }

    IconButton {
        id: iconButton
        anchors.centerIn: rect
        width: units.iconSizes.medium
        height: width
        color: root.textColor
        onClicked: root.clicked()
    }
}
