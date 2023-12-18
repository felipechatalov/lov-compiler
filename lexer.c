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
        case TOKEN_KEYWORD:
            return "TOKEN_KEYWORD";
        case TOKEN_OPERATOR:
            return "TOKEN_OPERATOR";
        case TOKEN_SEPARATOR:
            return "TOKEN_SEPARATOR";
        default:
            return "TOKEN_UNKNOWN";
    }
    return NULL;
};

int is_operator(char c){
    return  c ==    "+"  ||   // plus
            c ==    "-"  ||   // minus
            c ==    "*"  ||   // star
            c ==    "/"  ||   // slash
            c ==    "="  ||   // equal (assignment)
            c ==    "==" ||   // double equal (comparison)
            c ==    "!=" ||   // not equal (comparison)
            c ==    ">"  ||   // greater than
            c ==    "<"  ||   // less than 
            c ==    ">=" ||   // greater than or equal
            c ==    "<=" ||   // less than or equal
            c ==    "!"  ||   // exclamation mark (not)
            c ==    "+=" ||   // plus equal
            c ==    "-=" ||   // minus equal
            c ==    "*=" ||   // star equal
            c ==    "/=" ||   // slash equal
            c ==    "++" ||   // plus plus
            c ==    "--";     // minus minus
}

int is_separator(char c){
    return  c ==    " "  ||   // space
            c ==    "\n" ||   // new line
            c ==    ","  ||   // comma
            c ==    "."  ||   // dot
            c ==    ":"  ||   // colon
            c ==    '"'  ||   // double quote
            c ==    "'"  ||   // single quote
            c ==    "#"  ||   // hash
            c ==    "("  ||   // open parenthesis
            c ==    ")"  ||   // close parenthesis
            c ==    "{"  ||   // open curly brace
            c ==    "}"  ||   // close curly brace
            c ==    "["  ||   // open square bracket
            c ==    "]"  ||   // close square bracket
            c ==    ";";   // semicolon
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
