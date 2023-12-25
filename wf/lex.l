
%{

    // https://iq.opengenus.org/yacc-and-bison/
    // https://www.gnu.org/software/bison/manual/html_node/index.html#Top
    // https://westes.github.io/flex/manual/Actions.html#Actions
    // https://github.com/bisqwit/compiler_series/blob/master/ep1/conj.y

    #include "parser.tab.h"
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

%}

%option yylineno
%option noyywrap

DIGIT [0-9]
ID [a-zA-Z][a-zA-Z0-9]*
whitespace [ \t\n]


%%

"print"         { return print; }
"exit"          { return exit_command; }
{ID}*           { printf("lexer >%s<, %d\n", yytext, yyleng); yylval.strval = strdup(yytext); return identifier; }
{DIGIT}+        { yylval.intval = atoi(yytext); return number; }
[-+=;]          { return yytext[0]; }
[ \t\n]         { ; }
.               { ; }


%%

int main(int argc, char **argv)
{
    yyin = fopen(argv[1], "r");
    yyparse();
    fclose(yyin);
    return 0;
}

