# SPDX-FileCopyrightText: 2022 Uniontech Software Technology Co.,Ltd.
#
# SPDX-License-Identifier: BSD-3-Clause

foreach(module ${Dtk_FIND_COMPONENTS})
    find_package(Dtk${module})
endforeach()

include("${CMAKE_CURRENT_LIST_DIR}/DtkInstallDConfigConfig.cmake")
