#include <stdlib.h>
#include <stdio.h>
#include <string.h>

typedef struct node{
    struct node* brother;
    struct node* child;
    char *name; //label of the node
    char *value; //value of the node, if it has any
} node;

typedef struct symb_table{
    char *table_name; //nome da table
    char *table_type; //tipo da tabela
    int func_check; //func ou global
}symb_table;

typedef struct params *param_list;
typedef struct params{
    char *param_name; //nome do param
    char *param_type; //tipo do param
    param_list next; //next da lista de parametros
}params;

typedef struct vars *vars_list;
typedef struct vars{
    char *var_name;     //nome da var
    char *var_type;     //tipo da variavel
    vars_list next;
}vars;

typedef struct func *func_list;
typedef struct func{
    symb_table *table; //de que tabela é a funcao
    vars_list func_vars; //possiveis variaveis
    param_list func_param; //parametros da funcao
    func_list next;
}func;

node *create_node(char *name, char *value);
void add_child(node *dad, node * child);
void add_brother(node *aux_brother, node *new_brother);
void printAST(node *current, int n);
void check_brothers(node *aux, char *val);
int count_brothers(node *start_node);

//-------------- 

func_list func_header;

func_list insert_table(char *table_name, char *table_type, int func_check);
void insert_var(func_list v_list, char *name, char *type);
void insert_param(func_list p_list, char *name, char *type);
void print_tables();
char *change_type(char *type);
void semantic_analysis(node *root);
