#!/bin/sh 
lex gocompiler.l && yacc -d gocompiler.y && cc -Wall -g -m32 -o gocompiler y.tab.c lex.yy.c ast.c && zip gocompiler ast.c ast.h gocompiler.l gocompiler.y && ./gocompiler -s < factorial.dgo > out.txt
lex gocompiler.l && yacc -d gocompiler.y && cc -Wall -g  -o gocompiler y.tab.c lex.yy.c ast.c && zip gocompiler ast.c ast.h gocompiler.l gocompiler.y && ./gocompiler -s < factorial.dgo > out.txt
lex gocompiler.l && yacc -d gocompiler.y && cc -Wall -g -m32 -o gocompiler y.tab.c lex.yy.c ast.c && ./gocompiler -s < factorial.dgo > out.txt
