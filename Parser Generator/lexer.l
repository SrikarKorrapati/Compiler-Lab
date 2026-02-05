%{
#include <stdio.h>
#include <string.h>
#include "y.tab.h"
%}

%option noyywrap

%%

[ \t\n\r]+          ; /* Skip whitespace */
"//".* ; /* Skip single-line comments */
"/*"([^*]|\*+[^*/])*(\*+"/") ; /* Skip multi-line comments */

"if"                { return IF; }
"else"              { return ELSE; }
"=="                { return EQ; }
"!="                { return NE; }
"<="                { return LE; }
">="                { return GE; }
"&&"                { return AND; }
"||"                { return OR; }

[0-9]+(\.[0-9]+)?   { return NUMBER; }

[a-zA-Z_][a-zA-Z0-9_]* { return IDENTIFIER; }

[0-9]+[a-zA-Z_]+    { 
    printf("LEXICAL ERROR: Invalid Identifier '%s'\n", yytext); 
    return IDENTIFIER; 
}

"+"|"-"|"*"|"/"|"%"|"<"|">"|"!"|"="|"("|")"|";" { 
    return yytext[0]; 
}

.                   { return yytext[0]; }

%%