%{
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>
#include "compiladores.h"

%}

%union {
  double val;
  symrec *tptr;
}

%token <val> NUM
%token <tptr> VAR FNCT
%type <val> exp

%right '='
%left  '-' '+'
%left  '*' '/'
%left  NEG
%right '^'

%%

input : /* vazio */
        | input line
;

line : '\n'
       | exp '\n' { printf ("%.10lf\n", $1); }
       | error '\n' {yyerrok;                }
;

exp : NUM                   { $$ = $1;                          }
      | VAR                 { $$ = $1->value.var;               }
      | VAR '=' exp         { $$ = $3; $1->value.var = $3;      }
      | FNCT '(' exp ')'    { $$ = (*($1->value.fnctptr))($3);  }
      | exp '+' exp         { $$ = $1 + $3;                     }
      | exp '-' exp         { $$ = $1 - $3;                     }
      | exp '*' exp         { $$ = $1 * $3;                     }
      | exp '/' exp         { $$ = $1 / $3;                     }
      | '-' exp %prec NEG   { $$ = -$2;                         }
      | exp '^' exp         { $$ = pow ($1, $3);                }
      | '(' exp ')'         { $$ = $2;                          }
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
	fprintf(stderr, "Parse error: %s\n", s);

}
struct init {
  char * fname;
  double (*fnct)(double);
};

struct init arith_fncts[] = {

"sin" , & sin,
"cos" , & cos,
"atan", & atan,
"ln"  , & log,
"exp" , & exp,
"sqrt", & sqrt,
0     , 0
};

symrec * sym_table = (symrec *) 0;

symrec * putsym (char * sym_name, int sym_type) {
  symrec * ptr;
  ptr = (symrec *) malloc (sizeof (symrec));
  ptr->name = (char *) malloc (strlen (sym_name) + 1);
  strcpy (ptr->name, sym_name);
  ptr->type = sym_type;
  ptr->value.var = 0;
  ptr->next = (struct symrec *) sym_table;
  sym_table = ptr;
  return ptr;
}

symrec * getsym (char * sym_name) {
  symrec * ptr;
  for (ptr=sym_table; ptr != (symrec *) 0; ptr = (symrec *) ptr->next)
    if (strcmp (ptr->name, sym_name) ==0)
      return ptr;
  return (symrec *) 0;

}

void init_table (void){
  int i;
  symrec * ptr;
  for (i=0; arith_fncts[i].fname !=0; i++) {
    ptr = putsym (arith_fncts[i].fname, FNCT);
    ptr->value.fnctptr = arith_fncts[i].fnct;
  }



}
