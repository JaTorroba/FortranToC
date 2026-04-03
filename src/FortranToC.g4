grammar FortranToC;

prg : PROGRAM IDENT SEMI dcllist header sentlist END PROGRAM IDENT subproglist ;

/*============Syntax rules:============*/
type        : INTEGER | REAL | CHARACTER charlength ;
charlength  : '(' numint ')' | ;
numint      : NUM_INT_CONST | NUM_INT_CONST_B | NUM_INT_CONST_H | NUM_INT_CONST_O ;
simpvalue   : numint | NUM_REAL_CONST | STRING_CONST ;
init        : '=' simpvalue | ;

/***********Declaration List***********/ //LL1
dcllist : dcl dcllist | ;
dcl     : type dcl_p;
dcl_p   : defcte | defvar ;
/*Constant*/
ctelist : ',' IDENT '=' simpvalue ctelist | ;
defcte  : ',' PARAMETER '::' IDENT '=' simpvalue ctelist SEMI ;
/*Variable*/
defvar  : '::' varlist SEMI ;
varlist     : IDENT init varlist_p ;
varlist_p   : ',' IDENT init varlist_p | ;

/*
defcte  : type ',' PARAMETER '::' IDENT '=' simpvalue ctelist SEMI defcte_p ;
defcte_p: type ',' PARAMETER '::' IDENT '=' simpvalue ctelist SEMI defcte_p | ;
defvar  : type '::' varlist SEMI defvar_p ;
defvar_p: type '::' varlist SEMI defvar_p | ;
*/

/*
defcte  : type ',' PARAMETER '::' IDENT '=' simpvalue ctelist SEMI defcte | ;
defvar  : type '::' varlist SEMI defvar | ;
ctelist : IDENT '=' simpvalue ',' ctelist | ;
*/

/****************Header****************/ //LL1
header  : INTERFACE headlist END INTERFACE | ;
headlist    : decproc decsubprog | decfun decsubprog ;
decsubprog  : decproc decsubprog | decfun decsubprog | ;
/*Procedure*/
decproc : SUBROUTINE IDENT formal_paramlist dec_s_paramlist END SUBROUTINE IDENT ;
formal_paramlist    : '(' nomparamlist ')' | ;
nomparamlist        : IDENT nomparamlist_p ;
nomparamlist_p      : ',' IDENT nomparamlist_p | ;
dec_s_paramlist     : type ',' INTENT '(' paramtype ')' IDENT SEMI dec_s_paramlist | ;
paramtype           : IN | OUT | INOUT ;

/*Function*/
decfun  : FUNCTION IDENT '(' nomparamlist ')' type '::' IDENT SEMI dec_f_paramlist END FUNCTION IDENT ;
dec_f_paramlist : type ',' INTENT '(' IN ')' IDENT SEMI dec_f_paramlist | ;

/*
dec_f_paramlist : dec_f_paramlist_p ;
dec_f_paramlist_p   : type ',' INTENT '(' IN ')' IDENT SEMI dec_f_paramlist_p | ;
*/

/*************Sentencie List************/

/*Normal sentencies*/
//sentlist  : sent | sentlist sent // not LL
sentlist    : sent sentlist_p;
sentlist_p  : sent sentlist_p | ;
sent        : IDENT '=' exp SEMI | proc_call SEMI;
/*
not LL
exp : exp op exp | factor;

not LL1 for exp_p
exp         : factor exp_p;
exp_p       : op exp exp_p | ;
*/
exp         : factor exp_p;
exp_p       : oparit factor exp_p | ;

oparit      : '+' | '-' | '*' | '/';
//factor      : simpvalue | '(' exp ')' | IDENT '(' exp explist ')' | IDENT; // not LL1
factor      : simpvalue | '(' exp ')' | IDENT subpparamlist;
proc_call   : CALL IDENT subpparamlist;
subpparamlist   : '(' exp explist ')' | ;
explist     : ',' exp explist | ;

/*Condition sentencies*/
//expcond     : expcond oplog expcond | factorcond;
expcond     : factorcond expcond_p;
expcond_p   : oplog factorcond expcond_p | ;
oplog       : OR | AND | EQV | NEQV;

factorcond    : exp opcomp exp | '(' expcond ')' | NOT factorcond | TRUE | FALSE; //LL(K)


opcomp      : '<' | '>' | '<=' | '>=' | '==' | '/=' ;






/***************Subprogram***************/

subproglist : codproc subproglist | codfun subproglist | ;
codproc     : SUBROUTINE IDENT formal_paramlist dec_s_paramlist dcllist sentlist END SUBROUTINE IDENT;
codfun      : FUNCTION IDENT '(' nomparamlist ')' type '::' IDENT SEMI dec_f_paramlist dcllist sentlist_fun;

sentlist_fun    : IDENT '=' exp SEMI sentlist_fun_p | proc_call SEMI sentlist_fun;
sentlist_fun_p  : END FUNCTION IDENT | sentlist_fun;
/*===============Tokens:===============*/
/***************Keywords***************/
PROGRAM    : 'PROGRAM' ;
END        : 'END' ;
INTERFACE  : 'INTERFACE' ;
FUNCTION   : 'FUNCTION' ;
SUBROUTINE : 'SUBROUTINE' ;
CALL       : 'CALL' ;
IF         : 'IF';
ENDIF      : 'ENDIF';
THEN       : 'THEN';
ELSE       : 'ELSE';
SELECT     : 'SELECT';
CASE       : 'CASE';
DEFAULT    : 'DEFAULT';
WHILE      : 'WHILE';
DO         : 'DO';
ENDDO      : 'ENDDO';


INTEGER    : 'INTEGER' ;
REAL       : 'REAL' ;
CHARACTER  : 'CHARACTER' ;

PARAMETER  : 'PARAMETER' ;
INTENT     : 'INTENT' ;
IN         : 'IN' ;
OUT        : 'OUT' ;
INOUT      : 'INOUT' ;

SEMI        : ';' ;

IDENT : [a-zA-Z][a-zA-Z0-9_]* ;

NUM_REAL_CONST  :
( NUM_INT_CONST '.' [0-9]+
| NUM_INT_CONST [eE] NUM_INT_CONST
| NUM_INT_CONST '.' [0-9]+ [eE] NUM_INT_CONST
);

NUM_INT_CONST   : '-'? [0-9]+ ;
NUM_INT_CONST_B : 'b' SINGLE_QUOTE [01]+ SINGLE_QUOTE     ;
NUM_INT_CONST_O : 'o' SINGLE_QUOTE [0-7]+ SINGLE_QUOTE    ;
NUM_INT_CONST_H : 'z' SINGLE_QUOTE [0-9A-F]+ SINGLE_QUOTE ;

TRUE    : '.TRUE.'   ;
FALSE   : '.FALSE.' ;
OR      : '.OR.';
AND     : '.AND.';
NOT     : '.NOT.';
EQV     : '.EQV.';
NEQV    : '.NEQV.';


STRING_CONST    :
( SINGLE_QUOTE (SINGLE_QUOTE SINGLE_QUOTE | ~['\r\n])* SINGLE_QUOTE
| DOUBLE_QUOTE (DOUBLE_QUOTE DOUBLE_QUOTE | ~["\r\n])* DOUBLE_QUOTE
);

COMMENT     : '!' ~[\r\n]+ '\r'?'\n' -> skip ;
RN          : [ \t\r\n]+ -> skip ;

fragment SINGLE_QUOTE : '\'' ;
fragment DOUBLE_QUOTE : '"'  ;