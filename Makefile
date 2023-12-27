EXEC = compiler.out
SOURCES = ${wildcard src/*.c}
MAIN_SOURCE = src/compiler.c
FLAGS = -Wall



${EXEC}:
	gcc ${FLAGS} ${MAIN_SOURCE} -o ${EXEC}	

clean:
	-rm *.out

lint:
	clang-tidy src/*.c src/include/*.h -- -Isrc/include