#include <stdio.h>


#include "lexer.c"

int main(){
    const char *content = "#define#import idt;  . ++\n aaaa 11 'asdas' \"dasdasd\" exec1 1@@3 l@aa 1a2 1.2 1.2.3";
    //const char *content = "#include <stdio.h>\n\nint main(){\n\tprintf(\"Hello World!\\n\" /comment);\n\treturn 0;\n}";
    Lexer lexer = lexer_new(content, strlen(content));
    Token token;
    token = lexer_next(&lexer);

    while (token.class != TOKEN_EOF){
        printf("%.*s (%s)\n", token.lenght, token.text, token_kind_to_text(evaluate_token(token)));
        token = lexer_next(&lexer);
    }

    return 0;
}