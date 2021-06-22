%{
#include <string.h>
#include <stdlib.h>
#include "syntaxe.h"
extern char s[10];
extern int l;
extern int lineNumber,c;
%}
%option noyywrap
nbr [0-9]
entier {nbr}+
identif [a-zA-Z_][0-9a-zA-Z_]*[\s]?
%%
Ecrire {return ECRIRE;}
Algorithme {return ALGO;}
Entier {return ENTIE;}
":" {return DP;}
"+" {return PLUS;}
"-" {return MOIN;}
"*" {return MULT;}
"/" {return DIVS;}
"(" {return PAR_O;}
")" {return PAR_F;}
var {return VAR;}
debut { return DEBUT; }
fin { return FIN; }
[" "\t] { /* rien */ }
{entier} {l=atoi(yytext);return ENTIER; }
{identif} { strcpy(s, yytext);return IDENTIF; }
"=" { return AFFECT; }
";" { return PTVIRG; }
"," {return VIRG;}
"\n" { ++lineNumber; }
. { return yytext[0]; }
%%return 0;

