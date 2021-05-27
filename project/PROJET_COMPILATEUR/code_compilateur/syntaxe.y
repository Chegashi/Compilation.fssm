%{
	#include <stdlib.h>
	#include <stdio.h>
	#include <string.h>

	extern FILE* yyin;    
	int yylex(void); 
	void yyerror( const char * msg); 
	int lineNumber;

	extern int i;
	int j;
	extern  char *yytext;
	
	typedef struct{
		char *identif;
		int type;
		int adresse;
		int complement;
	}	ENTREE_DICO;

	void 	creerDico();
	void 	errdeclare();
	void 	notdeclare();
	void 	DimTab();

	#define TAILLE_INITIALE_DICO 50;
	#define INCREMENT_TAILLE_DICO 25;

	void creerDico(void);
	void agrandirDico(void);
	void erreurFatale(char *message);
	void ajouterEntree(char *identif,int type,int adresse,int complement);
    




	ENTREE_DICO *dico;
	int maxDico,sommet,base;
	char at[100];

	char TabId[100][10];
	int j=1;

	char NOM[256];
	FILE* f;
	char ID[4];

	char	*type(char	*T); 
	char	FF[1000];
	FILE* h;

%}

%token  ALGO IDENTIF VAR CONST DEBUT FIN 
%token  ENTIER AFFECT PTVIRGULE CR
%token	NOMBRE NOMBREREEL  DPOINT EGAL VIRGULE CO CF
%token	REEL  BOOL CAR CHAINE TAB 
%token  DCOMM FCOMM
%token	SI PO  PF ALORS   SINON  FINSI SELON FINSELON AUTRE
%token  LT  GT  LET  GET  DIFF
%token  ADD SUS DIV MUL MOD DIVE
%token	READ WRITE DCOT NONE
%token  TANTQUE FINTANTQUE POUR FINPOUR ALLANT PAS JUSQUA REPEAT FAIRE
%token  FUNCTION PROC RET ENDFUNCTION ENDPROC DFUN DPROC
%token  TERM LETTRE NALL NOLL  REL TABU
%start  program 


%% 

program : program1 sous_algo  | program1 ;

program1 :	ALGO  {creerDico();}  TERM { strcpy(NOM,yytext);strcat(NOM,".c");f = fopen("algo.c","w");h = fopen("ft.h","w");
										 fprintf(f,"#include <stdio.h>\n#include <string.h>\n#include <stdlib.h>\n#include \"ft.h\"\n\nint main(){\n");}
				declaration {errdeclare();} 
			DEBUT 

							listInstr {notdeclare();}

			FIN {fprintf(f,"return(0);\n}\n")};
declaration 				:
							  VAR listdeclaration_var        |
							  CONST listdeclaration_constante 
							  VAR listdeclaration_var   CONST listdeclaration_constante   |
							  CONST listdeclaration_constante VAR listdeclaration_var  ;

listdeclaration_var			: listdeclaration_var1 |listdeclaration_var2|listdeclaration_var1 listdeclaration_var2 ;		 
listdeclaration_var1		: listdeclaration_var1 declaration_var1 |declaration_var1;
declaration_var1			: type1 DPOINT listidentif1  PTVIRGULE {fprintf(f,"%s\n",yytext);} 
listidentif1				: listidentif1 VIRGULE{fprintf(f,"%s",yytext);} IDENTIF{fprintf(f,"%s",yytext)}| 
							  IDENTIF{fprintf(f,"%s",yytext)};


listdeclaration_var2		:listdeclaration_var2   declaration_var2 |declaration_var2 ;
declaration_var2			: type1 DPOINT TAB  listidentif2   PTVIRGULE {fprintf(f,"%s\n",yytext);}  ;
listidentif2				: listidentif2  VIRGULE{fprintf(f,"%s",yytext);}  IDENTIF {fprintf(f,"%s",yytext); } dimension  | IDENTIF{fprintf(f,"%s",yytext);} dimension ;
dimension					: dim dim | dim;
dim 						: CO{fprintf(f,"%s","[");} NOMBRE{fprintf(f,"%s",yytext);} CF{fprintf(f,"%s","]");} |
								CO{fprintf(f,"%s","[");} IDENTIF{fprintf(f,"%s",yytext);} CF{fprintf(f,"%s","]");} ;

listdeclaration_constante	: listdeclaration_constante declaration_constante | declaration_constante;
declaration_constante   	: {fprintf(f,"\tconst ")} ENTIER {fprintf(f,"\t%s\t\t",type(yytext));} DPOINT IDENTIF {fprintf(f,"%s",yytext);} 
								AFFECT {fprintf(f,"%s",yytext);}  NOMBRE {fprintf(f,"\t%s",yytext);} PTVIRGULE {fprintf(f," %s\n",yytext);}|
							  {fprintf(f,"\tconst ")} REEL  {fprintf(f,"\t%s\t\t",type(yytext));} DPOINT IDENTIF{fprintf(f,"%s",yytext);} 
							  AFFECT {fprintf(f,"%s",yytext);} NOMBREREEL{fprintf(f,"\t%s",yytext);} PTVIRGULE {fprintf(f," %s\n",yytext);};


type1						: ENTIER{fprintf(f,"\t%s\t\t",type(yytext));}| REEL {fprintf(f,"\t%s\t",type(yytext));}|
							  BOOL {fprintf(f,"t\t%s\t",type(yytext));}| CAR{fprintf(f,"\t%s",type(yytext));} | 
							  CHAINE {fprintf(f,"\t%s\t",type(yytext));};

comm 			: DIV DIV {fprintf(f,"\n\t/*");} listter {fprintf(f,"*/\n");}DIV DIV;
listter 		: listter  TERM{fprintf(f," %s",yytext);} | TERM{fprintf(f,"%s",yytext);}|"\n"{fprintf(f,"\\n");} | listInstr inst  |inst;

listInstr		: listInstr inst  | inst ;

inst 			: affectation|affichage | saisir | instcond|instchoix |instriteratif| comm|
					REL PTVIRGULE{fprintf(f,"printf(\"\\n\");");}|TABU PTVIRGULE{fprintf(f,"printf(\"\\t\");");}|
					TERM{fprintf(f,"\t%s(",yytext);} PO listidp PF{fprintf(f,");\n");}PTVIRGULE;



listidp 		: listidp VIRGULE{fprintf(f,"%s",yytext);} IDENTIF {fprintf(f,"%s",yytext);} |
					IDENTIF{fprintf(f,"%s",yytext);};

affectation 	:   NALL IDENTIF  {fprintf(f,"\t  %s  ",yytext);} AFFECT {fprintf(f," %s ",yytext);} type  PTVIRGULE 
					{fprintf(f," %s\n",yytext);} | 

				    IDENTIF{strcpy(FF,yytext);} dimensionc  AFFECT  type5 PTVIRGULE  |

				    NOLL IDENTIF {fprintf(f,"\n\t  %s",yytext);} dimension AFFECT {fprintf(f," %s ",yytext);} type PTVIRGULE {fprintf(f," ;\n");};



type 			: NOMBRE  {fprintf(f," %d",yylval);} |exp |NOMBREREEL {fprintf(f," %d",yylval);}|
				  DCOT LETTRE {fprintf(f,"\t  \"%s\"",yytext);} DCOT|
				  TERM{fprintf(f,"\t%s(",yytext);} PO listidp PF{fprintf(f,")");};
type5 			: DCOT {fprintf(f,"\tstrcpy(%s,\"",FF);}  listTERM DCOT{fprintf(f,"\");\n");}  |
				  DCOT LETTRE {fprintf(f,"\t%s = \"%s\" ;\n\t",FF,yytext);} DCOT;


listTERM 		: listTERM TERM {fprintf(f,"%s",yytext);}  | TERM{fprintf(f,"%s",yytext);} ;

dimensionc					: dimc dimc | dimc;
dimc 						: CO{strcat(FF,yytext);} NOMBRE{strcat(FF,yytext);}  CF{strcat(FF,yytext);} ;

exp 			: listoperation | IDENTIF {fprintf(f,"  %s ",yytext);} |oprtab;
oprtab 			: oprtab opr NOLL IDENTIF {fprintf(f,"\t  %s",yytext);} dimension|
				  NOLL IDENTIF {fprintf(f,"\t  %s",yytext);} dimension;

listoperation	: listoperation opr type3 | operation;
operation 		: type3 opr type3;
type3			:  NOMBRE{fprintf(f,"%d",yylval);}|NOMBREREEL | NALL IDENTIF {fprintf(f," %s ",yytext);};
opr 			: ADD {fprintf(f,"+ ");}| SUS {fprintf(f,"- ");}| DIV {fprintf(f,"/ ");}| MUL {fprintf(f,"* ");}| MOD {fprintf(f,"%%");}| DIVE{fprintf(f,"/ ");};

affichage 					: WRITE{fprintf(f,"\n\t printf");} PO{fprintf(f,"(");}  listmessage PF PTVIRGULE ;
listmessage					: listmessage message | message;
message					    : message VIRGULE{fprintf(f,"\n\t printf(");} DCOT{fprintf(f,"\"");} sent  DCOT{fprintf(f,"\");\n");}|

							  message VIRGULE IDENTIF{fprintf(f,"\n\tif(sizeof(%s)==sizeof(char))",yytext);fprintf(f,"printf(\"%%c\",%s);",yytext);fprintf(f,"\n\telse if(sizeof(%s)==sizeof(int))",yytext);fprintf(f,"printf(\"%%d\",%s);",yytext);fprintf(f,"\n\telse if(sizeof(%s)==sizeof(double))",yytext);fprintf(f,"printf(\"%%f.3\",%s);",yytext);}|

							  DCOT{fprintf(f,"\"");} sent DCOT{fprintf(f,"\");");}  |

							  IDENTIF {fprintf(f,"\" \");");fprintf(f,"\nif(sizeof(%s)==sizeof(char))",yytext);fprintf(f,"printf(\"%%c\",%s);",yytext);fprintf(f,"\nelse if(sizeof(%s)==sizeof(int))",yytext);fprintf(f,"printf(\"%%d\",%s);",yytext);fprintf(f,"\nelse if(sizeof(%s)==sizeof(double))",yytext);fprintf(f,"printf(\"%%f.3\",%s);",yytext);} ;
sent						: sent TERM{fprintf(f," %s ",yytext);} | TERM{fprintf(f," %s ",yytext);} ;

saisir						: READ PO listidentifs PF PTVIRGULE ;
listidentifs 				: listidentifs VIRGULE IDENTIF{fprintf(f,"\nif(sizeof(%s)==sizeof(char))",yytext);fprintf(f,"scanf(\"%%c\",&%s);",yytext);fprintf(f,"\nelse if(sizeof(%s)==sizeof(int))",yytext);fprintf(f,"scanf(\"%%d\",&%s);",yytext);fprintf(f,"\nelse if(sizeof(%s)==sizeof(double))",yytext);fprintf(f,"scanf(\"%%f.3\",&%s);",yytext);}| IDENTIF{fprintf(f,"\nif(sizeof(%s)==sizeof(char))",yytext);fprintf(f,"scanf(\"%%c\",&%s);",yytext);fprintf(f,"\nelse if(sizeof(%s)==sizeof(int))",yytext);fprintf(f,"scanf(\"%%d\",&%s);",yytext);fprintf(f,"\nelse if(sizeof(%s)==sizeof(double))",yytext);fprintf(f,"scanf(\"%%f.3\",&%s);\n",yytext);};

instcond		: SI{fprintf(f,"\n\n\tif(");} PO  condition PF  {fprintf(f,"){\n");}ALORS listInstr fins ;
fins 			: FINSI {fprintf(f," }\n\n");}|SINON {fprintf(f,"\t}\n\telse{\n");}  listInstr FINSI{fprintf(f,"\t}\n");};


condition		:  NALL IDENTIF {fprintf(f,"%s",yytext);} type2  NOMBRE {fprintf(f,"%s",yytext);}  | 
				    IDENTIF {fprintf(f,"%s",yytext);} type2 IDENTIF {fprintf(f,"%s",yytext);};

type2			: LT {fprintf(f," %s ",yytext);}| GT {fprintf(f," %s ",yytext);}| 
				  LET {fprintf(f," %s ",yytext);}| GET {fprintf(f," %s ",yytext);}| DIFF{fprintf(f," %s ","!=");} 
				  |EGAL{fprintf(f," %s ",yytext);};

instchoix 		: SELON{fprintf(f,"\n\tswitch( ");} IDENTIF{fprintf(f,"%s ){\n\t",yytext);} FAIRE 
				  listnbr AUTRE{fprintf(f,"\t\ndefault:\t");} DPOINT inst FINSELON{fprintf(f,"}\n");};
listnbr 		: listnbr nb | nb;
nb 				: NOMBRE{fprintf(f,"\n\tcase\t%s:\t",yytext);} DPOINT  
				  inst{fprintf(f,"\t\tbreak;");};

instriteratif 	: bpour | btantque | brepeter;


bpour			: POUR{fprintf(f,"\tfor(");} IDENTIF{strcpy(ID,yytext);fprintf(f,"%s",ID);} ALLANT{fprintf(f,"=");} 
				  NOMBRE {fprintf(f,"%s;",yytext);}JUSQUA typebp PAS  
				  NOMBRE{fprintf(f,"%s=%s+%s)",ID,ID,yytext);} FAIRE{fprintf(f,"{");} 
				  listInstr  FINPOUR{fprintf(f,"\n\t}\n\n");} ;

typebp 			: NOMBRE{fprintf(f,"%s<=%s;",ID,yytext);}|IDENTIF{fprintf(f,"%s<=%s;",ID,yytext);};

btantque		: TANTQUE{fprintf(f,"\twhile");} PO{fprintf(f,"(");} condition PF{fprintf(f,")");} FAIRE{fprintf(f,"{\n");}
				  listInstr FINTANTQUE{fprintf(f,"\t}\n\n");};


brepeter		: REPEAT{fprintf(f,"\tdo{\n");} listInstr JUSQUA{fprintf(f,"}while");} 
				  PO{fprintf(f,"(!(");} condition PF{fprintf(f,"));\n\n");} ;



sous_algo		: sous_algo fonction | sous_algo procedure | procedure | fonction;


fonction		:   type1f DPOINT FUNCTION TERM{fprintf(f,"%s",yytext);fprintf(h,"%s",yytext);}
					PO{fprintf(f,"(");fprintf(h,"(");} listarg PF{fprintf(f,"){\n");fprintf(h,");\n");}declarationf 
					DFUN listInstr RET{fprintf(f,"\n\treturn");} PO {fprintf(f,"(");}type4 PF{fprintf(f,");\n\t");}
					PTVIRGULE ENDFUNCTION{fprintf(f,"}");};


procedure		: PROC {fprintf(f,"\n\tvoid\t");fprintf(h,"\n\tvoid\t");}TERM{fprintf(f,"%s",yytext);fprintf(h,"%s",yytext);} 
				  PO{fprintf(f,"(");fprintf(h,"(");} listarg PF {fprintf(f,"){\n");fprintf(h,");\n");}declarationf DPROC  listInstr 
				  ENDPROC{fprintf(f,"\t}");};


listarg 		: listarg VIRGULE{fprintf(f,",");fprintf(h,",");} type1f DPOINT  IDENTIF {fprintf(f,"%s",yytext);fprintf(h,"%s",yytext);}|
				  type1f  DPOINT IDENTIF{fprintf(f,"%s",yytext);fprintf(h,"%s",yytext);};

type4 			: NOMBRE{fprintf(f,"%s",yytext);}|IDENTIF{fprintf(f,"%s",yytext);}|NOMBREREEL{fprintf(f,"%s",yytext);};


declarationf 				:
							  VAR listdeclaration_varf         | 
							  CONST listdeclaration_constantef |
							  VAR listdeclaration_varf   CONST listdeclaration_constantef   |
							  CONST listdeclaration_constantef VAR listdeclaration_varf  ;

listdeclaration_varf		: listdeclaration_var1f |listdeclaration_var2f|listdeclaration_var1f listdeclaration_var2f | NONE PTVIRGULE;

listdeclaration_var1f		: listdeclaration_var1f declaration_var1f |declaration_var1f;
declaration_var1f			: type1f1 DPOINT listidentif1f  PTVIRGULE {fprintf(f,"%s\n",yytext);} ;
listidentif1f				: listidentif1f VIRGULE{fprintf(f,"%s",yytext);} IDENTIF{fprintf(f,"%s",yytext)}| 
							  IDENTIF{fprintf(f,"%s",yytext)};


listdeclaration_var2f		: listdeclaration_var2f   declaration_var2f |declaration_var2f ;
declaration_var2f			: type1f1 DPOINT TAB  listidentif2f   PTVIRGULE {fprintf(f,"%s\n",yytext);} ;
listidentif2f				: listidentif2f  VIRGULE{fprintf(f,"%s",yytext);} IDENTIF{fprintf(f,"%s",yytext)} dimensionf 								  |IDENTIF{fprintf(f,"%s",yytext)} dimensionf ;
dimensionf					: dimf |dimf dimf;
dimf 						: CO{fprintf(f,"%s",yytext);} NOMBRE{fprintf(f,"%s",yytext);} CF{fprintf(f,"%s",yytext);};

listdeclaration_constantef	: listdeclaration_constantef declaration_constantef | declaration_constantef;
declaration_constantef   	: {fprintf(f,"\tconst\t");}ENTIER  DPOINT IDENTIF {fprintf(f,"%s",yytext);} 
								AFFECT NOMBRE {fprintf(f,"\t%s\n",yytext);} PTVIRGULE |
							  {fprintf(f,"\tconst\t");}REEL DPOINT IDENTIF{fprintf(f,"%s",yytext);} 
							  AFFECT NOMBREREEL{fprintf(f,"\t%s\n",yytext);} PTVIRGULE ;

type1f1						: ENTIER{fprintf(f,"\t%s\t\t",type(yytext));}| REEL {fprintf(f,"\t%s\t",type(yytext));}|
							  BOOL {fprintf(f,"t\t%s\t",type(yytext));}| CAR{fprintf(f,"\t%s",type(yytext));} | 
							  CHAINE {fprintf(f,"\t%s\t",type(yytext));};

type1f						: ENTIER{fprintf(f,"\t%s\t\t",type(yytext));fprintf(h,"\t%s\t\t",type(yytext));}| 
							  REEL {fprintf(f,"\t%s\t",type(yytext));fprintf(h,"\t%s\t",type(yytext));}|
							  BOOL {fprintf(f,"t\t%s\t",type(yytext));fprintf(h,"t\t%s\t",type(yytext));}| 
							  CAR{fprintf(f,"\t%s",type(yytext));fprintf(h,"\t%s",type(yytext));} | 
							  CHAINE {fprintf(f,"\t%s\t",type(yytext));fprintf(h,"\t%s\t",type(yytext));};



%%

void creerDico(void){
	maxDico = TAILLE_INITIALE_DICO;
	dico = malloc(maxDico * sizeof(ENTREE_DICO));
	if(dico==NULL)
		erreurFatale("Erreur interne (pas assez de memoire)");
	sommet = base = 0;
}

void agrandirDico(void){
	maxDico = maxDico + INCREMENT_TAILLE_DICO;
	if(dico==NULL)
		erreurFatale("Erreur interne (pas assez de memoire)");
}

void erreurFatale(char *message){
	fprintf(stderr,"%s\n",message);
	exit(-1);
}

void ajouterEntree(char *identif,int type,int adresse,int complement){
	if (sommet >= maxDico)
		agrandirDico();
	dico[sommet].identif = malloc(strlen(identif)+1);
	if(dico[sommet].identif == NULL)
		erreurFatale("Erreur interne (pas assez de memoire)");
	strcpy(dico[sommet].identif,identif);
	dico[sommet].type = type;
	dico[sommet].adresse = adresse;
	dico[sommet].complement = complement;
	sommet++;
}

void errdeclare(){
	int k=0,t = 0;
	char *var;


	strcpy(TabId[0],dico[0].identif);
	while(j < sommet)
	{	
		var = malloc(strlen(dico[j].identif)*sizeof(char));
		strcpy(var,dico[j].identif);
		while (k < j)
		{
			if (strcmp(var,TabId[k]) == 0)
			{
				t = 1;
				break;
			}
			else
				k++;
		}
		k = 0;
		if (t == 1)
		{	
			yyerror(" ");
			printf("double declaration %s",var);
			exit(0);
		}
		else{
			strcpy(TabId[j],var);
		} 
		t = 0;
		j++;
	}
	sommet = 0;
	j--;
}

void notdeclare(){
	int 	k = 0,t = 0,l = 0;
	char	*temp;
	while(dico[k].identif)
	{	
		l = 0;
		t = 0;
		temp = malloc(strlen(dico[k].identif)*sizeof(char));
		strcpy(temp,dico[k].identif);
		while(l <= j){
			if(strcmp(TabId[l],temp)==0)
				t = 1;
			l++;
		}
		if(t == 0){
			yyerror(" ");
			printf("%s not declared",temp);
			exit(0);
		}
		k++;	
	}
}
void yyerror( const char * msg){
	printf("line %d : %s\n", lineNumber, msg);

}

char	*type(char	*T){
	char *ret;
	if(strcmp(T,"ENTIER")==0){
		ret=malloc(sizeof(char)*strlen("int"));
		strcpy(ret,"int");
	}
	if(strcmp(T,"REEL")==0){
		ret=malloc(sizeof(char)*strlen("float"));
		strcpy(ret,"float");
	}
	if((strcmp(T,"CHAINE")==0)||(strcmp(T,"CAR")==0)){
		ret=malloc(sizeof(char)*strlen("char"));
		strcpy(ret,"char");
	}
	return ret;
} 

int main(int argc,char ** argv)
{ 
	if(argc>1) 
		yyin=fopen(argv[1],"r"); 
	if(!yyparse())
		printf("");
	
	return(0);
}