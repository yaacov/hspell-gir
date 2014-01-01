NULL = 

AM_CPPFLAGS = \
	$(HSPELL_GIR_CFLAGS) \
	-include $(CONFIG_HEADER) \
	$(NULL)

lib_LTLIBRARIES = libhspell_gir.la

include_HEADERS = hspell-gir.h

libhspell_gir_la_VALAFLAGS = --library hspell-gir \
	 --pkg hspell --pkg linginfo --vapidir=../vapi \
	-H hspell-gir.h --vapi=../vapi/hspell-gir.vapi

libhspell_gir_la_SOURCES = \
	hspell-gir.vala \
	$(NULL)

libhspell_gir_la_LIBADD = \
	 -lm -lz -lhspell \
	$(HSPELL_GIR_LIBS) \
	$(NULL)

EXTRA_DIST = \
	$(NULL)

DISTCLEANFILES = \
	$(NULL)

CLEANFILES = \
	$(NULL)

-include $(INTROSPECTION_MAKEFILE)
INTROSPECTION_GIRS =
INTROSPECTION_SCANNER_ARGS = --add-include-path=$(srcdir)
INTROSPECTION_COMPILER_ARGS = --includedir=$(srcdir)

if HAVE_INTROSPECTION
introspection_sources = $(libhspell_gir_la_SOURCES) hspell-gir.h hspell-gir.c

LibHspell-1.0.gir: libhspell_gir.la
LibHspell_1_0_gir_INCLUDES = GObject-2.0
LibHspell_1_0_gir_CFLAGS = $(INCLUDES)
LibHspell_1_0_gir_LIBS = libhspell_gir.la
LibHspell_1_0_gir_FILES = $(introspection_sources)
LibHspell_1_0_gir_NAMESPACE = LibHspell
INTROSPECTION_GIRS += LibHspell-1.0.gir

girdir = $(datadir)/gir-1.0
gir_DATA = $(INTROSPECTION_GIRS)

typelibdir = $(libdir)/girepository-1.0
typelib_DATA = $(INTROSPECTION_GIRS:.gir=.typelib)

CLEANFILES += $(gir_DATA) $(typelib_DATA)
endif


