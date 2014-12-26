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

import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.0
import PSS.Shell.Controls 1.0 as Controls
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.pss.appchooser.private 0.1 as AppChooser

FocusScope {
    signal closed()

    id: root
    height: units.gridUnit * 17

    AppChooser.ProcessRunner {
        id: processRunner

        function executeSetting(name) {
            root.closed();
            runSetting(name);
        }
    }

    PlasmaCore.DataSource {
        id: dataSource
        engine: "time"
        connectedSources: ["Local"]
        interval: 30000
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: units.largeSpacing

        RowLayout {
            spacing: units.largeSpacing

            RowLayout {
                spacing: units.largeSpacing

                PlasmaComponents.Label {
                    text: "Weather: 20 C, Clear"
                    font.pointSize: theme.defaultFont.pointSize * 0.9

                    MouseArea {
                        anchors.fill: parent
                        onClicked: stackView.push(weatherComponent)
                    }
                }

                Item {
                    Layout.fillWidth: true
                }

                Controls.Button {
                    text: "Clock Settings"
                    //onClicked: stackView.push(clockSettingsComponent)
                    onClicked: processRunner.executeSetting("clock")
                }

                Layout.alignment: Qt.AlignTop
            }

            Clock {
                timeDataSource: dataSource

                MouseArea {
                    anchors.fill: parent
                    onClicked: stackView.push(calendarComponent)
                    onDoubleClicked: root.closed()
                }

                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                Layout.fillHeight: true
            }

            RowLayout {
                spacing: units.largeSpacing

                Controls.Button {
                    text: "Add Appointment"
                    onClicked: stackView.push(appointmentComponent)
                }

                Item {
                    Layout.fillWidth: true
                }

                PlasmaComponents.Label {
                    text: "System Language: English"
                    font.pointSize: theme.defaultFont.pointSize * 0.9

                    MouseArea {
                        anchors.fill: parent
                        //onClicked: stackView.push(languageComponent)
                        onClicked: processRunner.executeSetting("translations")
                    }
                }

                Layout.alignment: Qt.AlignTop
            }
        }

        StackView {
            id: stackView
            initialItem: calendarComponent

            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }

    Component {
        id: calendarComponent

        CalendarView {
            selectedDate: dataSource.data["Local"]["DateTime"]
        }
    }

    Component {
        id: weatherComponent

        Item {
            PlasmaComponents.Label {
                anchors.centerIn: parent
                text: "Not implemented yet"
            }
        }
    }

    Component {
        id: clockSettingsComponent

        Item {
            PlasmaComponents.Label {
                anchors.centerIn: parent
                text: "Not implemented yet"
            }
        }
    }

    Component {
        id: appointmentComponent

        Item {
            PlasmaComponents.Label {
                anchors.centerIn: parent
                text: "Not implemented yet"
            }
        }
    }

    Component {
        id: languageComponent

        Item {
            PlasmaComponents.Label {
                anchors.centerIn: parent
                text: "Not implemented yet"
            }
        }
    }
}
