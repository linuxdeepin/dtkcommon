# This cmake file is used to deploy files that dconfig's meta and override configure.

include(CMakeParseArguments)

# get subpath according `FILE` and `BASE`.
# e.g: FILE = /a/b/c/d/foo.json, BASE = /a/b, then return SUBPATH = /c/d/
function(GET_SUBPATH FILE BASE SUBPATH)
    get_filename_component(BASE_FILE_PATH ${BASE} REALPATH)
    get_filename_component(FILE_PATH ${FILE} REALPATH)
    string(REGEX REPLACE ${BASE_FILE_PATH} "" SUBPATH_FILE_NAME ${FILE_PATH})
    get_filename_component(SUBPATH_PATH ${SUBPATH_FILE_NAME} DIRECTORY)

    set(${SUBPATH} ${SUBPATH_PATH} PARENT_SCOPE)
endfunction()


# deploy some `meta` 's configure.
#
# option USE_OPT_DIR   - using uos standard to install destination directory.
# FILES       - deployed files.
# BASE        - used to get subpath, if it's empty, only copy files, and ignore it's subpath structure.
# APPID       - working for the app.
# COMMONID    - working for common.
#
# e.g:
# dconfig_meta_files(APPID dconfigexample BASE ./configs FILES ./configs/example.json ./configs/a/example.json)
#
function(DCONFIG_META_FILES)
    set(options USE_OPT_DIR)
    set(oneValueArgs BASE APPID COMMONID)
    set(multiValueArgs FILES)

    cmake_parse_arguments(METAITEM "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    if(DEFINED ENV{DSG_DATA_DIR})
        set(DSG_DATA_DIR $ENV{DSG_DATA_DIR})
    else()
        set(DSG_DATA_DIR "/usr/share/dsg")
    endif()

    foreach(_current_FILE ${METAITEM_FILES})
        set(SUBPATH "")
        if (DEFINED METAITEM_BASE)
            GET_SUBPATH(${_current_FILE} ${METAITEM_BASE} SUBPATH)
        endif()

        if (DEFINED METAITEM_APPID)
            if (${METAITEM_USE_OPT_DIR} STREQUAL "TRUE")
                install(FILES "${_current_FILE}" DESTINATION /opt/apps/${METAITEM_APPID}/files/schemas/configs/${SUBPATH})
            else()
                install(FILES "${_current_FILE}" DESTINATION /usr/share/dsg/apps/${METAITEM_APPID}/configs/${SUBPATH})
            endif()
        elseif (DEFINED METAITEM_COMMONID)
            install(FILES ${_current_FILE} DESTINATION ${DSG_DATA_DIR}/configs/${SUBPATH})
        else()
            message(FATAL_ERROR "Please set APPID or COMMONID for the meta item." ${_current_FILE})
        endif()
    endforeach()
endfunction()


# deploy some `meta` 's override configure.
#
# configuration for the `meta_name` 's  override configure.
#
# FILES       - deployed files.
# BASE        - used to get subpath, if it's empty, only copy files, and ignore it's subpath structure.
# APPID       - working for the app, if it's empty, working for all app.
# META_NAME   - override for the meta configure.
#
# e.g :
#dconfig_override_files(APPID dconfigexample BASE ./configs META_NAME example  FILES ./configs/dconf-example.override.json ./configs/a/dconf-example.override.a.json)
#
function(DCONFIG_OVERRIDE_FILES)
    set(options)
    set(oneValueArgs BASE APPID META_NAME)
    set(multiValueArgs FILES)

    cmake_parse_arguments(OVERRIDEITEM "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    if (NOT DEFINED OVERRIDEITEM_META_NAME)
        message(FATAL_ERROR "Please set meta_name for the override configuration." ${FILES})
    endif()

    if(DEFINED ENV{DSG_DATA_DIR})
        set(DSG_DATA_DIR $ENV{DSG_DATA_DIR})
    else()
        set(DSG_DATA_DIR "/usr/share/dsg")
    endif()

    foreach(_current_FILE ${OVERRIDEITEM_FILES})
        set(SUBPATH "")
        if (DEFINED OVERRIDEITEM_BASE)
            GET_SUBPATH(${_current_FILE} ${OVERRIDEITEM_BASE} SUBPATH)
        endif()

        if (DEFINED OVERRIDEITEM_APPID)
            install(FILES "${_current_FILE}" DESTINATION ${DSG_DATA_DIR}/configs/overrides/${OVERRIDEITEM_APPID}/${OVERRIDEITEM_META_NAME}/${SUBPATH})
        else()
            install(FILES "${_current_FILE}" DESTINATION ${DSG_DATA_DIR}/configs/overrides/${OVERRIDEITEM_META_NAME}/${SUBPATH})
        endif()
    endforeach()
endfunction()
