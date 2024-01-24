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

%token TK_PRINT TK_FLOAT TK_CLASS_IDENTIFIER

%token <intval> TK_INT
%token <strval> TK_IDENTIFIER

%type <intval> expr term
%type <strval> assignment

%%


line: line assignment ';'            { ; }
    | line TK_PRINT expr ';'         {printf("%d\n", $3);}
    | line term ';'                  { ; }
    | 
    ;

assignment: TK_IDENTIFIER '=' expr {printf("[Parser] Read: `%s = %d`\n", $1, $3); $$ = $1;}
    ;

expr: term {$$ = $1;}
    | expr '+' term {$$ = $1 + $3;}
    | expr '-' term {$$ = $1 - $3;}
    | expr '*' term {$$ = $1 * $3;}
    | expr '/' term {$$ = $1 / $3;}
    ;

term : TK_INT {$$ = $1;}
    | TK_IDENTIFIER { printf("[Parser] indentifier: %s\n", $1);}
    ;


%%


void yyerror(const char* s) {
    fprintf(stderr, "%s\n", s);
}

