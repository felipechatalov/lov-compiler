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
        char* file;
    }symbol_table[100];
    int count = 0;
    int q;
    char type[10];

    struct node{
        struct node* left;
        struct node* right;
        char *token;
    }node;

    FILE* fp;
    int cur_class = 0;
    struct node* classes[10];
    char* classes_name[10];
    struct node* head;
    struct node* class;
    char* active_file_name;
    struct node* mknode(struct node*, struct node*, char*);
    void printInorder(struct node*);
    void printPreorder(struct node*);

    void check_declaration(char*);
    void check_return_type(char*);
    int check_types(char*, char*);
    char* get_type(char*);
    int sem_errors;
    char errors[10][100];
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

%type <nd_obj> headers main body return datatype expr stmt assignment value program comparator_binary comparator_unary functions function include params class_params class_body declaration condition term arithmetic class_variable else function_call params_call class_function_call class_stmt class

%left TK_PLUS TK_MINUS
%left TK_MULT TK_DIV
%right TK_ASSIGN
%nonassoc TK_LT TK_LE TK_GT TK_GE TK_EQ TK_NE TK_AND TK_OR TK_NOT

%%

program: headers functions main '(' params ')' '{' body '}' { 
        $3.nd = mknode($5.nd, $8.nd, "main");
        struct node* new = (struct node*)malloc(sizeof(struct node));
        new->left = $2.nd;
        new->right = $3.nd;
        new->token = "functions";
        $$.nd = mknode($1.nd, new, "program");
        head = $$.nd;
        }
    
    | class '(' params ')' '{' class_body '}' { 
        $$.nd = mknode($3.nd, $6.nd, "class");
        classes[cur_class] = $$.nd;
        
        char* newstr = (char*)malloc(strlen(active_file_name)+2);
        newstr[0] = '"';
        strcat(newstr, active_file_name);
        newstr[strlen(active_file_name)+1] = '"';
        newstr[strlen(active_file_name)+2] = '\0';
        classes_name[cur_class] = newstr;

        cur_class++;
        }
    ;

class: TK_CLASS TK_CLASS_IDENTIFIER { 
        add('L'); 
        $$.nd = mknode(NULL, NULL, $2.name);    
    }
    ;

class_body: class_stmt class_body  { 
        $$.nd = mknode($1.nd, $2.nd, "class body");
    }
    
    | { $$.nd = NULL; }
    ;

class_stmt: datatype TK_IDENTIFIER {add('V'); } assignment TK_SEMICOLON { 
        struct node* newnode = mknode(NULL, NULL, $2.name);
        $$.nd = mknode(newnode, $4.nd, "declaration");
    }

    | datatype TK_IDENTIFIER { add('F'); } '(' class_params ')' '{' body '}' { 
        $$.nd = mknode($5.nd, $8.nd, $2.name);
    }
    ;

class_params: TK_SELF { 
        struct node* newnode = mknode(NULL, NULL, "self");
        $$.nd = mknode(newnode, NULL, "class-params");
    }

    | TK_SELF TK_COMMA params { 
        struct node* newnode = mknode(NULL, NULL, "self");
        $$.nd = mknode(newnode, $3.nd, "class-params");
    }
    ;

function: datatype TK_IDENTIFIER { add('F'); } '(' params ')' '{' body '}' {  
    $$.nd = mknode($5.nd, $8.nd, $2.name);}
    ;

functions: functions function {  
    $$.nd = mknode($2.nd, $1.nd, "functions");
    }
    | { $$.nd = NULL;}
    ;

function_call: TK_IDENTIFIER '(' params_call ')' { 
        $$.nd = mknode(NULL, NULL, $1.name);
    }
    ;

params_call: expr TK_COMMA params_call { 
        $$.nd = mknode($1.nd, $3.nd, "params");
    }

    | expr { 
        $$.nd = mknode($1.nd, NULL, "params");
    }

    | { $$.nd = NULL;}
    ;

headers: include TK_SEMICOLON headers  {
    $$.nd = mknode($1.nd, $3.nd, "headers");
    }
    | {$$.nd = NULL;}
    ;

include: TK_INCLUDE TK_STRING { 
        add('H');

        for (int i = 0; i < cur_class; i++){
            
            if (strcmp(classes_name[i], $2.name) == 0){
                class = classes[i];
            }
        }


        $$.nd = mknode(class, NULL, $2.name);
        class = NULL;
    }
    ;

class_variable: TK_IDENTIFIER TK_DOT TK_IDENTIFIER { 
    char* newstr =  (char*)malloc(strlen($1.name)+strlen($3.name)+1);
    strcpy(newstr, $1.name);
    strcat(newstr, ".");
    strcat(newstr, $3.name);

    $$.nd = mknode(NULL, NULL, newstr);}
    ;

class_function_call: TK_IDENTIFIER TK_DOT TK_IDENTIFIER '(' params_call ')' { 
        char* newstr =  (char*)malloc(strlen($1.name)+strlen($3.name)+1);
        strcpy(newstr, $1.name);
        strcat(newstr, ".");
        strcat(newstr, $3.name);
        $$.nd = mknode($5.nd, NULL, newstr);
    }
    ;

params: datatype TK_IDENTIFIER {add('V');} TK_COMMA params { 
        struct node* newnode = mknode(NULL, NULL, $2.name);
        $$.nd = mknode(newnode, $4.nd, "params");
    }

    | datatype TK_IDENTIFIER {add('V');} { 
        struct node* newnode = mknode(NULL, NULL, $2.name);
        $$.nd = mknode(newnode, NULL, "params");
    }

    | {
        $$.nd = NULL;
    }
    ;

body: stmt body {  
    $$.nd = mknode($1.nd, $2.nd, "body");
    }

    | { 
        $$.nd = NULL;
    }
    ;

main: datatype TK_MAIN { add('F'); }
    ;

return: TK_RETURN { add('K'); } expr TK_SEMICOLON { 
        $$.nd = mknode($3.nd, NULL, "return");}
    ;

stmt:  TK_PRINT { add('K'); } expr TK_SEMICOLON  {
    $$.nd = mknode($3.nd, NULL, "print"); 
    }

    | TK_IDENTIFIER TK_ASSIGN expr TK_SEMICOLON  { 
        printf("tkid %s\n", $1.name);
        //check_declaration($1.name);
        struct node* newnode = mknode(NULL, NULL, $1.name);
        $$.nd = mknode(newnode, $3.nd, "assign");
    }

    | class_variable TK_ASSIGN expr TK_SEMICOLON { 
        $$.nd = mknode($1.nd, $3.nd, "assign");
    }
    
    | term TK_SEMICOLON { 
        $$.nd = $1.nd;
    }

    | declaration TK_SEMICOLON { 
        $$.nd = $1.nd; 
    }

    | TK_IF { add('K'); } '(' condition ')' '{' body '}' else   { 
        struct node* iff = mknode($4.nd, $7.nd, $1.name);
        $$.nd = mknode(iff, $9.nd, "if-else");
    }
    
    | TK_WHILE { add('K'); } '(' condition ')' '{' body '}'     {

        $$.nd = mknode($4.nd, $7.nd, "while");
    }
    
    | return { 
        $$.nd = $1.nd;    
    }
    ;

else: TK_ELSE {add('K');} '{' body '}' { 
        $$.nd = mknode($4.nd, NULL, "else");
    }

    | { $$.nd = NULL; }
    ;

condition: expr comparator_binary expr { 
        $$.nd = mknode($1.nd, $3.nd, $2.name); 
    }

    | comparator_unary expr { 
        $$.nd = mknode($2.nd, NULL, $1.name);
    }

    | TK_TRUE { add('K'); } { 
        $$.nd = mknode(NULL, NULL, "true");
    }

    | TK_FALSE { add('K'); } { 
        $$.nd = mknode(NULL, NULL, "false"); 
    }
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

declaration: datatype array_sign TK_IDENTIFIER {add('V');} assignment {
    struct node* newnode = mknode(NULL, NULL, $3.name);
    $$.nd = mknode(newnode, $5.nd, "declaration");
    }
    ;

array_sign: '[' TK_INT ']' { ; }
    | { ; }
    ;

datatype: TK_INT_TYPE { insert_type(); }
    | TK_FLOAT_TYPE { insert_type();}
    | TK_STRING_TYPE { insert_type();}
    | TK_CHAR_TYPE { insert_type();}
    | TK_CLASS_IDENTIFIER { insert_type();}
    ;

assignment: TK_ASSIGN expr {
    $$.nd = mknode($2.nd, NULL, "assignment");
    }

    | TK_ASSIGN TK_CLASS_IDENTIFIER '(' params_call ')' {
        struct node* newnode = mknode(NULL, NULL, $2.name);
        $$.nd = mknode(newnode, $4.nd, "assignment-cls.id");
    }

    | {$$.nd = NULL;}
    ;

expr: term {
    $$.nd = $1.nd;
    }
    
    | term arithmetic expr {
        $$.nd = mknode($1.nd, $3.nd, $2.name);
    }
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

term : value { 
        $$.nd = mknode(NULL, NULL, $1.name);    
    }

    | TK_IDENTIFIER { 
        check_declaration($1.name);
        $$.nd = mknode(NULL, NULL, $1.name);        
    }

    | function_call { 
        $$.nd = mknode(NULL, NULL, "func-call");
    }

    | class_variable { 
        $$.nd = $1.nd;
    }
    
    | class_function_call { 
        $$.nd = mknode($1.nd, NULL, "cfunc-call");
    }

    | TK_READ { add('K'); } '(' ')' { 
        $$.nd = mknode(NULL, NULL, "read");
    }
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
        countn = 0;
        FILE *fp = fopen(argv[i], "r");
        if (fp == NULL)
        {
            printf("Error: could not open file %s\n", argv[i]);
            return 1;
        }
        active_file_name = argv[i];
        yyin = fp;

        yyparse();

        fclose(fp);
    }


    int i = 0;
    printf("\nSYMBOL   DATATYPE   TYPE   LINE NUMBER \n");
    for(i=0; i<count; i++) {
		printf("%s\t%s\t%s\t%d\t%s\t\n", symbol_table[i].id_name, symbol_table[i].data_type, symbol_table[i].type, symbol_table[i].line_no, symbol_table[i].file);
	}
	for(i=0;i<count;i++) {
		free(symbol_table[i].id_name);
		free(symbol_table[i].type);
	}

    if (head != NULL){
        printf("In Order:\n");
        printInorder(head);
        printf("\n");

        printf("Pre Order:\n");
        printPreorder(head);
        printf("\n");
    }

    if(sem_errors>0) {
		printf("Semantic analysis completed with %d errors\n", sem_errors);
		for(int i=0; i<sem_errors; i++){
			printf("\t - %s", errors[i]);
		}
	} else {
		printf("Semantic analysis completed with no errors");
	}
	printf("\n\n");
}

void yyerror(const char* s) {
    fprintf(stderr, "%s\n", s);
    exit(1);
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
    printf("%s vs %s\n", yytext, str_holder);
    q=search(str_holder);
    if(!q) {
        if(c == 'H') {
            symbol_table[count].id_name=strdup(str_holder);        
            symbol_table[count].data_type=strdup(type);     
            symbol_table[count].line_no=countn;    
            symbol_table[count].type=strdup("Header");
            symbol_table[count].file=strdup(active_file_name);
            count++;  
        }  
        else if(c == 'K') {
            symbol_table[count].id_name=strdup(str_holder);
            symbol_table[count].data_type=strdup("N/A");
            symbol_table[count].line_no=countn;
            symbol_table[count].type=strdup("Keyword\t");
            symbol_table[count].file=strdup(active_file_name);   
            count++;  
        }  else if(c == 'V') {
            symbol_table[count].id_name=strdup(str_holder);
            symbol_table[count].data_type=strdup(type);
            symbol_table[count].line_no=countn;
            symbol_table[count].type=strdup("Variable");
            symbol_table[count].file=strdup(active_file_name);   
            count++;  
        }  else if(c == 'C') {
            symbol_table[count].id_name=strdup(str_holder);
            symbol_table[count].data_type=strdup("CONST");
            symbol_table[count].line_no=countn;
            symbol_table[count].type=strdup("Constant");   
            symbol_table[count].file=strdup(active_file_name);
            count++;  
        }  else if(c == 'F') {
            symbol_table[count].id_name=strdup(str_holder);
            symbol_table[count].data_type=strdup(type);
            symbol_table[count].line_no=countn;
            symbol_table[count].type=strdup("Function");   
            symbol_table[count].file=strdup(active_file_name);
            count++;  
        }  else if(c == 'L') {
            symbol_table[count].id_name=strdup(yylval.nd_obj.name);
            symbol_table[count].data_type=strdup("Class");
            symbol_table[count].line_no=countn;
            symbol_table[count].type=strdup("Class");   
            symbol_table[count].file=strdup(active_file_name);
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
void printInorder(struct node *tree) {
    int i; 
    if (tree->left) {
        printInorder(tree->left); 
    } 
    printf("%s, ", tree->token); 
    if (tree->right) {  
        printInorder(tree->right); 
    }
}
void printPreorder(struct node *tree) {
    int i; 
    printf("%s, ", tree->token); 
    if (tree->left) {
        printPreorder(tree->left); 
    } 
    if (tree->right) {  
        printPreorder(tree->right); 
    }
}
void check_declaration(char *c) {
    //printf("Checking decl for %s\n", c);    
    q = search(c);    
    //printf("return %d\n", q);
    if(!q) {        
        sprintf(errors[sem_errors], "Line %d: Variable \"%s\" not declared before usage in file %s!\n", countn+1, c, active_file_name);  
        sem_errors++;    
    }
}
void check_return_type(char *value) {
	char *main_datatype = get_type("main");
	char *return_datatype = get_type(value);
	if((!strcmp(main_datatype, "int") && !strcmp(return_datatype, "CONST")) || !strcmp(main_datatype, return_datatype)){
		return ;
	}
	else {
		sprintf(errors[sem_errors], "Line %d: Return type mismatch\n", countn+1);
		sem_errors++;
	}
}
int check_types(char *type1, char *type2){
	// declaration with no init
	if(!strcmp(type2, "null"))
		return -1;
	// both datatypes are same
	if(!strcmp(type1, type2))
		return 0;
	// both datatypes are different
	if(!strcmp(type1, "int") && !strcmp(type2, "float"))
		return 1;
	if(!strcmp(type1, "float") && !strcmp(type2, "int"))
		return 2;
	if(!strcmp(type1, "int") && !strcmp(type2, "char"))
		return 3;
	if(!strcmp(type1, "char") && !strcmp(type2, "int"))
		return 4;
	if(!strcmp(type1, "float") && !strcmp(type2, "char"))
		return 5;
	if(!strcmp(type1, "char") && !strcmp(type2, "float"))
		return 6;
}
char *get_type(char *var){
	for(int i=0; i<count; i++) {
		// Handle case of use before declaration
		if(!strcmp(symbol_table[i].id_name, var)) {
			return symbol_table[i].data_type;
		}
	}
}