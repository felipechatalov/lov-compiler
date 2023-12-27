#include "include/lexer.h"
#include "include/parser.h"

#include <stdlib.h>

void parser_init(){

}

char* parser_binary_op(TokenKind kind, Expr left, Expr right){
    return NULL;
}

/*
{
"kind": "binary_op",
"payload": {
    "op": op_token,
    "lhs": lhs,
    "rhs": rhs
}
*/
