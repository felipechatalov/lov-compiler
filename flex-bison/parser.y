%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <ctype.h>
    #include <string.h>

    int yylex();
    void yyerror(const char* s);

    typedef struct sym {
        char* name;
        int value;
        struct sym* next;
    } sym;

    sym* sym_table = NULL;

    void init_sym_table();
    void add_symbol(char* name, int value);
    int get_value(char* name);


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

assignment: identifier '=' expr {add_symbol($1, $3); }
    ;

expr: term {$$ = $1;}
    | expr '+' term {$$ = $1 + $3;}
    | expr '-' term {$$ = $1 - $3;}
    ;

term : number {$$ = $1;}
    | identifier { printf("found %s\n", $1);}
    ;

%%


void init_sym_table() {
}

void add_symbol(char* namev, int value) {
    sym* symbol = malloc(sizeof(sym));
    symbol->name = namev;
    symbol->value = value;
    symbol->next = sym_table;
    sym_table = symbol;

    printf("[add_symbol] assigned %s with value %d\n", namev, value);
    printf("[add_symbol] value of %s at table is %d\n", namev, get_value(namev));
}

int get_value(char* namev) {
    printf("[get_value] looking for %s\n", namev);

    sym* symbol = sym_table;
    while (symbol != NULL) {
        if (strcmp(symbol->name, namev) == 0) {
            return symbol->value;
        }
        symbol = symbol->next;
    }
    yyerror("Undefined variable");
    return 0;
}

void yyerror(const char* s) {
    fprintf(stderr, "%s\n", s);
}