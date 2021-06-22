flex -olexical.c lexical.l
bison -d -osyntaxe.c syntaxe.y
gcc -o prog lexical.c syntaxe.c
prog<code.txt