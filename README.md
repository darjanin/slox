```
expression     → literal
               | unary
               | binary
               | grouping ;

literal        → NUMBER | STRING | "true" | "false" | "nil" ;
grouping       → "(" expression ")" ;
unary          → ( "-" | "!" ) expression ;
binary         → expression operator expression ;
operator       → "==" | "!=" | "<" | "<=" | ">" | ">="
               | "+"  | "-"  | "*" | "/" ;
```


|Name       |Operators |Associates |
|-----------|----------|-----------|
|Equality   |== !=     |Left       |
|Comparison |> >= < <= |Left       |
|Term       |- +       |Left       |
|Factor     |/ \*      |Left       |
|Unary      |! -       |Right      |

```
program        → declaration* EOF ;
declaration    → varDecl | statement ;
varDecl        → "var" IDENTIFIER ( "=" expression )? ";" ;
statement      → exprStmt | printStmt | block | ifStmt | whileStmt | forStmt ;
block          → "{" declaration* "}" ;  
exprStmt       → expression ";" ;
printStmt      → "print" expression ";" ;
ifStmt         → "if" "(" expression ")" statement ( "else" statement )? ; 
whileStmt      → "while" "(" expression ")" statement ;
forStmt        → "for" "(" ( varDecl | exprStmt | ";" ) expression? ";" expression? ")" statement ; 

expression     → assignment ;
assignment     → IDENTIFIER "=" assignment | comma | logic_or ;
logic_or       → logic_and ( "or" login_and )* ;
logic_and      → comma ( "and" comma )* ;  
comma          → equality ( "," equality )* ;
equality       → comparison ( ( "!=" | "==" ) comparision )* ;
comparison     → term ( ( ">" | ">=" | "<" | "<=" ) term )* ;
term           → factor ( ( "-" | "+" ) factor )* ;
factor         → unary ( ( "/" | "*" ) unary )*;
unary          → ( "!" | "-" ) unary | primary;
primary        → NUMBER | STRING | "true" | "false" | "nil" | "(" expression ")" | IDENTIFIER ;
```

