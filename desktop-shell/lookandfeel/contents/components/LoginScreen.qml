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

Item {
    property alias model: usersView.model
    property Component actions

    signal loginRequested(string userName, string password)
    signal pageRequested(string page)

    id: root
    implicitHeight: usersView.height + details.implicitHeight

    ColumnLayout {
        anchors {
            left: parent.horizontalCenter
            top: parent.top
            right: parent.right
            bottom: parent.bottom
            leftMargin: -usersView.userItemWidth * 1.5
        }
        spacing: units.smallSpacing

        UsersView {
            id: usersView
            height: userItemHeight
            preferredHighlightBegin: userItemWidth * 1
            preferredHighlightEnd: userItemWidth * 2
            onSelected: root.clearPassword()

            Layout.fillWidth: true
        }

        PSSLabel {
            id: userLabel
            text: usersView.currentItem ? usersView.currentItem.name : ""
            font.pointSize: 18
            elide: Text.ElideRight
            horizontalAlignment: Qt.AlignHCenter

            Layout.fillWidth: true
        }

        PSSPasswordField {
            id: passwordField
            onAccepted: root.loginRequested(usersView.currentItem.userName, passwordField.text)

            Layout.fillWidth: true
        }

        RowLayout {
            id: details
            spacing: units.largeSpacing

            MessageBox {
                id: messageBox
            }

            Item {
                Layout.fillWidth: true
            }

            Loader {
                sourceComponent: root.actions

                Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
            }
        }
    }

    Component.onCompleted: root.clearPassword()

    function clearPassword() {
        passwordField.selectAll();
        passwordField.forceActiveFocus();
    }

    function setInfoMessage(msg) {
        messageBox.setInfoMessage(msg);
    }

    function setErrorMessage(msg) {
        messageBox.setErrorMessage(msg);
    }
}
