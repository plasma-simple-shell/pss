/****************************************************************************
 * This file is part of Plasma Simple Shell.
 *
 * Copyright (C) 2012 Marco Martin <mart@kde.org>
 * Copyright (C) 2013-2014 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
 *
 * Author(s):
 *    Pier Luigi Fiorini
 *    Marco Martin
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
import QtQuick.Layouts 1.1
import org.kde.plasma.core 2.0 as PlasmaCore
import PSS.Shell.Controls.Styles 1.0 as Styles

Item {
    // For the style
    property var __control: panel

    property Item containment

    id: root
    width: containment && containment.formFactor == PlasmaCore.Types.Vertical ? panel.thickness : panel.length
    height: containment && containment.formFactor == PlasmaCore.Types.Vertical ? panel.length : panel.thickness

    Styles.StyledItem {
        id: styledItem
        anchors.fill: parent
        style: Qt.createComponent(Styles.StyleSettings.path + "/PanelStyle.qml", root)
    }

    Item {
        id: containmentParent
        anchors.fill: styledItem
    }

    onContainmentChanged: {
        containment.parent = containmentParent;
        containment.visible = true;
        containment.anchors.fill = containmentParent;

        if (containment.Layout) {
            containment.Layout.minimumWidthChanged.connect(minimumWidthChanged);
            containment.Layout.maximumWidthChanged.connect(maximumWidthChanged);
            containment.Layout.preferredWidthChanged.connect(preferredWidthChanged);

            containment.Layout.minimumHeightChanged.connect(minimumHeightChanged);
            containment.Layout.maximumHeightChanged.connect(maximumHeightChanged);
            containment.Layout.preferredHeightChanged.connect(preferredHeightChanged);
        }
    }

    function minimumWidthChanged() {
        if (!containment.userConfiguring && containment.formFactor === PlasmaCore.Types.Horizontal)
            panel.length = Math.max(panel.width, containment.Layout.minimumWidth);
    }
    function maximumWidthChanged() {
        if (!containment.userConfiguring && containment.formFactor === PlasmaCore.Types.Horizontal) {
            panel.length = Math.min(panel.width, containment.Layout.maximumWidth);
        }
    }
    function preferredWidthChanged() {
        if (!containment.userConfiguring && containment.formFactor === PlasmaCore.Types.Horizontal) {
            panel.length = Math.min(panel.maximumLength, Math.max(containment.Layout.preferredWidth, panel.minimumLength));
        }
    }

    function minimumHeightChanged() {
        if (!containment.userConfiguring && containment.formFactor === PlasmaCore.Types.Vertical) {
            panel.length = Math.max(panel.height, containment.Layout.minimumWidth);
        }
    }
    function maximumHeightChanged() {
        if (!containment.userConfiguring && containment.formFactor === PlasmaCore.Types.Vertical) {
            panel.length = Math.min(panel.height, containment.Layout.maximumWidth);
        }
    }
    function preferredHeightChanged() {
        if (!containment.userConfiguring && containment.formFactor === PlasmaCore.Types.Vertical) {
            panel.length = Math.min(panel.maximumLength, Math.max(containment.Layout.preferredHeight, panel.minimumLength));
        }
    }

    Connections {
        target: containment
        onUserConfiguringChanged: {
            if (!containment.userConfiguring) {
                minimumWidthChanged();
                maximumWidthChanged();
                preferredWidthChanged();
                minimumHeightChanged();
                maximumHeightChanged();
                preferredHeightChanged();
            }
        }
    }
}
