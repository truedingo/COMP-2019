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

    func_node->table = malloc(sizeof(symb_table));
    func_node->table->table_name = strdup(name);
    
    printf("%s\n", name);
    printf("%s\n", func_node->table->table_name);
    //func_node->table->table_type = type;
    //func_node->table->func_check = is_func;

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
        func_node = (func_list)malloc(sizeof(func));
        func_node->table = malloc(sizeof(symb_table));
        func_node->func_vars = NULL;
        func_node->func_param = NULL;
        func_node->table->table_name = "global";
        func_node->table->func_check = 0;
        func_node->table->table_type = NULL;
        func_node->func_param = NULL;
        func_node->func_vars = NULL;
        func_node->next = NULL;
        func_header = func_node;

    }

    if(strcmp(current->name, "FuncHeader") == 0){

        node *aux = current->child; 

        if(strcmp(aux->name, "Id") == 0){
            func_list new_node = (func_list)malloc(sizeof(func));
            new_node->func_param = NULL;
            new_node->func_vars = NULL;
            new_node->table = malloc(sizeof(symb_table));
            new_node->table->table_name = strdup(aux->value);
            new_node->table->func_check = 1;
            if(aux->brother != NULL){
                if(strcmp(aux->brother->name, "Int") == 0){
                    new_node->table->table_type = strdup(aux->brother->name);
                }
                else{
                    new_node->table->table_type = strdup("none");
                }
            }
            else{
                new_node->table->table_type = strdup("none");
            }
            func_node->next = new_node;
            new_node->next = NULL;
        }

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

void print_tables(func_list func_header){

    func_list aux = func_header;
    if(aux != NULL){
        printf("===== Global Symbol Table =====\n");
        while(aux->next != NULL){
            printf("%s\t (%s)", aux->table->table_name, aux->table->table_type);
            aux = aux->next;
        }
        aux = func_header;
        while(aux->next != NULL){
            if(strcmp(aux->table->table_type, "none") == 0){
                printf("===== Function %s () Symbol Table =====\n", aux->table->table_name);
            }
            else{
                printf("===== Function %s (%s) Symbol Table =====\n", aux->table->table_name, aux->table->table_type);
            }
        }
    }
}



//void insert_function();
//void insert_var();



