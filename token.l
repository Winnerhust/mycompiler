%option noyywrap nodefault yylineno case-insensitive
%{
#include <stdio.h>
#include "parser.tab.h"

%}

space [ ]
tab \t
newline \n

digit [0-9]
oct_digit [0-7]
hex_digit [a-fA-F0-9]
Fsuffix (f|F|l|L)
Isuffix (l|L)
expo [Ee][+-]?{digit}+

identifier [a-zA-Z_][a-zA-Z0-9_]*

oct_integer 0{oct_digit}+{Isuffix}?
dec_integer {digit}+{Isuffix}?
hex_integer 0[xX]{hex_digit}+{Isuffix}?
real_dot {digit}+\.{digit}*{expo}?{Fsuffix}?
dot_real {digit}*\.{digit}+{expo}?{Fsuffix}?
real_expo {digit}+{expo}{Fsuffix}?

d_string '(\\.|''|[^'\n])*'
q_string \"(\\.|\"\"|[^"\n])*\"
string {d_string}|{q_string}

include_file_a <[^\n]*?>
include #include
%%
 /*auto code*/
"auto" { return AUTO; }
"break" { return BREAK; }
"case" { return CASE; }
"char" { return CHAR; }
"const" { return CONST; }
"continue" { return CONTINUE; }
"default" { return DEFAULT; }
"do" { return DO; }
"double" { return DOUBLE; }
"else" { return ELSE; }
"enum" { return ENUM; }
"extern" { return EXTERN; }
"float" { return FLOAT; }
"for" { return FOR; }
"goto" { return GOTO; }
"if" { return IF; }
"int" { return INT; }
"long" { return LONG; }
"register" { return REGISTER; }
"return" { return RETURN; }
"short" { return SHORT; }
"signed" { return SIGNED; }
"sizeof" { return SIZEOF; }
"static" { return STATIC; }
"struct" { return STRUCT; }
"switch" { return SWITCH; }
"typedef" { return TYPEDEF; }
"union" { return UNION; }
"unsigned" { return UNSIGNED; }
"void" { return VOID; }
"volatile" { return VOLATILE; }
"while" { return WHILE; }

{include} { return INCLUDE; }

"="                 { return '='; }
"*="                { return MUL_ASSIGN; }
"/="                { return DIV_ASSIGN; }
"%="                { return MOD_ASSIGN; }
"+="                { return ADD_ASSIGN; }
"-="                { return SUB_ASSIGN; }
"<<="               { return SHLL_ASSIGN; }
">>="               { return SHRL_ASSIGN; }
"&="                { return ANDB_ASSIGN; }
"|="                { return ORB_ASSIGN; }
"^="                { return XORB_ASSIGN; }

"&&"                { return ANDL_OP; }
"||"                { return ORL_OP; }
"|"                 { return '|'; }
"^"                 { return '^'; }
"&"                 { return '&'; }
"=="                { return EQ_OP; }
"!="                { return NE_OP; }
"<"                 { return '<'; }
"<="                { return LE_OP; }
">"                 { return '>'; }
">="                { return GE_OP; }
"<<"                { return SHLL_OP; }
">>"                { return SHRL_OP; }

"++"                { return INC_OP; }
"--"                { return DEC_OP; }
"+"                 { return '+'; }
"-"                 { return '-'; }
"*"                 { return '*'; }
"/"                 { return '/'; }
"%"                 { return '%'; }
"!"                 { return '!'; }

"("                 { return '('; }
")"                 { return ')'; }
"["                 { return '['; }
"]"                 { return ']'; }
"{"                 { return '{'; }
"}"                 { return '}'; }
","                 { return ','; }
";"                 { return ';'; }

{space}
{tab}
{newline}

{oct_integer} { yylval.longval = atol(yytext); return OCT_INTEGER; }
{dec_integer} { yylval.longval = atol(yytext); return DEC_INTEGER; }
{hex_integer} { yylval.longval = atol(yytext); return HEX_INTEGER; }
{real_dot}    { yylval.doubleval = atof(yytext); return FLOATING; }
{dot_real}    { yylval.doubleval = atof(yytext); return FLOATING; }
{real_expo}   { yylval.doubleval = atof(yytext); return FLOATING; }


{identifier} { yylval.symbol = strdup(yytext); return IDENTIFIER; }
{string} { yylval.string = strdup(yytext); return STRING; }
{include_file_a} { yylval.string = strdup(yytext); return INCLUDE_FILE_A; }
 /*未完成的字符串*/
'(\\.|[^'\n])*$         { printf("Unterminated string %s", yytext); }
\"(\\.|[^"\n])*$    { printf("Unterminated string %s", yytext); }

%%

