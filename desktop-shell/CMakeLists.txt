# Install look & feel package
plasma_install_package(lookandfeel org.pss.lookandfeel.desktop look-and-feel lookandfeel)

# Install SDDM theme from look & feel
install(DIRECTORY lookandfeel/contents/loginmanager/
        DESTINATION ${CMAKE_INSTALL_PREFIX}/share/sddm/themes/mauiproject
        PATTERN dummydata EXCLUDE)
install(DIRECTORY lookandfeel/contents/components
        DESTINATION ${CMAKE_INSTALL_PREFIX}/share/sddm/themes/mauiproject)

# Install shell package
plasma_install_package(shell org.pss.shells.desktop shells shell)
