TEMPLATE = app
CONFIG += console c++11
CONFIG -= app_bundle
CONFIG -= qt

SOURCES += \
        main.cpp

isEmpty(PREFIX){
    PREFIX = /usr
}

ARCH=$$system(dpkg-architecture -qDEB_HOST_MULTIARCH)

defineTest(checkDtkVersion) {
    isEmpty(VERSION) {
        isEmpty(VERSION): VERSION = $$system(git describe --tags --abbrev=0)
        isEmpty(VERSION): VERSION = 5.4.5
        isEmpty(VERSION): return(false)
        VERSION = $$replace(VERSION, [^0-9.],)
    }
    export(VERSION)
    return(true)
}

!checkDtkVersion():error("check dtk version failed")
message("build version : $$VERSION")

ver_list = $$split(VERSION, .)

isEmpty(VER_MAJ) {
    VER_MAJ = $$first(ver_list)
}
isEmpty(VER_MIN) {
    VER_MIN = $$member(ver_list, 1, 1)
    isEmpty(VER_MIN):VER_MIN = 0
}
isEmpty(VER_PAT) {
    VER_PAT = $$member(ver_list, 2, 2)
    isEmpty(VER_PAT):VER_PAT = 0
}
isEmpty(VER_BUI) {
    VER_BUI = $$member(ver_list, 3, 3)
    isEmpty(VER_BUI):VER_BUI = 0
}

mod_inst_pfx=$$_PRO_FILE_PWD_
MODULE_PRI = $$mod_inst_pfx/qt_lib_dtkcommon.pri
module_libs = $$PREFIX/lib/$$ARCH
module_tools = $$PREFIX/lib/$$ARCH/libdtk-$$VERSION
MODULE_INCLUDES = $$PREFIX/include/libdtk-$$VERSION

# Create a module .pri file

MODULE_ID=dtkcommon
MODULE_PRI_CONT += \
    "QT.$${MODULE_ID}.VERSION = $${VERSION}" \
    "QT.$${MODULE_ID}.MAJOR_VERSION = $${VER_MAJ}" \
    "QT.$${MODULE_ID}.MINOR_VERSION = $${VER_MIN}" \
    "QT.$${MODULE_ID}.PATCH_VERSION = $${VER_PAT}" \
    "" \
    "QT.$${MODULE_ID}.name = $${MODULE_ID}" \
    "QT.$${MODULE_ID}.module = dtkcommon" \
    "QT.$${MODULE_ID}.tools = $$module_tools" \
    "QT.$${MODULE_ID}.libs = $$module_libs" \
    "QT.$${MODULE_ID}.includes = $$MODULE_INCLUDES" \
    "QT.$${MODULE_ID}.frameworks = "

MODULE_PRI_CONT += \
    "QT.$${MODULE_ID}.depends = xml" \
    "QT.$${MODULE_ID}.module_config = v2" \
    "QT.$${MODULE_ID}.DEFINES = " \
    "" \
    "QT_MODULES += "

write_file($$MODULE_PRI, MODULE_PRI_CONT)|error("Aborting.")


prf.files = features/dtk_lib.prf \
             features/dtk_testcase.prf \
             features/dtk_module.prf \
             features/dtk_build.prf \
             features/dtk_translation.prf \
             features/dtk_build_config.prf \
             features/dtk_cmake.prf \
             features/dtk_qmake.prf

prf.path = $$PREFIX/lib/$$ARCH/qt5/mkspecs/features


cmake_dtk.files = cmake/Dtk/DtkConfig.cmake
cmake_dtk.path = $$PREFIX/lib/$(ARCH)/cmake/Dtk

cmake_dtkcmake.files = cmake/DtkCMake/DtkCMakeConfig.cmake
cmake_dtkcmake.path = $$PREFIX/lib/$$ARCH/cmake/DtkCMake

cmake_dtkcmaketools.files = cmake/DtkTools/DtkSettingsToolsMacros.cmake \
                            cmake/DtkTools/DtkToolsConfig.cmake
cmake_dtkcmaketools.path = $$PREFIX/lib/$$ARCH/cmake/DtkTools

dtkcommon_module.files = $$MODULE_PRI
dtkcommon_module.path = $$PREFIX/lib/$$ARCH/qt5/mkspecs/modules


INSTALLS += prf cmake_dtk cmake_dtkcmaketools dtkcommon_module
