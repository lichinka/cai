
/****************************************************************************
 *
 * MODULE:       r.waik
 * AUTHOR(S):    Tomaz Javornik, Andrej Hrovat Jozef Stefan Institute                
 *
 * PURPOSE:      Calculates radio coverage from a single base station 
 *               according to Walfish-Ikegami model
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

struct StructWaIk{
	double BSxIndex; 	/* normalized position of BS -> UTMx/resolution */	
	double BSyIndex; 	/* normalized position of BS -> UTMx/resolution */
	double BSAntHeight;     /* Antenna height of BS [m] */
	double MSAntHeight;     /* Antenna height of MS [m] */
	int xN;			/* dimension of teh input(Raster) and output (PathLoss) */
	int yN;			/* dimension of teh input(Raster) and output (PathLoss) */
	double scale;		/* Resolution of DEM file */
	double freq;		/* Carrier frequency in MHz */	
	double w;		/* Street width [m] */
	double b;		/* Distance between buildings [m] */
	double Hroof;	/* Building height [m] */
	double PHIStreet;  /* Street orientation*/
	double ResDist;		/* Resolution Walfish-Ikegami model profile calc */
	double radi;		/* Radius of calculation [km] */	
    };

/*
 * main function
 */
int main(int argc, char *argv[])
{
    double east;
    double north;
    double ant_height, frequency, radius, dem_height, clut_value;
    double rec_height = 1.5; /* height of receiver from the ground */
    
    struct Cell_head window;	     /* database window         */
    struct Cell_head cellhd;	/* it stores region information,
				   and header information of rasters */
    char *name,  *name2;			/* input raster name */
    char *result;		/* output raster name */
    char *mapset, *mapset2;		/* mapset name */
    void *inrast, *inrast2;		/* input buffer */
    unsigned char *outrast;	/* output buffer */
    int nrows, ncols;
    int row, col;
    int tr_row, tr_col;
    int infd, outfd, infd2;		/* file descriptor */
    int verbose;
    struct History history;	/* holds meta-data (title, comments,..) */

    struct GModule *module;	/* GRASS module for parsing arguments */

    struct Option *input,*opt1, *opt2, *opt4, *opt3, *opt5, *opt6, *opt7, *opt8, *output, *input2, *opt9, *opt10, *opt11;	/* options */
    struct Flag *flag1;		/* flags */

     int dem_defined = 0;
     int clut_defined = 0;

    //FILE *in;			/*file for WaIk param*/
    double w_main, b_main, Hroof_main, PHI_Street_main;	/*WaIk model parameters*/
    //char area_type_main;



    /* initialize GIS environment */
    G_gisinit(argv[0]);		/* reads grass env, stores program name to G_program_name() */

    /* initialize module */
    module = G_define_module();
    module->keywords = _("raster, waik");
    module->description = _("Walfish-Ikegami module");

    /* Define the different options as defined in gis.h */
    input = G_define_standard_option(G_OPT_R_INPUT);        
    
    input2 = G_define_standard_option(G_OPT_R_INPUT);
    input2->key = "clutter_map";
    input2->required = NO;
    input2->description = _("Clutter raster map with path loss coefficients");

    output = G_define_standard_option(G_OPT_R_OUTPUT);

    /* Define the different flags */
    flag1 = G_define_flag();
    flag1->key = 'q';
    flag1->description = _("Quiet");
   
    /*WA-IK parameters ------------------*/
    opt5 = G_define_option();
    opt5->key = "w";
    opt5->type = TYPE_DOUBLE;
    opt5->required = YES;
    opt5->description = _("Street width [m]");

    opt6 = G_define_option();
    opt6->key = "b";
    opt6->type = TYPE_DOUBLE;
    opt6->required = YES;
    opt6->description = _("Distance between buildings [m]");


    opt7 = G_define_option();
    opt7->key = "Hroof";
    opt7->type = TYPE_DOUBLE;
    opt7->required = YES;
    opt7->description = _("Building height [m]");

    opt9 = G_define_option();
    opt9->key = "PHI_Street";
    opt9->type = TYPE_DOUBLE;
    opt9->required = YES;
    opt9->answer = "90";
    opt9->description = _("Street orientation [°]"); 


    opt8 = G_define_option();
    opt8->key = "area_type";
    opt8->type = TYPE_STRING;
    opt8->required = NO;
    opt8->description = _("Type of area");
    opt8->options = "metropolitan,medium_cities";
    opt8->answer = "medium_cities";
    /*------------------------------------*/

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
 
    opt3 = G_define_option();
    opt3->key = "frequency";
    opt3->type = TYPE_DOUBLE;
    opt3->required = YES;
    opt3->description = _("Frequency (MHz)");

    opt4 = G_define_option();
    opt4->key = "radius";
    opt4->type = TYPE_DOUBLE;
    opt4->required = NO;
    opt4->answer = "10";
    opt4->description = _("Radius of calculation (km)");

    opt10 = G_define_option();
    opt10->key = "default_DEM_height";
    opt10->type = TYPE_DOUBLE;
    opt10->required = NO;
    opt10->description = _("Default DEM height (m)");

    opt11 = G_define_option();
    opt11->key = "default_CLUT_value";
    opt11->type = TYPE_DOUBLE;
    opt11->required = NO;
    opt11->description = _("Default clutter value (dB)");

    
           /* options and flags parser */
    if (G_parser(argc, argv))
	exit(EXIT_FAILURE);

    /* stores options and flags to variables */
    name = input->answer;
    name2 = input2->answer;
    result = output->answer;
    verbose = (!flag1->answer);
    G_scan_easting(opt1->answers[0], &east, G_projection());
    G_scan_northing(opt1->answers[1], &north, G_projection());
    sscanf(opt2->answer, "%lf", &ant_height);
    sscanf(opt4->answer, "%lf", &radius);
    sscanf(opt3->answer, "%lf", &frequency); 

    sscanf(opt5->answer, "%lf", &w_main);
    sscanf(opt6->answer, "%lf", &b_main);
    sscanf(opt7->answer, "%lf", &Hroof_main);
    sscanf(opt9->answer, "%lf", &PHI_Street_main);
		/*G_message(_("1.Parameter MAIN A0: %f, A1: %f, A2: %f, A3: %f"), A0_main, A1_main, A2_main, A3_main);*/
 

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

    G_debug(3, "number of rows %d", cellhd.rows);

	/* G_set_window(&cellhd);
	G_get_set_window(&cellhd); */
	G_get_window(&window);

    /* Allocate input buffer */
    inrast = G_allocate_raster_buf(FCELL_TYPE);
    inrast2 = G_allocate_raster_buf(FCELL_TYPE);

    /* Allocate output buffer, use input map data_type */
    nrows = G_window_rows();
    ncols = G_window_cols();
    outrast = G_allocate_raster_buf(FCELL_TYPE);

		//G_message(_("nrows %d and ncols %d"),nrows,ncols);

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
    trans_total_height = (double)trans_elev + ant_height;

    // check if transmitter is on DEM 
    if ( isnan((double)trans_elev))							
	{
		G_fatal_error(_("Transmitter outside raster DEM map."));
			//G_message(_("2. Transmiter elevatino [%f]"),(double)trans_elev);
	}
			//G_message(_("Total transmiter elevatino [%f]"),trans_total_height );

   /*--- define structure variables----*/	
	double BSAntHeight = ant_height;     
	double MSAntHeight = rec_height;     
	int xN = window.rows;			
	int yN = window.cols;	
	double scale = window.ew_res;		
	double freq = frequency;		
	double w = w_main;		
	double b = b_main;		
	double Hroof = Hroof_main;		
	double PHIStreet  = PHI_Street_main;			
	double ResDist = 1;
	double BSyIndex = (east-window.west)/scale+0.5; 
	double BSxIndex = (window.north-north)/scale+0.5;
	double radi = radius;

		// G_message(_("%d, %d, %f, %f, "),tr_row,tr_col,BSxIndex, BSyIndex);

		// G_message(_("2.Parameter BSxIndex: %f, BSyIndex: %f, BSAntHeight: %f, MSAntHeight: %f, xN: %d, yN: %d, scale: %f, freq: %f, w: %f, b: %f, Hroof: %f, ResDist: %f, Radius: %f, PHI: %f"),BSxIndex,BSyIndex, BSAntHeight, MSAntHeight,xN, yN, scale, freq, w, b, Hroof, ResDist, radi, PHIStreet);

   struct StructWaIk IniWaIk = {BSxIndex,BSyIndex, BSAntHeight, MSAntHeight, xN, yN, scale, freq, w, b, Hroof, PHIStreet, ResDist, radi};
   /*---------------------------------*/	
	
//G_message(_("START"));
/* do WA-IK */

    /* allocate the memory to contain the whole file */
	/*RASTER*/
	double **m_rast;
	int i;
	m_rast = (double **)G_calloc(nrows, sizeof(double *));
	//m_rast [0]= (double *)G_calloc(nrows * ncols, sizeof(double));
	double *tmp_rast = (double *)G_calloc(nrows * ncols, sizeof(double));
	memset (tmp_rast, 0, nrows * ncols * sizeof(double));
	for (i=0; i<nrows;i++)	
	{
		m_rast [i] = tmp_rast + i*ncols;
	}
	/*CLUTTER*/
	double **m_clut;
	int j;
	m_clut = (double **)G_calloc(nrows, sizeof(double *));
	//m_rast [0]= (double *)G_calloc(nrows * ncols, sizeof(double));
	double *tmp_clut = (double *)G_calloc(nrows * ncols, sizeof(double));
	memset (tmp_clut, 0, nrows * ncols * sizeof(double));
	for (j=0; j<nrows;j++)	
	{
		m_clut[j] = tmp_clut + j*ncols;
	}
	/*PATH LOSS*/
	double **m_loss;
	int k;
	m_loss = (double **)G_calloc(nrows, sizeof(double *));
	//m_rast [0]= (double *)G_calloc(nrows * ncols, sizeof(double));
	double *tmp_loss = (double *)G_calloc(nrows * ncols, sizeof(double));
	memset (tmp_loss, 0, nrows * ncols * sizeof(double));
	for (k=0; k<nrows;k++)	
	{
		m_loss[k] = tmp_loss + k*ncols;
	}
    
	// G_message(_("WaIkPathLossSub"));	   
	// G_message(_("Transformation"));

    /* Write file (raster and clutter) to array - for each row */

    double dist_Tx_Rx; /* distance between receiver and transmitter */
    double rec_east, rec_north;  /* receiver coordinates */
    double d_east, d_north; /* differences between receiver and transmitter coordinates (e.g. rec_east - tr_east)*/

    for (row = 0; row < nrows; row++) 
    {	
	if (verbose)
	  G_percent(row, nrows, 2);
	FCELL f_in, f_in2;	  
	/* read input map */
	if (G_get_raster_row(infd, inrast, row, FCELL_TYPE) < 0)
	  G_fatal_error(_("Unable to read raster map <%s> row %d"), name, row);
	/* read input map 2 */	
	if (G_get_raster_row(infd2, inrast2, row, FCELL_TYPE) < 0)
	  G_fatal_error(_("Unable to read raster map <%s> row %d"), name2, row);
	/* process the data */
	for (col = 0; col < ncols; col++) 
	  { 
	    f_in = ((FCELL *) inrast)[col];
	    f_in2 = ((FCELL *)inrast2)[col];	

	    /* calculate receiver coordinates */
	    rec_east = window.west + (col * window.ew_res);
	    rec_north = window.north - (row * window.ns_res);	
	    /* calculate differences in coordinates */
	    d_north = rec_north - north;
	    d_east = rec_east - east;
	  /* calculate distance */
	    dist_Tx_Rx = sqrt( pow((east - rec_east),2) + pow((north - rec_north),2) );
	    
	   // check the elevation of the terrain and clutter data - ********************************************************
		if ( isnan((double)f_in)  && dist_Tx_Rx/1000 <= radius)		
		{	
			if (dem_defined == 0)
			{
				if (opt10->answer == NULL)   /* set user defined resolution */
				{	
					G_fatal_error(_("Default DEM height not defined."));
				}
				else
				       sscanf(opt10->answer, "%lf", &dem_height);    
			      G_message(_("Receiver outside raster DEM map. Default height is: %f"), dem_height);
			}							
			dem_defined = 1;
			f_in = (FCELL)dem_height;
			//G_message(_(" Default hieght is: %f"), (double)f_in);
		}

		if ( isnan((double)f_in2)  && dist_Tx_Rx/1000 <= radius)		
		{	
			if (clut_defined == 0)
			{
				if (opt11->answer == NULL)   /* set user defined resolution */
				{	
					G_fatal_error(_("Default clutter value not defined."));
				}
				else
				       sscanf(opt11->answer, "%lf", &clut_value);    
			       G_message(_("Receiver outside clutter map. Default value is: %f"), clut_value);
			}							
			clut_defined = 1;			
			f_in2 = (FCELL)clut_value;
			//G_message(_(" Default hieght is: %f"), (double)f_in);
		}

		// *************************************************************************************
	
	    m_rast[row][col] = (double)f_in;
	    m_clut[row][col] = (double)f_in2;
	
		//G_message(_("m_rast[%d][%d]: %f:: m_clut: %f"),row, col, m_rast[row][col], m_clut[row][col]);  
	  }
     
      }
		// G_message(_("Transformation"));
	WaIkPathLossSub (m_rast, m_clut, m_loss, IniWaIk, opt8->answer); 
		// G_message(_("Transformation"));

    double path_loss_num;
    FCELL  null_f_out;

    for (row = 0; row < nrows; row++)
    {
	G_percent(row, nrows, 2);
	for (col = 0; col < ncols; col++) 
	{
		path_loss_num = m_loss[row][col];
		if (path_loss_num == 0)
		{
			G_set_f_null_value(&null_f_out, 1);   
			((FCELL *) outrast)[col] =null_f_out;
		}	
		else
		{
			((FCELL *) outrast)[col]  = (FCELL)path_loss_num;
		} 

	
		//((FCELL *) outrast)[col] = m_loss[row][col];
			//G_message(_("m_rast[%d][%d]: %f"),row, col, m_loss[row][col]);  
	}
 	/* write raster row to output raster map */
	if (G_put_raster_row(outfd, outrast, FCELL_TYPE) < 0)
	G_fatal_error(_("Failed writing raster map <%s>"), result);
    }


		// G_message(_("END"));

    /* memory cleanup */
    G_free(inrast);
    G_free(outrast);
    G_free(inrast2);


    /* closing raster maps */
    G_close_cell(infd);
    G_close_cell(outfd);
    G_close_cell(infd2);

    /* add command line incantation to history file */
    G_short_history(result, "raster", &history);
    G_command_history(&history);
    G_write_history(result, &history);

    exit(EXIT_SUCCESS);
}


int WaIkPathLossSub(double** Raster, double** Clutter, double** PathLoss, struct StructWaIk IniWaIk, char *area_type)
/*************************************************************************************************
 *
 *		Function WaIkPathLossSub calculates PathLoss in dB using Walfish-Ikegami path loss formula
 *			**PathLoss:		array of path loss in dB
 *
 *			**Raster:       input DEM file
 *          **Clutter:      input clutter file
 *			
 *			T.Javornik, Jan. 2010
 *
 *************************************************************************************************/
{
	//printf("WaIkPathLossSub \n");

	// Walfish-Ikegami model constants and variables
	double BSxIndex = IniWaIk.BSxIndex;		//	normalized position of BS -> UTMx/resolution 
	double BSyIndex = IniWaIk.BSyIndex;		//	normalized position of BS -> UTMy/resolution
	double AntHeightBS = IniWaIk.BSAntHeight;	//	Antenna height of BS [m]
	double AntHeightMS = IniWaIk.MSAntHeight;	//	Antenna height of MS [m]
	int xN = IniWaIk.xN;				//	dimension of the input(Raster) and output (PathLoss)
	int yN = IniWaIk.yN;				//	dimension of the input(Raster) and output (PathLoss)
	double scale = IniWaIk.scale;			//	Resolution Walfish-Ikegami model
	double w = IniWaIk.w;				//	Street width [m]
	double b = IniWaIk.b;				//	Distance between buildings [m] 
	double Hroof  = IniWaIk.Hroof;		//	Building height [m] 
	double PHI_Street  = IniWaIk.PHIStreet;	//	Street orientation
	double freq  = IniWaIk.freq;			//	carrier frequency
	double ResDist = IniWaIk.ResDist;		//	distance BS - MS sampling rate [normalized with scale
	double Lambda = 300.0/freq;			//	wave lenght
	double radi = IniWaIk.radi;			// radius of calculation

		// G_message(_("Radij: %f, PHI: %f"),radi, PHI_Street);
		//G_message(_("2.Parameter BSxIndex: %f, BSyIndex: %f, BSAntHeight: %f, MSAntHeight: %f, xN: %d, yN: %d, scale: %f, freq: %f, w: %f, b: %f, Hroof: %f, ResDist: %f"),BSxIndex,BSyIndex, AntHeightBS, AntHeightMS,xN, yN, scale, freq, w, b, Hroof, ResDist);

//--------------------------------------------------------------------------------------------------------------------------------------------	
	double ZoBS;					
	double ZoTransBS,ZoTransMS;       // BS and MS height about the sea level

	double ZoTransBS_delta, ZoTransMS_delta;  // BS and MS height about/below roof

	double FreeSpacePathLoss = 0;			//  Free space path loss	
	double PathLoss_RTS;					//  Roof-top-to-street diffraction and scatter loss
	double PathLoss_MSD;					//  Multi-screen loss
        double PathLoss_Street;			  	//  Street orientation loss
	
	//double PHI_Street;						// Street orientation angle
	double temp_angle; 					// temporary angle
	//double PathLossTmp = 0;				// tmp path loss

	double tiltBS2MS;				// (ZoBS-ZoMS)/distBS2MSNorm	
	
	int ix; int iy;	
	double DiffX, DiffY, Zeff;			// Difference in X and Y direction
	
	double DistBS2MSNorm, DistBS2MSKm;		// distance between MS and BS in Km sqrt(x2+y2+z2) * scale / 1000
							// normalized distance between MS and BS in xy plan sqrt(x2+y2)

	double ElevAngCos, Hdot, Ddot, Ddotdot, PathLossDiff;

	double ZObs2LOS = 0;
	double DistObs2BS = 0;

	ZoBS = Raster[(int)BSxIndex][(int)BSyIndex];	// BS height above the sea level calculated from raster DEM file
	ZoTransBS = ZoBS + AntHeightBS;			// BS transmitter height above the sea level
 /*PREGLEJ*/       ZoTransBS_delta =  ZoTransBS - Hroof;		// BS transmitter height above the roof
     // Path loss MSD factos
	double PathLoss_MSD1 = 0;
	double ka =0;
	double kd =0;
	double kf =0;
	
	// PathLoss_MSD1 -------------------------------------------------------------------------------
	if (ZoTransBS > Hroof)
		PathLoss_MSD1 = -18*log10(1+ZoTransBS_delta);
	else if (ZoTransBS <= Hroof)
		PathLoss_MSD1 = 0;
	// kf
	if (strcmp(area_type, "metropolitan") == 0)
		kf = -4 + 1.5*((freq/925)-1);
	else if (strcmp(area_type, "medium_cities") == 0)
		kf = -4 + 0.7*((freq/925)-1);		
	else
		G_fatal_error(_("Unknown area type: [%s]."), area_type);
	//------------------------------------------------------------------------------------------------------
	
		/* 	G_message(_("BS antenna above sea level: %f \n"), ZoBS);
			G_message(_("BSxIndex: %d, BSyIndex: %d"),(int)BSxIndex, (int)BSyIndex);
			G_message(_("START_1::: xN: %d, yN: %d"), xN, yN);
		*/
		// G_message(_("Model computation started."));
	for (ix = 0; ix < xN; ix++)
	{
		G_percent(ix, xN, 2);
		for (iy = 0; iy < yN; iy++)
		{
		     // Path Loss due to Hata model
			DiffX = (BSxIndex-ix); DiffY = (BSyIndex-iy);
			// ZoMS = Raster[ix][iy];
			ZoTransMS = Raster[ix][iy]+AntHeightMS;  // ZoMS
                	Zeff = ZoTransBS - ZoTransMS;

			ZoTransMS_delta = Hroof - AntHeightMS;       // MS receiver hight below roof

			DistBS2MSKm = sqrt(DiffX*DiffX+DiffY*DiffY)*scale/1000;//sqrt(DiffX*DiffX+DiffY*DiffY+Zeff*Zeff)*scale/1000;
			DistBS2MSNorm = sqrt(DiffX*DiffX+DiffY*DiffY);
						
			if(ZoBS <= Raster[ix][iy]) {
				Zeff = AntHeightBS;  // ZoMS
			}
			
			if (DistBS2MSKm < 0.01){
				DistBS2MSKm = 0.01;
			}
			if ((DistBS2MSKm) > radi)
		    	{    
			      	continue;
			}

		     // Free space loss  -------------------------------------------------------------------------------------------------------------------		
			FreeSpacePathLoss = 32.4 + 20*log10(freq) + 20*log10(DistBS2MSKm);			
			
			// Rooftop-to-street difraction and scatter loss - PathLoss_RTS 	--------------------------------------------------------
				
								//G_message(_("DiffX: %f and DiffY: %f, scale: %f"), DiffX, DiffY, scale);
			/* temp_angle = atan ((DiffY)/(DiffX));	//  Path loos street orientation
			if (temp_angle < 0)
			      temp_angle = - temp_angle;
			PHI_Street = temp_angle * 180 / PI;  	// convert from radians to degrees */

								//G_message(_("tem_angle: %f and PHI_Street: %f"), temp_angle, PHI_Street);
								//G_message(_("PHI_Street: %f"), PHI_Street);

			if (PHI_Street>=0 && PHI_Street < 35)
				PathLoss_Street = -10 + 0.354*PHI_Street;
			else if (PHI_Street>=35 && PHI_Street < 55)
				PathLoss_Street = 2.5 - 0.075*(PHI_Street - 35);
			else if (PHI_Street>=55 && PHI_Street < 91 )
				PathLoss_Street = 4 - 0.114*(PHI_Street - 55);
			else{
				PathLoss_Street = 0;  										// Tx location (PHI_Street= nan)
				// G_message(_("Wrong street orienatation angle: [%f]."), PHI_Street);
				// //G_fatal_error(_("Wrong street orienatation angle: [%f]."), PHI_Street);
				}	
								//G_message(_("PathLoss_Street: %f"), PathLoss_Street);
	
			if (Hroof>AntHeightMS){
				PathLoss_RTS = -16.9 - 10*log10(w) + 10*log10(freq) + 20*log10(ZoTransMS_delta) + PathLoss_Street;  
			}
			else {
				PathLoss_RTS= 0;
			}
		
		     	// Multi-screen loss	- PathLoss_MSD	----------------------------------------------------------------------------------------
			   // ka
			if (DistBS2MSKm >=0.5 && ZoTransBS <= Hroof)	
				ka = 54 - 0.8*ZoTransBS_delta;
			else if (DistBS2MSKm < 0.5 && ZoTransBS <= Hroof)	
				ka = 54 - 0.8*ZoTransBS_delta*(DistBS2MSKm/0.5);
			else if (ZoTransBS > Hroof)	
				ka = 54;
			  // kd
			if (ZoTransBS > Hroof)
				kd = 18; 
			else if (ZoTransBS <= Hroof)
				kd = 18 - 15*(ZoTransBS/Hroof);
				
			PathLoss_MSD = PathLoss_MSD1 + ka + kd*log10(DistBS2MSKm) + kf*log10(freq) - 9*log10(b);
			if (PathLoss_MSD < 0){
				PathLoss_MSD = 0;		
			}
                        // ------------------------------------------------------------------------------------------------------------------------------
                      
			// write data to pathloss --------------------------------------------------------------------------------------------------
			PathLoss[ix][iy] = FreeSpacePathLoss + PathLoss_RTS + PathLoss_MSD + Clutter[ix][iy];
		} // end irow
	} // end icol
	return 0;
}

