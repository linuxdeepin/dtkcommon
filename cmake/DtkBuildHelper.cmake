# SPDX-FileCopyrightText: 2023 Uniontech Software Technology Co.,Ltd.
#
# SPDX-License-Identifier: BSD-3-Clause

include(CMakeParseArguments)

# generate dtk moudule config header file.
#
# MODULE_NAME   - module name.  ${MODULE_NAME}_config.h
# DEST_DIR      - used to get header file dest path, if it's empty, ${CMAKE_CURRENT_SOURCE_DIR} is used.
# HEADERS       - header files without .h extension. 
# EXT_CONTENTS  - extra contents strings.  
#
# e.g:
# set(VERSION_DEC "#define DTK_VERSION_MAJOR 5"
#                 "#define DTK_VERSION_MINOR 5"
#                 "#define DTK_VERSION_PATCH 23"
#                 "#define DTK_VERSION_BUILD 0"
#                 "#define DTK_VERSION_STR \"5.5.23\"\n")
# set(HEADERS ./DConfig ./DConfigFile ./DLog ./DObject)
# dtk_gen_config_header(MODULE_NAME dtkcore 
#                  DEST_DIR include/global
#                  HEADERS ${HEADERS}
#                  EXT_CONTENTS  ${VERSION_DEC})
#
#    filename: ${CMAKE_CURRENT_SOURCE_DIR}/include/global/dtkcore_config.h
#    ==== file content begin ====
#    // SPDX-FileCopyrightText: 2022 UnionTech Software Technology Co., Ltd.
#    //
#    // SPDX-License-Identifier: LGPL-3.0-or-later
#
#    #define DTK_VERSION_MAJOR 5
#    #define DTK_VERSION_MINOR 5
#    #define DTK_VERSION_PATCH 23
#    #define DTK_VERSION_BUILD 0
#    #define DTK_VERSION_STR "5.5.23"
#
#    #define DTKCORE_CLASS_DConfig
#    #define DTKCORE_CLASS_DConfigFile
#    #define DTKCORE_CLASS_DLog
#    #define DTKCORE_CLASS_DObject
#    ==== file content end ====
#
function(dtk_gen_config_header)
    set(oneValueArgs MODULE_NAME DEST_DIR OUTPUT_VARIABLE)
    set(multiValueArgs HEADERS EXT_CONTENTS)

    cmake_parse_arguments(_CONFIG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    if (DEFINED _CONFIG_MSG)
        message("MODULE_NAME: ${_CONFIG_MODULE_NAME}\n"
                "DEST_DIR: ${_CONFIG_DEST_DIR}\n"
                "HEADERS: ${_CONFIG_HEADERS}\n")
    endif()

    set(config_file_path ${CMAKE_CURRENT_SOURCE_DIR})
    if (DEFINED _CONFIG_DEST_DIR)
        set(config_file_path ${_CONFIG_DEST_DIR})
    endif()

    if (DEFINED _CONFIG_MODULE_NAME)
        string(APPEND config_file_path /${_CONFIG_MODULE_NAME}_config.h)
        message("generate file path:" ${config_file_path})
    else()
        message(FATAL_ERROR \"MODULE_NAME needs to be defined when calling dtk_gen_config_header\")
    endif()

    set(LICENSE_DEC 
    "// SPDX-FileCopyrightText: 2023 UnionTech Software Technology Co., Ltd.\n"
    "//\n"
    "// SPDX-License-Identifier: LGPL-3.0-or-later\n"
    "\n")

    file(WRITE ${config_file_path} ${LICENSE_DEC})

    foreach(_ext_content ${_CONFIG_EXT_CONTENTS})
        file(APPEND ${config_file_path} "${_ext_content}\n")
    endforeach()

    foreach(_head_file ${_CONFIG_HEADERS})
        get_filename_component(classname ${_head_file} NAME)
        string(TOUPPER ${_CONFIG_MODULE_NAME} _UP_MODULE_NAME)
        file(APPEND ${config_file_path} "#define ${_UP_MODULE_NAME}_CLASS_${classname}\n")
    endforeach()

    set(${_CONFIG_OUTPUT_VARIABLE} ${config_file_path} PARENT_SCOPE)
endfunction()

# turn on coverage test
function(dtk_setup_code_coverage TARGET)
    if (CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
        target_compile_options(${TARGET} PRIVATE -fprofile-instr-generate -ftest-coverage)
    elseif (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
        target_compile_options(${TARGET} PRIVATE -fprofile-arcs -ftest-coverage)
    endif()
    target_link_libraries(${TARGET} PRIVATE gcov)
endfunction()

# set(OPT1 ON)
# set(defs DEF1 DEF2 DEF3)
# cmake -DDEF1=xxx1 -DDEF2=xxx2
#
# dtk_check_and_add_definitions(OPTIONS OPT1 OPT_NOT_EXISTED ${TARGET} DEFS ${defs})
#
# target_compile_definitions(${TARGET} PRIVATE -DOPT1)
# target_compile_definitions(${TARGET} PRIVATE -DDEF1=xxx1)
# target_compile_definitions(${TARGET} PRIVATE -DDEF2=xxx2)
#
function(dtk_check_and_add_definitions TARGET)
    cmake_parse_arguments(ARGV
        ""
        ""
        "OPTIONS;DEFS"
        ${ARGN}
    )

    foreach(opt ${ARGV_OPTIONS})
        if (${opt})
            target_compile_definitions(${TARGET} PRIVATE -D${opt})
        endif()
    endforeach()

    foreach(def ${ARGV_DEFS})
        list(APPEND DEFINITIONS ${def})
    endforeach()

    foreach(def ${DEFINITIONS})
        if (${def})
            target_compile_definitions(${TARGET} PRIVATE -D${def}=${${def}})
        endif()
    endforeach()
endfunction()
