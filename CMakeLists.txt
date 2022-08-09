cmake_minimum_required(VERSION 3.10)
include(GNUInstallDirs)
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
message(${PROJECT_VERSION})
set(LINUXNAME "debian")
option(LINUXNAME "linuxname" "debian")
set(SPECPATH "qt5/mkspecs/")

if (${LINUXNAME} STREQUAL "archlinux")
  set(SPECPATH "qt/mkspecs/")
  message("arch")
endif()
set(MODULE_INCLUDES ${CMAKE_INSTALL_LIBDIR}/libdtk-${PROJECT_VERSION_MAJOR})
set(CONFIGUREFILE 
  "QT.${PROJECT_NAME}.VERSION = ${PROJECT_VERSION}\n"
  "QT.${PROJECT_NAME}.MAJOR_VERSION = ${PROJECT_VERSION_MAJOR}\n"
  "QT.${PROJECT_NAME}.MINOR_VERSION = ${PROJECT_VERSION_MINOR}\n"
  "QT.${PROJECT_NAME}.PATCH_VERSION = ${PROJECT_VERSION_PATCH}\n"
  "QT.${PROJECT_NAME}.name = dtkcommon\n"
  "QT.${PROJECT_NAME}.module = dtkcommon\n"
  "QT.${PROJECT_NAME}.tools = ${MODULE_INCLUDES}\n"
  "QT.${PROJECT_NAME}.libs = ${CMAKE_INSTALL_LIBDIR}\n"
  "QT.${PROJECT_NAME}.includes = ${MODULE_INCLUDES}\n"
  "QT.${PROJECT_NAME}.frameworks = \n"
  "QT.${PROJECT_NAME}.depends = xml\n"
  "QT.${PROJECT_NAME}.module_config = v2\n"
  "QT.${PROJECT_NAME}.DEFINES = \n"
  "QT_MODULES += "
)

file(WRITE qt_lib_dtkcommon.pri ${CONFIGUREFILE})

install(FILES qt_lib_dtkcommon.pri DESTINATION "${CMAKE_INSTALL_LIBDIR}/${SPECPATH}/modules")
install(FILES schemas/com.deepin.dtk.gschema.xml DESTINATION "${CMAKE_INSTALL_DATAROOTDIR}/glib-2.0/schemas")
install(DIRECTORY features DESTINATION "${CMAKE_INSTALL_LIBDIR}/${SPECPATH}" FILES_MATCHING PATTERN "*" )
install(DIRECTORY cmake DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/Dtk/" FILES_MATCHING  PATTERN "*" )

