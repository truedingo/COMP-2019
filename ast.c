#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "ast.h"

node *create_node(char *name, char *value){
    node *n = (node *) malloc(sizeof(node));

    n->name = (char *)strdup(name);

    if(n->value == NULL){
        n->value = NULL;
    }
    else{
        n->value = (char *)strdup(value);
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

void printAST(node *current, int n){
    int i;

    if(current == NULL){
        return;
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


