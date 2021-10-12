foreach(module ${Dtk_FIND_COMPONENTS})
    find_package(Dtk${module})
endforeach()

include("${CMAKE_CURRENT_LIST_DIR}/DtkInstallDConfigConfig.cmake")
