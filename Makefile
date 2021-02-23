ARCH = $(shell dpkg-architecture -qDEB_HOST_MULTIARCH)


features_files = features/dtk_module.prf \
				features/dtk_build_config.prf \
				features/dtk_lib.prf \
				features/dtk_qmake.prf \
				features/dtk_cmake.prf \
				features/dtk_build.prf \
				features/dtk_translation.prf

features_files_install_path = /usr/lib/$(ARCH)-linux-gnu/qt5/mkspecs/features


schemas_files = schemas/com.deepin.dtk.gschema.xml
schemas_files_install_path = /usr/share/glib-2.0/schemas/

confs_files = confs/com.deepin.dtk.FileDrag.conf
confs_files_install_path = /etc/dbus-1/system.d/

all: build

build:
	@echo build for arch: $(ARCH)

test: 
	@echo "Testing schemas with glib-compile-shemas..."
	@glib-compile-schemas --dry-run schemas

install:
	@echo install for arch:$(ARCH)
	@test -d $(DESTDIR)$(features_files_install_path) || mkdir -p $(DESTDIR)$(features_files_install_path)
	@test -d $(DESTDIR)$(schemas_files_install_path) || mkdir -p $(DESTDIR)$(schemas_files_install_path)
	@test -d $(DESTDIR)$(confs_files_install_path) || mkdir -p $(DESTDIR)$(confs_files_install_path)
	install -v -m 0644 $(schemas_files) $(DESTDIR)$(schemas_files_install_path)
	install -v -m 0644 $(confs_files) $(DESTDIR)$(confs_files_install_path)
	install -v -m 0644 $(features_files) $(DESTDIR)$(features_files_install_path)

uninstall:
	-rm -f $(DESTDIR)$(features_files_install_path)/dtk_module.prf
	-rm -f $(DESTDIR)$(features_files_install_path)/dtk_build_config.prf
	-rm -f $(DESTDIR)$(features_files_install_path)/dtk_lib.prf
	-rm -f $(DESTDIR)$(features_files_install_path)/dtk_qmake.prf
	-rm -f $(DESTDIR)$(features_files_install_path)/dtk_cmake.prf
	-rm -f $(DESTDIR)$(features_files_install_path)/dtk_build.prf
	-rm -f $(DESTDIR)$(features_files_install_path)/dtk_translation.prf
	-rm -f $(DESTDIR)$(confs_files_install_path)/com.deepin.dtk.FileDrag.conf
	-rm -f $(DESTDIR)$(schemas_files_install_path)/com.deepin.dtk.gschema.xml

