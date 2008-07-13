#*************************************************************************
#
#   OpenOffice.org - a multi-platform office productivity suite
#
#   $RCSfile: makefile.mk,v $
#
#   $Revision: 1.2 $
#
#   last change: $Author: mox $ $Date: 2008-07-13 11:34:49 $
#
#   The Contents of this file are made available subject to
#   the terms of GNU Lesser General Public License Version 2.1.
#
#
#     GNU Lesser General Public License Version 2.1
#     =============================================
#     Copyright 2005 by Sun Microsystems, Inc.
#     901 San Antonio Road, Palo Alto, CA 94303, USA
#
#     This library is free software; you can redistribute it and/or
#     modify it under the terms of the GNU Lesser General Public
#     License version 2.1, as published by the Free Software Foundation.
#
#     This library is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#     Lesser General Public License for more details.
#
#     You should have received a copy of the GNU Lesser General Public
#     License along with this library; if not, write to the Free Software
#     Foundation, Inc., 59 Temple Place, Suite 330, Boston,
#     MA  02111-1307  USA
#
#*************************************************************************

PRJ=..

PRJNAME=cairo
TARGET=so_cairo

# --- Settings -----------------------------------------------------

.INCLUDE :	settings.mk

.IF  "$(ENABLE_CAIRO)" == ""
all:
        @echo "Nothing to do (Cairo not enabled)."

.ELIF "$(SYSTEM_CAIRO)" == "YES"
all:
    @echo "Nothing to do, using system cairo."

.ELIF "$(BUILD_CAIRO)" == ""
all:
       @echo "Not building cairo from source, prebuilt binaries will be used."

.ENDIF

# --- Files --------------------------------------------------------

CAIROVERSION=1.6.4

TARFILE_NAME=$(PRJNAME)-$(CAIROVERSION)
#PATCH_FILE_NAME=$(TARFILE_NAME).patch

cairo_CFLAGS=-I$(SOLARINCDIR)
cairo_LDFLAGS=-L$(SOLARLIBDIR)

# pixman is in this module
pixman_CFLAGS=-I$(SRC_ROOT)$/$(PRJNAME)$/$(INPATH)$/inc
pixman_LIBS=-L$(SRC_ROOT)$/$(PRJNAME)$/$(INPATH)$/lib -lpixman-1

.IF "$(OS)"=="WNT"
# --------- Windows -------------------------------------------------
.IF "$(COM)"=="GCC"
CONFIGURE_DIR=
CONFIGURE_ACTION=.$/configure
CONFIGURE_FLAGS=--enable-static=no --build=i586-pc-mingw32 --host=i586-pc-mingw32 CFLAGS="$(cairo_CFLAGS) -D_MT" LDFLAGS="$(cairo_LDFLAGS) pixman_CFLAGS="$(pixman_CFLAGS)" pixman_LIBS="$(pixman_LIBS)" -no-undefined -L$(ILIB:s/;/ -L/)" LIBS="-lmingwthrd" ZLIB3RDLIB=$(ZLIB3RDLIB) OBJDUMP="$(WRAPCMD) objdump"
BUILD_ACTION=$(GNUMAKE)
BUILD_FLAGS+= -j$(EXTMAXPROCESS)
BUILD_DIR=$(CONFIGURE_DIR)
.IF "$(GUI)$(COM)"=="WNTGCC"
.EXPORT : PWD
.ENDIF

.ELSE   # WNT, not GCC
CONFIGURE_DIR=win32
CONFIGURE_ACTION=cscript configure.js
.IF "$(debug)"!=""
CONFIGURE_FLAGS+=debug=yes
.ENDIF
BUILD_ACTION=nmake
BUILD_DIR=$(CONFIGURE_DIR)
.ENDIF

OUT2INC+=src$/cairo-win32.h

.ELIF "$(GUIBASE)"=="aqua"
# ----------- Native Mac OS X (Aqua/Quartz) --------------------------------
CONFIGURE_DIR=
CONFIGURE_ACTION=cp $(SRC_ROOT)$/$(PRJNAME)$/cairo$/dummy_pkg_config . && .$/configure
CONFIGURE_FLAGS=--enable-static=no --disable-xlib --disable-freetype --disable-svg --disable-png --enable-quartz --enable-quartz-font --enable-gtk-doc=no --enable-test-surfaces=no PKG_CONFIG=./dummy_pkg_config CFLAGS="$(cairo_CFLAGS)" LDFLAGS="$(cairo_LDFLAGS)" pixman_CFLAGS="$(pixman_CFLAGS)" pixman_LIBS="$(pixman_LIBS)" ZLIB3RDLIB=$(ZLIB3RDLIB)
BUILD_ACTION=$(GNUMAKE)
BUILD_FLAGS+= -j$(EXTMAXPROCESS)
BUILD_DIR=$(CONFIGURE_DIR)

OUT2INC+=src$/cairo-quartz.h

.ELSE
# ----------- Unix ---------------------------------------------------------
.IF "$(OS)$(COM)"=="LINUXGCC" || "$(OS)$(COM)"=="FREEBSDGCC"
LDFLAGS:=-Wl,-rpath,'$$$$ORIGIN:$$$$ORIGIN/../ure-link/lib' -Wl,-noinhibit-exec -Wl,-z,noexecstack
.ELIF "$(OS)$(COM)"=="SOLARISC52"
LDFLAGS:=-Wl,-R'$$$$ORIGIN:$$$$ORIGIN/../ure-link/lib'
.ELIF "$(OS)"=="MACOSX"      # X11 on Mac OS X
cairo_CFLAGS+=-I/usr/X11/include 
cairo_LDFLAGS+=-L/usr/X11/lib -lfontconfig -lXrender
.ENDIF  # "$(OS)$(COM)"=="LINUXGCC" || "$(OS)$(COM)"=="FREEBSDGCC"

.IF "$(SYSBASE)"!=""
cairo_CFLAGS+=-I$(SYSBASE)$/usr$/include -I$(SOLARINCDIR)$/external $(EXTRA_CFLAGS)
.IF "$(OS)"=="SOLARIS" || "$(OS)"=="LINUX"
LDFLAGS+=-L$(SYSBASE)$/lib -L$(SYSBASE)$/usr$/lib -L$(SOLARLIBDIR) -lpthread -ldl
.ENDIF
.ENDIF			# "$(SYSBASE)"!=""

.EXPORT: LDFLAGS

.IF "$(COMNAME)"=="sunpro5"
cairo_CFLAGS+=-xc99=none
.ENDIF

CONFIGURE_DIR=
CONFIGURE_ACTION=.$/configure
CONFIGURE_FLAGS=--enable-xlib --enable-freetype --disable-svg --disable-png --enable-gtk-doc=no --enable-test-surfaces=no --enable-static=no CFLAGS="$(cairo_CFLAGS)" LDFLAGS="$(cairo_LDFLAGS)" pixman_CFLAGS="$(pixman_CFLAGS)" pixman_LIBS="$(pixman_LIBS)" ZLIB3RDLIB=$(ZLIB3RDLIB)
.IF "$(OS)"=="MACOSX"      # X11 on Mac OS X
CONFIGURE_ACTION=cp $(SRC_ROOT)$/$(PRJNAME)$/cairo$/dummy_pkg_config . && .$/configure
CONFIGURE_FLAGS+=--disable-quartz --disable-quartz-font PKG_CONFIG=./dummy_pkg_config
.ENDIF
BUILD_ACTION=$(GNUMAKE)
BUILD_FLAGS+= -j$(EXTMAXPROCESS)
BUILD_DIR=$(CONFIGURE_DIR)

OUT2INC+=src$/cairo-xlib.h \
     src$/cairo-xlib-xrender.h

.ENDIF



# -------- All platforms --------------------------------------------



OUT2INC+=src$/cairo-deprecated.h \
     src$/cairo-features.h  \
     src$/cairo-pdf.h	\
     src$/cairo-ps.h	\
     src$/cairo.h

.IF "$(OS)"=="MACOSX"
OUT2LIB+=src$/.libs$/libcairo*.dylib
.ELIF "$(OS)"=="WNT"
.IF "$(COM)"=="GCC"
OUT2BIN+=src$/.libs$/*.a
OUT2BIN+=src$/.libs$/*.dll
.ELSE
OUT2LIB+=win32$/bin.msvc$/*.lib
OUT2BIN+=win32$/bin.msvc$/*.dll
.ENDIF
.ELSE
OUT2LIB+=src$/.libs$/libcairo.so*
.ENDIF

# --- Targets ------------------------------------------------------

.INCLUDE : set_ext.mk
.INCLUDE : target.mk
.INCLUDE : tg_ext.mk

