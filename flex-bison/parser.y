%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <ctype.h>
    #include <string.h>

    // https://medium.com/codex/building-a-c-compiler-using-lex-and-yacc-446262056aaa
    
    int yylex();
    void yyerror(const char* s);

    extern int countn;
%}


%union {
    int intval; 
    float floatval;
    char* strval;
}

%token TK_PRINT TK_IF TK_ELSE TK_WHILE TK_CLASS TK_AND TK_OR TK_NOT TK_INT_TYPE TK_FLOAT_TYPE TK_STRING_TYPE TK_CHAR_TYPE TK_RETURN TK_MAIN
%token TK_CLASS_IDENTIFIER TK_INCLUDE TK_SELF
%token TK_LT TK_LE TK_GT TK_GE TK_EQ TK_NE TK_ASSIGN 
%token TK_PLUS TK_MINUS TK_MULT TK_DIV
%token TK_COMMA TK_SEMICOLON TK_DOT


%token <intval> TK_INT
%token <strval> TK_IDENTIFIER
%token <floatval> TK_FLOAT
%token <strval> TK_STRING
%token <strval> TK_CHAR

%type <intval> expr term
%type <strval> assignment

%%

program: headers function main '(' params ')' '{' body return '}' { printf("program\n"); }
    ;

function: function datatype TK_IDENTIFIER '(' params ')' '{' body return '}' { printf("function\n"); }
    |
    ;

function_call: TK_IDENTIFIER '(' params_call ')' { printf("function call\n"); }
    ;

params_call: params_call TK_COMMA expr { printf("params call\n"); }
    | expr { printf("params call\n"); }
    |
    ;

headers: headers header { printf("headers\n"); }
    |
    ;

header: include { printf("include\n"); }
    | class { printf("class\n"); }
    ;

include: TK_INCLUDE TK_STRING TK_SEMICOLON { ; }
    ;

class: TK_CLASS TK_CLASS_IDENTIFIER '(' params ')' '{' class_body '}' { ; }

class_body: class_body class_var_decl { ; }
    | class_body class_func_decl { ; }
    |
    ;

class_var_decl: datatype TK_IDENTIFIER TK_SEMICOLON { ; }
    | datatype TK_IDENTIFIER TK_ASSIGN expr TK_SEMICOLON { ; }
    ;

class_func_decl: datatype TK_IDENTIFIER '(' TK_SELF ')' '{' body return '}' { ; }
    | datatype TK_IDENTIFIER '(' TK_SELF TK_COMMA params ')' '{' body return '}' { ; }
    ;

class_variable: TK_IDENTIFIER TK_DOT TK_IDENTIFIER { printf("class variable\n"); }
    ;

class_function_call: TK_IDENTIFIER TK_DOT TK_IDENTIFIER '(' params_call ')' { printf("class function call\n"); }
    ;

params: params TK_COMMA datatype TK_IDENTIFIER { printf("params\n"); }
    | datatype TK_IDENTIFIER { printf("params\n"); }
    |
    ;

body: body stmt { printf("body\n"); }
    |
    ;

main: datatype TK_MAIN { printf("main\n"); }
    ;

return: TK_RETURN expr TK_SEMICOLON { printf("return\n"); }
    ;

stmt: assignment TK_SEMICOLON                                   { printf("assignment smc\n"); }
    | TK_PRINT expr TK_SEMICOLON                                { printf("print expr\n"); }
    | term TK_SEMICOLON                                         { printf("term smc\n"); }
    | declaration TK_SEMICOLON                                  { printf("declaration smc\n"); }
    | TK_IF '(' condition ')' '{' body '}'                      { printf("if\n"); }
    | TK_IF '(' condition ')' '{' body '}' TK_ELSE '{' body '}' { printf("if else\n"); }
    | TK_WHILE '(' condition ')' '{' body '}'                   { printf("while\n"); }
    | return                                                    { printf("return smc\n"); }
    ;

condition: expr comparator_binary expr { ; }
    | comparator_unary expr { ; }
    ;

comparator_binary: TK_EQ 
    | TK_NE 
    | TK_LT 
    | TK_LE 
    | TK_GT 
    | TK_GE
    | TK_AND
    | TK_OR
    ;

comparator_unary: TK_NOT
    ;

declaration: datatype TK_IDENTIFIER { ; }    
    | datatype TK_IDENTIFIER TK_ASSIGN expr { ; }
    | datatype TK_IDENTIFIER TK_ASSIGN TK_CLASS_IDENTIFIER '(' params_call ')' { ; }
    ;

datatype: TK_INT_TYPE {printf("int type\n");}
    | TK_FLOAT_TYPE {printf("float type\n");}
    | TK_STRING_TYPE {printf("string type\n");}
    | TK_CHAR_TYPE {printf("char type\n");}
    | TK_CLASS_IDENTIFIER {printf("class type\n");}
    ;

assignment: TK_IDENTIFIER TK_ASSIGN expr {;}
    | TK_IDENTIFIER TK_ASSIGN TK_CLASS_IDENTIFIER '(' params_call ')' {;}
    | class_variable TK_ASSIGN expr {;}
    ;

expr: term {;}
    | expr TK_PLUS term { ; }
    | expr TK_MINUS term { ; }
    | expr TK_MULT term { ; }
    | expr TK_DIV term { ; }
    ;

value: TK_INT { ; }
    | TK_FLOAT { ; }
    | TK_STRING { ; }
    | TK_CHAR { ; }
    ;

term : value { ; }
    | TK_IDENTIFIER { ;}
    | function_call { ; }
    | class_variable { ; }
    | class_function_call { ; }
    ;


%%

void yyerror(const char* s) {
    fprintf(stderr, "%s\n", s);
}