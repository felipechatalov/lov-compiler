%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <ctype.h>
    #include <string.h>

    int yylex();
    void yyerror(const char* s);

    typedef struct {
        char* name;
        char* tpye;
        int line;
    } symbol;

    symbol* sym_table[100];

    void add_symbol(char* name, char* type, int line);
    int exists_symbol_table(char*name);

%}


%union {
    int intval; 
    char* strval;
}

%token print

%token <intval> number
%token <strval> identifier

%type <intval> line expr term
%type <strval> assignment

%%

line: assignment ';'        {;}
    | print expr ';'         {printf("%d\n", $2);}
    | line assignment ';'   {;}
    | line print expr ';'    {printf("%d\n", $3);}
    | term ';'              { ; }
    ;

assignment: identifier '=' expr {printf("[Parser] Read: `%s = %d`\n", $1, $3); add_symbol($1, "identifier", yylen); }
    ;

expr: term {$$ = $1;}
    | expr '+' term {$$ = $1 + $3;}
    | expr '-' term {$$ = $1 - $3;}
    ;

term : number {$$ = $1;}
    | identifier { printf("[Parser] indentifier: %s\n", $1);}
    ;

%%

void add_symbol(char* name, char* type, int line) {
    printf("[add_symbol] uninplemented\n");
}

int get_value(char* namev) {
    printf("[get_value] uninplemented\n");
    return 0;
}

int exists_symbol_table(char*name){
    printf("[exists_symbol_table] uninplemented\n");
    return 0;
}

void yyerror(const char* s) {
    fprintf(stderr, "%s\n", s);
}

