
%{
    #include <string.h>
    #include "syntaxeY.h"

    char *yytext;
    int i=0;
    char *c;
    char IdTab[100][10];

    extern  int lineNumber;
    extern	void creerDico(void);
	extern	void agrandirDico(void);
	extern	void erreurFatale(char *message);
	extern	void ajouterEntree(char *identif,int type,int adresse,int complement);
    extern	struct ENTREE_DICO *dico;
    extern int maxDico,sommet,base;


%}

Debut "DEBUT"
Fin_algo "FIN"
variable "VAR"
constante "CONST"
nbr [0-9]

lettre [0-9A-Za-z ]
identif [a-zA-Z][0-9a-zA-Z_]* 
term [0-9a-zA-Z_][0-9a-zA-Z_][0-9a-zA-Z_][0-9a-zA-Z_][0-9a-zA-Z_][0-9a-zA-Z_]*
spec [\^\+\-\:\*\]]*


  

%%
"\n"                        {   lineNumber++;       }
ALGO                        {   return ALGO;    	}
{Debut}                     {   return DEBUT;       }
{Fin_algo}                  {   return FIN; 	    }

{variable}                  {   return VAR;			}
{constante}                 {   return CONST;		}
ENTIER 		                {   return ENTIER;  	}	
REEL		                {   return REEL;    	}
BOOL		                {   return BOOL;    	}
CAR                    	    {   return CAR; 		}
CHAINE                      {   return CHAINE;  	}
TABLEAU		                {   return TAB; 		}	 

"/*"		                {   return DCOMM;   	}
"*/"		                {   return FCOMM;   	}
"\""						{   return DCOT;		}
","                         {   return VIRGULE;		}
";"                         {   return PTVIRGULE;	}
":"                         {   return DPOINT;		}
"="                         {   return AFFECT;		}
"=="                        {   return EGAL;		}
"<"			                {   return LT;  		}
">"                         {   return GT;  		}
"<="		                {   return LET; 		}
">="		                {   return GET; 		}
"<>"		                {   return DIFF;		}

"["			                {   return CO;  		}
"]"			                {   return CF;  		}

"+"			                {   return ADD; 		}			
"-"			                {   return SUS; 		}	
"/"			                {   return DIV; 		}	
"*"			                {   return MUL; 		}
"MOD"		                {   return MOD; 		}
"DIV"		                {   return DIVE;		}

"LIRE"		                {   return READ;    	}
"ECRIRE"	                {   return WRITE;   	}

"("			                {   return PO;  		}
")"			                {   return PF;  		}	
SI                          {   return SI;  		}
SINON                       {   return SINON;   	}
ALORS                       {   return ALORS;   	}
FSI                         {   return FINSI;   	}
SELON 		                {   return SELON;   	}
FSELON 		                {   return FINSELON;   	}
AUTRE 						{	return AUTRE;		}

TANTQUE		                {   return TANTQUE; 	}
FTANTQUE	                {   return FINTANTQUE;  } 
POUR 		                {   return POUR;    	}
FPOUR		                {   return FINPOUR; 	} 
ALLANT		                {   return ALLANT;   	} 
PAS			                {   return PAS; 		}
JUSQUA		                {   return JUSQUA;  	}	 
REPETER		                {   return REPEAT;  	}
FAIRE						{   return FAIRE;		}

FONCTION	                {   return FUNCTION;    }
DEBUTF	                	{   return DFUN;    	}
DEBUTP	                	{   return DPROC;    	}
PROCEDURE	                {   return PROC;    	}
FINFONCTION 				{   return ENDFUNCTION; }
FINPROCEDURE 				{   return ENDPROC;    	}
RETOURNE	                {   return RET; 		}
RETOURE_LIGNE               {   return REL;         }
TABULATION                  {   return TABU;        }
{nbr}+                      {    yylval = atof(yytext);return NOMBRE;  	   }
{nbr}+.{nbr}+               {    yylval = atof(yytext);return NOMBREREEL;  }
[" "\t]                     {   /* rien */ 			}
"$"                         {   return NALL;        }
"$$"                        {   return NOLL;        }
"NONE"                        {   return NONE;        }
{term}                      {   return TERM;        }
{lettre}                    {   return LETTRE;      }
{identif}                   {   ajouterEntree(yytext,1,1,1);return IDENTIF; }
.                           {   return yytext[0];   }

%%

int valNombre;
int yywrap(void) {
    return 1;
}

