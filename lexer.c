#include "lexer.h"
#include <stdlib.h>


Lexer lexer_new(const char *content, int lenght){
    Lexer lexer = {0};
    lexer.content = content;
    lexer.lenght = lenght;
    return lexer;
};

Token lexer_next(Lexer *lexer){

    lexer_trim_left(lexer);    

    Token token = {
        .text = &lexer->content[lexer->cursor]
    };

    if (lexer->cursor >= lexer->lenght){
        return token;
    }

    //printf("lexer->content[lexer->cursor] = %c\n", lexer->content[lexer->cursor]);
    //int temp = lexer->content[lexer->cursor];
    //printf("temp = %d\n", temp);
    if (lexer->content[lexer->cursor] == '#'){
        lexer->cursor++;
        token.kind = TOKEN_HASH;
        token.lenght = 1;
        return token;
    }

    if (is_symbol_start(lexer->content[lexer->cursor])){
        token.kind = TOKEN_SYMBOL;
        while (lexer->cursor < lexer->lenght && is_symbol(lexer->content[lexer->cursor])){
            lexer->cursor++;
            token.lenght++;
        }
        return token;
    }

    lexer->cursor++;
    token.kind = TOKEN_INVALID;
    token.lenght = 1;


    return token;
};

char* token_to_text(TokenKind kind){
    switch(kind){
        case TOKEN_END:
            return "TOKEN_END";
        case TOKEN_INVALID:
            return "TOKEN_INVALID";
        case TOKEN_HASH:
            return "TOKEN_HASH";
        case TOKEN_SYMBOL:
            return "TOKEN_SYMBOL";
        default:
            return "TOKEN_UNKNOWN";
    }
    return NULL;
}

int is_symbol_start(char c){
    return iswalpha(c) || c == '_';
}

int is_symbol(char c){
    return iswalnum(c) || c == '_';
}  

void lexer_trim_left(Lexer *lexer){
    while (lexer->cursor < lexer->lenght && isspace(lexer->content[lexer->cursor])){
        if (lexer->content[lexer->cursor] == '\n'){
            lexer->line++;
            lexer->lineStart = lexer->cursor + 1;
        }
        else{
            lexer->column++;
        }
        lexer->cursor++;
    }
}
