%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <ctype.h>
    #include <string.h>

    int yylex();
    void yyerror(const char* s);

%}


%union {
    int intval; 
    float floatval;
    char* strval;
}

%token TK_PRINT TK_IF TK_ELSE TK_WHILE TK_CLASS TK_AND TK_OR TK_NOT TK_INT_TYPE TK_FLOAT_TYPE TK_STRING_TYPE TK_CHAR_TYPE TK_RETURN TK_MAIN
%token TK_CLASS_IDENTIFIER TK_FLOAT TK_STRING TK_CHAR
%token TK_LT TK_LE TK_GT TK_GE TK_EQ TK_NE TK_ASSIGN 
%token TK_PLUS TK_MINUS TK_MULT TK_DIV
%token TK_COMMA TK_SEMICOLON TK_DOT


%token <intval> TK_INT
%token <strval> TK_IDENTIFIER

%type <intval> expr term
%type <strval> assignment

%%


line: line assignment TK_SEMICOLON            { ; }
    | line TK_PRINT expr TK_SEMICOLON         {printf("%d\n", $3);}
    | line term TK_SEMICOLON                  { ; }
    | line TK_RETURN expr TK_SEMICOLON            { printf("return %d\n", $3); }
    | line declaration TK_SEMICOLON                { printf("declaration found\n"); }
    | 
    ;

declaration: TK_INT_TYPE TK_IDENTIFIER {printf("Decl %s\n", $2);}    
    | TK_INT_TYPE TK_IDENTIFIER TK_ASSIGN expr {printf("Decl %s %d\n", $2, $4);}
    ;

assignment: TK_IDENTIFIER TK_ASSIGN expr {printf("[Parser] Read: `%s = %d`\n", $1, $3); $$ = $1;}
    ;

expr: term {$$ = $1;}
    | expr TK_PLUS term {$$ = $1 + $3;}
    | expr TK_MINUS term {$$ = $1 - $3;}
    | expr TK_MULT term {$$ = $1 * $3;}
    | expr TK_DIV term {$$ = $1 / $3;}
    ;

term : TK_INT {$$ = $1;}
    | TK_IDENTIFIER { printf("[Parser] indentifier: %s\n", $1);}
    ;


%%


void yyerror(const char* s) {
    fprintf(stderr, "%s\n", s);
}

