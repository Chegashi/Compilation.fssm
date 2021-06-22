/* fichier syntaxe.y */
%{
int yyerror();
int yylex();
#include <stdio.h>
#include <stdlib.h>
%}
%token NOMBRE PLUS MOIN MULT DIVS PAR_O PAR_F
%start expression
%%
expression: expression PLUS terme
| expression MOIN terme
| terme
;
terme: terme MULT facteur
| terme DIVS facteur
| facteur
;
facteur: PAR_O expression PAR_F
| MOIN facteur
| NOMBRE
;
%%
int main(void){
if (yyparse()==0)
printf("expression correcte");
}
int yyerror(){
fprintf(stderr,"erreur de syntaxe\n");
return 1;
}