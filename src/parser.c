#include "include/lexer.h"
#include "include/parser.h"

#include <stdlib.h>
#include <stdio.h>

Parser* parser_new(Lexer* lexer){
    Parser *parser = malloc(sizeof(Parser));
    parser->lexer = lexer;
    return parser;
}



