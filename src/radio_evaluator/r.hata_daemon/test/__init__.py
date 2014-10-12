import sys

GISBASE="/usr/local/grass-6.4.1RC1/"

sys.path.append (GISBASE + 'etc')
sys.path.append (GISBASE + 'etc/python')
sys.path.append (GISBASE + 'lib')
sys.path.append (GISBASE + 'bin')
sys.path.append (GISBASE + 'extralib')
sys.path.append (GISBASE + 'msys/bin')

import grass.script as grass

