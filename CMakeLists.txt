project(PSS)

cmake_minimum_required(VERSION 2.8.12 FATAL_ERROR)

# Find includes in corresponding build directories
set(CMAKE_INCLUDE_CURRENT_DIR ON)

# Instruct CMake to run moc automatically when needed
set(CMAKE_AUTOMOC ON)

# Options
option(ENABLE_SYSTEMD "Enables systemd support" OFF)

# Set version
set(PSS_VERSION_MAJOR 0)
set(PSS_VERSION_MINOR 5)
set(PSS_VERSION_PATCH 90)
set(PSS_VERSION_STRING "${PSS_VERSION_MAJOR}.${PSS_VERSION_MINOR}.${PSS_VERSION_PATCH}")

# ECM
find_package(ECM 0.0.11 REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake" ${ECM_MODULE_PATH} ${ECM_KDE_MODULE_DIR})

# Installation directories
include(KDEInstallDirs)

# Other macros
include(KDECMakeSettings)
include(KDECompilerSettings)

# Macro to print feature summary
include(FeatureSummary)

# Add custom uninstall target
configure_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/cmake_uninstall.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake"
    IMMEDIATE @ONLY)
add_custom_target(uninstall "${CMAKE_COMMAND}" -P "${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake")

# Set up packaging
set(CPACK_PACKAGE_NAME "pss")
set(CPACK_PACKAGE_VERSION "${PSS_VERSION_STRING}")
set(CPACK_GENERATOR "TGZ")
set(CPACK_SET_DESTDIR FALSE)
set(CPACK_SOURCE_PACKAGE_FILE_NAME "${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION}")
set(CPACK_SOURCE_IGNORE_FILES "/build/;/.git;/*.user;/.tx/;~$;${CPACK_SOURCE_IGNORE_FILES}")
include(CPack)
add_custom_target(dist COMMAND ${CMAKE_MAKE_PROGRAM} package_source)

# Build flags
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fvisibility=hidden -fvisibility-inlines-hidden -Wall -Wextra -Wno-unused-parameter -std=c++11")

# Assume release build by default
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "RelWithDebInfo" CACHE STRING "" FORCE)
endif()

# Minimum version requirements
set(QT_MIN_VERSION "5.3.0")
set(KF5_MIN_VERSION "5.0.0")

# Find Qt5
find_package(Qt5 ${QT_MIN_VERSION} CONFIG REQUIRED COMPONENTS Qml Quick)

# Find KF5
find_package(KF5 REQUIRED COMPONENTS
    Plasma
    PlasmaQuick
    I18n
    KDELibs4Support
    Runner
    Service
    Solid
)

# Other libraries from KDE
find_package(LibKWorkspace CONFIG REQUIRED)

# Subdirectories
add_subdirectory(applets)
add_subdirectory(data)
add_subdirectory(desktop-shell)
add_subdirectory(wallpapers)

# Display featute summary
feature_summary(WHAT ALL FATAL_ON_MISSING_REQUIRED_PACKAGES)
