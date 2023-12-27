#ifndef PARSER_H
#define PARSER_H


// Expression types
typedef enum {
    Expression,
    Value,
    Variable,
    Function,
} ExprType;

typedef enum{
    OP_PLUS,
    OP_MINUS,
    OP_STAR,          
    OP_SLASH,
    OP_EQUAL,
    OP_DOUBLE_EQUAL,
    OP_NOT_EQUAL,
    OP_GREATER_THAN,
    OP_LESS_THAN,
    OP_GREATER_THAN_OR_EQUAL,
    OP_LESS_THAN_OR_EQUAL,
    OP_NOT,
} ExprOp;

// Expression struct
typedef struct {
    ExprType left;
    ExprType right;
    ExprOp operation;
} Expr;

#endif