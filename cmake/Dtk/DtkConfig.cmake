# SPDX-FileCopyrightText: 2022 Uniontech Software Technology Co.,Ltd.
#
# SPDX-License-Identifier: GPL-3.0-or-later

foreach(module ${Dtk_FIND_COMPONENTS})
    find_package(Dtk${module})
endforeach()

include("${CMAKE_CURRENT_LIST_DIR}/DtkInstallDConfigConfig.cmake")
