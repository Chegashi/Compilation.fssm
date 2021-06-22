%{
#include <stdio.h>
extern FILE* yyin; //file pointer by default points to terminal
int yylex(void); // defini dans progL.cpp, utilise par yyparse()
void yyerror(const char * msg);
int lineNumber; // notre compteur de lignes
%}
%token DEBUT FIN // les lexemes que doit fournir yylex()
%token IDENTIF ENTIER AFFECT PTVIRG
%token POUR ALLANT_DE JUSQUA
%start program /// l’axiome de notre grammaire
%%
program : DEBUT listInstr FIN {printf(" sqlt pgme \n");}
;
listInstr : listInstr inst
| inst
;
inst : IDENTIF AFFECT expr PTVIRG {printf(" instr affect \n");}
    |POUR IDENTIF ALLANT_DE ENTIER JUSQUA ENTIER inst PTVIRG {printf("boucle POUR")}
;
expr : ENTIER {printf(" expr entier \n");}
| IDENTIF {printf(" expr identif \n");}
;
%%
void yyerror( const char * msg){
printf("line %d : %s", lineNumber, msg);
}
int main(int argc,char ** argv){
if(argc>1) yyin=fopen(argv[1],"r"); // check result !!!
lineNumber=1;
if(!yyparse())
printf("Expression correct n");
return(0);
}