#ifndef LEXER_H
#define LEXER_H

typedef enum {
    TOKEN_END = 0,
    TOKEN_INVALID,
    TOKEN_HASH,
    TOKEN_SYMBOL,
    TOKEN_KEYWORD,
    TOKEN_OPERATOR,
    TOKEN_SEPARATOR,
} TokenKind;

typedef struct {
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
const KEYWORDS_COUNT = sizeof(keywords) / sizeof(keywords[0]);

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
const OPERATORS_COUNT = sizeof(operators) / sizeof(operators[0]);

const char *separators[] = {
    " ",   // space
    "\n",  // new line
    ",",   // comma
    ".",   // dot
    ":",   // colon
    "\"",  // double quote
    '"',   // single quote
    "#",   // hash
    "(",   // open parenthesis
    ")",   // close parenthesis
    "{",   // open curly brace
    "}",   // close curly brace
    "[",   // open square bracket
    "]",   // close square bracket
    ";",   // semicolon
};
const SEPARATORS_COUNT = sizeof(separators) / sizeof(separators[0]);






Lexer lexer_new(const char *content, int lenght);
Token lexer_next(Lexer *lexer);
int is_symbol_start(char c);
int is_symbol(char c);
void lexer_trim_left(Lexer *lexer);
char* token_to_text(TokenKind kind);
int is_operator(char c);
int is_separator(char c);
#endif // LEXER_H