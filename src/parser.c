#include "include/lexer.h"
#include "include/parser.h"

#include <stdlib.h>


Parser* parser_new(Lexer* lexer){
    Parser *parser = malloc(sizeof(Parser));
    parser->lexer = lexer;
    //parser->token = lexer_next(lexer);
    return parser;
}

Token* parser_eat(Parser *parser, int type){

    if (parser->token->kind != type){
        printf("[Parser]: Expected: `%s`, got: `%s`\n", token_kind_to_text(type), token_kind_to_text(parser->token->kind));
        exit(1);
    }

    
}
