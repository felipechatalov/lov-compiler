#ifndef LEXER_H
#define LEXER_H

typedef enum {
    TOKEN_EOF = 0,
    TOKEN_INVALID,
    TOKEN_IDENTIFIER,
    TOKEN_KEYWORD,
    TOKEN_OPERATOR,
    TOKEN_SEPARATOR,
    TOKEN_NUMBER,
    TOKEN_STRING,
} TokenClass;

typedef enum {
    TOKEN_KW_IF,
    TOKEN_KW_ELSE,
    TOKEN_KW_IMPORT,
    TOKEN_KW_DEF,
    // ...
    TOKEN_NUMBER_INT,
    TOKEN_NUMBER_FLOAT,
    TOKEN_VALUE_STRING,
    // ...
    TOKEN_VAR_IDENTIFIER,
    // ...
    TOKEN_OPERATOR_PLUS,
    TOKEN_OPERATOR_MINUS,
    TOKEN_SEPARATOR_COMMA,
    // ...
    TOKEN_UNKNOWN,
} TokenKind;

typedef struct {
    TokenClass class;
    TokenKind kind;
    const char *text;
    int lenght;
    int line;
    int column;
} Token;

typedef struct {
    const char *content;
    int lenght;
    int cursor;
    int line;
    int column;
    int lineStart;
} Lexer;

const char *keywords[] = {
    "if",
    "else",
    "import",
    "def",
    "return",
    "for",
    "while",
    "int",
    "float",
    "char",
};
const int KEYWORDS_COUNT = sizeof(keywords) / sizeof(keywords[0]);

const char *operators[] = {
    "+",   // plus
    "-",   // minus
    "*",   // star
    "/",   // slash
    "=",   // equal (assignment)
    "==",  // double equal (comparison)
    "!=",  // not equal (comparison)
    ">",   // greater than
    "<",   // less than 
    ">=",  // greater than or equal
    "<=",  // less than or equal
    "!",   // exclamation mark (not)
    "+=",  // plus equal
    "-=",  // minus equal
    "*=",  // star equal
    "/=",  // slash equal
    "++",  // plus plus
    "--",  // minus minus
};
const int OPERATORS_COUNT = sizeof(operators) / sizeof(operators[0]);

const char *separators[] = {
    ",",   // comma
    ".",   // dot
    ":",   // colon
//    "\"",  // double quote
    "'",   // single quote
    "#",   // hash
    "(",   // open parenthesis
    ")",   // close parenthesis
    "{",   // open curly brace
    "}",   // close curly brace
    "[",   // open square bracket
    "]",   // close square bracket
    ";",   // semicolon
};
const int SEPARATORS_COUNT = sizeof(separators) / sizeof(separators[0]);



Lexer lexer_new(const char *content, int lenght);
Token lexer_next(Lexer *lexer);
int is_symbol_start(char c);
int is_symbol(char c);
void lexer_trim_left(Lexer *lexer);
int is_operator(char c);
int is_separator(char c);
int is_digit(char c);
int is_invalid(char c);
char* token_class_to_text(TokenClass class);
char* token_kind_to_text(TokenKind kind);
TokenKind evaluate_token_kind(Token token);

#endif // LEXER_H