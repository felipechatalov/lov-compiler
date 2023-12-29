#include "include/lexer.h"
#include "include/parser.h"

#include <stdlib.h>
#include <stdio.h>

Parser* parser_new(Lexer* lexer){
    Parser *parser = malloc(sizeof(Parser));
    parser->lexer = lexer;
    return parser;
}


// SYMBOL TABLE PLAN
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





// ABSTRACT SYNTAX TREE PLAN
/*
the tree should look like this:
                   program
                      \
                      expr
                  /    |     \
               term   '*'     expr
               |           /    |   \
              var:x   value:10 '+' value:5


the evaluation should work from the botton-up
first, evaluate the values, then the terms, then the exprs

problem: how to generate the tree from the sequence of tokens?
sol.(1) - use a stack to store the tokens, then pop them out
            trying to fit them in node mold/cast, until we have a valid node
            after that, generate a node and it stays at the right of the next
            valid node
sol.(2) - have base mold/cast for each type of node(expr, term, func...)
            for each token, try to fit it in those molds/casts, until we
            can be sure that we have a valid and meant-to-be type of node
            if we can't fit it in any of the molds/casts, then we have a syntax error
            after we have a valid node, we work from left to right, until we reach terminal nodes
*/