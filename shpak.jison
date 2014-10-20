%lex
%%

\s+                                                                         /*skip*/
\#[^\n]*                                                                    yytext = yytext.replace(/^#+/, ''); return 'COMMENT'
";"                                                                         return ';'
","                                                                         return ','
"("                                                                         return '('
")"                                                                         return ')'
"{"                                                                         return '{'
"}"                                                                         return '}'
"?"                                                                         return '?'
"["                                                                         return '['
"]"                                                                         return ']'
"number"                                                                    return 'NUMBER'
"integer"                                                                   return 'INTEGER'
"string"                                                                    return 'STRING'
"uri"                                                                       return 'URI'
"timestamp"                                                                 return 'TIMESTAMP'
"object"                                                                    return 'OBJECT'
"union"                                                                     return 'UNION'
"array"                                                                     return 'ARRAY'
"$ref"                                                                      return 'REF'
"$ref_array"                                                                return 'REF_ARRAY'
"enum"                                                                      return 'ENUM'
"$extends"                                                                  return 'EXTENDS'
\"[\w\/\.]+\.spec\"                                                         yytext = yytext.substr(1,yyleng-2); return 'SPEC_PATH'
\d+                                                                         return 'NUMBER_VALUE'
[A-Za-z_0-9-]+                                                              return 'NAME'
\"[\w_-ㄱ-ㅎ가-힣]+\"                                                           yytext = yytext.substr(1,yyleng-2); return 'STR_VALUE';
<<EOF>>                                                                     return 'EOF'

/lex

%%

spec :
    shpak EOF
        { return $1; }
    ;

shpak :
    rootDef ';'
        { $$ = $1; }
    ;

rootDef :
    commentsDef OBJECT '{' entries '}' extendsDef
        { $$ = new yy.Type($2, null, null, $4, null, $6); $$.setComment($1); }
    | commentsDef OBJECT '{' '}' extendsDef
        { $$ = new yy.Type($2, null, null, null, null, $5); $$.setComment($1); }
    | OBJECT '{' entries '}' extendsDef
        { $$ = new yy.Type($1, null, null, $3, null, $5);}
    | OBJECT '{' '}' extendsDef
        { $$ = new yy.Type($1);}
    ;

extendsDef :
    EXTENDS '(' specPathsDef ')'
        { $$ = $3; }
    |
        { $$ = null; }
    ;

specPathDef :
    SPEC_PATH { $$ = [$1]; }
    ;

specPathsDef
    : SPEC_PATH ',' specPathsDef
        { $$ = $3; $$.unshift($1); }
    |  specPathDef
    |
        { $$ = []; }
    ;

entry
    : STRING NAME optionDef ';'
        { $$ = new yy.Type($1, $2, $3); }
    | NUMBER NAME optionDef ';'
        { $$ = new yy.Type($1, $2, $3); }
    | INTEGER NAME optionDef ';'
        { $$ = new yy.Type($1, $2, $3); }
    | TIMESTAMP NAME optionDef ';'
        { $$ = new yy.Type($1, $2, $3); }
    | URI NAME optionDef ';'
        { $$ = new yy.Type($1, $2, $3); }
    | REF '(' SPEC_PATH ')' NAME optionDef ';'
        { $$ = new yy.Type($1, $3, $4, null, [$6]); }
    | REF_ARRAY '(' SPEC_PATH ')' NAME optionDef ';'
        { $$ = new yy.Type($1, $3, $4, null, [$6]); }
    | ENUM NAME optionDef valuesDef ';'
        { $$ = new yy.Type($1, $2, $3, null, [$4]); }
    | OBJECT '{' entries '}' NAME optionDef ';'
        { $$ = new yy.Type($1, $5, $6, $3); }
    | ARRAY '{' nonameEntry '}' NAME optionDef ';'
        { $$ = new yy.Type($1, $5, $6, [$3]); }
    | UNION '{' nonameEntries '}' NAME optionDef ';'
        { $$ = new yy.Type($1, $5, $6, [$3]); }
    ;

nonameEntry
    : STRING ';'
        { $$ = new yy.Type($1); }
    | NUMBER ';'
        { $$ = new yy.Type($1); }
    | INTEGER ';'
        { $$ = new yy.Type($1); }
    | TIMESTAMP ';'
        { $$ = new yy.Type($1); }
    | URI ';'
        { $$ = new yy.Type($1); }
    | REF '(' SPEC_PATH ')' ';'
        { $$ = new yy.Type($1, $3); }
    | REF_ARRAY '(' SPEC_PATH ')' ';'
        { $$ = new yy.Type($1, $3); }
    | ENUM valuesDef ';'
        { $$ = new yy.Type($1, null, null, null, [$2]); }
    | OBJECT '{' entries '}' ';'
        { $$ = new yy.Type($1, null, null, $3); }
    | ARRAY '{' nonameEntry '}' ';'
        { $$ = new yy.Type($1, null, null, [$3]); }
    | UNION '{' nonameEntries '}' ';'
        { $$ = new yy.Type($1, null, null, [$3]); }
    ;

entries
    : entry entries
        { $$ = $2; $$.unshift($1); }
    | entry
        { $$ = [$1];}
    | commentsDef entry entries
        { $$ = $3; $$.unshift($2); $2.setComment($1); }
    | commentsDef entry
        { $$ = [$2]; $2.setComment($1); }
    ;

nonameEntries
    : nonameEntry nonameEntries
        { $$ = $2; $$.unshift($1); }
    | nonameEntry
        { $$ = [$1]; }
    ;

optionDef
    : '?'
        { $$ = true; }
    |
        { $$ = null; }
    ;

valueDef
    : NUMBER_VALUE
        { $$ = Number(yytext); }
    | STR_VALUE
        { $$ = yytext; }
    ;

valueListDef
    : valueDef
        { $$ = [$1]; }
    | valueListDef ',' valueDef
        { $$ = $1; $$.push($3); }
    ;

valuesDef
    : '[' ']'
        { $$ = []; }
    | '[' valueListDef ']'
        { $$ = $2; }
    ;

commentsDef
    : COMMENT commentsDef
        { $$ = $2; $$.unshift($1); }
    | COMMENT
        { $$ = [$1]; }
    ;
