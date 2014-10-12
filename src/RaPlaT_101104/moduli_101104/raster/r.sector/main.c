
/****************************************************************************
 *
 * MODULE:       r.sector
 * AUTHOR(S):    Andrej Vilhar, Jozef Stefan Institute                
 *
 * PURPOSE:      Takes propagation pathloss and calculates additional
 *               gain/pathloss according to antenna's directional diagram.
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

#define PI 3.14159265


/* 
 * global function declaration 
 */
extern FCELL hata(FCELL);


/*
 * main function
 */
int main(int argc, char *argv[])
{
  /* antenna data */
    int beamDirection;
    //int electricalTiltAngle;
    int mechanicalAntennaTilt;
    double heightAGL;
    //char antennaType[8];
    double east;
    double north;
    
    //char antennaFolder[80];
     char antdata_file[100];
  
    double totalHeight;
    double gain;
    double horizontal[360];
    double vertical[360];
  /* end of antenna data */

  double rec_height = 1.5; /* height of receiver from the ground */
  double radius, dem_height;

  FILE *in;
  char buffer[256], text[32];
    
  struct Cell_head window;	     /* database window         */
  struct Cell_head cellhd;	/* it stores region information,
				   and header information of rasters */

  char *name, *name2;			/* input raster name */
  char *result;		/* output raster name */
  char *mapset, *mapset2;		/* mapset name */
  void *inrast, *inrast2;		/* input buffer */
  unsigned char *outrast;	/* output buffer */
  int nrows, ncols;
  int row, col, j;
  int tr_row, tr_col;
  int infd, infd2, outfd;		/* file descriptor */
  int verbose;
  struct History history;	/* holds meta-data (title, comments,..) */

  struct GModule *module;	/* GRASS module for parsing arguments */

  struct Option *input, *input2, *opt1, *opt2, *opt3, *opt4, *opt5, *opt6, *opt7, *opt8, *opt9, *opt10, *output;	/* options */
  struct Flag *flag1;		/* flags */

   int dem_defined = 0;

  /* default path to antenna diagram */
  char def_path[1000];
	strcpy(def_path,getenv("GISBASE"));
	strcat(def_path,"/etc/radio_coverage/antenna_diagrams/");


    /* initialize GIS environment */
    G_gisinit(argv[0]);		/* reads grass env, stores program name to G_program_name() */

    /* initialize module */
    module = G_define_module();
    module->keywords = _("raster, directional diagram, antenna sector");
    module->description = _("Sector module");
  
    /* Define the different options as defined in gis.h */
    input = G_define_standard_option(G_OPT_R_INPUT);
    input->key = "pathloss_raster";
    input->description = _("Omni antenna pathloss raster");

    input2 = G_define_standard_option(G_OPT_R_INPUT);
    input2->key = "DEM_raster";
    input2->required = YES;
    input2->description = _("Elevation model - required for transmitter height determination");
      
    output = G_define_standard_option(G_OPT_R_OUTPUT);
  
    /* Define the different flags */
    flag1 = G_define_flag();
    flag1->key = 'q';
    flag1->description = _("Quiet");

    /*opt8 = G_define_option();
    opt8->key = "antennas_folder";
    opt8->type = TYPE_STRING;
    opt8->required = YES;
    opt8->label = _("Antenna diagram folder");    */

    opt2 = G_define_option();
    opt2->key = "ant_data_file";
    opt2->type = TYPE_STRING;
    opt2->required = YES;
    opt2->label = _("Antenna data file");	

    opt1 = G_define_option();
    opt1->key = "beam_direction";
    opt1->type = TYPE_INTEGER;
    opt1->required = YES;
    opt1->label = _("Beam direction");

    /*opt2 = G_define_option();
    opt2->key = "el_tilt";
    opt2->type = TYPE_INTEGER;
    opt2->required = YES;
    opt2->label = _("Electrical tilt angle");*/

    opt3 = G_define_option();
    opt3->key = "mech_tilt";
    opt3->type = TYPE_INTEGER;
    opt3->required = YES;
    opt3->label = _("Mechanical antenna tilt");
    
    opt4 = G_define_option();
    opt4->key = "height_agl";
    opt4->type = TYPE_DOUBLE;
    opt4->required = YES;
    opt4->label = _("Above ground level height");

    /*opt5 = G_define_option();
    opt5->key = "antenna_type";
    opt5->type = TYPE_STRING;
    opt5->required = YES;
    opt5->label = _("Type of antenna (6 number code)");*/

    opt6 = G_define_option();
    opt6->key = "east";
    opt6->type = TYPE_DOUBLE;
    opt6->required = YES;
    opt6->label = _("Easting coordinate");    

    opt7 = G_define_option();
    opt7->key = "north";
    opt7->type = TYPE_DOUBLE;
    opt7->required = YES;
    opt7->label = _("Northing coordinate"); 

    opt10 = G_define_option();
    opt10->key = "default_DEM_height";
    opt10->type = TYPE_DOUBLE;
    opt10->required = NO;
    //opt10->answer = "0";
    opt10->description = _("Default DEM height (m)");     
    
    opt9 = G_define_option();
    opt9->key = "radius";
    opt9->type = TYPE_DOUBLE;
    opt9->required = NO;
    opt9->answer = "10";
    opt9->description = _("Radius of calculation (km)");

    /* options and flags parser */
    if (G_parser(argc, argv))
	exit(EXIT_FAILURE);

    /* stores options and flags to variables */
    name = input->answer;
    name2 = input2->answer;
    result = output->answer;
    verbose = (!flag1->answer);
    //sscanf(opt8->answer, "%s", &antennaFolder);
    sscanf(opt1->answer, "%d", &beamDirection);
    //sscanf(opt2->answer, "%d", &electricalTiltAngle);
   sscanf(opt2->answer, "%s", &antdata_file);
    sscanf(opt3->answer, "%d", &mechanicalAntennaTilt);
    sscanf(opt4->answer, "%lf", &heightAGL);
    //sscanf(opt5->answer, "%s", &antennaType);
    sscanf(opt6->answer, "%lf", &east);
    sscanf(opt7->answer, "%lf", &north);  
    sscanf(opt9->answer, "%lf", &radius);

    /* returns NULL if the map was not found in any mapset, 
     * mapset name otherwise */
    mapset = G_find_cell2(name, "");
    if (mapset == NULL)
	G_fatal_error(_("Raster pathloss map <%s> not found"), name);

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

    G_debug(3, "number of rows %d", cellhd.rows);

	//G_set_window(&cellhd);
	//G_get_set_window(&cellhd);
	G_get_window (&window);

//G_message(_("(window.west):[%f], (window.east):  [%f], (window.north): [%f] and (window.south): [%f]"), (window.west), (window.east), (window.north), (window.south));

    /* Allocate input buffer */
    inrast = G_allocate_raster_buf(FCELL_TYPE);
    inrast2 = G_allocate_raster_buf(FCELL_TYPE);

    /* Allocate output buffer, use input map data_type */
    nrows = G_window_rows();
    ncols = G_window_cols();
    outrast = G_allocate_raster_buf(FCELL_TYPE);
		//G_message(_("rows: %d, colums: %d"),nrows, ncols);

    /* controlling, if we can write the raster */
    if ((outfd = G_open_raster_new(result, FCELL_TYPE)) < 0)
	G_fatal_error(_("Unable to create raster map <%s>"), result);


	/* (1) calculate total height of the antenna */

	/* check if specified transmitter location inside window   */
	if (east < window.west || east > window.east
	    || north > window.north || north < window.south)
	  G_fatal_error(_("r.sector - specified base station  coordinates are outside current region bounds."));
    
	/* map array coordinates for transmitter */
	tr_row = (window.north - north) / window.ns_res;
	tr_col = (east - window.west) / window.ew_res;

	/* total height of transmitter */
	FCELL trans_elev;
	if (G_get_raster_row(infd2, inrast2, tr_row, FCELL_TYPE) < 0)
	  G_fatal_error(_("Unable to read DEM raster <%s> row %d"), name2, tr_row);
	trans_elev = ((FCELL *) inrast2)[tr_col];
	totalHeight = (double)trans_elev + heightAGL;

	// check if transmitter is on DEM
	if ( isnan((double)trans_elev))							
	{
		G_fatal_error(_("r.sector - transmitter outside raster DEM map."));
			//G_message(_("2. Transmiter elevatino [%f]"),(double)trans_elev);
	}
			//G_message(_("Total transmiter elevatino [%f]"),trans_total_height );

	
	/* (2) get antenna's gain and directional diagrams */
       	char fileName[1000];
       char comp_char[1];//, comp_char_fileName[1];
	strcpy(comp_char, "/");

	/* set correct filename */

		//G_message(_("Comparable string	: %s"),comp_char);
	
	strcpy (fileName, antdata_file);

		//G_message(_("Test1"));

		//G_message(_("fileName: %s"),fileName);
		//G_message(_("Antena Path Diagram: %s"),def_path);

	if ( strncmp(fileName, comp_char, 1) != 0)
	{
		strcat(def_path, fileName);
		strcpy(fileName, def_path);
		//G_message(_("Test2"));
	}	

		//G_message(_("Antena Path: %s, fileName: %s"),def_path,fileName);

	//strcat (fileName, antennaType);
	//strcat (fileName, "_2140_X_CO_M45_");	    
	//no_of_digits = sprintf(strElTilt, "%d", electricalTiltAngle);
	//if (no_of_digits == 1)
	//	strcat (fileName, "0");
	//strcat (fileName, strElTilt);
	//strcat (fileName, "T.MSI");
    
	/* open file */
	if( (in = fopen(fileName,"r")) == NULL )
		G_fatal_error(_("Unable to open antenna diagram in file <%s>"), fileName);  

	double temp_gain;
	/* get gain and find the beginning of horizontal diagram */
	while (1)
	{
		if (!fgets (buffer, 250, in)) 
		{	
			G_fatal_error(_("Empty or corrupted antenna diagram file <%s>"), fileName); 
			break;
		}
		sscanf (buffer, "%s %lf", text, &temp_gain);
		if (strcmp (text, "GAIN") == 0)		  
		    gain = temp_gain + 2.15;  /* with respect to isotropic antenna */	    		  
		if (strcmp (text, "HORIZONTAL") == 0) break; /* we have reached the beggining of HOR data*/
	}

	double angle, loss;
	/* read horizontal data - one angle degree per step*/
	for (j = 0; j < 360; j++)
	{
		fgets (buffer, 250, in); 
		sscanf (buffer, "%lf %lf", &angle, &loss);
		if (j != (int)angle)
		{
			G_fatal_error(_("Bad antenna diagram format.")); 
			break; 
		}
		horizontal[j] = loss;
	}

	/* skip one line ("VERTICAL 360")*/
	fgets (buffer, 250, in); 	

	/* read vertical data - one angle degree per step */
	for (j = 0; j < 360; j++)
	{
		fgets (buffer, 250, in); 
		sscanf (buffer, "%lf %lf", &angle, &loss);
		if (j != (int)angle)
		{
			G_fatal_error(_("Bad antenna diagram format.")); 
			break; 
		}
		vertical[j] = loss;
	}

	fclose(in);
  

	/* (3) process the input pathloss data */

	double height_diff_Tx_Rx; /* difference of total heights (Tx - Rx) */
	double dist_Tx_Rx; /* distance between receiver and transmitter */
	double rec_east, rec_north;  /* receiver coordinates */
	double d_east, d_north; /* differences between receiver and transmitter coordinates (e.g. rec_east - tr_east)*/
	double hor_coor_angle, vert_coor_angle; /* angle between x-axis of coordinate system and the line between RX and TX - (hor)izontal and (vert)ical*/
	double hor_diag_angle, vert_diag_angle; /* angle in the antenna's diagram (antenna's direction is taken into account) - (hor)izontal and (vert)ical*/
	double horizontal_loss, vertical_loss; /* pathloss due to antenna's diagram */
	double temp_angle; /* temporary angle */


    /* for each row */
    for (row = 0; row < nrows; row++) 
      {
	      
	if (verbose)
	  G_percent(row, nrows, 2);

	FCELL f_in, f_out, f_in_dem;  
	/* read input map */
	if (G_get_raster_row(infd, inrast, row, FCELL_TYPE) < 0)
	  G_fatal_error(_("Unable to read omni pathloss raster <%s> row %d"), name, row);
	
	if (G_get_raster_row(infd2, inrast2, row, FCELL_TYPE) < 0)
	  G_fatal_error(_("Unable to read DEM raster <%s> row %d"), name2, row);
	  
	/* process the data */
	for (col = 0; col < ncols; col++) 
	{ 
	    f_in = ((FCELL *) inrast)[col];
	    f_in_dem = ((FCELL *) inrast2)[col];
	  
	 /* calculate receiver coordinates */
	    rec_east = window.west + (col * window.ew_res);
	    rec_north = window.north - (row * window.ns_res);

	    /* calculate differences between receiver and transmitter coordinates */
	    d_north = rec_north - north;
	    d_east = rec_east - east;
	    
	    /* calculate distance between Tx and Rx */
	    dist_Tx_Rx = sqrt( pow(d_east,2) + pow(d_north,2) );
	   dist_Tx_Rx=dist_Tx_Rx/1000;

	    // check the elevation of the terrain ///////////////////////////
	    if ( isnan((double)f_in_dem))		
	    {	
               if (dist_Tx_Rx <= radius)
               { 			
		if (dem_defined == 0)
		{
			if (opt10->answer == NULL)   /* set user defined resolution */
			{	
				G_fatal_error(_("Default DEM height not defined (r.sector)."));
			}
			else
			       sscanf(opt10->answer, "%lf", &dem_height);    
		       G_message(_("Receiver outside raster DEM map (r.sector). Default height is: %f"), dem_height);
		}
							
		dem_defined = 1;
	       }	
	       f_in_dem = (FCELL)dem_height;
	    }
	    ///////////////////////////////////////////////////////////////////////////

	   
	    /* If distance between Rx and Tx exceeds given radius, continue with other cells */

            FCELL null_f_out;
	    if (dist_Tx_Rx > radius)
	    {
					//G_message(_("Razdalja sprejemnik oddajnik: %f"), dist_Tx_Rx);
		//f_out=(FCELL)0/0;
		G_set_f_null_value(&null_f_out, 1);   
		f_out=null_f_out;
		//f_out=0;
	    }

	    if (dist_Tx_Rx <= radius)
	   {    
					//G_message(_("Razdalja sprejemnik oddajnik: %f"), dist_Tx_Rx);
	
	   	 /* determine horizontal angle and loss */			
	   	 temp_angle = atan (d_north / d_east);
	   	 if (temp_angle < 0)
	   	   temp_angle = - temp_angle;
	    	      
	   	 if (d_north >= 0 && d_east >= 0)
	   	   hor_coor_angle = temp_angle;
	   	 else if (d_north >= 0 && d_east < 0)
	   	   hor_coor_angle = PI - temp_angle;
	   	 else if (d_north < 0 && d_east < 0)
	   	   hor_coor_angle = PI + temp_angle;
	   	 else /* (d_north < 0 && d_east >= 0) */
	   	   hor_coor_angle = 2*PI - temp_angle;

	   	 hor_coor_angle = hor_coor_angle * 180 / PI;  /* convert from radians to degrees */
	   	 
	   	 hor_diag_angle = hor_coor_angle - (double)beamDirection;
	
	   	 if (hor_diag_angle < 0)
	   	   hor_diag_angle = 360 + hor_diag_angle;

			/* to prevent reading unallocated data (diagram comprises values 0 - 359)*/
			temp_angle = ceil(hor_diag_angle);
			if (temp_angle == 360)
				temp_angle = 0;

		    horizontal_loss = horizontal[(int)floor(hor_diag_angle)] + ((horizontal[(int)temp_angle] - horizontal[(int)floor(hor_diag_angle)])*(hor_diag_angle - floor(hor_diag_angle))); /* interpolation */
	    
		    /* determine vertical angle and loss */
		    height_diff_Tx_Rx = totalHeight - (double)f_in_dem - rec_height;
	    
		    vert_coor_angle = atan (height_diff_Tx_Rx / dist_Tx_Rx);
		    vert_coor_angle = vert_coor_angle * 180 / PI;	      	      
	      
		    if (vert_coor_angle < 0)
		      vert_coor_angle = 360 + vert_coor_angle;
	    
		    vert_diag_angle = vert_coor_angle - (double)mechanicalAntennaTilt;
	      
		    if (vert_diag_angle < 0)
		      vert_diag_angle = 360 + vert_diag_angle;

		    /* to prevent reading unallocated data (diagram comprises values 0 - 359)*/
		    temp_angle = ceil(vert_diag_angle);
		    if (temp_angle == 360)
			temp_angle = 0;

		    vertical_loss = vertical[(int)floor(vert_diag_angle)] + ((vertical[(int)temp_angle] - vertical[(int)floor(vert_diag_angle)])*(vert_diag_angle - floor(vert_diag_angle))); /* interpolation */ 
	      
		    /* finally take into account pathloss for determined diagram angles and antenna gain*/
		    f_out = (FCELL)((double)f_in + horizontal_loss + vertical_loss - gain); 		
	    }

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
