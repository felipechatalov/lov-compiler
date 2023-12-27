EXEC = compiler.out
SOURCES = ${wildcard src/*.c}
OBJECTS = ${SOURCES:.c=.o}
FLAGS = -Wall



${EXEC}: ${OBJECTS}
	gcc ${FLAGS} ${OBJECTS} -o ${EXEC}	

%.o: %.c include/%.h
	gcc -c ${FLAGS} $< -o ${EXEC}

clean:
	-rm *.out
	-rm *.o
	-rm src/*.o

lint:
	clang-tidy src/*.c src/include/*.h