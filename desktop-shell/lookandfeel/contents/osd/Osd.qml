/****************************************************************************
 * This file is part of Plasma Simple Shell.
 *
 * Copyright (C) 2013-2014 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
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
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtra

PlasmaCore.Dialog {
    // OSD Timeout in msecs - how long it will stay on the screen
    property int timeout: 2500

    // This is either a text or a number, if showingProgress is set to true,
    // the number will be used as a value for the progress bar
    property var osdValue

    // Icon name to display
    property string icon

    // Set to true if the value is meant for progress bar,
    // false for displaying the value as normal text
    property bool showingProgress: false

    id: root
    location: PlasmaCore.Types.Floating
    type: PlasmaCore.Dialog.Notification
    onVisibleChanged: {
        // Prevent fading from old values when OSD shows up
        if (!visible) {
            root.icon = "";
            root.osdValue = 0;
        }
    }
    mainItem: Item {
        width: units.gridUnit * 15
        height: width

        ColumnLayout {
            anchors.centerIn: parent

            // TODO: We want XDG standard icons here
            PlasmaCore.IconItem {
                id: icon
                source: root.icon
                width: parent.height - progressBar.height - ((units.largeSpacing/2) * 3)
                height: width
            }

            PlasmaExtra.Heading {
                text: root.showingProgress ? "" : (root.osdValue ? root.osdValue : "")
                horizontalAlignment: Text.AlignHCenter
                visible: !root.showingProgress
            }

            ProgressBar {
                id: progressBar
                minimumValue: 0
                maximumValue: 00
                value: visible ? root.osdValue : 0
                visible: root.showingProgress
            }
        }
    }
}
