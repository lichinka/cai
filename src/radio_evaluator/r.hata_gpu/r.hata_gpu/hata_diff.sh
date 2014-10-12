r.hata_gpu input=dem100i_mo@PERMANENT output=ijs_map coordinate=463094,102454 ant_height=8 radius=40 area_type=urban frequency=2157.8 default_DEM_height=300 opencl=no --overwrite && \
r.hata_gpu input=dem100i_mo@PERMANENT output=my_map coordinate=463094,102454 ant_height=8 radius=40 area_type=urban frequency=2157.8 default_DEM_height=300 opencl=yes --overwrite && \
r.mapcalc diff = ijs_map - my_map && \
r.info diff | grep -i 'range of data'
