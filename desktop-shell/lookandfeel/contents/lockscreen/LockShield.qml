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
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import QtGraphicalEffects 1.0
import org.kde.plasma.core 2.0 as PlasmaCore
import "../components"

Item {
    signal slideRequested()

    id: root
    focus: true

    Keys.onEscapePressed: root.slideRequested()

    // TODO: Replace with a picture selected by the user
    Image {
        id: background
        anchors.fill: parent
        source: theme.wallpaperPathForSize(width, height)
        sourceSize.width: 1024
        sourceSize.height: 1024
        visible: !fastBlurEffect.visible
    }

    FastBlur {
        id: fastBlurEffect
        anchors.fill: parent
        source: background
        radius: 32
    }

    PlasmaCore.DataSource {
        id: timeSource
        engine: "time"
        connectedSources: ["Local"]
        interval: 1000
    }

    ColumnLayout {
        anchors {
            fill: parent
            margins: units.largeSpacing
        }
        spacing: units.smallSpacing

        Rectangle {
            id: container
            color: "#80000000"
            width: units.gridUnit * 12
            height: units.gridUnit * 12
            radius: width

            ColumnLayout {
                anchors.centerIn: parent

                PSSLabel {
                    id: timeLabel
                    text: Qt.formatTime(timeSource.data["Local"]["DateTime"], "hh:mm")
                    font.weight: Font.Bold
                    font.pointSize: dateLabel.font.pointSize * 4
                    color: "#f1f1f1"

                    Layout.alignment: Qt.AlignCenter
                }

                PSSLabel {
                    id: dateLabel
                    text: Qt.formatDate(timeSource.data["Local"]["DateTime"], Locale.LongFormat)
                    font.weight: Font.DemiBold
                    font.capitalization: Font.AllLowercase
                    color: "#f1f1f1"

                    Layout.alignment: Qt.AlignCenter
                }
            }

            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        }

        // TODO: Notifications here
        Item {
            Layout.fillHeight: true
        }

        CircularButton {
            iconName: "go-up-symbolic"
            color: "#80000000"
            textColor: "#f1f1f1"
            onClicked: root.slideRequested()

            Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
        }
    }
}
