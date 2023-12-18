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

    // if end of file
    if (lexer->cursor >= lexer->lenght){
        token.kind = TOKEN_END;
        token.lenght = 0;
        return token;
    }

    // if separator
    if (is_separator(lexer->content[lexer->cursor])){
        lexer->cursor++;
        token.kind = TOKEN_SEPARATOR;
        token.lenght = 1;
        return token;
    }

    // keyword or identifier
    // if starts with a letter
    if (is_symbol_start(lexer->content[lexer->cursor])){
        // while it is a letter or a number
        while (lexer->cursor < lexer->lenght && is_symbol(lexer->content[lexer->cursor])){
            lexer->cursor++;
            token.lenght++;
        }
        // check if it is a keyword
        for (int i = 0; i < KEYWORDS_COUNT; i++){
            if (strncmp(token.text, keywords[i], token.lenght) == 0){
                token.kind = TOKEN_KEYWORD;
                return token;
            }
        }
        token.kind = TOKEN_IDENTIFIER;
        return token;
    }

    // if operator
    if (is_operator(lexer->content[lexer->cursor])){
        token.kind = TOKEN_OPERATOR;
        // while it is a operator
        while (lexer->cursor < lexer->lenght && is_operator(lexer->content[lexer->cursor])){
            lexer->cursor++;
            token.lenght++;
        }
        return token;
    }

    // TODO if number
    
    // TODO if string



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
        case TOKEN_IDENTIFIER:
            return "TOKEN_IDENTIFIER";
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
    return  c ==    '+'  ||   // plus
            c ==    '-'  ||   // minus
            c ==    '*'  ||   // star
            c ==    '/'  ||   // slash
            c ==    '='  ||   // equal (assignment)
            c ==    '>'  ||   // greater than
            c ==    '<'  ||   // less than 
            c ==    '!';      // exclamation mark (not)
}

int is_separator(char c){
    return  c ==    ','  ||   // comma
            c ==    '.'  ||   // dot
            c ==    ':'  ||   // colon
            c ==    '\"' ||   // double quote
            c ==    '\'' ||   // single quote
            c ==    '#'  ||   // hash
            c ==    '('  ||   // open parenthesis
            c ==    ')'  ||   // close parenthesis
            c ==    '{'  ||   // open curly brace
            c ==    '}'  ||   // close curly brace
            c ==    '['  ||   // open square bracket
            c ==    ']'  ||   // close square bracket
            c ==    ';';      // semicolon
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
