%{
extern int lineNumber;
#include "syntaxeY.h"
%}
%option noyywrap
nbr [0-9]
entier {nbr}+
identif [a-zA-Z_][0-9a-zA-Z_]*
%%
debut { return DEBUT; }
fin { return FIN; }
pour { return POUR;}
allant_de { return ALLANT_DE;}
jusqua {return JUSQUA; }
[" "\t] { /* rien */ }
{entier} { return ENTIER; }
{identif} { return IDENTIF; }
"="     { return AFFECT; }
";"     { return PTVIRG;}
"\n"    { ++lineNumber; }
.       { return yytext[0];}
%%