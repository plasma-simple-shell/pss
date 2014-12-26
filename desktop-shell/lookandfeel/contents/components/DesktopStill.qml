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
import QtQuick.Controls 1.0
import QtGraphicalEffects 1.0
import PSS.Shell.Controls 1.0 as Controls
import org.kde.plasma.core 2.0 as PlasmaCore

Item {
    property int stage: 0

    id: root
    onStageChanged: {
        if (stage == 6)
            desaturate.desaturation = 0.4;
    }

    // TODO: Load a copy of user selecter wallpaper with blur
    // and remove the FastBlur here
    Image {
        id: image
        anchors.fill: parent
        // XXX: Looks like at this stage this is not available,
        // neither from sddm nor ksplashqml
        //source: theme.wallpaperPathForSize(width, height)
        source: "artwork/background.png"
        sourceSize.width: width
        sourceSize.height: height
        smooth: true
        visible: false
    }

    Desaturate {
        id: desaturate
        anchors.fill: parent
        source: image
        desaturation: 1.0

        Behavior on desaturation {
            NumberAnimation {
                easing.type: Easing.InOutQuad
                duration: root.stage < 6 ? units.longDuration : units.longDuration * 4
            }
        }
    }

    Controls.ProgressBar {
        anchors.centerIn: parent
        width: units.largeSpacing * 14
        minimumValue: 0
        maximumValue: 6
        value: root.stage
    }

    Timer {
        id: timer
        running: root.stage < 6
        interval: 500
        onTriggered: desaturate.desaturation -= 0.1
    }
}
