%{
#include <string.h>
#include "unitesLexicales.h"
%}
nbr [0-9]
entier {nbr}+
identif [a-zA-Z_][0-9a-zA-Z_]*
%%
debut { ECHO; return DEBUT; }
fin { ECHO; return FIN; }
{entier} { ECHO; valEntier = atoi(yytext); return ENTIER; };
{identif} {ECHO; strcpy(valIdentif, yytext); return IDENTIF; }
. { ECHO; return yytext[0]; }
%%
int valEntier;
char valIdentif[256];
int yywrap(void) {
return 1;
}