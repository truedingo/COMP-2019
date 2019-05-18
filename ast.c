#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "ast.h"

node *create_node(char *name, char *value){
    node *n = (node *) malloc(sizeof(node));

    n->name = (char *)strdup(name);

    if(value != NULL){
        n->value = (char *)strdup(value);
    }
    else{
        n->value = NULL;
    }

    n->brother = NULL;
    n->child = NULL;

    return n;
}

void add_child(node *dad, node * child){
    if(dad == NULL || child == NULL){
        return;
    }
    else{
        dad->child = child;
    }
}

void add_brother(node *aux_brother, node *new_brother){
    node *aux = aux_brother;
    if(aux_brother == NULL || new_brother == NULL){
        return;
    } 
    while (aux->brother != NULL)
    {
        aux = aux->brother;
    }
    aux->brother = new_brother;
}

void check_brothers(node *aux, char *val){
     
    while (aux->brother != NULL)
    {
        aux = aux->brother;
        node *new_child = create_node(val, NULL);
        node *child = aux->child;
        aux->child = new_child;
        add_brother(new_child, child);
    }
}

int count_brothers(node *start_node)
{
    int n = 0;
    node *aux;
    aux = start_node;
    while (aux != NULL)
    {
        aux = aux->brother;
        n++;
    }
    return n;
}


//CUIDADO QUE PARA OS ERROS SÓ SE PODE ANOTAR AS VARIAVEIS HA MEDIDA QUE SE LE A ARVORE
void create_function(func_list func_node){

    func_node = (func_list)malloc(sizeof(func));
    func_node->table = malloc(sizeof(symb_table));
    func_node->func_vars = (vars_list)malloc(sizeof(vars));
    func_node->func_param = (param_list)malloc(sizeof(params));
    func_node->next = NULL;
}


void insert_table(func_list func_node, char *name, char *type, int is_func){

    func_node->table->table_name = name;
    func_node->table->table_type = type;
    func_node->table->func_check = is_func;

}

void insert_param(func_list func_node, char *name, char *type){

    func_node->func_param->param_name = name;
    func_node->func_param->param_type = type;
    func_node->func_param->next = NULL;

}

void insert_var(func_list func_node, char *name, char *type, char *value){

    func_node->func_vars->var_name = name;
    func_node->func_vars->var_type = type;
    func_node->func_vars->var_value = value;
    func_node->func_vars->next = NULL;
}



void printAST(node *current, int n){
    int i;

    if(current == NULL){
        return;
    }

    if(strcmp(current->name, "Program") == 0){
        //inicio de program, fazer table global
        create_function(func_node);
        insert_table(func_node, "global", NULL, 0);
        func_header = func_node;        
    }

    if(strcmp(current->name, "NULL") == 0){
        printAST(current->brother, n);
        return;
    }

    if(strcmp(current->name, "NULL") != 0){
        for(i=0;i<n;i++){
            printf("..");
        }
        
        if(current->value != NULL){
            printf("%s(%s)\n",current->name, current->value);
        }
        else{
            printf("%s\n",current->name);
        }
    }
    printAST(current->child, n+1);
    printAST(current->brother, n);
}



//void insert_function();
//void insert_var();



