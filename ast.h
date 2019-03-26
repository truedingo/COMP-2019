#include <stdlib.h>
#include <stdio.h>
#include <string.h>

typedef struct node{
    struct node* brother;
    struct node* child;
    char *name; //label of the node
    char *value; //value of the node, if it has any
    int n_childs; // number of childs of the node
} node;

node *create_node(char *name, char *value);
void add_child(node *dad, node * child);
void add_brother(node *aux_brother, node *new_brother);
int count_brothers(node *root);
void printAST(node *current, int n);



