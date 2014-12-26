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
import QtQuick.Window 2.0
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0
import PSS.Shell.Controls 1.0 as Controls
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.kscreenlocker 1.0
import PSS.Components 1.0
import "../components"

NoiseBackground {
    property alias rebootVisible: shutdownOptions.rebootVisible
    property alias powerOffVisible: shutdownOptions.powerOffVisible

    signal rebootRequested()
    signal powerOffRequested()

    id: greeter
    color: "#272727"
    gradient: Gradient {
        GradientStop { position: 0; color: "#272727" }
        GradientStop { position: 1; color: "#2b2b2b" }
    }
    width: 800
    height: 600

    Connections {
        target: authenticator
        onFailed: {
            loginScreen.setErrorMessage(i18nd("org.pss.lookandfeel.desktop", "Unlocking failed"));
            loginScreen.clearPassword();
        }
        onGraceLockedChanged: {
            if (!authenticator.graceLocked)
                loginScreen.clearPassword();
        }
        onMessage: {
            loginScreen.setInfoMessage(text);
        }
        onError: {
            loginScreen.setErrorMessage(text);
        }
    }

    Sessions {
        id: sessions
    }

    Item {
        anchors {
            centerIn: parent
            bottomMargin: shutdownOptionsWrapper.height * units.smallSpacing
        }
        width: mainLayout.implicitWidth
        height: mainLayout.implicitHeight

        ColumnLayout {
            id: mainLayout
            anchors.fill: parent

            StackView {
                id: stackView
                width: greeter.width * 0.5
                height: greeter.height * 0.5
                initialItem: LoginScreen {
                    id: loginScreen
                    width: greeter.width * 0.5
                    height: units.largeSpacing * 14
                    actions: Row {
                        spacing: units.smallSpacing

                        KeyboardLayoutButton {}

                        Controls.ToolButton {
                            iconName: "system-log-out-symbolic"
                            iconSize: units.iconSizes.small
                            onClicked: loginScreen.pageRequested("newSession")
                        }

                        Controls.ToolButton {
                            iconName: "system-switch-user-symbolic"
                            iconSize: units.iconSizes.small
                            onClicked: loginScreen.pageRequested("switchUser")
                        }
                    }
                    model: ListModel {
                        id: users

                        Component.onCompleted: {
                            users.append({
                                "name": kscreenlocker_userName,
                                "userName": kscreenlocker_userName,
                                "realName": kscreenlocker_userName,
                                "icon": kscreenlocker_userImage || "avatar-default-symbolic"
                            });
                        }
                    }
                    onLoginRequested: authenticator.tryUnlock(password)
                    onPageRequested: {
                        switch (page) {
                        case "newSession":
                            stackView.push(newSessionComponent);
                        case "switchUser":
                            stackView.push(switchUserComponent);
                        default:
                            break;
                        }
                    }
                }
            }
        }
    }

    Item {
        id: shutdownOptionsWrapper
        anchors {
            right: parent.right
            bottom: parent.bottom
            margins: units.largeSpacing
        }
        width: shutdownOptions.implicitWidth
        height: shutdownOptions.implicitHeight

        ShutdownButtons {
            id: shutdownOptions
            anchors.fill: parent
            spacing: units.largeSpacing
            onRebootRequested: greeter.rebootRequested()
            onPowerOffRequested: greeter.powerOffRequested()
        }
    }

    Component {
        id: newSessionComponent

        Item {
            //title: i18nd("org.pss.lookandfeel.desktop", "New Session")
            width: units.largeSpacing * 10
            height: units.largeSpacing * 14
            //onBackRequested: stackView.pop()
        }
    }

    Component {
        id: sessionScreenComponent

        Item {
            //title: i18nd("org.pss.lookandfeel.desktop", "Change Session")
            width: units.largeSpacing * 10
            height: units.largeSpacing * 14
            //model: sessionModel
            //index: sessionModel.lastIndex
            //onSelected: greeter.sessionIndex = index
            //onBackRequested: stackView.pop()
        }
    }
}
