%{

#include<stdio.h>
int Upper=0;
int Lower=0;
%}

%%
[A-Z] {printf("Uppercase\t");Upper++;}
[a-z] {printf("Lowercase %s\n", yytext);Lower++;}
%%

int yywrap()
{
return 1;
}

main()
{
printf("Enter a string\n");
yylex();

printf("Uppercase=%d and Lowercase=%d",Upper,Lower);
}
