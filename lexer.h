#ifndef LEXER_H
#define LEXER_H

typedef enum {
    TOKEN_END = 0,
    TOKEN_INVALID,
    TOKEN_HASH,
    TOKEN_SYMBOL
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

Lexer lexer_new(const char *content, int lenght);
Token lexer_next(Lexer *lexer);
int is_symbol_start(char c);
int is_symbol(char c);
void lexer_trim_left(Lexer *lexer);
char* token_to_text(TokenKind kind);
#endif // LEXER_H