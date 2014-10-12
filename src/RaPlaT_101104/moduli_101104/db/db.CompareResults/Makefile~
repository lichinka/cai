# fix this relative to include/
# or use absolute path to the GRASS source code
MODULE_TOPDIR = ../../..

PGM = db.GenerateTable

LIBES = $(DBMILIB) $(GISLIB)
DEPENDENCIES = $(DBMIDEP) $(GISDEP)

include $(MODULE_TOPDIR)/include/Make/Module.make

default: cmd
