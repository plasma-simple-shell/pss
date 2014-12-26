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

#ifndef NOTIFICATIONSHELPER_H
#define NOTIFICATIONSHELPER_H

#include <QtCore/QObject>
#include <QtCore/QRect>
#include <QtCore/QHash>
#include <QtCore/QVariantMap>

class QQuickWindow;

class NotificationsHelper : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QRect plasmoidScreen MEMBER m_plasmoidScreen)
public:
    NotificationsHelper(QObject *parent = 0);
    ~NotificationsHelper();

    Q_INVOKABLE void addNotificationPopup(QObject *win);
    Q_INVOKABLE QRect workAreaForScreen(const QRect &screen);
    Q_INVOKABLE void closePopup(const QString &sourceName);
    /**
     * Fills the popup with data from notificationData
     * and puts the popup on proper place on screen.
     * If there's no space on screen for the notification,
     * it's queued and displayed as soon as there's space for it
     */
    Q_INVOKABLE void displayNotification(const QVariantMap &notificationData);

private Q_SLOTS:
    void popupClosed(bool visible);
    void displayQueuedNotification();

private:
    void repositionPopups();

    QList<QQuickWindow *> m_popupsOnScreen;
    QList<QQuickWindow *> m_availablePopups;
    QHash<QString, QQuickWindow*> m_sourceMap;
    QList<QVariantMap> m_queue;
    QRect m_plasmoidScreen;
    int m_offset;
};

#endif // NOTIFICATIONSHELPER_H
