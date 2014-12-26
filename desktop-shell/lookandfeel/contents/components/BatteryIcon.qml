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

Item {
    property bool hasBattery
    property int percent
    property bool pluggedIn
    property string batteryType

    Row {
        Icon {
            id: icon
            iconName: {
                if (root.pluggedIn)
                    return "battery-ac-adapter";
                if (!root.hasBattery)
                    return "battery-missing-symbolic";

                if (root.percent == 100)
                    return "battery-full-symbolic";
                else if (root.percent >= 90)
                    return root.charging ? "battery-full-charging-symbolic" : "battery-full-charged-symbolic";
                else if (root.percent >= 80)
                    return root.charging ? "battery-good-charging-symbolic" : "battery-good-symbolic";
                else if (root.percent >= 40)
                    return root.charging ? "battery-low-charging-symbolic" : "battery-low-symbolic";
                else if (root.percent >= 20)
                    return root.charging ? "battery-caution-charging-symbolic" : "battery-caution-symbolic";
                return root.charging ? "battery-empty-charging-symbolic" : "battery-empty-symbolic";
            }
            color: PlasmaCore.ColorScope.textColor
        }

        Icon {
            id: otherIcon
            iconName: {
                switch (root.batteryType) {
                case "Mouse":
                    return "battery-mouse-100";
                case "Pda":
                case "Phone":
                    return "battery-phone-100";
                case "Keyboard":
                case "UPS":
                    return "";
                default:
                    return "";
                }
            }
            //color: PlasmaCore.ColorScope.textColor
            visible: iconName != ""
        }
    }
}
