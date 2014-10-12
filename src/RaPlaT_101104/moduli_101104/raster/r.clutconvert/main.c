
/****************************************************************************
 *
 * MODULE:       r.clutconvert		
 * AUTHOR(S):    Andrej Hrovat, Jozef Stefan Institute                
 *
 * PURPOSE:      Convert land usage code from clutter file to 
 *               path loss factors
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
    char *name, *name2;			/* input raster name */
    char *result;		/* output raster name */
    char *mapset;		/* mapset name */
    void *inrast;		/* input buffer */
    unsigned char *outrast;	/* output buffer */
    int nrows, ncols;
    int row, col;
    int infd, outfd;		/* file descriptor */
    int verbose;
    struct History history;	/* holds meta-data (title, comments,..) */

    struct GModule *module;	/* GRASS module for parsing arguments */

    struct Option *input, *output, *input2;	/* options */
    FILE *in;			/*file for Path loss factors*/
	
    struct Flag *flag1;		/* flags */
   	
   char buffer_out[1000];
        
        
	strcpy(buffer_out,getenv("GISBASE"));
	strcat(buffer_out,"/etc/radio_coverage/lossfactors_new.txt");
	/*G_message(_("1!! Pot1: %s, Pot2: %s"), buffer_path, buffer_path1);     
	buffer_out=strcat(buffer_path,buffer_path1);
	G_message(_("Pot1: %s, Pot2: %s"), buffer_path, buffer_path1);*/

    /* initialize GIS environment */
    G_gisinit(argv[0]);		/* reads grass env, stores program name to G_program_name() */

    /* initialize module */
    module = G_define_module();
    module->keywords = _("raster, clutter");
    module->description = _("Clutter convert module");

    /* Define the different options as defined in gis.h */
    input = G_define_standard_option(G_OPT_R_INPUT);

    input2 = G_define_standard_option(G_OPT_F_INPUT);
    input2->key = "Path_loss_values";
    input2->type = TYPE_STRING;
    input2->required = YES;
    input2->answer = buffer_out;//getenv("GISBASE"); //strcat(buffer_path1,(char *)getenv("GISBASE"));//,"/etc/radio_coverage");
    input2->gisprompt = "old_file,file,input";
    input2->description = _("Path loss factors for land usage");
  
    /* Define the different flags */
     flag1 = G_define_flag();
     flag1->key = 'o';
     flag1->description = _("Old_Cipher");     

    output = G_define_standard_option(G_OPT_R_OUTPUT);
	
    /* options and flags parser */
    if (G_parser(argc, argv))
	{
	exit(EXIT_FAILURE);
	}
      

        /*G_message(_("1!! Pot1: %s, Pot2: %s"), buffer_path, buffer_path1);     
	strcat(buffer_path,buffer_path1);
	G_message(_("Pot1: %s, Pot2: %s"), buffer_path, buffer_path1);
        input2->answer = buffer_path;//getenv("GISBASE"); //strcat(buffer_path1,(char *)getenv("GISBASE"));//,"/etc/radio_coverage");*/

/* stores options and flags to variables */
    name = input->answer;
    name2 = input2->answer;
    result = output->answer;
    verbose = (flag1->answer);
	
G_message(_("Verbose: %d"),verbose);  

    /* returns NULL if the map was not found in any mapset, 
     * mapset name otherwise */
//G_message(_("3_START"));

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

	G_set_window(&cellhd);
	G_get_set_window(&cellhd);

    /* Allocate input buffer */
    inrast = G_allocate_raster_buf(FCELL_TYPE);

    /* Allocate output buffer, use input map data_type */
    nrows = G_window_rows();
    ncols = G_window_cols();
    outrast = G_allocate_raster_buf(FCELL_TYPE);

G_message(_("nrows %d and ncols %d"),nrows,ncols);

    /* controlling, if we can write the raster */
    if ((outfd = G_open_raster_new(result, FCELL_TYPE)) < 0)
	G_fatal_error(_("Unable to create raster map <%s>"), result);
 
/* do Clutter Convert */

    /* open file for model tuning parameters*/
    char fileName[150];
    strcpy (fileName, name2);

//G_message(_("Path: %s"),name2); 

    if( (in = fopen(fileName,"r")) == NULL )
		G_fatal_error(_("Unable to open file <%s>"), fileName);  
    
    char buffer[256];
    double terr_path_loss[100];
    int counter=0;  
    fgets (buffer, 250, in);	

    while(fgets(buffer,250,in)!=NULL){
   	sscanf(buffer,"%lf %lf", &terr_path_loss[counter]);	
	counter++;
    }
    
    int cipher_cont=0;	
   /* old or new clutter */
    if (verbose == 1)
    {
	cipher_cont=1;  
	G_message(_("Parameter UR: %f, GP: %f, RP: %f, GI: %f, GL: %f, GM: %f, GR: %f, VO: %f, KM: %f, OD: %f"), terr_path_loss[0], terr_path_loss[1], terr_path_loss[2], terr_path_loss[3], terr_path_loss[4], terr_path_loss[5], terr_path_loss[6], terr_path_loss[7], terr_path_loss[8], terr_path_loss[9]);
    }
   else if (verbose == 0)
   {
	cipher_cont=11;
	G_message(_("Parameter UR1: %f, UR2: %f, UR3: %f, UR4: %f, UR5: %f, GI: %f, GL: %f, GM: %f, GR: %f, VO: %f, KM: %f, OD: %f"), terr_path_loss[0], terr_path_loss[1], terr_path_loss[2], terr_path_loss[3], terr_path_loss[4], terr_path_loss[5], terr_path_loss[6], terr_path_loss[7], terr_path_loss[8], terr_path_loss[9], terr_path_loss[10], terr_path_loss[11]);
   }


    G_message(_("Counter: %d"),counter); 
    G_message(_("cipher_cont: %d"),cipher_cont);      
    G_message(_("START"));

    /* for each row */
    for (row = 0; row < nrows; row++) 
      {	  

	  FCELL f_in, f_out;	  
	 
	/* read input map */
	if (G_get_raster_row(infd, inrast, row, FCELL_TYPE) < 0)
	  G_fatal_error(_("Unable to read raster map <%s> row %d"), name, row);
	 
	/* process the data */
	for (col = 0; col < ncols; col++) 
	  { 
	    f_in = ((FCELL *) inrast)[col];

	    //G_message(_("Input data: %d"),(int)f_in);
	        	      	     
	    f_out = terr_path_loss[(int)f_in-cipher_cont];
            	    
           //G_message(_("Output data: %f"),(double)f_out);

	    ((FCELL *) outrast)[col] = f_out;

	  }
      
	/* write raster row to output raster map */
	if (G_put_raster_row(outfd, outrast, FCELL_TYPE) < 0)
	  G_fatal_error(_("Failed writing raster map <%s>"), result);
      }
         
//G_message(_("END_clutconvert_test"));
G_message(_("END"));

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
