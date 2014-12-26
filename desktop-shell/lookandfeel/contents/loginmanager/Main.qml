/****************************************************************************
 * This file is part of Maui.
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

Item {
    id: container
    width: sddmTheme.width
    height: sddmTheme.height

    Connections {
        target: sddm
        onLoginSucceeded: sddmTheme.slideToPageIndex(2)
    }

    NoiseBackground {
        anchors.fill: parent
        color: "#272727"
        gradient: Gradient {
            GradientStop { position: 0; color: "#272727" }
            GradientStop { position: 1; color: "#2b2b2b" }
        }
    }

    Theme {
        property variant geometry: screenModel.geometry(screenModel.primary)

        id: sddmTheme
        usersModel: userModel
        x: geometry.x
        y: geometry.y
        width: geometry.width
        height: geometry.height
    }
}
