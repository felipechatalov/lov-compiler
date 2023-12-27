
#include "lexer.c"

#include <stdio.h>
#include <stdlib.h>



int main(int argc, char **argv){
    //const char *content = "#define#import idt;  . ++\n aaaa 11 'asdas' \"dasdasd\" exec1 1@@3 l@aa 1a2 1.2 1.2.3";
    //const char *content = "#include <stdio.h>\n\nint main(){\n\tprintf(\"Hello World!\\n\");\n\treturn 0;\n}";
    
    if (argc < 2 || argc > 2){
        printf("Usage: %s <file>\n", argv[0]);
        return 1;
    }
    FILE *file = fopen(argv[1], "r");
    if (!file){
        printf("Error: Could not open file `%s`\n", argv[1]);
        return 1;
    }

    fseek(file, 0, SEEK_END);
    size_t file_size = ftell(file);
    fseek(file, 0, SEEK_SET);

    char *content = malloc(file_size);
    fread(content, 1, file_size, file);
    fclose(file);


    Lexer lexer = lexer_new(content, strlen(content));
    Token token;
    token = lexer_next(&lexer);

    while (token.class != TOKEN_EOF){
        printf("[Text] = `%.*s`, [Kind] = `%s`\n", token.lenght, token.text, token_kind_to_text(evaluate_token(token)));
        token = lexer_next(&lexer);
    }

    return 0;
}
