
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
    char str_holder[100];
    void lex_error(int);
%}

%option yylineno
%option noyywrap

alphaMax [A-Z]
alphaMin [a-z]
alpha {alphaMax}|{alphaMin}
alphanum {alpha}|{digit}
digit [0-9]

%%

"print"                             { strcpy(yylval.nd_obj.name, yytext); strcpy(str_holder, yytext); return TK_PRINT; }
"if"                                { strcpy(yylval.nd_obj.name, yytext); strcpy(str_holder, yytext); return TK_IF; }
"else"                              { strcpy(yylval.nd_obj.name, yytext); strcpy(str_holder, yytext); return TK_ELSE; }
"while"                             { strcpy(yylval.nd_obj.name, yytext); strcpy(str_holder, yytext); return TK_WHILE; }
"class"                             { strcpy(yylval.nd_obj.name, yytext); strcpy(str_holder, yytext); return TK_CLASS; }
"and"                               { strcpy(yylval.nd_obj.name, yytext); strcpy(str_holder, yytext); return TK_AND; }
"or"                                { strcpy(yylval.nd_obj.name, yytext); strcpy(str_holder, yytext); return TK_OR; }
"not"                               { strcpy(yylval.nd_obj.name, yytext); strcpy(str_holder, yytext); return TK_NOT; }
"int"                               { strcpy(yylval.nd_obj.name, yytext); strcpy(str_holder, yytext); return TK_INT_TYPE; }
"float"                             { strcpy(yylval.nd_obj.name, yytext); strcpy(str_holder, yytext); return TK_FLOAT_TYPE; }
"string"                            { strcpy(yylval.nd_obj.name, yytext); strcpy(str_holder, yytext); return TK_STRING_TYPE; }
"char"                              { strcpy(yylval.nd_obj.name, yytext); strcpy(str_holder, yytext); return TK_CHAR_TYPE; }
"return"                            { strcpy(yylval.nd_obj.name, yytext); strcpy(str_holder, yytext); return TK_RETURN; }
"main"                              { strcpy(yylval.nd_obj.name, yytext); strcpy(str_holder, yytext); return TK_MAIN; }
"include"                           { strcpy(yylval.nd_obj.name, yytext); strcpy(str_holder, yytext); return TK_INCLUDE; } 
"self"                              { strcpy(yylval.nd_obj.name, yytext); strcpy(str_holder, yytext); return TK_SELF; }
"read"                              { strcpy(yylval.nd_obj.name, yytext); strcpy(str_holder, yytext); return TK_READ; }
"true"                              { strcpy(yylval.nd_obj.name, yytext); strcpy(str_holder, yytext); return TK_TRUE; }
"false"                             { strcpy(yylval.nd_obj.name, yytext); strcpy(str_holder, yytext); return TK_FALSE; }

{alphaMin}{alphanum}*               { strcpy(yylval.nd_obj.name, yytext); strcpy(str_holder, yytext); return TK_IDENTIFIER; }
{alphaMax}{alphanum}*               { strcpy(yylval.nd_obj.name, yytext); strcpy(str_holder, yytext); return TK_CLASS_IDENTIFIER; }
[-]?{digit}+                        { strcpy(yylval.nd_obj.name, yytext); strcpy(str_holder, yytext); return TK_INT; }
[-]?{digit}+\.{digit}{1,4}          { strcpy(yylval.nd_obj.name, yytext); strcpy(str_holder, yytext); return TK_FLOAT; }
["].*["]                            { strcpy(yylval.nd_obj.name, yytext); strcpy(str_holder, yytext); return TK_STRING; }
['].[']                             { strcpy(yylval.nd_obj.name, yytext); strcpy(str_holder, yytext); return TK_CHAR; }

"<"                                 { strcpy(yylval.nd_obj.name, yytext); return TK_LT; }
"<="                                { strcpy(yylval.nd_obj.name, yytext); return TK_LE; }
">"                                 { strcpy(yylval.nd_obj.name, yytext); return TK_GT; }
">="                                { strcpy(yylval.nd_obj.name, yytext); return TK_GE; }
"=="                                { strcpy(yylval.nd_obj.name, yytext); return TK_EQ; }
"!="                                { strcpy(yylval.nd_obj.name, yytext); return TK_NE; }
"="                                 { strcpy(yylval.nd_obj.name, yytext); return TK_ASSIGN; }

"+"                                 { strcpy(yylval.nd_obj.name, yytext); return TK_PLUS; }
"-"                                 { strcpy(yylval.nd_obj.name, yytext); return TK_MINUS; }
"*"                                 { strcpy(yylval.nd_obj.name, yytext); return TK_MULT; }
"/"                                 { strcpy(yylval.nd_obj.name, yytext); return TK_DIV; }

","                                 { strcpy(yylval.nd_obj.name, yytext); return TK_COMMA; }
";"                                 { strcpy(yylval.nd_obj.name, yytext); return TK_SEMICOLON; }
"."                                 { strcpy(yylval.nd_obj.name, yytext); return TK_DOT; }

[(){}]                              { strcpy(yylval.nd_obj.name, yytext); return yytext[0]; }
"["                                 { strcpy(yylval.nd_obj.name, yytext); return yytext[0]; }
"]"                                 { strcpy(yylval.nd_obj.name, yytext); return yytext[0]; }
[\n]                                { countn++; }
[ \t]                               { ; }
.                                   { lex_error(countn+1); }


%%