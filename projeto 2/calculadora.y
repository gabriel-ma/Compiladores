%{
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
extern int yylex();
extern int yyparse();
extern FILE* yyin;
void yyerror(const char* s);
%}

%union {
    int ival;
    float fval;
}

%token<ival> T_INT
%token<fval> T_FLOAT
%token T_PLUS T_MINUS T_MULTIPLY T_DIVIDE T_LEFT T_RIGHT T_SIN T_COS T_TAN
%token T_NEWLINE T_QUIT
%left T_PLUS T_MINUS
%left T_MULTIPLY T_DIVIDE

%type<fval> mixed_expression

%start calculation

%%

calculation: 
       | calculation line
;

line: T_NEWLINE
    | mixed_expression T_NEWLINE { printf("Resultado: %f\n", $1);}
    | T_QUIT T_NEWLINE { printf("Saindo\n"); exit(0); }
;

mixed_expression: T_FLOAT { $$ = $1; }
      | mixed_expression T_PLUS mixed_expression     { $$ = $1 + $3; }
      | mixed_expression T_MINUS mixed_expression    { $$ = $1 - $3; }
      | mixed_expression T_MULTIPLY mixed_expression { $$ = $1 * $3; }
      | mixed_expression T_DIVIDE mixed_expression   {
        if($3 == 0) yyerror("Nao pode dividir por zero 0 (zero)");
        else { $$ = $1 / (float)$3; }
    }
      | T_SIN T_LEFT mixed_expression T_RIGHT   { $$ = sin($3); }
      | T_COS T_LEFT mixed_expression T_RIGHT   { $$ = cos($3); }
      | T_TAN T_LEFT mixed_expression T_RIGHT   { $$ = tan($3); }
      | T_LEFT mixed_expression T_RIGHT         { $$ = $2; }
      | T_RIGHT mixed_expression T_LEFT         { yyerror("Sintaxe invalida"); }
;

%%
int main() {
    yyin = stdin;

    do { 
        yyparse();
    } while(!feof(yyin));

    return 0;
}

void yyerror(const char* s) {
    fprintf(stderr, "Erro: %s\n", s);
}