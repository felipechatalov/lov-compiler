#!/bin/bash

#rm -f lex.yy.c y.tab.c y.tab.h 

#yacc -d parser.y
bison -dl parser.y

lex lex.l

#gcc lex.yy.c y.tab.c -o final
gcc lex.yy.c parser.tab.c -o final




