#ifndef PARSER_H
#define PARSER_H

#include "lexer.h"
#include "AST.h"

typedef struct {
    Lexer* lexer;
    Token* token;
} Parser;

Parser* parser_new(Lexer* lexer);

Token* parser_eat(Parser *parser, int type);

AST* parser_parse(Parser *parser);

#endif