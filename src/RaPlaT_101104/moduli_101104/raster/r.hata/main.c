
/****************************************************************************
 *
 * MODULE:       r.hata
 * AUTHOR(S):    Andrej Vilhar, Jozef Stefan Institute                
 *
 * PURPOSE:      Calculates radio coverage from a single base station 
 *               according to Hata model
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
 * Calculation of Hata for a pair of points:
 * -----------------------------------------
 * tr_height_eff ... effective height of Tx: difference between total Tx and total Rx height
 * d ... distance between Rx and Tx
 * freq ... radio frequency
 * rec_height ... AGL height of Rx
 * limit ... distance up to which hata should be calculated (input parameter of the model)
 * area_type ... type of area (urban, suburban, open)
 */
FCELL calc_hata(double tr_height_eff, double d, double freq, double rec_height, double limit, char *area_type)
{ 
  double Lu;   /* Path loss in urban area (in dB) */
  double Lo;   /* Path loss in open area (in dB) */
  double Lsu;  /* Path loss in suburban area (in dB) */
  double ahr;  /* Correction factor */
  FCELL x;     /* return value */

  /* get absolute value of effective height */
  tr_height_eff = fabs(tr_height_eff);

  /* If effective Tx height is too high or too low, then do not calculate */
  /*if (tr_height_eff > 20000 || tr_height_eff < 1)
    {
      G_set_f_null_value(&x, 1);
      return x;
    }*/

  d = d/1000;  /* in Hata, distance has to be given in km */    

  /* If Rx and Tx are closer than 10m, then do not calculate */
  if (d < 0.01 || d > limit)
    {    
      G_set_f_null_value(&x, 1);
      return x;
    }

  /* Correction factor ahr */
  ahr = (1.1*log10(freq) - 0.7)*rec_height - (1.56*log10(freq)-0.8);

  /* Lu */
  Lu = 69.55 + 26.16*log10(freq) - 13.82*log10(tr_height_eff) - ahr + (44.9-6.55*log10(tr_height_eff))*log10(d);

  /* Lo */
  Lo = Lu - 4.78*pow(log10(freq),2) + 18.33*log10(freq) - 40.94;

  /* Lsu */
  Lsu = Lu - 2*pow(log10(freq/28),2) - 5.4;

/*G_message(_("Lu [%f] and Lsu [%f] and Lo [%f]"),Lu,Lsu, Lo);*/

  /* return x */
  if (strcmp(area_type, "urban") == 0)
	x=(FCELL)Lu;
  else if (strcmp(area_type, "suburban") == 0)
	x=(FCELL)Lsu;
  else if (strcmp(area_type, "open") == 0)
	x=(FCELL)Lo;
  else
	G_fatal_error(_("Unknown area type: [%s]."), area_type);
  
  return x;
}
 

/*
 * main function
 */
int main(int argc, char *argv[])
{
    double east;
    double north;
//
    double ant_height, frequency, radius, dem_height;
    double rec_height = 1.5; /* height of receiver from the ground */
    
   struct Cell_head window;	   /*  database window         */
    struct Cell_head cellhd;	/* it stores region information,
				   and header information of rasters */
    char *name;			/* input raster name */
    char *result;		/* output raster name */
    char *mapset;		/* mapset name */
    void *inrast;		/* input buffer */
    unsigned char *outrast;	/* output buffer */
    int nrows, ncols;
    int row, col;
    int tr_row, tr_col;
    int infd, outfd;		/* file descriptor */
    int verbose;
    struct History history;	/* holds meta-data (title, comments,..) */

    struct GModule *module;	/* GRASS module for parsing arguments */
//
    struct Option *input,*opt1, *opt2, *opt4, *opt5, *opt3, *opt6, *output;	/* options */
    struct Flag *flag1;		/* flags */
//    
     int dem_defined = 0;

    /* initialize GIS environment */
    G_gisinit(argv[0]);		/* reads grass env, stores program name to G_program_name() */

    /* initialize module */
    module = G_define_module();
    module->keywords = _("raster, hata");
    module->description = _("Hata module");

    /* Define the different options as defined in gis.h */
    input = G_define_standard_option(G_OPT_R_INPUT);        
    output = G_define_standard_option(G_OPT_R_OUTPUT);

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
    opt2->description = _("Height of the anntenas (m)");

    opt4 = G_define_option();
    opt4->key = "radius";
    opt4->type = TYPE_DOUBLE;
    opt4->required = NO;
    opt4->answer = "10";
    opt4->description = _("Radius of calculation (km)");

    opt5 = G_define_option();
    opt5->key = "area_type";
    opt5->type = TYPE_STRING;
    opt5->required = NO;
    opt5->description = _("Type of area");
    opt5->options = "urban,suburban,open";
    opt5->answer = "urban";

    opt3 = G_define_option();
    opt3->key = "frequency";
    opt3->type = TYPE_DOUBLE;
    opt3->required = YES;
    opt3->description = _("Frequency (MHz)");
//////////////////////////////////////////////////////////////////////////////////
    opt6 = G_define_option();
    opt6->key = "default_DEM_height";
    opt6->type = TYPE_DOUBLE;
    opt6->required = NO;
    //opt6->answer = "0";
    opt6->description = _("Default DEM height (m)");
/////////////////////////////////////////////////////////////////////////////////

    /* options and flags parser */
    if (G_parser(argc, argv))
	exit(EXIT_FAILURE);
    /* stores options and flags to variables */
    name = input->answer;
    result = output->answer;
    verbose = (!flag1->answer);
    G_scan_easting(opt1->answers[0], &east, G_projection());
    G_scan_northing(opt1->answers[1], &north, G_projection());
    sscanf(opt2->answer, "%lf", &ant_height);
    sscanf(opt4->answer, "%lf", &radius);
    sscanf(opt3->answer, "%lf", &frequency);						

    /* returns NULL if the map was not found in any mapset, 
     * mapset name otherwise */
    mapset = G_find_cell2(name, "");
    if (mapset == NULL)
	G_fatal_error(_("Raster map <%s> not found"), name);

    if (G_legal_filename(result) < 0)
	G_fatal_error(_("<%s> is an illegal file name"), result);


    /* G_open_cell_old - returns file destriptor (>0) */
    if ((infd = G_open_cell_old(name, mapset)) < 0)		
	G_fatal_error(_("Unable to open raster map <%s>"), name);


    /* controlling, if we can open input raster */
    if (G_get_cellhd(name, mapset, &cellhd) < 0)
	G_fatal_error(_("Unable to read file header of <%s>"), name);

    G_debug(3, "number of rows %d", cellhd.rows);

	/*G_set_window(&cellhd);
	G_get_set_window(&cellhd);*/
    G_get_window (&window);

    /* Allocate input buffer */
    inrast = G_allocate_raster_buf(FCELL_TYPE);

    /* Allocate output buffer, use input map data_type */
    nrows = G_window_rows();
    ncols = G_window_cols();
    outrast = G_allocate_raster_buf(FCELL_TYPE);

    /* controlling, if we can write the raster */
    if ((outfd = G_open_raster_new(result, FCELL_TYPE)) < 0)
	G_fatal_error(_("Unable to create raster map <%s>"), result);


  /*  G_get_window(&window);*/


    /* check if specified transmitter location inside window   */
	if (east < window.west || east > window.east
	    || north > window.north || north < window.south)
      G_fatal_error(_("Specified base station  coordinates are outside current region bounds."));
    

   /* map array coordinates for transmitter */
	tr_row = (window.north - north) / window.ns_res;
	tr_col = (east - window.west) / window.ew_res;


    /* total height of transmitter */
    FCELL trans_elev;
    double trans_total_height;
    if (G_get_raster_row(infd, inrast, tr_row, FCELL_TYPE) < 0)
      G_fatal_error(_("Unable to read raster map <%s> row %d"), name, tr_row);
    trans_elev = ((FCELL *) inrast)[tr_col];

		//G_message(_("Transmiter elevatino [%f]"),trans_elev);

    trans_total_height = (double)trans_elev + ant_height;

    // check if transmitter is on DEM - ********************************************
    if ( isnan((double)trans_elev))							
	{
		G_fatal_error(_("Transmitter outside raster DEM map."));
			//G_message(_("2. Transmiter elevatino [%f]"),(double)trans_elev);
	}
			//G_message(_("Total transmiter elevatino [%f]"),trans_total_height );
    //  ************************************************************************
    
    /* do HATA */

    double height_diff_Tx_Rx; /* difference of total heights (Tx - Rx) */
    double dist_Tx_Rx; /* distance between receiver and transmitter */
    double rec_east, rec_north;  /* receiver coordinates */
    double d_east, d_north; /* differences between receiver and transmitter coordinates (e.g. rec_east - tr_east)*/
	   

    /* for each row */
    for (row = 0; row < nrows; row++) 
      {	  

	if (verbose)
	  G_percent(row, nrows, 2);
	
	FCELL f_in, f_out;	  
	 
	/* read input map */
	if (G_get_raster_row(infd, inrast, row, FCELL_TYPE) < 0)
	  G_fatal_error(_("Unable to read raster map <%s> row %d"), name, row);
	  
	/* process the data */
	for (col = 0; col < ncols; col++) 
	  { 
	    f_in = ((FCELL *) inrast)[col];
	  
	    /* calculate receiver coordinates */
	    rec_east = window.west + (col * window.ew_res);
	    rec_north = window.north - (row * window.ns_res);	

	    /* calculate differences in coordinates */
	    d_north = rec_north - north;
	    d_east = rec_east - east;
	  /* calculate distance */
	    dist_Tx_Rx = sqrt( pow((east - rec_east),2) + pow((north - rec_north),2) );

	    // check the elevation of the terrain - ********************************************************
		if ( isnan((double)f_in) && dist_Tx_Rx/1000 <= radius)		
		{	
					//G_message(_("Distance RX TX: %f"), dist_Tx_Rx/100);										
		 	if (dem_defined == 0)
			{
				if (opt6->answer == NULL)   /* set user defined resolution */
					G_fatal_error(_("Default DEM height not defined."));
				else
				       sscanf(opt6->answer, "%lf", &dem_height);    
			       G_message(_("Receiver outside raster DEM map. Default height is: %f"), dem_height);
			}
		      	dem_defined = 1;
		        f_in = (FCELL)dem_height;
		   	//G_message(_(" Default hieght is: %f"), (double)f_in);
                 }
		// *************************************************************************************
   	      
      
	    /* calculate height difference */
	    if ((double)trans_elev > (double)f_in)
            	height_diff_Tx_Rx = trans_total_height - (double)f_in - rec_height;
	    else
  		height_diff_Tx_Rx = ant_height;

		//G_message(_("Height difference: %f"), height_diff_Tx_Rx);

	    /* calculate hata */
	    f_out = calc_hata(height_diff_Tx_Rx, dist_Tx_Rx, frequency, rec_height, radius, opt5->answer);

	    ((FCELL *) outrast)[col] = f_out;

	  }
      
	/* write raster row to output raster map */
	if (G_put_raster_row(outfd, outrast, FCELL_TYPE) < 0)
	  G_fatal_error(_("Failed writing raster map <%s>"), result);
      }
         

    /* memory cleanup */
    G_free(inrast);
    G_free(outrast);

    /* closing raster maps */
    G_close_cell(infd);
    G_close_cell(outfd);

    /* add command line incantation to history file */
    G_short_history(result, "raster", &history);
    G_command_history(&history);
    G_write_history(result, &history);


    exit(EXIT_SUCCESS);
}
