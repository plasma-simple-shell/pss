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

RowLayout {
    id: root
    spacing: units.smallSpacing
    visible: pmSource.connectedSources != "" && pmSource.data["Battery"]["Has Battery"] && pmSource.data["Battery0"]["Is Power Supply"]

    PlasmaCore.DataSource {
        id: pmSource
        engine: "powermanagement"
        connectedSources: sources
        onSourceAdded: {
            if (source == "Battery0") {
                disconnectSource(source);
                connectSource(source);
            }
        }
        onSourceRemoved: {
            if (source == "Battery0")
                disconnectSource(source);
        }
    }

    BatteryIcon {
        id: batteryIcon
        hasBattery: true
        percent: pmSource.data["Battery0"] ? pmSource.data["Battery0"]["Percent"] : 0
        pluggedIn: pmSource.data["Battery0"] ? pmSource.data["Battery0"]["State"] != "Discharging" : false
        width: units.iconSizes.medium
        height: width
    }

    PSSLabel {
        id: batteryLabel
        text: {
            var state = pmSource.data["Battery0"] ? pmSource.data["Battery0"]["State"] : "";

            switch (state) {
            case "NoCharge":
            case "Discharging":
                return i18nd("org.pss.lookandfeel.desktop", "%1\% charge remaining", batteryIcon.percent)
            case "FullyCharged":
                return i18nd("org.hahwaii.lookandfeel.desktop", "Fully charged")
            default:
                return i18nd("org.pss.lookandfeel.desktop","%1\%, charging", batteryIcon.percent)
            }
        }
        wrapMode: Text.Wrap
    }
}
