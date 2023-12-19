#include "lexer.h"
#include <stdlib.h>

// https://en.wikipedia.org/wiki/Lexical_analysis

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
        token.class = TOKEN_EOF;
        token.lenght = 0;
        return token;
    }

    // TODO if string
    if (lexer->content[lexer->cursor] == '\"'){
        lexer->cursor++;
        token.lenght++;
        token.class = TOKEN_STRING;
        // while it is not a double quote
        while (lexer->cursor < lexer->lenght && lexer->content[lexer->cursor] != '\"' ){
            lexer->cursor++;
            token.lenght++;
        }
        lexer->cursor++;
        token.lenght++;
        return token;
    }

    // if separator
    if (is_separator(lexer->content[lexer->cursor])){
        lexer->cursor++;
        token.class = TOKEN_SEPARATOR;
        token.lenght = 1;
        return token;
    }

    // keyword or identifier
    // if starts with a letter
    if (is_symbol_start(lexer->content[lexer->cursor])){
        // while it is a letter or a number
        while (lexer->cursor < lexer->lenght && 
        (is_symbol(lexer->content[lexer->cursor]) ||
        is_invalid(lexer->content[lexer->cursor]))){
            lexer->cursor++;
            token.lenght++;
        }
        // check if it is a keyword
        for (int i = 0; i < KEYWORDS_COUNT; i++){
            if (strncmp(token.text, keywords[i], token.lenght) == 0){
                token.class = TOKEN_KEYWORD;
                return token;
            }
        }
        token.class = TOKEN_IDENTIFIER;
        return token;
    }

    // if operator
    if (is_operator(lexer->content[lexer->cursor])){
        token.class = TOKEN_OPERATOR;
        // while it is a operator
        while (lexer->cursor < lexer->lenght && is_operator(lexer->content[lexer->cursor])){
            lexer->cursor++;
            token.lenght++;
        }
        return token;
    }

    // TODO if number
    if (isdigit(lexer->content[lexer->cursor])){
        token.class = TOKEN_NUMBER;
        // while it is a number
        while (lexer->cursor < lexer->lenght && 
        (isdigit(lexer->content[lexer->cursor]) || 
        lexer->content[lexer->cursor] == '.') ||
        is_invalid(lexer->content[lexer->cursor])){
            lexer->cursor++;
            token.lenght++;
        }
        return token;
    }




    lexer->cursor++;
    token.class = TOKEN_INVALID;
    token.lenght = 1;


    return token;
};

char* token_class_to_text(TokenClass class){
    switch(class){
        case TOKEN_EOF:
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
        case TOKEN_NUMBER:
            return "TOKEN_NUMBER";
        case TOKEN_STRING:
            return "TOKEN_STRING";

        default:
            return "TOKEN_UNKNOWN";
    }
    return NULL;
};

char* token_kind_to_text(TokenKind kind){
    return "TOKEN_UNKNOWN";
}

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

int is_digit(char c){
    return isdigit(c);
}

int is_invalid(char c){
    return  c ==    '@'  ||   // at
            c ==    '$'  ||   // dollar
            c ==    '%'  ||   // percent
            c ==    '&'  ||   // ampersand
            c ==    '|'  ||   // pipe
            c ==    '\\' ||   // backslash
            c ==    '^'  ||   // caret
            c ==    '~'  ||   // tilde
            c ==    '`';      // backtick
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

TokenKind evaluate_token(Token token){
    return TOKEN_UNKNOWN;
}
