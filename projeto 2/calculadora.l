%option noyywrap

%{
#include <stdio.h>

#define YY_DECL int yylex()

#include "calculadora.tab.h"

%}

%%

[ \t]	;
[0-9]+(\.[0-9]+)?	{yylval.fval = atof(yytext); return T_FLOAT;}
\n		{return T_NEWLINE;}
"+"		{return T_PLUS;}
"-"		{return T_MINUS;}
"*"		{return T_MULTIPLY;}
"/"		{return T_DIVIDE;}
"("		{return T_LEFT;}
")"		{return T_RIGHT;}
"sin"|"SIN"	{return T_SIN;}
"cos"|"COS"	{return T_COS;}
"tan"|"TAN"	{return T_TAN;}
"exit"		{return T_QUIT;}

%%