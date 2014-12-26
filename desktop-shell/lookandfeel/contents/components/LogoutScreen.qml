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
import PSS.Shell.Controls 1.0 as Controls
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras

Item {
    property string mode: "poweroff"
    property var currentAction
    property real timeout: 60
    property real remainingTime: timeout
    property bool canLogOut
    property bool canPowerOff
    property bool canRestart

    signal cancel()
    signal logOutRequested()
    signal powerOffRequested()
    signal restartRequested()

    id: root
    state: mode
    states: [
        State {
            name: "logout"
            PropertyChanges { target: root; currentAction: logOutRequested }
            PropertyChanges { target: actionIcon; iconName: "system-log-out-symbolic" }
            PropertyChanges { target: actionLabel; text: i18nd("org.pss.lookandfeel.desktop", "Log Out") }
            PropertyChanges { target: okButton; text: i18nd("org.pss.lookandfeel.desktop", "Log out") }
        },
        State {
            name: "poweroff"
            PropertyChanges { target: root; currentAction: powerOffRequested }
            PropertyChanges { target: actionIcon; iconName: "system-shutdown-symbolic" }
            PropertyChanges { target: actionLabel; text: i18nd("org.pss.lookandfeel.desktop", "Power Off") }
            PropertyChanges { target: okButton; text: i18nd("org.pss.lookandfeel.desktop", "Power off") }
        },
        State {
            name: "restart"
            PropertyChanges { target: root; currentAction: restartRequested }
            PropertyChanges { target: actionIcon; iconName: "system-reboot-symbolic" }
            PropertyChanges { target: actionLabel; text: i18nd("org.pss.lookandfeel.desktop", "Restart") }
            PropertyChanges { target: okButton; text: i18nd("org.pss.lookandfeel.desktop", "Restart") }
        }
    ]
    onModeChanged: root.remainingTime = root.timeout
    onRemainingTimeChanged: {
        if (remainingTime <= 0)
            root.currentAction();
    }

    Action {
        onTriggered: root.cancel()
        shortcut: "Escape"
    }

    Timer {
        running: true
        repeat: true
        interval: 10000
        onTriggered: root.remainingTime -= 10
    }

    ColumnLayout {
        anchors.centerIn: parent

        IconButton {
            id: actionIcon
            width: units.iconSizes.large
            height: width
            color: theme.viewTextColor
            onClicked: root.currentAction()

            Layout.alignment: Qt.AlignHCenter
        }

        PlasmaExtras.Heading {
            id: actionLabel
            level: 2

            Layout.alignment: Qt.AlignHCenter
        }

        Controls.ProgressBar {
            id: progressBar
            width: units.largeSpacing * 5
            minimumValue: 0
            maximumValue: root.timeout
            value: root.remainingTime

            Layout.alignment: Qt.AlignHCenter
        }

        PlasmaComponents.Label {
            id: actionText
            text: {
                var msg = "";

                switch (root.state) {
                case "logout":
                    msg = "You will be logged out automatically in %1 seconds.";
                    break;
                case "poweroff":
                    msg = "The system will power off automatically in %1 seconds.";
                    break;
                case "restart":
                    msg = "The system will restart automatically in %1 seconds.";
                    break;
                default:
                    break;
                }

                return i18nd("org.pss.lookandfeel.desktop", msg, root.remainingTime);
            }

            Layout.alignment: Qt.AlignHCenter
        }

        Item {
            height: units.largeSpacing * 2
        }

        LogoutOptions {
            id: logoutOptions
            canLogOut: root.canLogOut
            canPowerOff: root.canPowerOff
            canRestart: root.canRestart
            onModeChanged: root.mode = mode

            Layout.alignment: Qt.AlignHCenter

            Component.onCompleted: mode = root.mode
        }

        Item {
            height: units.largeSpacing * 2
        }

        RowLayout {
            Controls.Button {
                text: i18nd("org.pss.lookandfeel.desktop", "Cancel")
                onClicked: root.cancel()
            }

            Controls.Button {
                id: okButton
                isDefault: true
                onClicked: root.currentAction()
            }

            Layout.alignment: Qt.AlignHCenter
        }
    }
}
