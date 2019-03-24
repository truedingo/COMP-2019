%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    int yylex(void);
    void yyerror (const char *s);
%}


%token SEMICOLON BLANKID PACKAGE RETURN AND ASSIGN STAR COMMA DIV EQ GE GT LBRACE LE LPAR LSQ LT MINUS MOD NE NOT OR PLUS RBRACE RPAR RSQ ELSE FOR IF VAR INT FLOAT32 BOOL STRING PRINT PARSEINT FUNC CMDARGS
%token REALLIT RESERVED ID INTLIT STRLIT

%left   COMMA
%right  ASSIGN
%left   OR
%left   AND
%left   EQ NE
%left   LT GT LE GE
%left   PLUS MINUS
%left   STAR DIV MOD
%right NOT
%left RPAR LPAR

%nonassoc   ELSE
//%token Program Declarations VarDeclaration VarSpec Type FuncDeclaration Parameters FuncBody VarsAndStatements Statement ParseArgs FuncInvocation Expr  

%%
Program: 
    PACKAGE ID SEMICOLON Declarations
    ;

Declarations:  /* empty */
    |   VarDeclaration SEMICOLON Declarations
    |   FuncDeclaration SEMICOLON Declarations
    ;

VarDeclaration:
    VAR VarSpec
    |   VAR LPAR VarSpec SEMICOLON RPAR
    ;

VarSpec:
    ID CommaAux Type
    ;

CommaAux: /* empty */ 
     |  COMMA ID CommaAux   
    ;

Type:
    INT
    |   FLOAT32
    |   BOOL
    |   STRING
    ;

FuncDeclaration:
    FUNC ID LPAR RPAR FuncBody
    |   FUNC ID LPAR Parameters RPAR FuncBody
    |   FUNC ID LPAR RPAR Type FuncBody
    |   FUNC ID LPAR Parameters RPAR Type FuncBody
    ;

Parameters:
    ID Type ParamAux
    ;

ParamAux: /* empty */ 
    |   COMMA ID Type ParamAux
    ;

FuncBody:
    LBRACE VarsAndStatements RBRACE
    ;

VarsAndStatements: /* empty */ 
    |   VarsAndStatements   SEMICOLON
    |   VarsAndStatements VarDeclaration SEMICOLON
    |   VarsAndStatements Statement SEMICOLON
    ;

Statement:
    ID ASSIGN Expr
    |   LBRACE StatementAux RBRACE
    |   IF Expr LBRACE StatementAux RBRACE
    |   IF Expr LBRACE StatementAux ELSE LBRACE StatementAux RBRACE
    |   FOR LBRACE StatementAux RBRACE
    |   FOR Expr LBRACE StatementAux RBRACE
    |   RETURN
    |   RETURN Expr
    |   FuncInvocation
    |   ParseArgs
    |   PRINT LPAR Expr RPAR
    |   PRINT LPAR STRLIT RPAR
    |   error
    ;

StatementAux: /* empty */ 
    |   Statement SEMICOLON StatementAux
    ;

ParseArgs:
    ID COMMA BLANKID ASSIGN PARSEINT LPAR CMDARGS LSQ Expr RSQ RPAR
    | ID COMMA BLANKID ASSIGN PARSEINT LPAR error RPAR
    ;

FuncInvocation:
    ID LPAR RPAR
    |   ID LPAR Expr ExprAux RPAR
    |   ID LPAR error RPAR
    ;

ExprAux: /* empty */ 
    | COMMA Expr ExprAux
    ;

Expr:
    Expr OR Expr
    |   Expr AND Expr
    |   Expr LT Expr
    |   Expr GT Expr
    |   Expr EQ Expr
    |   Expr NE Expr
    |   Expr LE Expr
    |   Expr GE Expr
    |   Expr PLUS Expr
    |   Expr MINUS Expr
    |   Expr STAR Expr
    |   Expr DIV Expr
    |   Expr MOD Expr
    |   NOT Expr
    |   MINUS Expr
    |   PLUS Expr
    |   INTLIT
    |   REALLIT
    |   ID
    |   FuncInvocation
    |   LPAR Expr RPAR
    |   LPAR error RPAR
    ;
%%

