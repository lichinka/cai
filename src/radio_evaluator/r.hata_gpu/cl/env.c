#include <stdlib.h>
#include <stdio.h>
#include <string.h>



int
__getenv_token( const char* name, const char* token, char* value, size_t n )
{
    char* envstr = (char*)getenv(name);

    *value  = '\0';

    if (!envstr)
		return(1);
	else
		printf ("Env. variable found!\n");

    char* ptr;
    char* clause = strtok_r(envstr,":",&ptr);

   while (clause) {

        char* sep = strchr(clause,'_');

      if (sep) {

            if (token && !strncasecmp(token,clause,strlen(token))) {

				if ((strlen(sep+1)+1) < n)
                	strncpy(value,sep+1, strlen(sep+1)+1);
				else
                	strncpy(value,sep+1, n);
	
                return(0);

            }

      } else if (!token) {

			if ((strlen(clause)+1) < n)
            	strncpy(value,clause,strlen(clause)+1);
			else
            	strncpy(value,clause,n);

            return(0);

      }

      clause = strtok_r(NULL,":",&ptr);
   }

    return(2);
}



int main (int argc, char **argv)
{
	int err;
	char name[256];

	err = __getenv_token("STDGPU","platform_name",name,256);

	printf ("__getenv returned %d and ", err);
	printf ("%s\n", name);

	return (1);
}
