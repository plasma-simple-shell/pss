/****************************************************************************
 * This file is part of Plasma Simple Shell.
 *
 * Copyright (C) 2014 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
 * Copyright (C) 2014 Martin Klapetek <mklapetek@kde.org>
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
import QtQuick.Layouts 1.0
import PSS.Shell.Controls 1.0 as Controls
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.kquickcontrolsaddons 2.0

Controls.NotificationPopup {
    property var notificationProperties

    id: notificationPopup
    onVisibleChanged: notificationTimer.running = visible

    Behavior on y {
        NumberAnimation {
            easing.type: Easing.OutQuad
            duration: units.longDuration
        }
    }

    Behavior on height {
        NumberAnimation {
            easing.type: Easing.OutQuad
            duration: units.longDuration
        }
    }

    MouseEventListener {
        id: mainItem
        width: units.gridUnit * 24
        height: units.gridUnit * 5
        hoverEnabled: true
        state: "controlsHidden"
        states: [
            State {
                name: "controlsShown"
            },
            State {
                name: "controlsHidden"
            }
        ]
        transitions: [
            Transition {
                NumberAnimation {
                    properties: "opacity"
                    easing.type: Easing.InOutQuad
                    duration: units.longDuration
                }
            }
        ]
        onContainsMouseChanged: {
            if (containsMouse) {
                mainItem.state = "controlsShown";
                notificationTimer.running = false;
            } else {
                mainItem.state = "controlsHidden";
                notificationTimer.restart();
            }
        }
        onClicked: {
            closeNotification(notificationProperties.source);
            notificationPopup.hide();
        }

        Timer {
            id: notificationTimer
            repeat: false
            running: false
            onTriggered: {
                if (!notificationProperties.isPersistent)
                    closeNotification(notificationProperties.source);
                notificationPopup.hide();
            }
        }

        RowLayout {
            id: mainLayout
            anchors.fill: parent
            anchors.margins: units.gridUnit
            spacing: units.smallSpacing

            QIconItem {
                id: appIconItem
                width: units.iconSizes.large
                height: width
                visible: !imageItem.visible

                Layout.alignment: Qt.AlignTop
            }

            QImageItem {
                id: imageItem
                width: units.iconSizes.large
                height: width
                smooth: true
                fillMode: Image.PreserveAspectFit
                visible: nativeWidth > 0

                Layout.alignment: Qt.AlignTop
            }

            RowLayout {
                spacing: units.smallSpacing

                ColumnLayout {
                    spacing: units.smallSpacing

                    PlasmaExtras.Heading {
                        id: titleLabel
                        level: 4
                        height: paintedHeight
                        elide: Text.ElideRight
                        onLinkActivated: Qt.openUrlExternally(link)
                        visible: text.length > 0

                        Layout.alignment: Qt.AlignTop
                        Layout.fillWidth: true
                    }

                    PlasmaComponents.Label {
                        id: bodyLabel
                        color: PlasmaCore.ColorScope.textColor
                        wrapMode: Text.Wrap
                        elide: Text.ElideRight
                        maximumLineCount: 10
                        verticalAlignment: Text.AlignTop
                        onLinkActivated: Qt.openUrlExternally(link)

                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.alignment: Qt.AlignTop
                    }

                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }

                ColumnLayout {
                    id: actionsColumn
                    spacing: units.smallSpacing

                    Repeater {
                        id: actionsRepeater
                        model: new Array()

                        Controls.Button {
                            text: modelData.text
                            onClicked: {
                                executeAction(notificationProperties.source, modelData.id);
                                notificationPopup.hide();
                            }
                        }
                    }

                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }

                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
    }

    function populatePopup(notification) {
        notificationProperties = notification;
        notificationTimer.interval = notification.expireTimeout;
        notificationTimer.restart();
        titleLabel.text = notification.summary;
        bodyLabel.text = notification.body;
        appIconItem.icon = notification.appIcon;
        actionsRepeater.model = notification.actions;
        imageItem.image = notification.picture;
    }
}
