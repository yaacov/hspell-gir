NULL = 

#Build in these directories:

DISTCHECK_CONFIGURE_FLAGS = --enable-introspection

SUBDIRS = \
	src \
	examples \
	examples/hspell-gui \
	vapi \
	$(NULL)

pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = hspell-gir.pc

hspell_girdocdir = ${prefix}/doc/hspell_gir
hspell_girdoc_DATA = \
	ChangeLog \
	README \
	COPYING \
	AUTHORS \
	INSTALL \
	NEWS\
	$(NULL)

EXTRA_DIST = \
	$(libhdate_glibdoc_DATA) \
	hspell-gir.pc.in \
	$(NULL)

DISTCLEANFILES = \
	$(NULL)

