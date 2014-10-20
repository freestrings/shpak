%lex

%%
\s+                         /**/
\@[a-zA-Z_-]+\s+[^\n]*      return 'NAMED'
[^\n]*                      return 'VALUE'

/lex
%%

str
    : comments
        { return $1; }
    ;

comments
    : comments comment
        { $$ = $1; $$.add($2); }
    | comment
        { $$ = $1; }
    ;


comment
    : NAMED
        { var exec = /^@([a-zA-Z_-]+)\s+(.*)/.exec($1); $$ = new yy.Comment(exec[1], exec[2]); }
    | VALUE
        { $$ = new yy.Comment(null, $1); }
    ;
