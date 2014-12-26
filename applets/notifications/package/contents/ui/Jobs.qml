/****************************************************************************
 * This file is part of Plasma Simple Shell.
 *
 * Copyright (C) 2014 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
 * Copyright (C) 2012 Marco Martin <notmart@gmail.com>
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
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras

Column {
    property alias count: jobsRepeater.count

    id: jobsRoot
    anchors {
        left: parent.left
        right: parent.right
    }

    PlasmaCore.DataSource {
        property variant runningJobs

        id: jobsSource
        engine: "applicationjobs"
        interval: 0
        onSourceAdded: connectSource(source);
        onSourceRemoved: {
            if (!notifications)
                return;

            var message = runningJobs[source]["label1"] ? runningJobs[source]["label1"] : runningJobs[source]["label0"];
            notifications.addNotification(
                source,
                runningJobs[source]["appIconName"],
                0,
                runningJobs[source]["appName"],
                i18n("%1 [Finished]", runningJobs[source]["infoMessage"]),
                message,
                true,
                6000,
                0,
                0,
                0,
                [{"id": message, "text": i18n("Open")}]);

            delete runningJobs[source];
        }
        onNewData: {
            var jobs = runningJobs;
            jobs[sourceName] = data;
            runningJobs = jobs;
        }
        onDataChanged: {
            var total = 0, i;
            for (i = 0; i < sources.length; ++i) {
                if (jobsSource.data[sources[i]]["percentage"])
                    total += jobsSource.data[sources[i]]["percentage"];
            }

            total /= sources.length;
            notificationsApplet.globalProgress = total/100;
        }

        Component.onCompleted: {
            jobsSource.runningJobs = new Object;
            connectedSources = sources;
        }
    }

    Item {
        visible: jobsRepeater.count > 3

        PlasmaComponents.ProgressBar {
            anchors {
                verticalCenter: parent.verticalCenter
                left: parent.left
                right: parent.right
            }
            minimumValue: 0
            maximumValue: 100
            value: notificationsApplet.globalProgress * 100
        }
    }

    Repeater {
        id: jobsRepeater
        model: jobsSource.sources
        delegate: JobDelegate {}
    }
}
