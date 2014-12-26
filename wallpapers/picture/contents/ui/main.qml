/****************************************************************************
 * This file is part of Plasma Simple Shell.
 *
 * Copyright (C) 2012-2014 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
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
import PSS.Components 1.0
import org.kde.plasma.wallpapers.image 2.0 as Wallpaper

NoiseBackground {
    property string configuredImage: wallpaper.configuration.Image

    id: background
    color: wallpaper.configuration.Color
    onConfiguredImageChanged: imageWallpaper.addUrl(configuredImage)

    Behavior on color {
        ColorAnimation {
            duration: 400
            easing.type: Easing.OutQuad
        }
    }

    Wallpaper.Image {
        id: imageWallpaper
        renderingMode: Wallpaper.Image.SingleImage
        width: background.width
        height: background.height
    }

    SmoothFadeImage {
        property real aspectRatio: parent.width / parent.height

        id: image
        anchors.fill: parent
        source: imageWallpaper.wallpaperPath
        sourceSize.width: aspectRatio * 1024
        sourceSize.height: 1024
        smooth: true
        clip: fillMode === Image.PreserveAspectCrop
    }

    Component.onCompleted: imageWallpaper.addUrl(configuredImage)
}
