%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "ast.h"
    int yylex(void);
    void yyerror (const char *s);
    node* auxNode;
%}


%union{
    char *string;
    struct node* node;
}


%token SEMICOLON BLANKID PACKAGE RETURN AND ASSIGN STAR COMMA DIV EQ GE GT LBRACE LE LPAR LSQ LT MINUS MOD NE NOT OR PLUS RBRACE RPAR RSQ ELSE FOR IF VAR INT FLOAT32 BOOL STRING PRINT PARSEINT FUNC CMDARGS
%token <string> REALLIT RESERVED ID INTLIT STRLIT

%left   COMMA
%right  ASSIGN
%left   OR
%left   AND
%left   EQ NE
%left   LT GT LE GE
%left   PLUS MINUS
%left   STAR DIV MOD
%right NOT
%left RPAR LPAR LSQ RSQ

%nonassoc   ELSE IF
%type <node> Program Declarations VarDeclaration FuncDeclaration VarSpec CommaAux Type Parameters ParamAux FuncBody VarsAndStatements Statement Expr StatementAux FuncInvocation ParseArgs ExprAux

%%
Program: 
    PACKAGE ID SEMICOLON Declarations           {$$=create_node("Program", NULL); add_child($$, $4);}
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
    ID CommaAux Type                            {$$=create_node("VarDecl", $1); add_child($$, $3);add_brother($$, $2);} 
    ;

CommaAux: /* empty */                           {$$=NULL;}
     |  COMMA ID CommaAux                       {$$=create_node("VarDecl", $2); add_brother($$, $3);}   
    ;

Type:
    INT                                         {$$=create_node("INT", NULL);}
    |   FLOAT32                                 {$$=create_node("FLOAT32", NULL);}
    |   BOOL                                    {$$=create_node("BOOL", NULL);}
    |   STRING                                  {$$=create_node("STRING", NULL);}
    ;

FuncDeclaration:
    FUNC ID LPAR RPAR FuncBody                      {$$=create_node("FuncDecl", NULL); auxNode = create_node("FuncHeader", $2); add_child($$, auxNode); add_brother(auxNode, $5);}
    |   FUNC ID LPAR Parameters RPAR FuncBody       {$$=create_node("FuncDecl", NULL); auxNode = create_node("FuncHeader", $2); add_child($$, auxNode); add_brother(auxNode, $6); add_child(auxNode, $4);}
    |   FUNC ID LPAR RPAR Type FuncBody             {$$=create_node("FuncDecl", NULL); auxNode = create_node("FuncHeader", $2); add_child($$, auxNode); add_brother(auxNode, $6); add_child(auxNode, $5);}
    |   FUNC ID LPAR Parameters RPAR Type FuncBody  {$$=create_node("FuncDecl", NULL); auxNode = create_node("FuncHeader", $2); add_child($$, auxNode); add_brother(auxNode, $7); add_child(auxNode, $6); add_child(auxNode, $4);}
    ;

Parameters:
    ID Type ParamAux                                {$$=create_node("FuncParams", $1); add_child($$, $3);}
    ;

ParamAux: /* empty */                               {$$=NULL;} 
    |   COMMA ID Type ParamAux                      {$$=create_node("ParamDecl", $2); add_child($$, $3);}
    ;

FuncBody:
    LBRACE VarsAndStatements RBRACE                 {$$=create_node("FuncBody",NULL); add_child($$, $2);}
    ;

VarsAndStatements: /* empty */                      {;} 
    |   VarsAndStatements   SEMICOLON               {;} 
    |   VarsAndStatements VarDeclaration SEMICOLON  {;} 
    |   VarsAndStatements Statement SEMICOLON       {;} 
    ;

Statement:
    ID ASSIGN Expr                                                              {;} 
    |   LBRACE StatementAux RBRACE                                              {;} 
    |   IF Expr LBRACE StatementAux RBRACE                                      {;} 
    |   IF Expr LBRACE StatementAux RBRACE ELSE LBRACE StatementAux RBRACE      {;} 
    |   FOR LBRACE StatementAux RBRACE                                          {;} 
    |   FOR Expr LBRACE StatementAux RBRACE                                     {;} 
    |   RETURN                                                                  {;} 
    |   RETURN Expr                                                             {;} 
    |   FuncInvocation                                                          {;} 
    |   ParseArgs                                                               {;} 
    |   PRINT LPAR Expr RPAR                                                    {;} 
    |   PRINT LPAR STRLIT RPAR                                                  {;} 
    |   error                                                                   {;} 
    ;

StatementAux: /* empty */                                                       {;} 
    |   Statement SEMICOLON StatementAux                                        {;} 
    ;

ParseArgs:
    ID COMMA BLANKID ASSIGN PARSEINT LPAR CMDARGS LSQ Expr RSQ RPAR             {;} 
    | ID COMMA BLANKID ASSIGN PARSEINT LPAR error RPAR                          {;} 
    ;

FuncInvocation:
    ID LPAR RPAR                                                                {;} 
    |   ID LPAR Expr ExprAux RPAR                                               {;} 
    |   ID LPAR error RPAR                                                      {;} 
    ;

ExprAux: /* empty */                                                            {;} 
    | COMMA Expr ExprAux                                                        {;} 
    ;

Expr:{;} 
    Expr OR Expr                                                                {;} 
    |   Expr AND Expr   {;} 
    |   Expr LT Expr    {;} 
    |   Expr GT Expr    {;} 
    |   Expr EQ Expr    {;} 
    |   Expr NE Expr    {;} 
    |   Expr LE Expr    {;} 
    |   Expr GE Expr    {;} 
    |   Expr PLUS Expr  {;} 
    |   Expr MINUS Expr {;} 
    |   Expr STAR Expr  {;} 
    |   Expr DIV Expr   {;} 
    |   Expr MOD Expr   {;} 
    |   NOT Expr        {;} 
    |   MINUS Expr      {;} 
    |   PLUS Expr       {;} 
    |   INTLIT          {;} 
    |   REALLIT         {;} 
    |   ID              {;} 
    |   FuncInvocation  {;} 
    |   LPAR Expr RPAR  {;} 
    |   LPAR error RPAR {;} 
    ;
%% 

