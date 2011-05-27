# vim: ts=8 noet ft=make

!include mk/common-values.mk

PREFIX=.\stage
LIBDIR=$(PREFIX)\lib
INCDIR=$(PREFIX)\include
BOOST_INCDIR=
BOOST_LIBDIR=
PATH=$(BOOST_LIBDIR);$(PATH)
CXXFLAGS=/nologo /EHsc /MD /I$(BOOST_INCDIR) -DBOOST_ALL_NO_LIB
CXX=cl.exe
CXX_c=/c
CXX_o=/Fo
AR=lib.exe
ARFLAGS=/nologo
AR_o=/OUT:
CP=copy
LD=link.exe
LD_L=/LIBPATH:
LD_o=/OUT:
LDFLAGS=/nologo /INCREMENTAL:NO $(LD_L)$(BOOST_LIBDIR)
LDFLAGS_SO=/DLL /IMPLIB:$(IMPORT_LIB)
LDLIBS=boost_unit_test_framework.lib
LDLIBS_SHARED=$(IMPORT_LIB)
MKDIR_P=mkdir
MT=mt.exe
MTFLAGS=/nologo
RM_F=del /f
INSTALL_PROGRAM=$(INSTALL)
INSTALL=copy

DLL_LINKAGE=-DINIPHILE_DLL

LIBINIPHILE_PC=
SONAME=libiniphile-$(VERSION_major).so
IMPORT_LIB=libiniphile.lib

EMBED_MANIFEST= \
	$(MT) $(MTFLAGS) -manifest $@.manifest -outputresource:$@;1

dot_exe=.exe

all: .all

check: initest
	initest-static$(dot_exe)
	initest-shared$(dot_exe)

install: all
	if not exist $(DESTDIR)$(BINDIR) \
	$(MKDIR_P) $(DESTDIR)$(BINDIR)
	if not exist $(DESTDIR)$(LIBDIR) \
	$(MKDIR_P) $(DESTDIR)$(LIBDIR)
	if not exist $(DESTDIR)$(MAN1DIR) \
	$(MKDIR_P) $(DESTDIR)$(MAN1DIR)
	$(INSTALL_PROGRAM) libiniphile.a $(DESTDIR)$(LIBDIR)\libiniphile.a
	$(INSTALL_PROGRAM) $(SONAME) $(DESTDIR)$(LIBDIR)\$(SONAME)
	$(INSTALL_PROGRAM) $(IMPORT_LIB) $(DESTDIR)$(LIBDIR)\$(IMPORT_LIB)
	if not exist $(DESTDIR)$(INCDIR)\iniphile \
	$(MKDIR_P) $(DESTDIR)$(INCDIR)\iniphile
	for %f in ($(PUBLIC_HEADERS)) do \
		$(INSTALL) %f $(DESTDIR)$(INCDIR)\iniphile\%f

$(IMPORT_LIB): $(SONAME)

!include mk/common.mk
