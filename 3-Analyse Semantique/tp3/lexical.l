%{
#include <string.h>
#include "syntaxe.h"
extern int lineNumber;

%}
%option noyywrap

entier [1-9][0-9]*|0
identif [a-zA-Z_][0-9a-zA-Z_]*

%%

var { return VAR;}
"=" {return AFFECT;}
";" {return PTVIRG;}
[" "\t] {}
{entier} { yylval.entier = atoi(yytext); return ENTIER; }
{identif} { strcpy(yylval.var, yytext);return IDENTIF; }
"\n" { ++lineNumber; }
. { return yytext[0]; }
%%