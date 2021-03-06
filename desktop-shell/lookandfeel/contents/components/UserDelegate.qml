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
import org.kde.plasma.core 2.0 as PlasmaCore
import PSS.Components 1.0

PlasmaCore.ColorScope {
    property string userName
    property string name
    property string iconSource
    property alias faceSize: icon.width
    readonly property bool selected: ListView.isCurrentItem

    signal hovered()
    signal clicked()

    id: root
    opacity: selected ? 1.0 : 0.625
    onIconSourceChanged: {
        // Defaults to avatar-default-symbolic
        if (iconSource == "" || iconSource.indexOf("default.face.icon") != -1) {
            icon.iconSource = "";
            icon.iconName = "avatar-default-symbolic";
            icon.color = PlasmaCore.ColorScope.textColor;
            return;
        }

        // Configure icon for pictures or icon names
        if (iconSource.indexOf("/") == 0) {
            icon.iconSource = iconSource;
            icon.iconName = "";
            icon.color = Qt.rgba(0, 0, 0, 0);
        } else {
            icon.iconSource = "";
            icon.iconName = iconSource;
            icon.color = iconSource.indexOf("-symbolic") == -1
                ? Qt.rgba(0, 0, 0, 0)
                : PlasmaCore.ColorScope.textColor;
        }
    }

    Behavior on opacity {
        NumberAnimation {
            duration: 250
            easing.type: Easing.InOutQuad
        }
    }

    PlasmaCore.FrameSvgItem {
        id: container
        anchors.fill: parent
        imagePath: "widgets/background"

        Icon {
            id: icon
            anchors.centerIn: parent
            height: width
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: root.hovered()
        onClicked: root.clicked()
    }
}
