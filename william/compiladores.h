struct symrec {
  char * name;
  int type;
  union {
    double var;
    double (*fnctptr)(double);
  } value;
  struct symrec * next;
};

typedef struct symrec symrec;

extern symrec * sym_table;

symrec * putsym (char * sym_name, int sym_type);
symrec * getsym (char * sym_name);
