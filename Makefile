CC = gcc
SRC_PATH = ./
C_INCLUDE = 
C_FLAGS = -Wall

all: lexer compiler
lexer: ${SRC_PATH}/lexer.c
	echo "Compiling lexer"
	${CC} ${C_FLAGS} ${C_INCLUDE} ${SRC_PATH}/lexer.c -o lexer

compiler: ${SRC_PATH}/compiler.c
	echo "Compiling compiler"
	${CC} ${C_FLAGS} ${C_INCLUDE} ${SRC_PATH}/compiler.c -o compiler