%option noyywrap
%{
# include "compiladores.h"
# include "y.tab.h"
%}



%%

[0-9]*\.?[0-9]+ {
  sscanf (yytext, "%lf", &yylval.val);
  return NUM;

}

[a-zA-Z][a-zA-Z_0-9]* {
  symrec *s;
  s = getsym (yytext);
  if (s == 0){
    s = putsym (yytext, VAR);
  }
  yylval.tptr = s;
  return s->type;

}

[ \t]* {
  ;
}

.|\n {
  return *yytext;

}
%%
