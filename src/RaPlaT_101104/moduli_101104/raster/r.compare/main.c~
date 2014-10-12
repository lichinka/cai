
/****************************************************************************
 *
 * MODULE:       r.compare		
 * AUTHOR(S):    Andrej Hrovat, Jozef Stefan Institute                
 *
 * PURPOSE:      Compare results of two path loss prediction models
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
 * main function
 */
int main(int argc, char *argv[])
{

/*    struct Cell_head window;	     database window         */
    struct Cell_head cellhd;	/* it stores region information,
				   and header information of rasters */
    struct Cell_head cellhd2;
   
    char *name, *name2;			/* input raster name */
    char *result;		/* output raster name */
    char *mapset, *mapset2;		/* mapset name */
    void *inrast, *inrast2;		/* input buffer */
    unsigned char *outrast;	/* output buffer */
    int nrows, ncols;

    //int row_start,row_end;
    //int col_start, col_end;

    //int north_2, south_2, east_2, west_2;
    

    int row, col;
    int infd, outfd, infd2;		/* file descriptor */
    int verbose;
    struct History history;	/* holds meta-data (title, comments,..) */

    struct GModule *module;	/* GRASS module for parsing arguments */

    struct Option *input, *output, *input2;	/* options */
    struct Flag *flag1;		/* flags */
 
    /* initialize GIS environment */
    G_gisinit(argv[0]);		/* reads grass env, stores program name to G_program_name() */

    /* initialize module */
    module = G_define_module();
    module->keywords = _("raster, difference");
    module->description = _("Path loss difference module");

    /* Define the different options as defined in gis.h */
    input = G_define_standard_option(G_OPT_R_INPUT);
    input->key = "Raster_File_Path_Loss_Values_1";
    input->required = YES;
    input->description = _("Path loss-first model");

    input2 = G_define_standard_option(G_OPT_R_INPUT);
    input2->key = "Raster_File_Path_Loss_Values_2";
    input2->required = NO;
    input2->description = _("Path loss-second model");
        
    output = G_define_standard_option(G_OPT_R_OUTPUT);

    /* Define the different flags */
    flag1 = G_define_flag();
    flag1->key = 'q';
    flag1->description = _("Quiet");

    /* options and flags parser */
    if (G_parser(argc, argv))
	{
	exit(EXIT_FAILURE);
	}
    /* stores options and flags to variables */
    name = input->answer;
    name2 = input2->answer;
    result = output->answer;

G_message(_("name: <%s>, name2: <%s>: "),name,name2);

    /* returns NULL if the map was not found in any mapset, 
     * mapset name otherwise */
G_message(_("3_START"));

    mapset = G_find_cell2(name, "");
    if (mapset == NULL){
	G_fatal_error(_("Raster map <%s> not found"), name);
    }
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
    if (G_get_cellhd(name, mapset, &cellhd) < 0)  // cellhd prve mape
	G_fatal_error(_("Unable to read file header of <%s>"), name);
	
   	
    if (G_get_cellhd(name2, mapset2, &cellhd2) < 0)  // cellhd druge mape
	G_fatal_error(_("Unable to read file header of <%s>"), name2);

   //row_start = (north_2 - cellhd.north)/cellhd.ns_res;
   //col_start = (cellhd.west - west_2)/cellhd.ew_res;
    					//tr_row = (cellhd.north - north) / cellhd.ns_res;
   					//tr_col = (east - cellhd.west) / cellhd.ew_res;
   //G_message(_("row_start: [%d], col_start: [%d]"),row_start, col_start);	        

    G_debug(3, "number of rows %d", cellhd2.rows);

	G_set_window(&cellhd2);
	G_get_set_window(&cellhd2);

    /* Allocate input and output buffer */
    inrast = G_allocate_raster_buf(FCELL_TYPE);
    inrast2 = G_allocate_raster_buf(FCELL_TYPE);

    /* Allocate output buffer, use input map data_type */
    outrast = G_allocate_raster_buf(FCELL_TYPE);

    nrows = cellhd2.rows;
    ncols = cellhd2.cols;
G_message(_("nrows %d and ncols %d"),nrows,ncols);

    /* controlling, if we can write the raster */
    if ((outfd = G_open_raster_new(result, FCELL_TYPE)) < 0)
	G_fatal_error(_("Unable to create raster map <%s>"), result);
 
G_message(_("START"));

    /* for each row */
    for (row = 0; row < nrows; row++) 
      {	  
	if (verbose)
	  G_percent(row, nrows, 2);

	  FCELL f_in, f_in2, f_out;	  
	 
	/* read input map */
	if (G_get_raster_row(infd, inrast, row, FCELL_TYPE) < 0)
	  G_fatal_error(_("Unable to read raster map <%s> row %d"), name, row);
        if (G_get_raster_row(infd2, inrast2, row, FCELL_TYPE) < 0)
	  G_fatal_error(_("Unable to read raster map <%s> row %d"), name2, row);

	 
	/* process the data */
	for (col = 0; col < ncols; col++) 
	  { 
	    f_in = ((FCELL *) inrast)[col];
            f_in2 = ((FCELL *) inrast2)[col];

	    //G_message(_("Input data: f_in: [%f], f_in2: [%f]"),(double)f_in, (double)f_in2);
	        	      	     
	    f_out = (double)f_in - (27.5-(double)f_in2/100);
            //f_out = (double)f_in - (double)f_in2;
            //G_message(_("Difference: %f"),(double)f_out);	        	      	    
	
		//G_message(_("row [%d], col [%d]"),row, col);	        	      	    

	    ((FCELL *) outrast)[col] = f_out;

	  }
      
	/* write raster row to output raster map */
	if (G_put_raster_row(outfd, outrast, FCELL_TYPE) < 0)
	  G_fatal_error(_("Failed writing raster map <%s>"), result);
      }
         
G_message(_("END"));

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
