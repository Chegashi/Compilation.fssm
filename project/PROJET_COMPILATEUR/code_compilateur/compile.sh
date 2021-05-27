bison -d -o  syntaxeY.c syntaxe.y 

flex -oanalexL.c analex.l

gcc -o prog analexL.c syntaxeY.c

./prog < $1


