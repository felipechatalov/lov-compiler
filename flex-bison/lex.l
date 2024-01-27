
%{

    // https://iq.opengenus.org/yacc-and-bison/
    // https://www.gnu.org/software/bison/manual/html_node/index.html#Top
    // https://westes.github.io/flex/manual/Actions.html#Actions
    // https://github.com/bisqwit/compiler_series/blob/master/ep1/conj.y

    #include "parser.tab.h"
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    int countn = 1;
%}

%option yylineno
%option noyywrap

alphaMax [A-Z]
alphaMin [a-z]
alpha {alphaMax}|{alphaMin}
alphanum {alpha}|{digit}
digit [0-9]

%%

"print"                             { return TK_PRINT; }
"if"                                { return TK_IF; }
"else"                              { return TK_ELSE; }
"while"                             { return TK_WHILE; }
"class"                             { return TK_CLASS; }
"and"                               { return TK_AND; }
"or"                                { return TK_OR; }
"not"                               { return TK_NOT; }
"int"                               { return TK_INT_TYPE; }
"float"                             { return TK_FLOAT_TYPE; }
"string"                            { return TK_STRING_TYPE; }
"char"                              { return TK_CHAR_TYPE; }
"return"                            { return TK_RETURN; }
"main"                              { return TK_MAIN; }
"include"                           { return TK_INCLUDE; } 
"self"                              { return TK_SELF; }
"read"                              { return TK_READ; }
"true"                              { return TK_TRUE; }
"false"                             { return TK_FALSE; }

{alphaMin}{alphanum}*               { yylval.strval = strdup(yytext); return TK_IDENTIFIER; }
{alphaMax}{alphanum}*               { yylval.strval = strdup(yytext); return TK_CLASS_IDENTIFIER; }
[-]?{digit}+                        { yylval.intval = atoi(yytext); return TK_INT; }
[-]?{digit}+\.{digit}{1,4}          { yylval.floatval = atof(yytext); return TK_FLOAT; }
["].*["]                            { yylval.strval = strdup(yytext); return TK_STRING; }
['].[']                             { yylval.strval = strdup(yytext); return TK_CHAR; }

"<"                                 { return TK_LT; }
"<="                                { return TK_LE; }
">"                                 { return TK_GT; }
">="                                { return TK_GE; }
"=="                                { return TK_EQ; }
"!="                                { return TK_NE; }
"="                                 { return TK_ASSIGN; }

"+"                                 { return TK_PLUS; }
"-"                                 { return TK_MINUS; }
"*"                                 { return TK_MULT; }
"/"                                 { return TK_DIV; }

","                                 { return TK_COMMA; }
";"                                 { return TK_SEMICOLON; }
"."                                 { return TK_DOT; }

[(){}]                              { return yytext[0]; }

[\n]                                { countn++; }
[ \t]                               { ; }
.                                   { ; }


%%