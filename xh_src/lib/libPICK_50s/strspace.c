/*------------------------------------------*/
/* 
  Determines the first SPACE in a string 
*/

int strspace(name)

   char *name;
{
int i=0, j=1;

while (j) {
   if (name[i] == ' ') return(i);
   i++;
}
}
