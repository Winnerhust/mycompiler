#include<stdio.h>
#include<stdarg.h>
#include "parser.tab.h"

void yyerror(const char *s, ...)
{
    extern char *yytext;
    va_list ap;
    va_start(ap, s);
    fprintf(stderr,"error:\"%s\" ",yytext);
    vfprintf(stderr, s, ap);
    fprintf(stderr, "\n");
}

int main(int argc,char *argv[])
{
    yyparse();
    puts("b\n");
    return 0;
}
