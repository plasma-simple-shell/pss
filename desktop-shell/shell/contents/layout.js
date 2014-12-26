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

// Create a bottom panel for the primary screen
var panel = new Panel;
panel.screen = 0;
panel.location = "bottom";
panel.height = 64; // units.iconSizes.large

// Add AppChooser and assign a shortcut
var appChooser = panel.addWidget("org.pss.appchooser");
appChooser.currentConfigGroup = ["Shortcuts"];
appChooser.writeConfig("global", "Alt+F1");

// Task manager
panel.addWidget("org.kde.plasma.taskmanager");

// Add System Tray and configure it
var systemTray = panel.addWidget("org.kde.plasma.systemtray");
systemTray.currentConfigGroup = ["General"];
systemTray.writeConfig("extraItems", [
    "org.kde.plasma.devicenotifier",
    "org.kde.plasma.battery",
    "org.kde.plasma.mediacontroller",
    "org.kde.plasma.networkmanagement",
    "org.pss.notifications"
]);

var i, j;
for (i = 0; i < screenCount; i++) {
    // Create an activity for each screen
    var activity = createActivity("Desktop");

    // Assign a wallpaper plugin to each desktop
    var desktops = desktopsForActivity(activity);
    for (j = 0; j < desktops.length; j++) {
        desktops[j].wallpaperPlugin = "org.kde.image";
    }
}
