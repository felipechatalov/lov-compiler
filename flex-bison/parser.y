%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <ctype.h>
    #include <string.h>
    // https://medium.com/codex/building-a-c-compiler-using-lex-and-yacc-446262056aaa
    
    int yylex();
    void yyerror(const char* s);

    extern int countn;
    extern char str_holder[100];
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

    struct node{
        struct node* left;
        struct node* right;
        char *token;
    }node;

    struct node* head;
    struct node* mknode(struct node* left, struct node* right, char* token);
%}


%union {
    int intval; 
    float floatval;
    char* strval;
    struct var_name {
        char name[100];
        struct node* nd;
    }nd_obj;
}

%token <nd_obj> TK_PRINT TK_IF TK_ELSE TK_WHILE TK_CLASS TK_AND TK_OR TK_NOT TK_INT_TYPE TK_FLOAT_TYPE TK_STRING_TYPE TK_CHAR_TYPE TK_RETURN TK_MAIN
%token <nd_obj> TK_CLASS_IDENTIFIER TK_INCLUDE TK_SELF TK_READ TK_TRUE TK_FALSE
%token <nd_obj> TK_LT TK_LE TK_GT TK_GE TK_EQ TK_NE TK_ASSIGN 
%token <nd_obj> TK_PLUS TK_MINUS TK_MULT TK_DIV
%token <nd_obj> TK_COMMA TK_SEMICOLON TK_DOT
%token <nd_obj> TK_INT TK_IDENTIFIER TK_FLOAT TK_STRING TK_CHAR

%type <nd_obj> headers main body return datatype expr stmt assignment value program comparator_binary comparator_unary

%%

program: headers functions main '(' params ')' '{' body return '}' { printf("program\n"); }
    | headers class '(' params ')' '{' class_body '}' { printf("class-program\n"); }
    ;

class: TK_CLASS TK_CLASS_IDENTIFIER { add('L'); printf("class\n"); }
    ;

class_body: class_stmt class_body  { printf("class body\n"); }
    |
    ;

class_stmt: datatype TK_IDENTIFIER {add('V');} assignment TK_SEMICOLON { printf("class var decl\n"); }
    | datatype TK_IDENTIFIER { add('F'); } '(' class_params ')' '{' body return '}' { printf("class func decl\n"); }
    ;

class_params: TK_SELF { ; }
    | TK_SELF TK_COMMA params { ; }
    ;

function: datatype TK_IDENTIFIER { add('F'); } '(' params ')' '{' body return '}' { printf("function\n"); }
    ;

functions: functions function { printf("functions\n"); }
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
    ;

include: TK_INCLUDE TK_STRING  {  add('H'); }
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

stmt:  TK_PRINT { add('K'); } expr TK_SEMICOLON                 { printf("print expr\n"); }
    | TK_IDENTIFIER TK_ASSIGN expr TK_SEMICOLON                 { printf("identifier assign expr smc\n"); }
    | class_var_assn TK_SEMICOLON                               { printf("class var assn smc\n"); }
    | term TK_SEMICOLON                                         { printf("term smc\n"); }
    | declaration TK_SEMICOLON                                  { printf("declaration smc\n"); }
    | TK_IF { add('K'); } '(' condition ')' '{' body '}' else   { printf("if\n"); }
    | TK_WHILE { add('K'); } '(' condition ')' '{' body '}'     { printf("while\n"); }
    | return                                                    { printf("return smc\n"); }
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

declaration: datatype TK_IDENTIFIER {add('V');} assignment
    ;

datatype: TK_INT_TYPE {printf("int type\n"); insert_type(); }
    | TK_FLOAT_TYPE {printf("float type\n"); insert_type();}
    | TK_STRING_TYPE {printf("string type\n"); insert_type();}
    | TK_CHAR_TYPE {printf("char type\n"); insert_type();}
    | TK_CLASS_IDENTIFIER {printf("class type\n"); insert_type();}
    ;

assignment: TK_ASSIGN expr
    | TK_ASSIGN TK_CLASS_IDENTIFIER '(' params_call ')' {;}
    | 
    ;

class_var_assn: class_variable TK_ASSIGN expr {;}
    ;

expr: term {;}
    | expr arithmetic term { ; }
    ;

arithmetic: TK_PLUS { ; }
    | TK_MINUS { ; }
    | TK_MULT { ; }
    | TK_DIV { ; }
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
    if (argc < 2)
    {
        printf("Usage: %s <input_file> <input_file2> ... \n", argv[0]);
        return 1;
    }

    for (int i = 1; i < argc; i++)
    {
        countn = 1;
        FILE *fp = fopen(argv[i], "r");
        if (fp == NULL)
        {
            printf("Error: could not open file %s\n", argv[i]);
            return 1;
        }

        yyin = fp;

        yyparse();

        fclose(fp);
    }


    int i = 0;
    printf("\nSYMBOL   DATATYPE   TYPE   LINE NUMBER \n");
    for(i=0; i<count; i++) {
		printf("%s\t%s\t%s\t%d\t\n", symbol_table[i].id_name, symbol_table[i].data_type, symbol_table[i].type, symbol_table[i].line_no);
	}
	for(i=0;i<count;i++) {
		free(symbol_table[i].id_name);
		free(symbol_table[i].type);
	}

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
            symbol_table[count].id_name=strdup(yylval.nd_obj.name);        
            symbol_table[count].data_type=strdup(type);     
            symbol_table[count].line_no=countn;    
            symbol_table[count].type=strdup("Header");
            count++;  
        }  
        else if(c == 'K') {
            symbol_table[count].id_name=strdup(yylval.nd_obj.name);
            symbol_table[count].data_type=strdup("N/A");
            symbol_table[count].line_no=countn;
            symbol_table[count].type=strdup("Keyword\t");   
            count++;  
        }  else if(c == 'V') {
            symbol_table[count].id_name=strdup(str_holder);
            symbol_table[count].data_type=strdup(type);
            symbol_table[count].line_no=countn;
            symbol_table[count].type=strdup("Variable");   
            count++;  
        }  else if(c == 'C') {
            symbol_table[count].id_name=strdup(yylval.nd_obj.name);
            symbol_table[count].data_type=strdup("CONST");
            symbol_table[count].line_no=countn;
            symbol_table[count].type=strdup("Constant");   
            count++;  
        }  else if(c == 'F') {
            symbol_table[count].id_name=strdup(str_holder);
            symbol_table[count].data_type=strdup(type);
            symbol_table[count].line_no=countn;
            symbol_table[count].type=strdup("Function");   
            count++;  
        }  else if(c == 'L') {
            symbol_table[count].id_name=strdup(yylval.nd_obj.name);
            symbol_table[count].data_type=strdup(type);
            symbol_table[count].line_no=countn;
            symbol_table[count].type=strdup("Class");   
            count++;  
        }
    }
}
struct node* mknode(struct node* left, struct node* right, char* token){
    struct node* newnode = (struct node*)malloc(sizeof(struct node));
    char* newstr =  (char*)malloc(strlen(token)+1);
    strcpy(newstr, token);
    newnode->left = left;
    newnode->right = right;
    newnode->token = newstr;
    return newnode;
}
