#ifndef PARSER_H
#define PARSER_H

#include "lexer.h"

typedef struct {
    Lexer* lexer;
} Parser;


Parser* parser_new(Lexer* lexer);

#endif