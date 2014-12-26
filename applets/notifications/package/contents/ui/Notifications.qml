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
import org.pss.private.notifications 1.0

Column {
    property QtObject notificationPopup
    property alias count: notificationsRepeater.count

    id: notificationsRoot
    anchors {
        left: parent.left
        right: parent.right
        margins: units.smallSpacing
    }

    Component {
        id: notificationPopupComponent

        NotificationPopup {}
    }

    ListModel {
        property bool inserting: false;

        id: notificationsModel
    }

    // Idle whith more than 5 minutes of user inactivity,
    // check every 30 seconds
    PlasmaCore.DataSource {
        property bool idle: data["UserActivity"]["IdleTime"] > 5*60*1000

        id: idleTimeSource
        engine: "powermanagement"
        interval: 30000
        connectedSources: ["UserActivity"]
    }

    PlasmaCore.DataSource {
        id: notificationsSource
        engine: "notifications"
        interval: 0
        onSourceAdded: connectSource(source);
        onSourceRemoved: {
            notificationPositioner.closePopup(source);

            var i;
            for (i = 0; i < notificationsModel.count; ++i) {
                if (notificationsModel.get(i).source == source) {
                    notificationsModel.remove(i)
                    break
                }
            }
        }
        onNewData: {
            var _data = data; // Temp copy to avoid lots of context switching
            var actions = new Array();
            if (data["actions"] && data["actions"].length % 2 == 0) {
                var i;
                for (i = 0; i < data["actions"].length; i += 2) {
                    var action = new Object();
                    action["id"] = data["actions"][i];
                    action["text"] = data["actions"][i + 1];
                    actions.push(action);
                }
            }
            notificationsRoot.addNotification(
                    sourceName,
                    _data["appIcon"],
                    _data["picture"],
                    _data["appName"],
                    _data["summary"],
                    _data["body"],
                    _data["isPersistent"],
                    _data["expireTimeout"],
                    _data["urgency"],
                    _data["appRealName"],
                    _data["configurable"],
                    actions);
        }
    }

    NotificationsHelper {
        id: notificationPositioner
        plasmoidScreen: plasmoid.screenGeometry
    }

    Repeater {
        id: notificationsRepeater
        model: notificationsModel
        delegate: NotificationDelegate {}
    }

    Component.onCompleted: {
        // Create the popup components and pass them to the C++ plugin
        var i;
        for (i = 0; i < 3; i++) {
            var popup = notificationPopupComponent.createObject();
            notificationPositioner.addNotificationPopup(popup);
        }
    }

    function addNotification(source, appIcon, picture, appName, summary, body, isPersistent, expireTimeout, urgency, appRealName, configurable, actions) {
        var i, item;

        // Do not show duplicated notifications
        for (i = 0; i < notificationsModel.count; ++i) {
            item = notificationsModel.get(i);

            if (item.source == source && item.appName == appName &&
                    item.summary == summary && item.body == body)
                return
        }

        for (i = 0; i < notificationsModel.count; ++i) {
            item = notificationsModel.get(i);

            if (item.source == source) {
                notificationsModel.remove(i);
                break;
            }
        }

        if (notificationsModel.count > 20)
            notificationsModel.remove(notificationsModel.count - 1);

        var notification = {
            "source": source,
            "appIcon": appIcon,
            "picture": picture,
            "appName": appName,
            "summary": summary,
            "body": body,
            "isPersistent": isPersistent,
            "expireTimeout": expireTimeout,
            "urgency": urgency,
            "configurable": configurable,
            "appRealName": appRealName,
            "actions": actions
        };

        if (isPersistent) {
            notificationsModel.inserting = true;
            notificationsModel.insert(0, notification);
            notificationsModel.inserting = false;
        }

        notificationPositioner.displayNotification(notification);
    }

    function executeAction(source, id) {
        if (source.indexOf("notification") !== -1) {
            // Try to use the service
            var service = notificationsSource.serviceForSource(source);
            var op = service.operationDescription("invokeAction");
            op["actionId"] = id;

            service.startOperationCall(op);
        } else if (source.indexOf("Job") !== -1) {
            // Try to open the id as url
            Qt.openUrlExternally(id);
        }
    }

    function configureNotification(appRealName) {
        var service = notificationsSource.serviceForSource("notification");
        var op = service.operationDescription("configureNotification");
        op["appRealName"] = appRealName;
        service.startOperationCall(op);
    }

    function closeNotification(source) {
        var service = notificationsSource.serviceForSource(source);
        var op = service.operationDescription("userClosed");
        service.startOperationCall(op);
    }
}
