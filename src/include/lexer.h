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
    TOKEN_TYPE_STR,
    
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
    TOKEN_VALUE_INT,
    TOKEN_VALUE_FLOAT,
    TOKEN_VALUE_STRING,
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

typedef struct {
    const char *text;
    TokenKind kind;
} TableToken;

TableToken TokenLookUpTable[] = {
    // Keywords
    {.text = "if",      .kind = TOKEN_KW_IF},
    {.text = "else",    .kind = TOKEN_KW_ELSE},
    {.text = "import",  .kind = TOKEN_KW_IMPORT},
    {.text = "def",     .kind = TOKEN_KW_DEF},
    {.text = "return",  .kind = TOKEN_KW_RETURN},   // return
    {.text = "for",     .kind = TOKEN_KW_FOR},
    {.text = "while",   .kind = TOKEN_KW_WHILE},
    {.text = "int",     .kind = TOKEN_TYPE_INT},
    {.text = "float",   .kind = TOKEN_TYPE_FLOAT},
    {.text = "str",     .kind = TOKEN_TYPE_STR},

    // Operators
    {.text = "+",       .kind = TOKEN_OP_PLUS},   // plus
    {.text = "-",       .kind = TOKEN_OP_MINUS},   // minus
    {.text = "*",       .kind = TOKEN_OP_STAR},   // star
    {.text = "/",       .kind = TOKEN_OP_SLASH},   // slash
    {.text = "=",       .kind = TOKEN_OP_EQUAL},   // equal (assignment)
    {.text = "==",      .kind = TOKEN_OP_DOUBLE_EQUAL},   // double equal (comparison)
    {.text = "!=",      .kind = TOKEN_OP_NOT_EQUAL},   // not equal (comparison)
    {.text = ">",       .kind = TOKEN_OP_GREATER_THAN},   // greater than
    {.text = "<",       .kind = TOKEN_OP_LESS_THAN},   // less than 
    {.text = ">=",      .kind = TOKEN_OP_GREATER_THAN_OR_EQUAL},   // greater than or equal
    {.text = "<=",      .kind = TOKEN_OP_LESS_THAN_OR_EQUAL},   // less than or equal
    {.text = "!",       .kind = TOKEN_OP_NOT},   // exclamation mark (not)
    {.text = "+=",      .kind = TOKEN_OP_PLUS_EQUAL},   // plus equal
    {.text = "-=",      .kind = TOKEN_OP_MINUS_EQUAL},   // minus equal
    {.text = "*=",      .kind = TOKEN_OP_STAR_EQUAL},   // star equal
    {.text = "/=",      .kind = TOKEN_OP_SLASH_EQUAL},   // slash equal
    {.text = "++",      .kind = TOKEN_OP_PLUS_PLUS},   // plus plus
    {.text = "--",      .kind = TOKEN_OP_MINUS_MINUS},   // minus minus

    // Separators
    {.text = ",",       .kind = TOKEN_SEP_COMMA},   // comma
    {.text = ".",       .kind = TOKEN_SEP_DOT},   // dot
    {.text = ":",       .kind = TOKEN_SEP_COLON},   // colon
    {.text = "\"",      .kind = TOKEN_SEP_DOUBLE_QUOTE},   // double quote
    {.text = "'",       .kind = TOKEN_SEP_SINGLE_QUOTE},   // single quote
    {.text = "#",       .kind = TOKEN_SEP_HASH},   // hash
    {.text = "(",       .kind = TOKEN_SEP_OPEN_PARENTHESIS},   // open parenthesis
    {.text = ")",       .kind = TOKEN_SEP_CLOSE_PARENTHESIS},   // close parenthesis
    {.text = "{",       .kind = TOKEN_SEP_OPEN_CURLY_BRACE},   // open curly brace
    {.text = "}",       .kind = TOKEN_SEP_CLOSE_CURLY_BRACE},   // close curly brace
    {.text = "[",       .kind = TOKEN_SEP_OPEN_SQUARE_BRACKET},   // open square bracket
    {.text = "]",       .kind = TOKEN_SEP_CLOSE_SQUARE_BRACKET},   // close square bracket
    {.text = ";",       .kind = TOKEN_SEP_SEMICOLON},   // semicolon
};
int TOKEN_LOOK_UP_TABLE_SIZE = sizeof(TokenLookUpTable) / sizeof(TokenLookUpTable[0]);

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
    TOKEN_TYPE_STR,
    
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
    TOKEN_VALUE_INT,
    TOKEN_VALUE_FLOAT,
    TOKEN_VALUE_STRING,
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
    "TOKEN_VALUE_INT",
    "TOKEN_VALUE_FLOAT",
    "TOKEN_VALUE_STRING",
    "TOKEN_UNKNOWN",
};

Lexer* lexer_new(char *content, int lenght);
Token* lexer_next(Lexer *lexer);
int is_symbol_start(char c);
int is_symbol(char c);
void lexer_trim_left(Lexer *lexer);
int is_operator(char c);
int is_separator(char c);
int is_digit(char c);
int is_invalid(char c);
char* token_class_to_text(TokenClass class);
char* token_kind_to_text(TokenKind kind);
TokenKind evaluate_token(Token* token);

#endif // LEXER_H