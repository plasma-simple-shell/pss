/****************************************************************************
 * This file is part of Plasma Simple Shell.
 *
 * Copyright (C) 2014 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
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
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.kquickcontrolsaddons 2.0

Item {
    id: notificationDelegate
    width: popupFlickable.width
    height: childrenRect.height

    // Remove this notification after 10 minutes, except when
    // in idle mode
    Timer {
        id: removeTimer
        interval: 10*60*1000
        repeat: false
        running: !idleTimeSource.idle
        onTriggered: {
            if (!notificationsModel.inserting)
                notificationsModel.remove(index);
        }
    }

    RowLayout {
        width: parent.width
        height: childrenRect.height

        QIconItem {
            id: appIconItem
            width: units.iconSizes.large
            height: width
            icon: appIcon
            visible: !imageItem.visible

            Layout.alignment: Qt.AlignTop
        }

        QImageItem {
            id: imageItem
            anchors.fill: appIconItem
            image: picture
            smooth: true
            visible: nativeWidth > 0
        }

        RowLayout {
            spacing: units.smallSpacing

            ColumnLayout {
                spacing: units.smallSpacing

                PlasmaExtras.Heading {
                    id: titleLabel
                    level: 4
                    height: paintedHeight
                    text: summary
                    elide: Text.ElideRight
                    visible: text.length > 0
                    onLinkActivated: Qt.openUrlExternally(link)

                    Layout.fillWidth: true
                }

                TextEdit {
                    id: bodyText
                    text: body
                    color: theme.textColor
                    selectedTextColor: theme.viewBackgroundColor
                    selectionColor: theme.viewFocusColor
                    font.capitalization: theme.defaultFont.capitalization
                    font.family: theme.defaultFont.family
                    font.italic: theme.defaultFont.italic
                    font.letterSpacing: theme.defaultFont.letterSpacing
                    font.pointSize: theme.defaultFont.pointSize
                    font.strikeout: theme.defaultFont.strikeout
                    font.underline: theme.defaultFont.underline
                    font.weight: theme.defaultFont.weight
                    font.wordSpacing: theme.defaultFont.wordSpacing
                    renderType: Text.NativeRendering
                    selectByMouse: true
                    readOnly: true
                    wrapMode: Text.Wrap
                    textFormat: TextEdit.RichText
                    onLinkActivated: Qt.openUrlExternally(link)

                    Layout.fillWidth: true
                }
            }

            ColumnLayout {
                id: actionsColumn
                spacing: units.smallSpacing

                Repeater {
                    id: actionsRepeater
                    model: actions

                    Controls.Button {
                        text: model.text
                        onClicked: {
                            executeAction(source, model.id);
                            removeTimer.triggered();
                        }
                    }
                }

                Layout.fillWidth: true
            }
        }

        Layout.fillWidth: true
    }
}
