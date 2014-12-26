/****************************************************************************
 * This file is part of Plasma Simple Shell.
 *
 * Copyright (C) 2012 Marco Martin <mart@kde.org>
 * Copyright (C) 2013-2014 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
 * Copyright (C) 2014 David Edmundson <davidedmundson@kde.org>
 *
 * Author(s):
 *    David Edmundson
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
import PSS.Shell.Controls 1.0 as Controls
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import "../explorer"
import "../controlcenter"

Rectangle {
    id: root
    color: Qt.rgba(0, 0, 0, 0.2)
    width: 1024
    height: 768

    property Item containment
    property Item wallpaper

    function toggleWidgetExplorer(containment) {
        //console.log("Widget Explorer toggled");

        if (sidePanelStack.state == "widgetExplorer") {
            sidePanelStack.state = "closed";
        } else {
            sidePanelStack.setSource(Qt.resolvedUrl("../explorer/Explorer.qml"), {"containment": containment})
            sidePanelStack.state = "widgetExplorer";
        }
    }

    function toggleActivityManager() {
    }

    function toggleControlCenter() {
        //console.debug("Control center toggled");

        if (topPanelStack.state == "controlCenter") {
            topPanelStack.state = "closed";
        } else {
            topPanelStack.setSource(Qt.resolvedUrl("../controlcenter/Panel.qml"))
            topPanelStack.state = "controlCenter";
        }
    }

    ControlCenter {
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
        }
        z: 1000000
        onClicked: toggleControlCenter()
    }

    Controls.SidePanel {
        id: sidePanel
        location: PlasmaCore.Types.LeftEdge
        onVisibleChanged: {
            if (!visible) {
                sidePanelStack.state = "closed";
            } else {
                var rect = containment.availableScreenRect;
                sidePanel.requestActivate();
                sidePanelStack.height = containment ? rect.height : 100;
                sidePanel.x = desktop.x + rect.x;
                sidePanel.y = desktop.y + rect.y;
            }
        }

        Loader {
            id: sidePanelStack
            asynchronous: true
            width: item ? item.width : 100
            height: 100
            onLoaded: {
                if (sidePanelStack.item)
                    item.closed.connect(function(){sidePanelStack.state = "closed";});
                sidePanel.visible = true;
            }
            onStateChanged: {
                if (sidePanelStack.state == "closed") {
                    sidePanelStack.source = ""; //unload all elements
                    sidePanel.visible = false;
                }
            }
        }
    }

    Controls.SidePanel {
        id: topPanel
        location: PlasmaCore.Types.TopEdge
        onVisibleChanged: {
            if (!visible) {
                topPanelStack.state = "closed";
            } else {
                var rect = containment.availableScreenRect;

                topPanel.requestActivate();

                if (topPanel.state == "controlCenter") {
                    topPanel.x = desktop.x + rect.x;
                    topPanel.y = desktop.y + rect.y;
                    topPanelStack.width = containment ? rect.width : rect.width;
                }
            }
        }

        Loader {
            id: topPanelStack
            asynchronous: true
            width: root.width
            height: item ? item.height : 0
            onLoaded: {
                if (topPanelStack.item) {
                    item.closed.connect(function() {
                        topPanelStack.state = "closed";
                    });
                }

                topPanel.visible = true;
            }
            onStateChanged: {
                if (topPanelStack.state == "closed") {
                    topPanelStack.source = "";
                    topPanel.visible = false;
                }
            }
        }
    }

    onContainmentChanged: {
        //containment.parent = root;

        internal.newContainment = containment;

        if (containment != null) {
            containment.visible = true;
        }
        if (containment != null) {
            if (internal.oldContainment != null && internal.oldContainment != containment) {
                if (internal.newContainment != null) {
                    switchAnim.running = true;
                }
            } else {
                containment.anchors.left = root.left;
                containment.anchors.top = root.top;
                containment.anchors.right = root.right;
                containment.anchors.bottom = root.bottom;
                internal.oldContainment = containment;
            }
        }
    }

    onWallpaperChanged: {
        wallpaper.opacity = desktop.dashboardShown ? 0.3 : 1
        if (!internal.oldWallpaper) {
            internal.oldWallpaper = wallpaper;
        }
    }

    Connections {
        target: desktop
        onDashboardShownChanged: {
            wallpaper.opacity = desktop.dashboardShown ? 0.3 : 1
        }
    }

    //some properties that shouldn't be accessible from elsewhere
    QtObject {
        id: internal;

        property Item oldContainment: null;
        property Item newContainment: null;
        property Item oldWallpaper: null;
    }

    SequentialAnimation {
        id: switchAnim
        ScriptAction {
            script: {
                if (containment) {
                    containment.anchors.left = undefined;
                    containment.anchors.top = undefined;
                    containment.anchors.right = undefined;
                    containment.anchors.bottom = undefined;
                }
                internal.oldContainment.anchors.left = undefined;
                internal.oldContainment.anchors.top = undefined;
                internal.oldContainment.anchors.right = undefined;
                internal.oldContainment.anchors.bottom = undefined;

                if (containment) {
                    internal.oldContainment.z = 0;
                    internal.oldContainment.x = 0;
                    containment.z = 1;
                    containment.x = root.width;
                }
            }
        }
        ParallelAnimation {
            NumberAnimation {
                target: internal.oldContainment
                properties: "x"
                to: internal.newContainment != null ? -root.width : 0
                duration: 400
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                target: internal.newContainment
                properties: "x"
                to: 0
                duration: units.longDuration
                easing.type: Easing.InOutQuad
            }
        }
        ScriptAction {
            script: {
                if (containment) {
                    containment.anchors.left = root.left;
                    containment.anchors.top = root.top;
                    containment.anchors.right = root.right;
                    containment.anchors.bottom = root.bottom;
                    internal.oldContainment.visible = false;
                    internal.oldWallpaper.opacity = 1;
                    internal.oldContainment = containment;
                    internal.oldWallpaper = wallpaper;
                }
            }
        }
    }


    Component.onCompleted: {
        //configure the view behavior
        desktop.stayBehind = true;
        desktop.fillScreen = true;
    }
}
