/* fichier lexique.l */
%{
#include "calcY.h"
%}
%%
[0-9]+ {return NOMBRE;}
"+" {return PLUS;}
"-" {return MOIN;}
"*" {return MULT;}
"/" {return DIVS;}
"(" {return PAR_O;}
")" {return PAR_F;}
[\t];
\n return 0;
. return yytext[0];
%%
int yywrap(void){
return 0;
}