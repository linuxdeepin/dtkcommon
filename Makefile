ARCH = $(shell dpkg-architecture -qDEB_HOST_MULTIARCH)


features_files = features/dtk_module.prf \
				features/dtk_build_config.prf \
				features/dtk_lib.prf \
				features/dtk_qmake.prf \
				features/dtk_cmake.prf \
				features/dtk_build.prf \
				features/dtk_translation.prf \
				features/dtk_testcase.prf

features_files_install_path = /usr/lib/$(ARCH)/qt5/mkspecs/features


schemas_files = schemas/com.deepin.dtk.gschema.xml
schemas_files_install_path = /usr/share/glib-2.0/schemas/

confs_files = confs/com.deepin.dtk.FileDrag.conf
confs_files_install_path = /etc/dbus-1/system.d/

cmake_dtk_files = cmake/Dtk/DtkConfig.cmake
cmake_dtk_files_install_path = /usr/lib/$(ARCH)/cmake/Dtk

cmake_dtkcmake_files = cmake/DtkCMake/DtkCMakeConfig.cmake
cmake_dtkcmake_files_install_path = /usr/lib/$(ARCH)/cmake/DtkCMake

cmake_dtkcmaketools_files = cmake/DtkTools/DtkSettingsToolsMacros.cmake \
                            cmake/DtkTools/DtkToolsConfig.cmake
cmake_dtkcmaketools_files_install_path = /usr/lib/$(ARCH)/cmake/DtkTools

dtkcommon_module_files = qt_lib_dtkcommon.pri
dtkcommon_module_files_install_path = /usr/lib/$(ARCH)/qt5/mkspecs/modules

all: build

build:
	@echo build for arch: $(ARCH)
	@/bin/bash write_dtkcommon_module.sh


.PHONY:clean test

test: 
	@echo "Testing schemas with glib-compile-shemas..."
	@glib-compile-schemas --dry-run schemas

install: all
	@echo install for arch:$(ARCH)
	@test -d $(DESTDIR)$(features_files_install_path) || mkdir -p $(DESTDIR)$(features_files_install_path)
	@test -d $(DESTDIR)$(schemas_files_install_path) || mkdir -p $(DESTDIR)$(schemas_files_install_path)
	@test -d $(DESTDIR)$(confs_files_install_path) || mkdir -p $(DESTDIR)$(confs_files_install_path)
	@test -d $(DESTDIR)$(cmake_dtk_files_install_path) || mkdir -p $(DESTDIR)$(cmake_dtk_files_install_path)
	@test -d $(DESTDIR)$(cmake_dtkcmake_files_install_path) || mkdir -p $(DESTDIR)$(cmake_dtkcmake_files_install_path)
	@test -d $(DESTDIR)$(cmake_dtkcmaketools_files_install_path) || mkdir -p $(DESTDIR)$(cmake_dtkcmaketools_files_install_path)
	@test -d $(DESTDIR)$(dtkcommon_module_files_install_path) || mkdir -p $(DESTDIR)$(dtkcommon_module_files_install_path)
	install -v -m 0644 $(schemas_files) $(DESTDIR)$(schemas_files_install_path)
	install -v -m 0644 $(confs_files) $(DESTDIR)$(confs_files_install_path)
	install -v -m 0644 $(features_files) $(DESTDIR)$(features_files_install_path)
	install -v -m 0644 $(cmake_dtk_files) $(DESTDIR)$(cmake_dtk_files_install_path)
	install -v -m 0644 $(cmake_dtkcmake_files) $(DESTDIR)$(cmake_dtkcmake_files_install_path)
	install -v -m 0644 $(cmake_dtkcmaketools_files) $(DESTDIR)$(cmake_dtkcmaketools_files_install_path)
	install -v -m 0644 $(dtkcommon_module_files) $(DESTDIR)$(dtkcommon_module_files_install_path)

uninstall:
	-rm -f $(DESTDIR)$(features_files_install_path)/dtk_module.prf
	-rm -f $(DESTDIR)$(features_files_install_path)/dtk_build_config.prf
	-rm -f $(DESTDIR)$(features_files_install_path)/dtk_lib.prf
	-rm -f $(DESTDIR)$(features_files_install_path)/dtk_qmake.prf
	-rm -f $(DESTDIR)$(features_files_install_path)/dtk_cmake.prf
	-rm -f $(DESTDIR)$(features_files_install_path)/dtk_build.prf
	-rm -f $(DESTDIR)$(features_files_install_path)/dtk_translation.prf
	-rm -f $(DESTDIR)$(features_files_install_path)/dtk_testcase.prf
	-rm -f $(DESTDIR)$(confs_files_install_path)/com.deepin.dtk.FileDrag.conf
	-rm -f $(DESTDIR)$(schemas_files_install_path)/com.deepin.dtk.gschema.xml
	-rm -f $(DESTDIR)$(dtkcommon_module_files_install_path)/qt_lib_dtkcommon.pri

clean:
	-rm -f qt_lib_dtkcommon.pri
