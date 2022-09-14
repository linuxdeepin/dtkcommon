# SPDX-FileCopyrightText: 2022 Uniontech Software Technology Co.,Ltd.
#
# SPDX-License-Identifier: BSD-3-Clause

cmake_minimum_required(VERSION 3.10)
#set(DVERSION "5.5.22")
option(DVERSION "define project version" "5.5.22")
if(DVERSION)
  project(dtkcommon
    VERSION ${DVERSION}
  )
else()
  project(dtkcommon
    VERSION "5.5.23"
  )
endif()
include(GNUInstallDirs)
message(${PROJECT_VERSION})
set(LINUXNAME "debian")
option(LINUXNAME "linuxname" "debian")
set (MKSPECS_INSTALL_DIR "${CMAKE_INSTALL_FULL_LIBDIR}/qt5/mkspecs" CACHE STRING "INSTALL DIR FOR qt pri files")

set(SPECPATH "qt5/mkspecs/")

if (${LINUXNAME} STREQUAL "archlinux")
  set(SPECPATH "qt/mkspecs/")
  message("arch")
endif()
set(MODULE_INCLUDES ${CMAKE_INSTALL_FULL_INCLUDEDIR}/libdtk-${PROJECT_VERSION})
set(MODULE_TOOLS ${CMAKE_INSTALL_FULL_LIBDIR}/libdtk-${PROJECT_VERSION})
configure_file(misc/qt_lib_dtkcommon.pri.in qt_lib_dtkcommon.pri @ONLY)

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/qt_lib_dtkcommon.pri DESTINATION "${MKSPECS_INSTALL_DIR}/modules")
install(FILES schemas/com.deepin.dtk.gschema.xml DESTINATION "${CMAKE_INSTALL_DATAROOTDIR}/glib-2.0/schemas")
install(DIRECTORY features DESTINATION "${MKSPECS_INSTALL_DIR}" FILES_MATCHING PATTERN "*" )
install(DIRECTORY cmake DESTINATION "${CMAKE_INSTALL_LIBDIR}" FILES_MATCHING  PATTERN "*" )

