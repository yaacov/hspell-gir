AC_INIT([hspell-gir], [0.3.0], [kobi.zamir@gmail.com], [hspell-gir])
AC_CONFIG_SRCDIR([Makefile.am])
AC_CONFIG_HEADERS(config.h)
AM_INIT_AUTOMAKE([dist-bzip2])
AM_MAINTAINER_MODE
 
AC_PROG_CC
AM_PROG_CC_C_O
AC_DISABLE_STATIC
AC_PROG_LIBTOOL

AC_PATH_PROG(VALAC, valac, valac)
AC_SUBST(VALAC)

AC_SUBST(CFLAGS)
AC_SUBST(CPPFLAGS)
AC_SUBST(LDFLAGS)

GLIB_REQUIRED=2.12.0

AC_ARG_WITH(vala-pkg,
	[AS_HELP_STRING([--with-vala-pkg=PKG],
	[vala pkg-config package])])

if test "$with_vala_pkg" = "" ; then
	VALA_PKG="libvala-0.18"
else
	VALA_PKG=$with_vala_pkg
fi

PKG_CHECK_MODULES(HSPELL_GIR, $VALA_PKG glib-2.0 >= $GLIB_REQUIRED gobject-2.0 >= $GLIB_REQUIRED)
AC_SUBST(HSPELL_GIR_CFLAGS)

GOBJECT_INTROSPECTION_CHECK([0.6.7])

VAPIDIR=`pkg-config --variable=vapidir $VALA_PKG`
AC_SUBST(VAPIDIR)

AC_CONFIG_FILES([Makefile
	hspell-gir.pc
	examples/Makefile
	examples/hspell-gui/Makefile
	vapi/Makefile
	src/Makefile])

AC_OUTPUT

echo 
echo "hspell-gir"
echo 
echo "vala package:        " $VALA_PKG
echo "found introspection: " ${found_introspection}

