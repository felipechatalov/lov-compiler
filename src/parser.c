#include "include/lexer.h"
#include "include/parser.h"

#include <stdlib.h>
#include <stdio.h>

Parser* parser_new(Lexer* lexer){
    Parser *parser = malloc(sizeof(Parser));
    parser->lexer = lexer;
    return parser;
}



/*  how the table should look like
name        data_type       type
char*       char*           char*

var1        int             variable
function1   float(return)   function
var2        string          variable
*/

/*
need to add variables, functions names,
and values to the symbol table

the main ideia is, for each token, check if its class is
TOKEN_ID and check if its not a keyword
if both are true, it is a variable or function, add to the symbol table
*/

/*
needed functions to work:

-add_symbol
-get_symbol
-already_exists
*/
