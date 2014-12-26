/****************************************************************************
 * This file is part of Plasma Simple Shell.
 *
 * Copyright (C) 2014 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
 * Copyright (C) 2014 Marco Martin <mart@kde.org>
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
import QtQuick.Layouts 1.1
import QtQuick.Window 2.1
import PSS.Shell.Controls 1.0 as Controls
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.kquickcontrolsaddons 2.0 as KControls
import org.kde.plasma.private.shell 2.0

PlasmaCore.Dialog {
//Controls.SidePanel {
    id: sidePanel
    visualParent: alternativesHelper.applet
    location: alternativesHelper.applet.location
    //! remove when using SidePanel
    type: PlasmaCore.Dialog.Dock
    hideOnWindowDeactivate: true

    Controls.ToolButton {
        id: closeButton
        anchors {
            top: parent.top
            right: parent.right
        }
        iconName: "window-close-symbolic"
        iconSize: units.iconSizes.small
        flat: true
        onClicked: sidePanel.close()
    }

    ColumnLayout {
        property string currentPlugin: alternativesHelper.currentPlugin

        signal configurationChanged

        id: root
        focus: true

        WidgetExplorer {
            id: widgetExplorer
            provides: alternativesHelper.appletProvides
        }

        PlasmaExtras.Heading {
            text: i18nd("org.pss.shells.desktop", "Alternatives");
        }

        // TODO: Plasma should give us information about the current plugin like a description,
        // so we can show a more descriptive message like 'Please choose an alternative to "applet verbose name" from the list below'.
        PlasmaExtras.Paragraph {
            text: i18nd("org.pss.shells.desktop", "Please choose an alternative to this applet from the list below.")
            wrapMode: Text.Wrap

            Layout.fillWidth: true
        }

        Controls.ScrollView {
            ListView {
                id: mainList
                model: widgetExplorer.widgetsModel
                highlight: PlasmaComponents.Highlight {
                    id: highlight
                }
                delegate: MouseArea {
                    property bool checked: model.pluginName == alternativesHelper.currentPlugin

                    id: delegate
                    width: mainList.width
                    height: childrenRect.height

                    RowLayout {
                        spacing: units.largeSpacing
                        x: units.smallSpacing
                        width: mainList.width - units.smallSpacing
                        height: units.iconSizes.huge + units.largeSpacing

                        KControls.QIconItem {
                            width: units.iconSizes.huge
                            height: width
                            icon: model.decoration
                        }

                        RowLayout {
                            ColumnLayout {
                                PlasmaExtras.Heading {
                                    level: 4
                                    text: model.name

                                    Layout.fillWidth: true
                                }

                                PlasmaComponents.Label {
                                    text: model.description
                                    font.pointSize: theme.smallestFont.pointSize
                                    wrapMode: Text.WordWrap

                                    Layout.fillWidth: true
                                }

                                Layout.fillWidth: true
                            }

                            Controls.Button {
                                text: i18nd("org.pss.shells.desktop", "Choose")
                                visible: !delegate.checked
                                onClicked: {
                                    root.currentPlugin = model.pluginName;
                                    alternativesHelper.loadAlternative(root.currentPlugin);
                                    sidePanel.close();
                                }

                                Layout.alignment: Qt.AlignTop | Qt.AlignRight
                            }

                            Layout.fillWidth: true
                        }
                    }

                    Component.onCompleted: {
                        if (checked)
                            mainList.currentIndex = index;
                    }
                }
            }

            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumHeight: Math.min(Screen.height - units.gridUnit * 10, mainList.contentHeight + units.gridUnit)
            Layout.preferredHeight: mainList.height
        }

        Keys.onEscapePressed: sidePanel.close()

        Layout.minimumWidth: units.gridUnit * 30
    }

    Component.onCompleted: {
        //flags = flags | Qt.WindowStaysOnTopHint;
        sidePanel.show();
    }
}
