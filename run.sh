#!/bin/sh 
lex gocompiler.l 
yacc -d gocompiler.y
cc -o y.output y.tab.c lex.yy.c 