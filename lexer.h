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
    TOKEN_KW_RETURN,
    TOKEN_KW_FOR,
    TOKEN_KW_WHILE,
    
    TOKEN_TYPE_INT,
    TOKEN_TYPE_FLOAT,
    TOKEN_TYPE_STRING,
    
    TOKEN_OP_PLUS,
    TOKEN_OP_MINUS,
    TOKEN_OP_STAR,          
    TOKEN_OP_SLASH,
    TOKEN_OP_EQUAL,
    TOKEN_OP_DOUBLE_EQUAL,
    TOKEN_OP_NOT_EQUAL,
    TOKEN_OP_GREATER_THAN,
    TOKEN_OP_LESS_THAN,
    TOKEN_OP_GREATER_THAN_OR_EQUAL,
    TOKEN_OP_LESS_THAN_OR_EQUAL,
    TOKEN_OP_NOT,
    TOKEN_OP_PLUS_EQUAL,
    TOKEN_OP_MINUS_EQUAL,
    TOKEN_OP_STAR_EQUAL,
    TOKEN_OP_SLASH_EQUAL,
    TOKEN_OP_PLUS_PLUS,
    TOKEN_OP_MINUS_MINUS,

    TOKEN_SEP_COMMA,
    TOKEN_SEP_DOT,
    TOKEN_SEP_COLON,
    TOKEN_SEP_DOUBLE_QUOTE,
    TOKEN_SEP_SINGLE_QUOTE,
    TOKEN_SEP_HASH,
    TOKEN_SEP_OPEN_PARENTHESIS,
    TOKEN_SEP_CLOSE_PARENTHESIS,
    TOKEN_SEP_OPEN_CURLY_BRACE,
    TOKEN_SEP_CLOSE_CURLY_BRACE,
    TOKEN_SEP_OPEN_SQUARE_BRACKET,
    TOKEN_SEP_CLOSE_SQUARE_BRACKET,
    TOKEN_SEP_SEMICOLON,

    TOKEN_ID,

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

const char* valid_symbols[] = {
    "if",
    "else",
    "import",
    "def",
    "return",
    "for",
    "while",
    "int",
    "float",
    "str",

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

    ",",   // comma
    ".",   // dot
    ":",   // colon
    "\"",  // double quote
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

const int KEYWORDS_COUNT = 10;
const int OPERATORS_COUNT = 18;
const int SEPARATORS_COUNT = 13;


const TokenKind token_kinds[] = {
    TOKEN_KW_IF,
    TOKEN_KW_ELSE,
    TOKEN_KW_IMPORT,
    TOKEN_KW_DEF,
    TOKEN_KW_RETURN,
    TOKEN_KW_FOR,
    TOKEN_KW_WHILE,
    
    TOKEN_TYPE_INT,
    TOKEN_TYPE_FLOAT,
    TOKEN_TYPE_STRING,
    
    TOKEN_OP_PLUS,
    TOKEN_OP_MINUS,
    TOKEN_OP_STAR,          
    TOKEN_OP_SLASH,
    TOKEN_OP_EQUAL,
    TOKEN_OP_DOUBLE_EQUAL,
    TOKEN_OP_NOT_EQUAL,
    TOKEN_OP_GREATER_THAN,
    TOKEN_OP_LESS_THAN,
    TOKEN_OP_GREATER_THAN_OR_EQUAL,
    TOKEN_OP_LESS_THAN_OR_EQUAL,
    TOKEN_OP_NOT,
    TOKEN_OP_PLUS_EQUAL,
    TOKEN_OP_MINUS_EQUAL,
    TOKEN_OP_STAR_EQUAL,
    TOKEN_OP_SLASH_EQUAL,
    TOKEN_OP_PLUS_PLUS,
    TOKEN_OP_MINUS_MINUS,

    TOKEN_SEP_COMMA,
    TOKEN_SEP_DOT,
    TOKEN_SEP_COLON,
    TOKEN_SEP_DOUBLE_QUOTE,
    TOKEN_SEP_SINGLE_QUOTE,
    TOKEN_SEP_HASH,
    TOKEN_SEP_OPEN_PARENTHESIS,
    TOKEN_SEP_CLOSE_PARENTHESIS,
    TOKEN_SEP_OPEN_CURLY_BRACE,
    TOKEN_SEP_CLOSE_CURLY_BRACE,
    TOKEN_SEP_OPEN_SQUARE_BRACKET,
    TOKEN_SEP_CLOSE_SQUARE_BRACKET,
    TOKEN_SEP_SEMICOLON,

    TOKEN_ID,
    TOKEN_UNKNOWN,
};

char* token_kind_list[] = {
    "TOKEN_KW_IF",
    "TOKEN_KW_ELSE",
    "TOKEN_KW_IMPORT",
    "TOKEN_KW_DEF",
    "TOKEN_KW_RETURN",
    "TOKEN_KW_FOR",
    "TOKEN_KW_WHILE",
    
    "TOKEN_TYPE_INT",
    "TOKEN_TYPE_FLOAT",
    "TOKEN_TYPE_STRING",
    
    "TOKEN_OP_PLUS",
    "TOKEN_OP_MINUS",
    "TOKEN_OP_STAR",          
    "TOKEN_OP_SLASH",
    "TOKEN_OP_EQUAL",
    "TOKEN_OP_DOUBLE_EQUAL",
    "TOKEN_OP_NOT_EQUAL",
    "TOKEN_OP_GREATER_THAN",
    "TOKEN_OP_LESS_THAN",
    "TOKEN_OP_GREATER_THAN_OR_EQUAL",
    "TOKEN_OP_LESS_THAN_OR_EQUAL",
    "TOKEN_OP_NOT",
    "TOKEN_OP_PLUS_EQUAL",
    "TOKEN_OP_MINUS_EQUAL",
    "TOKEN_OP_STAR_EQUAL",
    "TOKEN_OP_SLASH_EQUAL",
    "TOKEN_OP_PLUS_PLUS",
    "TOKEN_OP_MINUS_MINUS",

    "TOKEN_SEP_COMMA",
    "TOKEN_SEP_DOT",
    "TOKEN_SEP_COLON",
    "TOKEN_SEP_DOUBLE_QUOTE",
    "TOKEN_SEP_SINGLE_QUOTE",
    "TOKEN_SEP_HASH",
    "TOKEN_SEP_OPEN_PARENTHESIS",
    "TOKEN_SEP_CLOSE_PARENTHESIS",
    "TOKEN_SEP_OPEN_CURLY_BRACE",
    "TOKEN_SEP_CLOSE_CURLY_BRACE",
    "TOKEN_SEP_OPEN_SQUARE_BRACKET",
    "TOKEN_SEP_CLOSE_SQUARE_BRACKET",
    "TOKEN_SEP_SEMICOLON",

    "TOKEN_ID",
    "TOKEN_UNKNOWN",
};

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