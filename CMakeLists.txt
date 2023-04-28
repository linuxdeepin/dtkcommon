# SPDX-FileCopyrightText: 2022 Uniontech Software Technology Co.,Ltd.
#
# SPDX-License-Identifier: BSD-3-Clause

cmake_minimum_required(VERSION 3.10)
set (DVERSION "5.6.8" CACHE STRING "define project version")
project(dtkcommon
  VERSION ${DVERSION}
  DESCRIPTION "DTK COMMON"
  HOMEPAGE_URL "https://github.com/linuxdeepin/dtkcommon"
)
message(STATUS "Project version: ${PROJECT_VERSION}")

if (CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  set(CMAKE_INSTALL_PREFIX /usr)
endif ()

include(GNUInstallDirs)
set (MKSPECS_INSTALL_DIR "${CMAKE_INSTALL_LIBDIR}/qt5/mkspecs" CACHE STRING "Install directory for qt pri files")

set(MODULE_INCLUDES ${CMAKE_INSTALL_FULL_INCLUDEDIR}/dtk${PROJECT_VERSION_MAJOR})
set(MODULE_TOOLS ${CMAKE_INSTALL_FULL_LIBDIR}/dtk${PROJECT_VERSION_MAJOR})
configure_file(misc/qt_lib_dtkcommon.pri.in qt_lib_dtkcommon.pri @ONLY)

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/qt_lib_dtkcommon.pri DESTINATION "${MKSPECS_INSTALL_DIR}/modules")
install(FILES schemas/com.deepin.dtk.gschema.xml DESTINATION "${CMAKE_INSTALL_DATAROOTDIR}/glib-2.0/schemas")
install(DIRECTORY features DESTINATION "${MKSPECS_INSTALL_DIR}" FILES_MATCHING PATTERN "*" )
install(DIRECTORY cmake DESTINATION "${CMAKE_INSTALL_LIBDIR}" FILES_MATCHING  PATTERN "*" )
