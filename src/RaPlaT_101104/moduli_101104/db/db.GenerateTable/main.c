
/****************************************************************************
 *
 * MODULE:       db.GenerateTable
 *
 * AUTHOR(S):    Tine Celcer, Jozef Stefan Institute                
 *
 * PURPOSE:      Generiranje/priprava DBF tabele za vpis podatkov v modulu r.MaxPower
 *             
 *
 * COPYRIGHT:    (C) 2009 Jozef Stefan Institute
 *
 *
 *****************************************************************************/

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>
#include <grass/gis.h>
#include <grass/dbmi.h>
#include <grass/glocale.h>
#include <grass/codes.h>


int main(int argc, char *argv[])
{
 dbConnection conn;
 dbDriver *driver; 
 dbTable *table;
 int i,ncols_tab,cell_num,ovr;
 char *tabname;
 char *drv_name;
 char *db_name; 
 char temp_str[10];  
 char temp_str1[4];
 
 
 struct GModule *module;	    /* GRASS module for parsing arguments */
 struct Option *table_name,*cell_number,*driver_name,*database;  /* options */
 struct Flag *flag1;		    /* flags */

 /* initialize GIS environment */
    G_gisinit(argv[0]);		/* reads grass env, stores program name to G_program_name() */

    /* initialize module */
    module = G_define_module();
    module->keywords = _("generateTable, DB");
    module->description = _("GenerateTable module"); 
    
    /* Define the different flags */   
    flag1 = G_define_flag();
    flag1->key = 'o';
    flag1->description = _("allow overwrite");
    
    table_name = G_define_option();
    table_name->required = YES;
    table_name->key = "table";
    table_name->type = TYPE_STRING;
    table_name->description = _("Table name");

    driver_name = G_define_option();
    driver_name->required = YES;
    driver_name->key = "driver";
    driver_name->type = TYPE_STRING;
    driver_name->description = _("Driver name");
    driver_name->options = db_list_drivers();
    driver_name->answer = (char *) db_get_default_driver_name();

    database = G_define_option();
    database->required = YES;
    database->key = "database";
    database->type = TYPE_STRING;
    database->description = _("Database name");
    database->answer = (char *) db_get_default_database_name();

    cell_number = G_define_option();
    cell_number->key = "cell_num";
    cell_number->type = TYPE_INTEGER;
    cell_number->required = YES;
    cell_number->description = _("Number of successive path loss values to be written in the table");

    /* options and flags parser */
    if (G_parser(argc, argv))
	exit(EXIT_FAILURE);

    /* stores options and flags to variables */
   tabname = table_name->answer;
   drv_name = driver_name->answer;
   db_name = database->answer;
   sscanf(cell_number->answer, "%d", &cell_num);
   ovr = flag1->answer; 
   
   ncols_tab=3*cell_num+4;   

   //preveri ce tabela s tem imenom ze obstaja 
   if (db_table_exists(drv_name, db_name,tabname)==1)
      { 
       if (ovr)
        db_delete_table(drv_name, db_name,tabname); 
       else  
        G_fatal_error(_("Table <%s> already exists"), tabname);
      }

   /* set connection */
   db_get_connection(&conn);	/* read current */

   if (driver_name->answer)
	conn.driverName = drv_name;

   if (database->answer)
	conn.databaseName = db_name;

   db_set_connection(&conn);  

   driver = db_start_driver_open_database(drv_name, db_name);  
   table = db_alloc_table(ncols_tab);
   db_set_table_name(table, tabname);

   for (i=0;i<cell_num+1;i++)
   {
     if(i==0)
      {
        db_set_column_name(&table->columns[3*i],"x");
	db_set_column_sqltype(&table->columns[3*i],DB_SQL_TYPE_INTEGER);
	db_set_column_length(&table->columns[3*i],6);

        db_set_column_name(&table->columns[3*i+1],"y");
	db_set_column_sqltype(&table->columns[3*i+1],DB_SQL_TYPE_INTEGER);
	db_set_column_length(&table->columns[3*i+1],6);
 
        db_set_column_name(&table->columns[3*i+2],"resolution");
	db_set_column_sqltype(&table->columns[3*i+2],DB_SQL_TYPE_INTEGER);
	db_set_column_length(&table->columns[3*i+2],4);

      }

     else
      { 
                
        strcpy(temp_str,"cell");
        sprintf(temp_str1,"%d",i);
        strcat(temp_str,temp_str1);

        db_set_column_name(&table->columns[3*i],temp_str);
        db_set_column_sqltype(&table->columns[3*i],DB_SQL_TYPE_CHARACTER);
	db_set_column_length(&table->columns[3*i],10);
	
        strcpy(temp_str,"Pr");
        strcat(temp_str,temp_str1);

        db_set_column_name(&table->columns[3*i+1],temp_str);
	db_set_column_sqltype(&table->columns[3*i+1],DB_SQL_TYPE_INTEGER);
	db_set_column_length(&table->columns[3*i+1],6);

        strcpy(temp_str,"model");
        strcat(temp_str,temp_str1);
   
        db_set_column_name(&table->columns[3*i+2],temp_str);
	db_set_column_sqltype(&table->columns[3*i+2],DB_SQL_TYPE_CHARACTER);
	db_set_column_length(&table->columns[3*i+2],35);
      }   

   }

  db_set_column_name(&table->columns[ncols_tab-1],"EcN0");
  db_set_column_sqltype(&table->columns[ncols_tab-1],DB_SQL_TYPE_INTEGER);
  db_set_column_length(&table->columns[ncols_tab-1],6);   
       
  db_create_table(driver,table);
  
  db_close_database(driver);
  db_shutdown_driver(driver);

  exit(EXIT_SUCCESS);
}
