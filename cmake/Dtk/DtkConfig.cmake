# SPDX-FileCopyrightText: 2022 Uniontech Software Technology Co.,Ltd.
#
# SPDX-License-Identifier: BSD-3-Clause
include(CMakeFindDependencyMacro)
foreach(module ${Dtk_FIND_COMPONENTS})
    find_dependency(Dtk${module})
endforeach()
