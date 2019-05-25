%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "ast.h"
    int yylex(void);
    void yyerror (const char *s);
    node* auxNode;
    node* auxNode2;
    node* auxNode3;
    node* start_node;
    int prod_error=0;
%}

%union{
    struct token* value;
    struct node* node;
}

%token <value> REALLIT RESERVED ID INTLIT STRLIT SEMICOLON BLANKID PACKAGE RETURN AND ASSIGN STAR COMMA DIV EQ GE GT LBRACE LE LPAR LSQ LT MINUS MOD NE NOT OR PLUS RBRACE RPAR RSQ ELSE FOR IF VAR INT FLOAT32 BOOL STRING PRINT PARSEINT FUNC CMDARGS

%type <node> Program Declarations VarDeclaration FuncDeclaration VarSpec CommaAux Type Parameters ParamAux FuncBody VarsAndStatements Statement Expr StatementAux FuncInvocation ParseArgs ExprAux


%left   COMMA
%right  ASSIGN
%left   OR
%left   AND  
%left   LT GT LE GE  EQ NE
%left   PLUS MINUS
%left   STAR DIV MOD
%right NOT

%nonassoc   ELSE IF

%%
Program: 
    PACKAGE ID SEMICOLON Declarations           {start_node = create_node("Program", NULL,0,0); add_child(start_node,$4);}
    ;

Declarations:  /* empty */                      {$$=NULL;}
    |   VarDeclaration SEMICOLON Declarations   {$$=$1; add_brother($$, $3);}
    |   FuncDeclaration SEMICOLON Declarations  {$$=$1; add_brother($$, $3);}
    ;

VarDeclaration:
    VAR VarSpec                                 {$$=$2;}
    |   VAR LPAR VarSpec SEMICOLON RPAR         {$$=$3;}
    ;

VarSpec:
    ID CommaAux Type                            {$$=create_node("VarDecl", NULL, $1->line, $1->column); add_brother($$, $2); add_child($$, $3); add_brother($3, create_node("Id", $1->value, $1->line, $1->column)); check_brothers($$, $3->name);} 
    ;

CommaAux: /* empty */                           {$$=NULL;}
    |  COMMA ID CommaAux                       {$$=create_node("VarDecl", NULL, $1->line, $2->column); add_brother($$, $3); add_child($$, create_node("Id", $2->value, $2->line, $2->column));}   
    ;

Type:
    INT                                         {$$=create_node("Int", NULL,0,0);}
    |   FLOAT32                                 {$$=create_node("Float32", NULL,0,0);}
    |   BOOL                                    {$$=create_node("Bool", NULL,0,0);}
    |   STRING                                  {$$=create_node("String", NULL,0,0);}
    ;

FuncDeclaration:
    FUNC ID LPAR RPAR FuncBody                      {$$=create_node("FuncDecl", NULL,0,0); auxNode = create_node("FuncHeader", NULL,0,0); add_child($$, auxNode); add_brother(auxNode, $5); auxNode2 = create_node("Id", $2->value, $2->line, $2->column); add_child(auxNode, auxNode2); add_brother(auxNode2, create_node("FuncParams", NULL,0,0));}
    |   FUNC ID LPAR Parameters RPAR FuncBody       {$$=create_node("FuncDecl", NULL,0,0); auxNode = create_node("FuncHeader", NULL,0,0); add_child($$, auxNode); add_brother(auxNode, $6); auxNode2 = create_node("Id", $2->value, $2->line, $2->column); add_child(auxNode, auxNode2); add_brother(auxNode2, $4);}
    |   FUNC ID LPAR RPAR Type FuncBody             {$$=create_node("FuncDecl", NULL,0,0); auxNode = create_node("FuncHeader", NULL,0,0); add_child($$, auxNode); add_brother(auxNode, $6); auxNode2 = create_node("Id", $2->value, $2->line, $2->column); add_child(auxNode, auxNode2); add_brother(auxNode2, $5); auxNode3 = create_node("FuncParams", NULL,0,0); add_brother($5,auxNode3);}
    |   FUNC ID LPAR Parameters RPAR Type FuncBody  {$$=create_node("FuncDecl", NULL,0,0); auxNode = create_node("FuncHeader", NULL,0,0); add_child($$, auxNode); add_brother(auxNode, $7); auxNode2 = create_node("Id", $2->value, $2->line, $2->column); add_child(auxNode, auxNode2); add_brother(auxNode2, $6); add_brother($6, $4);}
    ;

Parameters:
    ID Type ParamAux                                {$$=create_node("FuncParams", NULL,0,0); auxNode = create_node("ParamDecl", NULL,0,0); add_child($$, auxNode); add_child(auxNode, $2); add_brother($2, create_node("Id", $1->value, $1->line, $1->column)); add_brother(auxNode, $3);}
    ;

ParamAux: /* empty */                               {$$=NULL;} 
    |   COMMA ID Type ParamAux                      {$$=create_node("ParamDecl", NULL,0,0); add_child($$, $3); auxNode = create_node("Id", $2->value, $2->line, $2->column); add_brother($3, auxNode); add_brother($$, $4);}
    ;

FuncBody:
    LBRACE VarsAndStatements RBRACE                 {$$=create_node("FuncBody", NULL,0,0); add_child($$, $2);}
    ;

VarsAndStatements: /* empty */                      {$$=NULL;}
    |   VarsAndStatements SEMICOLON                 {$$=$1;}
    |   VarsAndStatements VarDeclaration SEMICOLON  {if($1 == NULL){$$ = $2;}else{ $$ = $1; add_brother($$, $2);}} 
    |   VarsAndStatements Statement SEMICOLON       {if($1 == NULL){$$ = $2;}else{ $$ = $1; add_brother($$, $2);}} 
    ;

Statement:
    ID ASSIGN Expr                                                              {$$=create_node("Assign", NULL,$2->line, $2->column); auxNode = create_node("Id", $1->value, $1->line, $1->column); add_child($$, auxNode); add_brother(auxNode, $3);} 
    |   LBRACE StatementAux RBRACE                                              {if(count_brothers($2)>1){$$ = create_node("Block", NULL,0,0);add_child($$, $2);} else{$$ = $2;}} 
    |   IF Expr LBRACE StatementAux RBRACE                                      {$$=create_node("If", NULL,$1->line, $1->column); add_child($$, $2); auxNode = create_node("Block", NULL,0,0); add_brother($2, auxNode); add_child(auxNode, $4); auxNode2 = create_node("Block", NULL,0,0); add_brother(auxNode, auxNode2);} 
    |   IF Expr LBRACE StatementAux RBRACE ELSE LBRACE StatementAux RBRACE      {$$=create_node("If", NULL, $1->line, $1->column); add_child($$, $2); auxNode = create_node("Block", NULL,0,0); add_brother($2, auxNode); add_child(auxNode, $4); auxNode2 = create_node("Block", NULL,0,0); add_brother(auxNode, auxNode2); add_child(auxNode2, $8);} 
    |   FOR LBRACE StatementAux RBRACE                                          {$$=create_node("For", NULL,$1->line, $1->column); auxNode = create_node("Block", NULL,0,0); add_child($$, auxNode); add_child(auxNode, $3);} 
    |   FOR Expr LBRACE StatementAux RBRACE                                     {$$=create_node("For", NULL,$1->line, $1->column); add_child($$, $2); auxNode = create_node("Block", NULL,0,0); add_brother($2, auxNode); add_child(auxNode, $4);} 
    |   RETURN                                                                  {$$=create_node("Return", NULL,$1->line, $1->column);} 
    |   RETURN Expr                                                             {$$=create_node("Return", NULL,$1->line, $1->column); add_child($$, $2);} 
    |   FuncInvocation                                                          {$$=$1;} 
    |   ParseArgs                                                               {$$=$1;} 
    |   PRINT LPAR Expr RPAR                                                    {$$=create_node("Print", NULL,$1->line, $1->column); add_child($$, $3);} 
    |   PRINT LPAR STRLIT RPAR                                                  {$$=create_node("Print", NULL,$1->line, $1->column); auxNode = create_node("StrLit", $3->value, $3->line, $3->column); add_child($$, auxNode);} 
    |   error                                                                   {prod_error=1; $$=create_node("Error", NULL,0,0);} 
    ;

StatementAux: /* empty */                                                       {$$=NULL;} 
    |   Statement SEMICOLON StatementAux                                        {$$=$1; add_brother($$, $3);} 
    ;

ParseArgs:
    ID COMMA BLANKID ASSIGN PARSEINT LPAR CMDARGS LSQ Expr RSQ RPAR             {$$=create_node("ParseArgs", NULL,$5->line, $5->column); auxNode = create_node("Id", $1->value, $1->line, $1->column); add_child($$, auxNode); add_brother(auxNode, $9);} 
    | ID COMMA BLANKID ASSIGN PARSEINT LPAR error RPAR                          {$$=create_node("ParseArgs", NULL,$5->line, $5->column); auxNode = create_node("Id",$1->value, $1->line, $1->column); auxNode2 = create_node("Error", NULL,0,0); add_brother(auxNode, auxNode2); prod_error=1;} 
    ;

FuncInvocation:
    ID LPAR RPAR                                                                {$$=create_node("Call", NULL,0,0);auxNode=create_node("Id",$1->value, $1->line, $1->column); add_child($$,auxNode);} 
    |   ID LPAR Expr ExprAux RPAR                                               {$$=create_node("Call", NULL,0,0); auxNode=create_node("Id",$1->value, $1->line, $1->column); add_child($$,auxNode); add_brother(auxNode,$3); add_brother($3, $4); } 
    |   ID LPAR error RPAR                                                      {$$=create_node("Call", NULL,0,0); auxNode=create_node("Id", $1->value, $1->line, $1->column); add_child($$, auxNode); auxNode2 = create_node("Error", NULL,0,0); add_brother(auxNode, auxNode2); prod_error=1;} 
    ;

ExprAux: /* empty */                                                            {$$=NULL;}
    | COMMA Expr ExprAux                                                        {$$ = $2; add_brother($2,$3);} 
    ;

Expr:
    Expr OR Expr                    {$$ = create_node("Or", NULL,$2->line, $2->column); add_child($$,$1); add_brother($1,$3);}
    |   Expr AND Expr               {$$ = create_node("And", NULL,$2->line, $2->column); add_child($$,$1); add_brother($1,$3);}
    |   Expr LT Expr                {$$ = create_node("Lt", NULL,$2->line, $2->column); add_child($$,$1); add_brother($1,$3);}
    |   Expr GT Expr                {$$ = create_node("Gt", NULL,$2->line, $2->column); add_child($$,$1); add_brother($1,$3);}
    |   Expr EQ Expr                {$$ = create_node("Eq", NULL,$2->line, $2->column); add_child($$,$1); add_brother($1,$3);}
    |   Expr NE Expr                {$$ = create_node("Ne", NULL,$2->line, $2->column); add_child($$,$1); add_brother($1,$3);}
    |   Expr LE Expr                {$$ = create_node("Le", NULL,$2->line, $2->column); add_child($$,$1); add_brother($1,$3);}
    |   Expr GE Expr                {$$ = create_node("Ge", NULL,$2->line, $2->column); add_child($$,$1); add_brother($1,$3);}
    |   Expr PLUS Expr              {$$ = create_node("Add", NULL,$2->line, $2->column); add_child($$,$1); add_brother($1,$3);}
    |   Expr MINUS Expr             {$$ = create_node("Sub", NULL,$2->line, $2->column); add_child($$,$1); add_brother($1,$3);}
    |   Expr STAR Expr              {$$ = create_node("Mul", NULL,$2->line, $2->column); add_child($$,$1); add_brother($1,$3);}
    |   Expr DIV Expr               {$$ = create_node("Div", NULL,$2->line, $2->column); add_child($$,$1); add_brother($1,$3);}
    |   Expr MOD Expr               {$$ = create_node("Mod", NULL,$2->line, $2->column); add_child($$,$1); add_brother($1,$3);}
    |   NOT Expr                    {$$ = create_node("Not", NULL,$2->line, $2->column); add_child($$,$2);}
    |   MINUS Expr %prec NOT        {$$ = create_node("Minus", NULL,$2->line, $2->column); add_child($$,$2);}
    |   PLUS Expr  %prec NOT        {$$ = create_node("Plus", NULL,$2->line, $2->column); add_child($$,$2);}
    |   INTLIT                      {$$ = create_node("IntLit",$1->value, $1->line, $1->column);}                  
    |   REALLIT                     {$$ = create_node("RealLit", $1->value, $1->line, $1->column);}  
    |   ID                          {$$ = create_node("Id", $1->value, $1->line, $1->column);}  
    |   FuncInvocation              {$$=$1;} 
    |   LPAR Expr RPAR              {$$=$2;} 
    |   LPAR error RPAR             {$$=create_node("Error", NULL,0,0); prod_error=1;} 
    ; 
%% 

