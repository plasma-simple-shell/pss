install(FILES pss-shell-desktop.desktop
        DESTINATION ${AUTOSTART_INSTALL_DIR})
install(FILES env-pss.sh
        DESTINATION ${CONFIG_INSTALL_DIR}/plasma-workspace/env
        RENAME pss.sh)
