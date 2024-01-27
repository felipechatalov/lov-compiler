%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <ctype.h>
    #include <string.h>
    // https://medium.com/codex/building-a-c-compiler-using-lex-and-yacc-446262056aaa
    
    int yylex();
    void yyerror(const char* s);

    extern int countn;
    extern char* yytext;
    extern FILE* yyin;
    void add(char);
    void insert_type();
    int search(char *);
    void insert_type();
    struct symbol{
        char* id_name;
        char* type;
        char* data_type;
        int line_no;
    }symbol_table[100];
    int count = 0;
    int q;
    char type[10];
%}


%union {
    int intval; 
    float floatval;
    char* strval;
}

%token TK_PRINT TK_IF TK_ELSE TK_WHILE TK_CLASS TK_AND TK_OR TK_NOT TK_INT_TYPE TK_FLOAT_TYPE TK_STRING_TYPE TK_CHAR_TYPE TK_RETURN TK_MAIN
%token TK_CLASS_IDENTIFIER TK_INCLUDE TK_SELF TK_READ TK_TRUE TK_FALSE
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

header: include TK_SEMICOLON { printf("include\n"); }
    | class { printf("class\n"); }
    ;

include: TK_INCLUDE TK_STRING  {  add('H'); }
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

main: datatype TK_MAIN { printf("main\n"); add('F'); }
    ;

return: TK_RETURN { add('K'); } expr TK_SEMICOLON { printf("return\n"); }
    ;

stmt: assignment TK_SEMICOLON                                   { printf("assignment smc\n"); }
    | TK_PRINT { add('K'); } expr TK_SEMICOLON                                { printf("print expr\n"); }
    | term TK_SEMICOLON                                         { printf("term smc\n"); }
    | declaration TK_SEMICOLON                                  { printf("declaration smc\n"); }
    | TK_IF { add('K'); } '(' condition ')' '{' body '}' else                 { printf("if\n"); }
    | TK_WHILE { add('K'); } '(' condition ')' '{' body '}'                   { printf("while\n"); }
    | return                                                   { printf("return smc\n"); }
    ;

else: TK_ELSE {add('K');} '{' body '}' { printf("else\n"); }
    |
    ;

condition: expr comparator_binary expr { ; }
    | comparator_unary expr { ; }
    | TK_TRUE { add('K'); } { ; }
    | TK_FALSE { add('K'); } { ; }
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

declaration: datatype TK_IDENTIFIER     
    | datatype TK_IDENTIFIER TK_ASSIGN expr { ; }
    | datatype TK_IDENTIFIER TK_ASSIGN TK_CLASS_IDENTIFIER '(' params_call ')' { ; }
    ;

datatype: TK_INT_TYPE {printf("int type\n"); insert_type(); }
    | TK_FLOAT_TYPE {printf("float type\n"); insert_type();}
    | TK_STRING_TYPE {printf("string type\n"); insert_type();}
    | TK_CHAR_TYPE {printf("char type\n"); insert_type();}
    | TK_CLASS_IDENTIFIER {printf("class type\n"); insert_type();}
    ;

assignment: TK_IDENTIFIER TK_ASSIGN expr
    | TK_IDENTIFIER TK_ASSIGN TK_CLASS_IDENTIFIER '(' params_call ')' {;}
    | class_variable TK_ASSIGN expr {;}
    ;

expr: term {;}
    | expr TK_PLUS term { ; }
    | expr TK_MINUS term { ; }
    | expr TK_MULT term { ; }
    | expr TK_DIV term { ; }
    ;

value: TK_INT { add('C'); }
    | TK_FLOAT { add('C'); }
    | TK_STRING { add('C'); }
    | TK_CHAR { add('C'); }
    ;

term : value { ; }
    | TK_IDENTIFIER { ;}
    | function_call { ; }
    | class_variable { ; }
    | class_function_call { ; }
    | TK_READ { add('K'); } '(' ')' { ; }
    ;


%%

int main(int argc, char **argv)
{
    if (argc != 2)
    {
        printf("Usage: %s <input_file>\n", argv[0]);
        return 1;
    }

    FILE *fp = fopen(argv[1], "r");
    if (fp == NULL)
    {
        printf("Error: could not open file %s\n", argv[1]);
        return 1;
    }

    yyin = fp;

    yyparse();

    int i = 0;
    printf("\nSYMBOL   DATATYPE   TYPE   LINE NUMBER \n");
    for(i=0; i<count; i++) {
		printf("%s\t%s\t%s\t%d\t\n", symbol_table[i].id_name, symbol_table[i].data_type, symbol_table[i].type, symbol_table[i].line_no);
	}
	for(i=0;i<count;i++) {
		free(symbol_table[i].id_name);
		free(symbol_table[i].type);
	}
    fclose(fp);

    return 0;
}

void yyerror(const char* s) {
    fprintf(stderr, "%s\n", s);
}

void insert_type() {
    strcpy(type, yytext);
}

int search(char *type) { 
    int i; 
    for(i=count-1; i>=0; i--) {
        if(strcmp(symbol_table[i].id_name, type)==0) {   
            return -1;
            break;  
        }
    } 
    return 0;
}

void add(char c) {
    q=search(yytext);
    if(!q) {
        if(c == 'H') {
            symbol_table[count].id_name=strdup(yytext);        
            symbol_table[count].data_type=strdup(type);     
            symbol_table[count].line_no=countn;    
            symbol_table[count].type=strdup("Header");
            count++;  
        }  
        else if(c == 'K') {
            symbol_table[count].id_name=strdup(yytext);
            symbol_table[count].data_type=strdup("N/A");
            symbol_table[count].line_no=countn;
            symbol_table[count].type=strdup("Keyword\t");   
            count++;  
        }  else if(c == 'V') {
            symbol_table[count].id_name=strdup(yytext);
            symbol_table[count].data_type=strdup(type);
            symbol_table[count].line_no=countn;
            symbol_table[count].type=strdup("Variable");   
            count++;  
        }  else if(c == 'C') {
            symbol_table[count].id_name=strdup(yytext);
            symbol_table[count].data_type=strdup("CONST");
            symbol_table[count].line_no=countn;
            symbol_table[count].type=strdup("Constant");   
            count++;  
        }  else if(c == 'F') {
            symbol_table[count].id_name=strdup(yytext);
            symbol_table[count].data_type=strdup(type);
            symbol_table[count].line_no=countn;
            symbol_table[count].type=strdup("Function");   
            count++;  
        }
    }
}