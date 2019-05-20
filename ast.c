#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "ast.h"

node *create_node(char *name, char *value)
{
    node *n = (node *)malloc(sizeof(node));

    n->name = (char *)strdup(name);

    if (value != NULL)
    {
        n->value = (char *)strdup(value);
    }
    else
    {
        n->value = NULL;
    }

    n->brother = NULL;
    n->child = NULL;

    return n;
}

void add_child(node *dad, node *child)
{
    if (dad == NULL || child == NULL)
    {
        return;
    }
    else
    {
        dad->child = child;
    }
}

void add_brother(node *aux_brother, node *new_brother)
{
    node *aux = aux_brother;
    if (aux_brother == NULL || new_brother == NULL)
    {
        return;
    }
    while (aux->brother != NULL)
    {
        aux = aux->brother;
    }
    aux->brother = new_brother;
}

void check_brothers(node *aux, char *val)
{

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

void printAST(node *current, int n)
{
    int i;

    if (current == NULL)
    {
        return;
    }

    if (strcmp(current->name, "NULL") == 0)
    {
        printAST(current->brother, n);
        return;
    }

    if (strcmp(current->name, "NULL") != 0)
    {
        for (i = 0; i < n; i++)
        {
            printf("..");
        }

        if (current->value != NULL)
        {
            printf("%s(%s)\n", current->name, current->value);
        }
        else
        {
            printf("%s\n", current->name);
        }
    }
    printAST(current->child, n + 1);
    printAST(current->brother, n);
}

// -----------------------------------------------

func_list insert_table(char *table_name, char *table_type, int func_check)
{

    func_list new_node = (func_list)malloc(sizeof(func));
    new_node->table = malloc(sizeof(symb_table));
    new_node->table->table_name = strdup(table_name);
    new_node->table->func_check = func_check;
    if(table_type != NULL){
        new_node->table->table_type = strdup(table_type);
    }
    else{
        new_node->table->table_type = NULL;
    }
    new_node->next = NULL;

    if(func_header == NULL){
        func_header = new_node;
        return func_header;
    }

    func_list aux = func_header;
    while (aux->next != NULL)
    {
        aux = aux->next;
    }
    aux->next = new_node;
    return new_node;
}

void insert_var(func_list func, char *name, char *type)
{
    vars_list new_node = (vars_list)malloc(sizeof(vars));
    new_node->var_name = strdup(name);
    new_node->var_type = strdup(type);
    new_node->next = NULL;

    if(func->func_vars == NULL){
        func->func_vars = new_node;
        return;
    }
    
    vars_list aux = func->func_vars;
    while (aux->next != NULL)
    {
        aux = aux->next;
    }
    aux->next = new_node;
}

void insert_param(func_list func, char *name, char *type)
{
    param_list new_node = (param_list)malloc(sizeof(params));
    new_node->param_name = strdup(name);
    new_node->param_type = strdup(type);
    new_node->next = NULL;

    if(func->func_param == NULL){
        func->func_param = new_node;
        return;
    }

    param_list aux = func->func_param;
    while (aux->next != NULL)
    {
        aux = aux->next;
    }
    aux->next = new_node;
}

void print_tables()
{
    // Print Global table
    printf("===== Global Symbol Table =====\n");
    vars_list aux_vars = func_header->func_vars;
    while(aux_vars != NULL){
        printf("%s\t\t%s\n", aux_vars->var_name, aux_vars->var_type);
        aux_vars = aux_vars->next;
    }
    func_list aux = func_header->next;
    while(aux != NULL){
        printf("%s\t(", aux->table->table_name);
        param_list aux_params = aux->func_param;
        while(aux_params != NULL){
            printf("%s",aux_params->param_type);
            aux_params = aux_params->next;
            if(aux_params != NULL){
                printf(",");
            }
        }

        if(aux->table->table_type != NULL){
            printf(")\t%s\n", aux->table->table_type);
        }
        else{
            printf(")\tnone\n");
        }

        aux = aux->next;
    }
    printf("\n");

    //Print Local tables
    aux = func_header->next;
    while(aux != NULL){
        printf("===== Function %s(", aux->table->table_name);
        param_list aux_params = aux->func_param;
        while(aux_params != NULL){
            printf("%s",aux_params->param_type);
            aux_params = aux_params->next;
            if(aux_params != NULL){
                printf(",");
            }
        }
        printf(") Symbol Table =====\n");

        if(aux->table->table_type != NULL){
            printf("return\t\t%s\n", aux->table->table_type);
        }
        else{
            printf("return\t\tnone\n");
        }

        aux_params = aux->func_param;
        while(aux_params != NULL){
            printf("%s\t\t%s\tparam\n", aux_params->param_name, aux_params->param_type);
            aux_params = aux_params->next;
        }

        vars_list aux_vars = aux->func_vars;
        while(aux_vars != NULL){
            printf("%s\t\t%s\n", aux_vars->var_name, aux_vars->var_type);
            aux_vars = aux_vars->next;
        }

        printf("\n");
        aux = aux->next;
    }
}

char *change_type(char *type){
    if(strcmp(type, "Int") == 0){
        return "int";
    }
    else if(strcmp(type, "Float32") == 0){
        return "float32";
    }
    else if(strcmp(type, "Bool") == 0){
        return "bool";
    }
    else if(strcmp(type, "String") == 0){
        return "string";
    }
    else if(strcmp(type, "IntLit") == 0){
        return "intLit";
    }
    else if(strcmp(type, "RealLit") == 0){
        return "realLit";
    }
    else{
        return "strLit";
    }
}

void semantic_analysis(node *root){

    node *atual = root->child;
    node *aux1, *aux2, *aux3, *aux4, *aux5;
    char *name, *type;

    func_list global_table = insert_table("Global", NULL, 0);;
    func_list atual_table = global_table;

    while(atual != NULL){

        if(strcmp(atual->name, "FuncDecl") == 0){
            aux1 = atual->child;

            // FuncHeader
            aux2 = aux1->child; // function ID
            aux3 = aux2->brother; // function type or params
            if(strcmp(aux3->name, "FuncParams") == 0){ // function is void
                atual_table = insert_table(aux2->value, NULL, 1);
                aux4 = aux3; // params
            }
            else{
                atual_table = insert_table(aux2->value, change_type(aux3->name), 1);
                aux4 = aux3->brother; // params
            }

            aux5 = aux4->child;
            while(aux5 != NULL){
                type = change_type(aux5->child->name);
                name = aux5->child->brother->value;
                insert_param(atual_table, name, type);
                aux5 = aux5->brother;
            }

            // FuncBody
            aux1 = aux1->brother->child;
            while(aux1 != NULL){
                if(strcmp(aux1->name, "VarDecl") == 0){
                    type = change_type(aux1->child->name);
                    name = aux1->child->brother->value;
                    insert_var(atual_table, name, type);
                }
                aux1 = aux1->brother;
            }
        }
        else if(strcmp(atual->name, "VarDecl") == 0){
            type = change_type(atual->child->name);
            name = atual->child->brother->value;
            insert_var(atual_table, name, type);
        }

        atual = atual->brother;
    }

}