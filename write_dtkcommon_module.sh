#! /bin/bash

# 通过仓库的tag获取版本号

readonly version_val=$(git describe --tags --abbrev=0)
readonly major_version=$(echo $version_val | awk -F'.' '{print $1}')
readonly minor_version=$(echo $version_val | awk -F'.' '{print $2}')
readonly patch_version=$(echo $version_val | awk -F'.' '{print $3}')
readonly arch=$(dpkg-architecture -qDEB_HOST_MULTIARCH)
# 写dtkcommon 模块文件
echo "write qt_lib_dtkcommon.pri file ............."

cat << EOF > qt_lib_dtkcommon.pri
QT.dtkcommon.VERSION = $version_val
QT.dtkcommon.MAJOR_VERSION = $major_version
QT.dtkcommon.MINOR_VERSION = $minor_version
QT.dtkcommon.PATCH_VERSION = $patch_version
QT.dtkcommon.name = dtkcommon
QT.dtkcommon.module = dtkcommon
QT.dtkcommon.tools = /usr/lib/$arch/libdtk-${version_val}
QT.dtkcommon.libs = /usr/lib/$arch
QT.dtkcommon.includes = /usr/include/libdtk-${version_val}
QT.dtkcommon.frameworks =
QT.dtkcommon.depends =
QT.dtkcommon.module_config = v2
QT.dtkcommon.DEFINES =
QT_MODULES +=
EOF


