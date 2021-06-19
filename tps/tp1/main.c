/*Mon Fichier principal .c */
#include <stdio.h>
#include "unitesLexicales.h"
int main(void) {
int unite;
do {
unite = yylex();
printf(" (unite: %d", unite);
if (unite == ENTIER)
printf(" val Entier: %d", valEntier);
else if (unite == IDENTIF)
printf(" Nom Identif : '%s'", valIdentif);
printf(")\n");
} while (unite != 0);
return 0;
}