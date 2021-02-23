PREFIX	:= /usr
ARCH    := x86

all: build

build: cfgs
	@echo build for arch: $(ARCH)
	mkdir -p result
	find schemas -name "*.xml" -exec cp {} result \;
	find confs -name "*.conf" -exec cp {} result \;

test: 
	@echo "Testing schemas with glib-compile-shemas..."
	glib-compile-schemas --dry-run result

install:
	@echo install for arch:$(ARCH)
	mkdir -p $(DESTDIR)$(PREFIX)/share/glib-2.0/schemas
	install -v -m 0644 result/*.xml $(DESTDIR)$(PREFIX)/share/glib-2.0/schemas/
	mkdir -p $(DESTDIR)/etc/dbus-1/system.d/
	install -v -m 0644 result/*.conf $(DESTDIR)/etc/dbus-1/system.d/

clean:
	-rm -rf result

.PHONY: cfgs
