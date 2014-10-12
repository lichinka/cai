
/****************************************************************************
 *
 * MODULE:       r.fspl
 * AUTHOR(S):    Andrej Vilhar, Jozef Stefan Institute                
 *
 * PURPOSE:      Calculates free space loss from a given transmission point
 *               to all the other points in input DEM. 
 *             
 *
 * COPYRIGHT:    (C) 2009 Jozef Stefan Institute
 *
 *
 *****************************************************************************/


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <grass/gis.h>
#include <grass/glocale.h>
#include <math.h>

/* 
 * global function declaration 
 */
extern FCELL hata(FCELL);


/*
 * Calculation of FSPL for a pair of points:
 * -----------------------------------------
 * x ... elevation of current point
 * tr_east, tr_north ... transmitter coordinates
 * tr_height ... total height = transmitter elevation + height of antenna
 * rec_col, rec_row ... the column and row of the receiving point
 * freq ... radio frequency
 * window ... database window
 */
FCELL calc_fspl(FCELL x, FCELL y, double tr_east, double tr_north, double tr_height, int rec_col, int rec_row, double freq, struct Cell_head window, double limit)
{ 
  double rec_east, rec_north;  /* receiver coordinates */
  double rec_height = 1.5; /* height of receiver from the ground */
  double PL;   /* Path loss */
  double d;    /* Distance between transmitter and receiver (ground projection) */
  double tr_height_eff; /* effective height of Tx: (absolute) difference between total Tx and total Rx height */
  double R;    /* Distance between transmitter and receiver (shortest physical distance) */
  //FCELL x;     /* return value */

  /* Calculate receiver coordinates */
  rec_east = window.west + (rec_col * window.ew_res);
  rec_north = window.north - (rec_row * window.ns_res);

  /* Calculate effective height */
  tr_height_eff = fabs(tr_height - (double)x - rec_height);
    
  /* Ground distance between Tx and Rx */
  d = sqrt( pow((tr_east - rec_east),2) + pow((tr_north - rec_north),2) );
  d = d/1000;  /* distance has to be given in km */

   if (d < 0.01 || d > limit)
    {    
      G_set_f_null_value(&x, 1);
      return x;
    }

  /* Real (physical) distance between Tx and Rx */
  R = sqrt( pow(d,2) + pow(tr_height_eff/1000,2) );


  /* Pathloss - calculate only where LOS */
  if (G_is_f_null_value(&y))
    return y;
  else    
    {
      /* G_message(_("d: %f, h: %f, R: %f"), d, tr_height_eff/1000, R);*/
      PL = 32.4 + 20*log10(R) + 20*log10(freq);
      x=(FCELL)PL;  
           
      return x;
    }
}


/*
 * main function
 */
int main(int argc, char *argv[])
{
    double east;
    double north;
    double ant_height, frequency, dem_height, dem_map_LOS, radius;
    
    struct Cell_head window;	/*      database window         */
    struct Cell_head cellhd;	/* it stores region information,
				   and header information of rasters */
    char *name, *name2;			/* input raster name */
    char *result;		/* output raster name */
    char *mapset, *mapset2;		/* mapset name */
    void *inrast, *inrast2;		/* input buffer */
    unsigned char *outrast;	/* output buffer */
    int nrows, ncols;
    int row, col;
    int tr_row, tr_col;
    int infd, infd2, outfd;		/* file descriptor */
    int verbose;
    struct History history;	/* holds meta-data (title, comments,..) */

    struct GModule *module;	/* GRASS module for parsing arguments */

    struct Option *input1, *input2,  *opt1, *opt2, *opt3, *opt4, *opt5, *opt6, *output;	/* options */
    struct Flag *flag1;		/* flags */

    int dem_defined = 0;
    int dem_defined_LOS = 0;

    /* initialize GIS environment */
    G_gisinit(argv[0]);		/* reads grass env, stores program name to G_program_name() */

    /* initialize module */
    module = G_define_module();
    module->keywords = _("raster, hata");
    module->description = _("Hata module");

    /* Define the different options as defined in gis.h */
    input1 = G_define_standard_option(G_OPT_R_INPUT);
    output = G_define_standard_option(G_OPT_R_OUTPUT);

    input2 = G_define_standard_option(G_OPT_R_INPUT);
    input2->key = "LOS_map";
    input2->required = NO;
    input2->description = _("LOS raster map to use as a mask");

    /* Define the different flags */
    flag1 = G_define_flag();
    flag1->key = 'q';
    flag1->description = _("Quiet");

    opt1 = G_define_option();
    opt1->key = "coordinate";
    opt1->type = TYPE_STRING;
    opt1->required = YES;
    opt1->key_desc = "x,y";
    opt1->description = _("Base station coordinates");

    opt2 = G_define_option();
    opt2->key = "ant_height";
    opt2->type = TYPE_DOUBLE;
    opt2->required = NO;
    opt2->answer = "10";
    opt2->description = _("Height of the anntenas");

    opt3 = G_define_option();
    opt3->key = "frequency";
    opt3->type = TYPE_DOUBLE;
    opt3->required = YES;
    opt3->description = _("Frequency (MHz)");

    opt4 = G_define_option();
    opt4->key = "default_DEM_height";
    opt4->type = TYPE_DOUBLE;
    opt4->required = NO;
    //opt4->answer = "0";
    opt4->description = _("Default DEM height (m)");

    opt5 = G_define_option();
    opt5->key = "default_LOS_raster_value";
    opt5->type = TYPE_DOUBLE;
    opt5->required = NO;
    //opt5->answer = "0";
    opt5->description = _("Default LOS raster value (m)");

    opt6 = G_define_option();
    opt6->key = "radius";
    opt6->type = TYPE_DOUBLE;
    opt6->required = NO;
    opt6->answer = "10";
    opt6->description = _("Radius of calculation (km)");


    /* options and flags parser */
    if (G_parser(argc, argv))
	exit(EXIT_FAILURE);

    /* stores options and flags to variables */
    name = input1->answer;
    name2 = input2->answer;
    result = output->answer;
    verbose = (!flag1->answer);
    G_scan_easting(opt1->answers[0], &east, G_projection());
    G_scan_northing(opt1->answers[1], &north, G_projection());
    sscanf(opt2->answer, "%lf", &ant_height);
    sscanf(opt3->answer, "%lf", &frequency);
    sscanf(opt6->answer, "%lf", &radius);

    G_get_window(&window);

    /* check if specified transmitter location inside window   */
    if (east < window.west || east > window.east
	|| north > window.north || north < window.south)
	G_fatal_error(_("Specified base station  coordinates are outside current region bounds."));
    

    /* returns NULL if the map was not found in any mapset, 
     * mapset name otherwise */
    mapset = G_find_cell2(name, "");
    if (mapset == NULL)
	G_fatal_error(_("Raster map <%s> not found"), name);

    mapset2 = G_find_cell2(name2, "");
    if (mapset2 == NULL)
	G_fatal_error(_("Raster map <%s> not found"), name2);

    if (G_legal_filename(result) < 0)
	G_fatal_error(_("<%s> is an illegal file name"), result);


    /* G_open_cell_old - returns file destriptor (>0) */
    if ((infd = G_open_cell_old(name, mapset)) < 0)
	G_fatal_error(_("Unable to open raster map <%s>"), name);

    if ((infd2 = G_open_cell_old(name2, mapset2)) < 0)
	G_fatal_error(_("Unable to open raster map <%s>"), name2);


    /* controlling, if we can open input raster */
    if (G_get_cellhd(name, mapset, &cellhd) < 0)
	G_fatal_error(_("Unable to read file header of <%s>"), name);

    if (G_get_cellhd(name2, mapset2, &cellhd) < 0)
	G_fatal_error(_("Unable to read file header of <%s>"), name2);


    G_debug(3, "number of rows %d", cellhd.rows);

    /* Allocate input buffer */
    inrast = G_allocate_raster_buf(FCELL_TYPE);
    inrast2 = G_allocate_raster_buf(FCELL_TYPE);

    /* Allocate output buffer, use input map data_type */
    nrows = G_window_rows();
    ncols = G_window_cols();
    outrast = G_allocate_raster_buf(FCELL_TYPE);

    /* controlling, if we can write the raster */
    if ((outfd = G_open_raster_new(result, FCELL_TYPE)) < 0)
	G_fatal_error(_("Unable to create raster map <%s>"), result);

    /* map array coordinates for transmitter */
    tr_row = (window.north - north) / window.ns_res;
    tr_col = (east - window.west) / window.ew_res;

    /* total height of transmitter */
    FCELL trans_elev;
    double trans_total_height;
    if (G_get_raster_row(infd, inrast, tr_row, FCELL_TYPE) < 0)
      G_fatal_error(_("Unable to read raster map <%s> row %d"), name, tr_row);
    trans_elev = ((FCELL *) inrast)[tr_col];
    trans_total_height = (double)trans_elev + ant_height;
    /*    G_message(_("trans_total_height: %f, trans_elev: %f"), trans_total_height, (double)trans_elev);*/

    // check if transmitter is on DEM
    if ( isnan((double)trans_elev))							
	{
		G_fatal_error(_("Transmitter outside raster DEM map."));
			//G_message(_("2. Transmiter elevatino [%f]"),(double)trans_elev);
	}
			//G_message(_("Total transmiter elevatino [%f]"),trans_total_height );

   

    /* FSPL */

   double dist_Tx_Rx; /* distance between receiver and transmitter */
   double rec_east, rec_north;  /* receiver coordinates */
   double d_east, d_north; /* differences between receiver and transmitter coordinates (e.g. rec_east - tr_east)*/

    /* for each row */
    for (row = 0; row < nrows; row++) {
      FCELL f, f2, f_out;

	if (verbose)
	    G_percent(row, nrows, 2);

	/* read input map */
	if (G_get_raster_row(infd, inrast, row, FCELL_TYPE) < 0)
	  G_fatal_error(_("Unable to read raster map <%s> row %d"), name, row);

	/* read input map 2 */
	if (G_get_raster_row(infd2, inrast2, row, FCELL_TYPE) < 0)
	  G_fatal_error(_("Unable to read raster map <%s> row %d"), name2, row);

	/* process the data */
	for (col = 0; col < ncols; col++) 
	  { 
	    f = ((FCELL *) inrast)[col];
	    f2 = ((FCELL *) inrast2)[col];


	    /* calculate receiver coordinates */
	    rec_east = window.west + (col * window.ew_res);
	    rec_north = window.north - (row * window.ns_res);	

	    /* calculate differences in coordinates */
	    d_north = rec_north - north;
	    d_east = rec_east - east;
	  /* calculate distance */
	    dist_Tx_Rx = sqrt( pow((east - rec_east),2) + pow((north - rec_north),2) );

	    // check the elevation of the terrain
		if ( isnan((double)f) && dist_Tx_Rx/1000 <= radius)	 	
		{	
			if (dem_defined == 0)
			{
				if (opt4->answer == NULL)   /* set user defined resolution */
					G_fatal_error(_("Default DEM height not defined."));
				else
				       sscanf(opt4->answer, "%lf", &dem_height);    
			       G_message(_("Receiver outside raster DEM map. Default height is: %f"), dem_height);
			}
							
			dem_defined = 1;
			
			f = (FCELL)dem_height;
			//G_message(_(" Default hieght is: %f"), (double)f_in);
		}

	    // check the LOS raster map
		if ( isnan((double)f2) && dist_Tx_Rx/1000 <= radius)		
		{	
			if (dem_defined_LOS == 0)
			{
				if (opt5->answer == NULL)   /* set user defined resolution */
					G_fatal_error(_("Default LOS value not defined."));
				else
				       sscanf(opt5->answer, "%lf", &dem_map_LOS);    
			       G_message(_("Receiver outside raster LOS map. Default LOS value: %f"), dem_map_LOS);
			}
							
			dem_defined_LOS = 1;
			
			f2 = (FCELL)dem_map_LOS;
			//G_message(_(" Default hieght is: %f"), (double)f_in);
		}


				//G_message(_("LOS value: %f"), (double)f2);

	    f_out = calc_fspl(f, f2, east, north, trans_total_height, col, row, frequency, window, radius);	/* calculate fspl */
	    ((FCELL *) outrast)[col] = f_out;
	  }
	
	/* write raster row to output raster map */
	if (G_put_raster_row(outfd, outrast, FCELL_TYPE) < 0)
	    G_fatal_error(_("Failed writing raster map <%s>"), result);
    }

    /* memory cleanup */
    G_free(inrast);
    G_free(inrast2);
    G_free(outrast);

    /* closing raster maps */
    G_close_cell(infd);
    G_close_cell(infd2);
    G_close_cell(outfd);

    /* add command line incantation to history file */
    G_short_history(result, "raster", &history);
    G_command_history(&history);
    G_write_history(result, &history);


    exit(EXIT_SUCCESS);
}
