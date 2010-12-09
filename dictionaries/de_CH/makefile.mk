#*************************************************************************
#
# DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
# 
# Copyright 2000, 2010 Oracle and/or its affiliates.
#
# OpenOffice.org - a multi-platform office productivity suite
#
# This file is part of OpenOffice.org.
#
# OpenOffice.org is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License version 3
# only, as published by the Free Software Foundation.
#
# OpenOffice.org is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License version 3 for more details
# (a copy is included in the LICENSE file that accompanied this code).
#
# You should have received a copy of the GNU Lesser General Public License
# version 3 along with OpenOffice.org.  If not, see
# <http://www.openoffice.org/license.html>
# for a copy of the LGPLv3 License.
#
#*************************************************************************

PRJ=..

PRJNAME=dictionaries
TARGET=dict-de-ch

# --- Settings -----------------------------------------------------

.INCLUDE: settings.mk
# it might be useful to have an extension wide include to set things
# like the EXTNAME variable (used for configuration processing)
# .INCLUDE :  $(PRJ)$/source$/<extension name>$/<extension_name>.pmk

# --- Files --------------------------------------------------------

# name for uniq directory
EXTENSIONNAME:=dict-de-CH
EXTENSION_ZIPNAME:=dict-de-CH

# extension will be buiild in de_DE (see build.prj) and the
# dictionary.xcu from there will be used
#COMPONENT_COPYONLY=TRUE

# some other targets to be done

# --- Extension packaging ------------------------------------------

# just copy:
COMPONENT_FILES= \
    $(EXTENSIONDIR)$/COPYING_OASIS.txt \
    $(EXTENSIONDIR)$/COPYING_GPLv2.txt \
    $(EXTENSIONDIR)$/COPYING_LGPL_v2.0.txt \
    $(EXTENSIONDIR)$/COPYING_LGPL_v2.1.txt \
    $(EXTENSIONDIR)$/de_CH_frami.aff \
    $(EXTENSIONDIR)$/de_CH_frami.dic \
    $(EXTENSIONDIR)$/hyph_de_CH.dic \
    $(EXTENSIONDIR)$/README_de_CH_frami.txt \
    $(EXTENSIONDIR)$/README_extension_owner.txt \
    $(EXTENSIONDIR)$/README_hyph_de_CH.txt \
    $(EXTENSIONDIR)$/README_th_de_CH_v2.txt \
    $(EXTENSIONDIR)$/th_de_CH_v2.dat \
    $(EXTENSIONDIR)$/th_de_CH_v2.idx

COMPONENT_CONFIGDEST=.
COMPONENT_XCU= \
    $(EXTENSIONDIR)$/dictionaries.xcu

# disable fetching default OOo license text
CUSTOM_LICENSE=COPYING_GPLv3.txt
# override default license destination
PACKLICS= $(EXTENSIONDIR)$/$(CUSTOM_LICENSE)

# add own targets to packing dependencies (need to be done before
# packing the xtension
# EXTENSION_PACKDEPS=makefile.mk $(CUSTOM_LICENSE)
EXTENSION_PACKDEPS=$(COMPONENT_FILES)

# global settings for extension packing
.INCLUDE : extension_pre.mk
.INCLUDE : target.mk
# global targets for extension packing
.INCLUDE : extension_post.mk
