export GISBASE="/usr/local/grass-6.4.1RC1/"
export PATH="$PATH:$GISBASE/bin:$GISBASE/scripts"
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$GISBASE/lib"
# for parallel session management, we use process ID (PID) as lock file number:
export GIS_LOCK=$$
# path to GRASS settings file
export GISRC="$HOME/.grassrc6"
export PYTHONPATH="${GISBASE}/etc/python"

ipython
