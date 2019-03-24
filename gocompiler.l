/* Diogo Amores 2015231975 damores@student.uc.pt */
/* Maria Roseiro 2015233281 miroseiro@student.dei.uc.pt */
%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "y.tab.h"
    #define LINHA linha++; coluna=1;
    #define COLUNA coluna+=yyleng;
    int flag_semicolon=0;
    int flag=0;
    int linha =1;
    int coluna=1;
    int c_atual=1;
    int l_atual=1;
    //string errors
    int ste_line;
    int ste_column;

%}

%x COMMENTS
START_COMMENT "/*"
END_COMMENT "*/"
SINGLE_COMMENT "//"
%x STRLIT_STATE
INVALID \\.|\\
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
CHARACTER [a-zA-Z]
RESERVED "break"|"case"|"chan"|"const"|"continue"|"default"|"defer"|"fallthrough"|"func"|"go"|"goto"|"import"|"interface"|"map"|"range"|"select"|"struct"|"switch"|"type"|"++"|"--"
ESCAPE \\n|\\t|\\\\|(\\\")|\\r|\\f
REALLIT [0-9]+[.]([0-9]+)?(([e]|[E])([+]|[-])?[0-9]+)?|[0-9]+([e]|[E])([+]|[-])?[0-9]+|[.][0-9]+(([e]|[E])([+]|[-])?[0-9]+)?
INTLIT [0-9]+|(0[0-9]+)|(0[x][a-fA-F0-9]+)|(0[X][a-fA-F0-9]+)
ID ([a-zA-Z]|[_])([a-zA-Z]|[_]|[0-9])*
STRLIT 	["]([^\n\r\"\\]|(\\n|\\r|\\f|\\t|\\\\|\\\"))*["]
TEXT_COMMENT [^\r\n]*
RETURNCHAR \r
LINETERMINATOR \n|{RETURNCHAR}|({RETURNCHAR})\n

%%

{SINGLE_COMMENT}{TEXT_COMMENT} {COLUNA;}
{START_COMMENT} {BEGIN COMMENTS; c_atual=coluna; l_atual=linha;COLUNA;}
<COMMENTS>("\n") {LINHA;}
<COMMENTS>(.) {COLUNA;}
<COMMENTS><<EOF>> {BEGIN 0; printf("Line %d, column %d: unterminated comment\n", l_atual, c_atual);COLUNA;}
<COMMENTS>{END_COMMENT} {BEGIN 0;COLUNA;}

"\""    {BEGIN STRLIT_STATE;ste_line = linha; ste_column = coluna;COLUNA;}
<STRLIT_STATE>{ESCAPE}  {COLUNA;}
<STRLIT_STATE>{INVALID}  {printf("Line %d, column %d: invalid escape sequence (%s)\n", linha, coluna, yytext);COLUNA;}
<STRLIT_STATE><<EOF>>  {BEGIN 0; printf("Line %d, column %d: unterminated string literal\n", ste_line, ste_column);COLUNA;}
<STRLIT_STATE>{LINETERMINATOR} {BEGIN 0;printf("Line %d, column %d: unterminated string literal\n", ste_line, ste_column);LINHA;}
<STRLIT_STATE>"\"" {BEGIN 0; COLUNA;}
<STRLIT_STATE>.  {COLUNA;}


{SEMICOLON} {if(flag==-1 ){printf("SEMICOLON\n");} flag_semicolon = 0; COLUNA; return SEMICOLON;}
{BLANKID} {if(flag==-1 ){printf("BLANKID\n");} flag_semicolon = 0; COLUNA; return BLANKID;}
{PACKAGE} {if(flag==-1 ){printf("PACKAGE\n");} flag_semicolon = 0; COLUNA; return PACKAGE;}
{RETURN} {if(flag==-1 ){printf("RETURN\n");} flag_semicolon = 1; COLUNA; return RETURN;}
{AND} {if(flag==-1 ){printf("AND\n");} flag_semicolon = 0; COLUNA; return AND;}
{ASSIGN} {if(flag==-1 ){printf("ASSIGN\n");} flag_semicolon = 0; COLUNA; return ASSIGN;}
{STAR} {if(flag==-1 ){printf("STAR\n");} flag_semicolon = 0; COLUNA; return STAR;}
{COMMA} {if(flag==-1 ){printf("COMMA\n");} flag_semicolon = 0; COLUNA; return COMMA;}
{DIV} {if(flag==-1 ){printf("DIV\n");} flag_semicolon = 0; COLUNA; return DIV;}
{EQ} {if(flag==-1 ){printf("EQ\n");} flag_semicolon = 0; COLUNA; return EQ;}
{GE} {if(flag==-1 ){printf("GE\n");} flag_semicolon = 0; COLUNA; return GE;}
{GT} {if(flag==-1 ){printf("GT\n");} flag_semicolon = 0; COLUNA; return GT;}
{LBRACE} {if(flag==-1 ){printf("LBRACE\n");} flag_semicolon = 0; COLUNA; return LBRACE;}
{LE} {if(flag==-1 ){printf("LE\n");} flag_semicolon = 0; COLUNA; return LE;}
{LPAR} {if(flag==-1 ){printf("LPAR\n");} flag_semicolon = 0; COLUNA; return LPAR;}
{LSQ} {if(flag==-1 ){printf("LSQ\n");} flag_semicolon = 0; COLUNA; return LSQ;}
{LT} {if(flag==-1 ){printf("LT\n");} flag_semicolon = 0; COLUNA; return LT;}
{MINUS} {if(flag==-1 ){printf("MINUS\n");} flag_semicolon = 0; COLUNA; return MINUS;}
{MOD} {if(flag==-1 ){printf("MOD\n");} flag_semicolon = 0; COLUNA; return MOD;}
{NE} {if(flag==-1 ){printf("NE\n");} flag_semicolon = 0; COLUNA; return NE;}
{NOT} {if(flag==-1 ){printf("NOT\n");} flag_semicolon = 0; COLUNA; return NOT;}
{OR} {if(flag==-1 ){printf("OR\n");} flag_semicolon = 0; COLUNA; return OR;}
{PLUS} {if(flag==-1 ){printf("PLUS\n");} flag_semicolon = 0; COLUNA; return PLUS;}
{RBRACE} {if(flag==-1 ){printf("RBRACE\n");} flag_semicolon = 1; COLUNA; return RBRACE;}
{RPAR} {if(flag==-1 ){printf("RPAR\n");} flag_semicolon = 1; COLUNA; return RPAR;}
{RSQ} {if(flag==-1 ){printf("RSQ\n");} flag_semicolon = 1; COLUNA; return RSQ;}
{ELSE} {if(flag==-1 ){printf("ELSE\n");} flag_semicolon = 0; COLUNA; return ELSE;}
{FOR} {if(flag==-1 ){printf("FOR\n");} flag_semicolon = 0; COLUNA; return FOR;}
{IF} {if(flag==-1 ){printf("IF\n");} flag_semicolon = 0; COLUNA; return IF;}
{VAR} {if(flag==-1 ){printf("VAR\n");} flag_semicolon = 0; COLUNA; return VAR;}
{INT} {if(flag==-1 ){printf("INT\n");} flag_semicolon = 0; COLUNA; return INT;}
{FLOAT32} {if(flag==-1 ){printf("FLOAT32\n");} flag_semicolon = 0; COLUNA; return FLOAT32;}
{BOOL} {if(flag==-1 ){printf("BOOL\n");} flag_semicolon = 0; COLUNA; return BOOL;}
{STRING} {if(flag==-1 ){printf("STRING\n");} flag_semicolon = 0; COLUNA; return STRING;}
{PRINT} {if(flag==-1 ){printf("PRINT\n");} flag_semicolon = 0; COLUNA; return PRINT;}
{PARSEINT} {if(flag==-1 ){printf("PARSEINT\n");} flag_semicolon = 0; COLUNA; return PARSEINT;}
{FUNC} {if(flag==-1 ){printf("FUNC\n");} flag_semicolon = 0; COLUNA; return FUNC;}
{CMDARGS} {if(flag==-1 ){printf("CMDARGS\n");} flag_semicolon = 0; COLUNA; return CMDARGS;}
{REALLIT} {if(flag==-1 ){printf("REALLIT(%s)\n", yytext);} flag_semicolon = 1; COLUNA;return REALLIT;}
{RESERVED} {if(flag==-1 ){printf("RESERVED(%s)\n", yytext);} flag_semicolon = 0; COLUNA;return RESERVED;}
{ID} {if(flag==-1 ){printf("ID(%s)\n", yytext);} flag_semicolon = 1; COLUNA;return ID;}
{INTLIT} {if(flag==-1 ){printf("INTLIT(%s)\n", yytext);} flag_semicolon = 1; COLUNA;return INTLIT;}
{STRLIT} {if(flag==-1 ){printf("STRLIT(%s)\n", yytext);}flag_semicolon = 1; COLUNA;return STRLIT;}
{LINETERMINATOR} {if(flag_semicolon == 1){if(flag==-1 )printf("SEMICOLON\n"); return SEMICOLON;} flag_semicolon = 0; LINHA;}
"\t"|" "    {COLUNA;}

.       {printf("Line %d, column %d: illegal character (%s)\n", linha, coluna, yytext); flag_semicolon = 0; COLUNA;} 

%%
int main(int argc, char* argv[]){
    if(argc > 1){
        if(strcmp(argv[1], "-l") == 0){
            flag=-1;
            yylex();
        }
        if(strcmp(argv[1], "-t") == 0){
            flag=-2;
        }
    }
    yyparse();
    return 0;
}
int yywrap()
{
return 1;
}

void yyerror (const char *s) { 
     printf ("Line %d, column %d: %s: %s\n",linha,(int)(coluna-strlen(yytext)), s, yytext);
}