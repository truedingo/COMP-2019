#!/bin/sh 
lex gocompiler.l 
yacc -d gocompiler.y
cc -o gocompiler y.tab.c lex.yy.c