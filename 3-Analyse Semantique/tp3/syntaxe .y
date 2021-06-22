%{
#include <stdio.h>
#include"SYNTAXE.h"
#include <stdlib.h>
#include <string.h>

extern FILE* yyin;

int yylex(void);

void yyerror(const char * msg);
int isToken(char *s, char t[][8]);
int isDeclared(char *s, char t[][20]);
void createIdentif(char *s,char t[][20]);
void isUsable(char *s,char t[][20]);
void identifTest(char *s,char t[][8],char vars[][20]);

int lineNumber;
int i=0;
char tokens[3][8] = {"debut", "var", "fin"};
char vars[10][20];
%}
%union {
char var[256];
int entier;
}


%token <var>IDENTIF <entier>ENTIER AFFECT PTVIRG
%token VAR
%start program
%%
program 		: '{' listInstr '}' {printf(" sqlt pgme\n");}
				;

listInstr 		: listInstr inst
				| inst
				;

inst 			: IDENTIF AFFECT expr PTVIRG {if(isDeclared($1,vars) == 0) {yyerror("Variable is not declared"); exit(-3);}}
				| VAR listVariables PTVIRG 
				;

listVariables 	: listVariables ',' IDENTIF {identifTest($3,tokens,vars);}
				| IDENTIF 
				;

expr 			: ENTIER {printf(" expr entier \n");}
 				| IDENTIF {printf(" expr identif \n");}
				;
%% 


int	isToken(char *s,char t[][8]){
	int i;
	for(i=0;i<3;i++)
		if (strcmp(s,t[i]) == 0)
			return -1;
	return 0;
}

int	isDeclared(char *s,char t[][20]){
	int i;
	for(i=0;i<3;i++)
		if (strcmp(s,t[i]) == 0)
			return -1;
	return 0;
}

void createIdentif(char *s,char t[][20]){
	strcpy(t[i++],s);
}

void isUsable(char *s,char t[][20]){
	if (isDeclared(s,t) == 0){
		yyerror("Using a non declared variable\n");
		exit(-1);
	}
}

void identifTest(char *s,char t[][8],char vars[][20]){
	if (isToken(s,t) == -1){
		yyerror("Declaring a variable with a token name\n");
		exit(-1);
	}
	if (isDeclared(s,vars) == -1){
		yyerror("Declaring two variables with the same name\n");
		exit(-2);
	}
	createIdentif(s,vars);
}

void yyerror( const char * msg){
printf("line %d : %s", lineNumber, msg);
}

int main(int argc,char ** argv){
	if(argc>1) yyin=fopen(argv[1],"r");
	lineNumber=1;
	if(!yyparse())
			printf("*** CORRECT CODE ***");

		return(0);
}