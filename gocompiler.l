/* Diogo Amores 2015231975 damores@student.uc.pt */
/* Maria Roseiro 2015233281 miroseiro@student.uc.pt */
%{
    int yylex();
    int yyparse();
    int val = 0;
    #include <stdio.h>
    #include <string.h>
    #define LINHA linha++; coluna=1;
    #define COLUNA coluna+=yyleng;
    int flag=0;
    int linha =1;
    int coluna=1;
    int c_atual=1;
    int l_atual=1;

%}

%x COMMENTS
SEMICOLON ";"
BLANKID "_"
PACKAGE "package"
RETURN "return"
AND "&&"
ASSIGN "="
STAR "*"
COMMA ","
DIV "/"
EQ "=="
GE ">="
GT ">"
LBRACE "{"
LE "<="
LPAR "("
LSQ "["
LT "<"
MINUS "-"
MOD "%"
NE "!="
NOT "!"
OR "||"
PLUS "+"
RBRACE "}"
RPAR ")"
RSQ "]"
ELSE "else"
FOR "for"
IF "if"
VAR "var"
INT "int"
FLOAT32 "float32"
BOOL "bool"
STRING "string"
PRINT "fmt.Println"
PARSEINT "strconv.Atoi"
FUNC "func"
CMDARGS "os.Args"
START_COMMENT "/*"
END_COMMENT "*/"
SINGLE_COMMENT "//"
CHARACTER [a-zA-Z]
ESCAPE \n|\t|\\|\'|\"
REALLIT [0-9]+[.]([0-9]+)?(([e]|[E])([+]|[-])?[0-9]+)?|[0-9]+([e]|[E])([+]|[-])?[0-9]+|[.][0-9]+(([e]|[E])([+]|[-])?[0-9]+)?
ID ([a-zA-Z]|[_])([a-zA-Z]|[_]|[0-9])*
TEXT_COMMENT [^\r\n]*
RETURNCHAR \r
LINETERMINATOR \n|{RETURNCHAR}|({RETURNCHAR})\n

%%

{SINGLE_COMMENT}{TEXT_COMMENT} {COLUNA;}
{START_COMMENT} {BEGIN COMMENTS; c_atual=coluna; l_atual=linha;COLUNA;}
<COMMENTS>("\n") {LINHA;}
<COMMENTS>(.) {COLUNA;}
<COMMENTS><<EOF>> {BEGIN 0; printf("Line %d, col %d: unterminated comment\n", l_atual, c_atual);COLUNA;}
<COMMENTS>{END_COMMENT} {BEGIN 0;COLUNA;}
{SEMICOLON} {if(flag==-1 && val == 1){printf("SEMICOLON\n");}}
{BLANKID} {if(flag==-1 && val == 1){printf("BLANKID\n");}}
{PACKAGE} {if(flag==-1 && val == 1){printf("PACKAGE\n");}}
{RETURN} {if(flag==-1 && val == 1){printf("RETURN\n");}}
{AND} {if(flag==-1 && val == 1){printf("AND\n");}}
{ASSIGN} {if(flag==-1 && val == 1){printf("ASSIGN\n");}}
{STAR} {if(flag==-1 && val == 1){printf("STAR\n");}}
{COMMA} {if(flag==-1 && val == 1){printf("COMMA\n");}}
{DIV} {if(flag==-1 && val == 1){printf("DIV\n");}}
{EQ} {if(flag==-1 && val == 1){printf("EQ\n");}}
{GE} {if(flag==-1 && val == 1){printf("GE\n");}}
{GT} {if(flag==-1 && val == 1){printf("GT\n");}}
{LBRACE} {if(flag==-1 && val == 1){printf("LBRACE\n");}}
{LE} {if(flag==-1 && val == 1){printf("LE\n");}}
{LPAR} {if(flag==-1 && val == 1){printf("LPAR\n");}}
{LSQ} {if(flag==-1 && val == 1){printf("LSQ\n");}}
{LT} {if(flag==-1 && val == 1){printf("LT\n");}}
{MINUS} {if(flag==-1 && val == 1){printf("MINUS\n");}}
{MOD} {if(flag==-1 && val == 1){printf("MOD\n");}}
{NE} {if(flag==-1 && val == 1){printf("NE\n");}}
{NOT} {if(flag==-1 && val == 1){printf("NOT\n");}}
{OR} {if(flag==-1 && val == 1){printf("OR\n");}}
{PLUS} {if(flag==-1 && val == 1){printf("PLUS\n");}}
{RBRACE} {if(flag==-1 && val == 1){printf("RBRACE\n");}}
{RPAR} {if(flag==-1 && val == 1){printf("RPAR\n");}}
{RSQ} {if(flag==-1 && val == 1){printf("RSQ\n");}}
{ELSE} {if(flag==-1 && val == 1){printf("ELSE\n");}}
{FOR} {if(flag==-1 && val == 1){printf("FOR\n");}}
{IF} {if(flag==-1 && val == 1){printf("IF\n");}}
{VAR} {if(flag==-1 && val == 1){printf("VAR\n");}}
{INT} {if(flag==-1 && val == 1){printf("INT\n");}}
{FLOAT32} {if(flag==-1 && val == 1){printf("FLOAT32\n");}}
{BOOL} {if(flag==-1 && val == 1){printf("BOOL\n");}}
{STRING} {if(flag==-1 && val == 1){printf("STRING\n");}}
{PRINT} {if(flag==-1 && val == 1){printf("PRINT\n");}}
{PARSEINT} {if(flag==-1 && val == 1){printf("PARSEINT\n");}}
{FUNC} {if(flag==-1 && val == 1){printf("FUNC\n");}}
{CMDARGS} {if(flag==-1 && val == 1){printf("CMDARGS\n");}}
{REALLIT} {if(flag==-1 && val == 1){printf("REALLIT(%s)\n", yytext);}COLUNA;}
{ID} {if(flag==-1 && val == 1){printf("ID(%s)\n", yytext);}COLUNA;}
{LINETERMINATOR} {LINHA;}

.       {COLUNA;} 

%%
int main(int argc, char* argv[]){
    if(argc > 1){
        if(strcmp(argv[1], "-l") == 0){
            flag=-1;
            val = 1;
        }
    }
    yylex();
    return 0;
}
int yywrap()
{
return 1;
}