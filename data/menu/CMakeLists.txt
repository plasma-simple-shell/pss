set(DIRECTORIES
    pss-entertainment.directory
    pss-internet.directory
    pss-main.directory
    pss-system.directory
    pss-work.directory
)
install(FILES ${DIRECTORIES}
        DESTINATION ${XDG_DIRECTORY_INSTALL_DIR})

install(FILES pss-applications.menu
        DESTINATION ${SYSCONF_INSTALL_DIR}/xdg/menus)
