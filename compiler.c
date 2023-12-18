#include <stdio.h>
#include <ctype.h>
#include <string.h>

#include "lexer.c"


void main(){
    const char *content = "#define#import idt;  . ++";
    Lexer lexer = lexer_new(content, strlen(content));
    Token token;
    token = lexer_next(&lexer);
    while (token.kind != TOKEN_END){
        printf("%.*s (%s)\n", token.lenght, token.text, token_to_text(token.kind));
        token = lexer_next(&lexer);
    }
}