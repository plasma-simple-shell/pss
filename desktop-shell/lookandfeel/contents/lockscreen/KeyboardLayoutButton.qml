/****************************************************************************
 * This file is part of Plasma Simple Shell.
 *
 * Copyright (C) 2014 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
 * Copyright (C) 2014 Daniel Vrátil <dvratil@redhat.com>
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

import QtQuick 2.1
import PSS.Shell.Controls 1.0 as Controls
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.kscreenlocker 1.0

Controls.ToolButton {
    activeFocusOnTab: true
    //iconName: "input-keyboard-symbolic"
    iconSize: units.iconSizes.small
    text: layout.currentLayout
    tooltip: i18ndc("org.pss.lookandfeel.desktop", "Button to change keyboard layout", "Change keyboard layout")
    visible: layout.layouts.length > 1
    onClicked: layout.nextLayout()

    KeyboardLayout {
        id: layout

        function nextLayout() {
            var layouts = layout.layouts;
            var index = layouts.indexOf(layout.currentLayout);
            if (index == (layouts.length - 1))
                index = -1;
            layout.currentLayout = layouts[index + 1];
        }
    }

    Accessible.name: i18ndc("org.pss.lookandfeel.desktop", "Button to change keyboard layout", "Switch layout")
}
