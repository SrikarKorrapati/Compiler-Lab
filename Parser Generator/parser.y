%{
#include <stdio.h>
#include <stdlib.h>

void yyerror(const char *s);
int yylex();
%}

%token IDENTIFIER NUMBER
%token IF ELSE
%token AND OR EQ NE LE GE

/* Define Precedence */
%right '='
%left OR
%left AND
%left EQ NE
%left '<' '>' LE GE
%left '+' '-'
%left '*' '/' '%'
%right '!'

/* Fix Dangling Else Ambiguity */
%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%%

input: /* empty */
     | input statement
     ;

statement: expression ';' { printf("Parsed: Expression Statement\n"); }
         | compound_statement
         | IF '(' expression ')' statement %prec LOWER_THAN_ELSE { printf("Parsed: IF Statement\n"); }
         | IF '(' expression ')' statement ELSE statement { printf("Parsed: IF-ELSE Statement\n"); }
         | error ';' { yyerrok; }
         ;

compound_statement: '{' statement_list '}' ;

statement_list: /* empty */
               | statement_list statement
               ;

expression: IDENTIFIER '=' expression  
          | expression OR expression
          | expression AND expression
          | expression EQ expression
          | expression NE expression
          | expression '<' expression
          | expression '>' expression
          | expression LE expression
          | expression GE expression
          | expression '+' expression
          | expression '-' expression
          | expression '*' expression
          | expression '/' expression
          | expression '%' expression
          | '!' expression
          | '(' expression ')'
          | NUMBER
          | IDENTIFIER
          ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Syntax Error: %s\n", s);
}

int main() {
    printf("Enter statements (e.g., if (x > 5) { y = 1; } else { y = 0; }):\n");
    yyparse();
    return 0;
}