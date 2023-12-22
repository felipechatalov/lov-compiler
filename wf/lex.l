%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    int linesn=0;
    int charsn=0;

    void ret_print(char* token_type);
    void yyerror();
%}

%option noyywrap

alphaMin [a-z]
alphaMax [A-Z]
alpha [a-zA-Z]
digit [0-9]
unary "++"|"--"

alnum {alpha}|{digit}
print [ -~]
ID {alpha}+({alnum})*
ICONST {digit}+
FCONST {digit}+\.{digit}{1,6}
CCONST ['].[']
SCONST ["].*["]

%%



"print"                        { ret_print("TOKEN_PRINT"); }
"read"                         { ret_print("TOKEN_READ"); }
"int"                          { ret_print("TOKEN_TYPE_INT"); }
"float"                        { ret_print("TOKEN_TYPE_FLOAT"); }
"char"                         { ret_print("TOKEN_TYPE_CHAR"); }
"str"                          { ret_print("TOKEN_TYPE_STR"); }
"void"                         { ret_print("TOKEN_TYPE_VOID"); }
"return"                       { ret_print("TOKEN_RETURN"); }
"while"	                       { ret_print("TOKEN_WHILE"); }
"if"	                       { ret_print("TOKEN_IF"); }
"else"	                       { ret_print("TOKEN_ELSE"); }
"class"                        { ret_print("TOKEN_CLASS"); }
^"#include"[ ]*<.+\.h>         { ret_print("TOKEN_INCLUDE"); }
[-]?{digit}+                   { ret_print("TOKEN_VALUE_INT"); }
[-]?{digit}+\.{digit}{1,6}     { ret_print("TOKEN_VALUE_FLOAT"); }
{alpha}+({alnum})*             { ret_print("TOKEN_ID"); }
{unary}                        { ret_print("TOKEN_UNARY"); }
"<="                           { ret_print("TOKEN_OP_LESS_EQUAL"); }
">="                           { ret_print("TOKEN_OP_GREATER_EQUAL"); }
"=="                           { ret_print("TOKEN_OP_EQUAL"); }
"!="                           { ret_print("TOKEN_OP_NOT_EQUAL"); }
">"	                           { ret_print("TOKEN_OP_GREATER"); }
"<"	                           { ret_print("TOKEN_OP_LESS"); }
"&&"	                       { ret_print("TOKEN_OP_AND"); }
"||"	                       { ret_print("TOKEN_OP_OR"); }
"+"                            { ret_print("TOKEN_OP_PLUS"); }
"-"                            { ret_print("TOKEN_OP_MINUS"); }
"/"                            { ret_print("TOKEN_OP_DIV"); }
"*"                            { ret_print("TOKEN_OP_MULT"); }
\/\/.*                         { ; }
\/\*(.*\n)*.*\*\/              { ; } 
[ \t]*                         { ; }
[\n]                           { linesn++; }
.	                           { charsn++; }
["].*["]                       { ret_print("TOKEN_VALUE_STR"); }
['].[']                        { ret_print("TOKEN_VALUE_CHAR"); }

%%

int main(int argc, char** argv){
    yyin = fopen(argv[1], "r");
    yylex();
    fclose(yyin);
    return 0;
}

void ret_print(char* token_type){
    printf("(%d, %d, %s, %s, %d)\n", linesn, charsn, token_type, yytext, yyleng);
}