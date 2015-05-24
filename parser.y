%{
#include <stdio.h>
extern int yylex (void);
extern void yyerror(const char *s, ...);
%}
%union
{
  char *string;         /* quoted string */
  char *symbol;         /* general symbol */
  double doubleval;     /* double number */
  long  longval;        /* long number */
  int separator;        /* separator */
}
%token <string> STRING
%token <symbol> IDENTIFIER
%token INCLUDE
%token<string> INCLUDE_FILE_A



/*auto token*/
%token AUTO
%token BREAK
%token CASE
%token CHAR
%token CONST
%token CONTINUE
%token DEFAULT
%token DO
%token DOUBLE
%token ELSE
%token ENUM
%token EXTERN
%token FLOAT
%token FOR
%token GOTO
%token IF
%token INT
%token LONG
%token REGISTER
%token RETURN
%token SHORT
%token SIGNED
%token SIZEOF
%token STATIC
%token STRUCT
%token SWITCH
%token TYPEDEF
%token UNION
%token UNSIGNED
%token VOID
%token VOLATILE
%token WHILE
%token<longval> OCT_INTEGER DEC_INTEGER HEX_INTEGER
%token<doubleval> FLOATING


%right '=' MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN ADD_ASSIGN SUB_ASSIGN SHLL_ASSIGN SHRL_ASSIGN ANDB_ASSIGN ORB_ASSIGN XORB_ASSIGN
%left ORL_OP
%left ANDL_OP
%left '!'
%left EQ_OP NE_OP '<' LE_OP '>'  GE_OP
%left '|'
%left '&'
%left SHLL_OP SHRL_OP
%left '+' '-'
%left '*' '/' '%' 
%left '^'
%right INC_OP DEC_OP

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%type<string> test
%start test
%%

assign_op
    : '='
    | MUL_ASSIGN
    | DIV_ASSIGN
    | MOD_ASSIGN
    | ADD_ASSIGN
    | SUB_ASSIGN
    | SHLL_ASSIGN
    | SHRL_ASSIGN
    | ANDB_ASSIGN
    | ORB_ASSIGN
    | XORB_ASSIGN
    ;
primary_expression
    : IDENTIFIER   
    | literal
    | '(' assignment_expression ')'
    ;
literal
    : OCT_INTEGER
    | DEC_INTEGER
    | HEX_INTEGER
    | FLOATING
    | STRING
    ;
assignment_expression
    : logical_or_expression
    | unary_expression assign_op assignment_expression
    ;
logical_or_expression
    : logical_and_expression
    | logical_or_expression ORL_OP logical_and_expression
    ;
logical_and_expression
    : equality_expression
    | logical_and_expression ANDL_OP equality_expression
    ;
equality_expression
    : relational_expression
    | equality_expression EQ_OP relational_expression
    | equality_expression NE_OP relational_expression
    ;
relational_expression
    : additive_expression
    | relational_expression '<' additive_expression
    | relational_expression '>' additive_expression
    | relational_expression LE_OP additive_expression
    | relational_expression GE_OP additive_expression
    ;
additive_expression
    : multiplicative_expression
    | additive_expression '+' multiplicative_expression
    | additive_expression '-' multiplicative_expression
    ;
multiplicative_expression
    : cast_expression
    | multiplicative_expression '*' cast_expression
    | multiplicative_expression '/' cast_expression
    | multiplicative_expression '%' cast_expression
    ;
cast_expression
    : unary_expression
    | '(' type ')' cast_expression
    ;
unary_expression
    : postfix_expression
    | '+' unary_expression
    | '-' unary_expression
    | '!' unary_expression
    | INC_OP unary_expression
    | DEC_OP unary_expression
    ;
postfix_expression
    : attach_expression
    | postfix_expression INC_OP
    | postfix_expression DEC_OP
    ;
    
attach_expression
    : primary_expression  
    | primary_expression array_offset
    | primary_expression '(' argument_list ')'
    | primary_expression '(' ')'
    ;
array_offset
    : '[' assignment_expression ']'
    | array_offset '[' assignment_expression ']'
    ;
argument_list
    : assignment_expression
    | argument_list ',' assignment_expression
    ;
type
    : basic_type
    | array_type 
    ;  
basic_type
    : VOID {puts("[VOID]\n");}
    | SHORT
    | INT
    | LONG
    | FLOAT
    | DOUBLE
    | CHAR
    ;
array_type
    : basic_type '[' constant_expression ']'
    | basic_type '[' ']'
    | array_type '[' constant_expression ']'
    | array_type '[' ']'
    ;
constant_expression
    : logical_or_expression
    ;

translation_unit
    : global_declaration
    | translation_unit global_declaration
    ;
global_declaration
    : function_definition
    | function_declaration
    | constant_declaration
    | include_filename
    ;
include_filename
    : INCLUDE STRING
    | INCLUDE INCLUDE_FILE_A
    ;
function_definition
    : function_type compound_statement
    ;
function_declaration
    : function_type ';'
    ;
variable_declaration
    : type init_declarator_list ';'
    ;
declaration
    : variable_declaration
    | constant_declaration
    | function_declaration
    ;
constant_declaration
    : CONST type init_declarator_list ';'
    ;
init_declarator_list
    : init_declarator
    | init_declarator_list ',' init_declarator
    ;
init_declarator
    : IDENTIFIER
    | IDENTIFIER '=' initializer
    ;
initializer
    : assignment_expression
    | '{' initializer_list '}'
    | '{' initializer_list ',' '}'
    ;
initializer_list
    : initializer
    | initializer_list ',' initializer
    ;
parameter_list
    : parameter
    | parameter_list ',' parameter
    ;
parameter
    : type IDENTIFIER
    | type IDENTIFIER '[' ']'
    | type IDENTIFIER '[' constant_expression ']'
    | unnamed_value
    ;
unnamed_value
    : type
    ;
compound_statement
    : '{' statement_list '}'
    | '{' '}'
    ;
statement_list
    : statement
    | statement_list statement
    ;
statement
    : declaration   {puts("$1");}
    | expression_statement {puts("$2");}
    | selection_statement
    | iteration_statement
    | jump_statement
    | compound_statement
    | empty_statement
    ;
empty_statement
    : ';' 
    ;
expression_statement
    : expression_list ';'
    ;
selection_statement
    : IF '(' assignment_expression ')' statement %prec LOWER_THAN_ELSE
     IF '(' assignment_expression ')' statement ELSE statement
    ;
iteration_statement
    : WHILE '(' assignment_expression ')' statement
    | DO statement WHILE '(' assignment_expression ')' ';'
    | FOR '(' for_init_statement assignment_expression ';' expression_list ')' statement
    | FOR '(' for_init_statement assignment_expression ';' ')' statement
    ;
for_init_statement
    : declaration
    | expression_statement
    | empty_statement
    ;
jump_statement
    : BREAK ';'
    | RETURN assignment_expression ';'
    | CONTINUE ';'
    ;
expression_list
    : assignment_expression
    | expression_list ',' assignment_expression
    ;
function_type
    : type IDENTIFIER '(' parameter_list ')'
    | type IDENTIFIER '(' ')'
    ;


test
   : translation_unit {printf("ok!\n");} 
   ;

%%
