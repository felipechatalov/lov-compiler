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

    // if string
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
            if (strncmp(token.text, TokenLookUpTable[i].text, token.lenght) == 0){
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

    // if number
    if (isdigit(lexer->content[lexer->cursor])){
        token.class = TOKEN_NUMBER;
        // while it is a number
        while (lexer->cursor < lexer->lenght && 
        (isdigit(lexer->content[lexer->cursor]) ||
        is_symbol(lexer->content[lexer->cursor]) || 
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
    return token_kind_list[kind];
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

int is_valid_int(const char *text, int lenght){
    int i;
    for (i = 0; i < lenght; i++){
        if (!isdigit(text[i])){
            return 0;
        }
    }
    return 1;
}

int is_valid_float(const char *text, int lenght){
    int i;
    int dot = 0;
    for (i = 0; i < lenght; i++){
        if (text[i] == '.'){
            dot++;
            if (dot > 1){
                return 0;
            }
        }
        else if (!isdigit(text[i])){
            return 0;
        }
    }
    return 1;
}

int is_valid_identifier(const char *text, int lenght){
    if (!is_symbol_start(text[0])){
        return 0;
    }
    int i = 1;
    for (i = 1; i < lenght; i++){
        if (!is_symbol(text[i])){
            return 0;
        }
    }
    return 1;
}

TokenKind evaluate_token(Token token){
    //printf("received: %.*s\n", token.lenght, token.text);
    //printf("class: %s\n", token_class_to_text(token.class));
    int i;

    if (token.class == TOKEN_KEYWORD || token.class == TOKEN_OPERATOR || token.class == TOKEN_SEPARATOR){
        for (i = 0; i < TOKEN_LOOK_UP_TABLE_SIZE; i++){
            if (strncmp(token.text, TokenLookUpTable[i].text, token.lenght) == 0){
                return TokenLookUpTable[i].kind;
            }
        }
    }
    else if (token.class == TOKEN_IDENTIFIER){
        if (is_valid_identifier(token.text, token.lenght)) return TOKEN_ID;
        return TOKEN_UNKNOWN;
    }
    else if (token.class == TOKEN_NUMBER){
        if (is_valid_int(token.text, token.lenght)) return TOKEN_VALUE_INT;
        if (is_valid_float(token.text, token.lenght)) return TOKEN_VALUE_FLOAT;
        return TOKEN_UNKNOWN;
        }
    else if (token.class == TOKEN_STRING) return TOKEN_VALUE_STRING;
    else if (token.class == TOKEN_INVALID) return TOKEN_UNKNOWN;
    else return TOKEN_UNKNOWN;

}
