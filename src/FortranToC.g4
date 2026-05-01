grammar FortranToC;

@parser::header {
    import model.*;
}

@parser::members {
    public ErrorNotifier errorNotifier = new ErrorNotifier(this);
    public Program program = new Program();
}

prg : PROGRAM IDENT SEMI
      dcllist
      header
      sentlist
      END PROGRAM IDENT
      subproglist {this.program.generateCode();};

/*============Syntax rules:============*/
type returns [String val, String length]
            : INTEGER {$val = "int"; $length="";}
            | REAL {$val = "float"; $length="";}
            | CHARACTER c=charlength {$val = "char"; $length=$c.length;}
            //Error alternatives
            | error=POSSIBLE_CHAR_TYPO c=charlength
                {Token offToken = $error; this.errorNotifier.notifyError(offToken, "character_typo"); $val = "char";$length=$c.length;}
            | error=POSSIBLE_INT_TYPO
                {Token offToken = $error; this.errorNotifier.notifyError(offToken, "integer_typo"); $val = "int"; $length="";}
            | error=POSSIBLE_REAL_TYPO
                {Token offToken = $error; this.errorNotifier.notifyError(offToken, "real_typo"); $val = "float"; $length="";};

charlength returns [String length]
            : '(' n=numint ')' {$length = "["+$n.val+"]";}
            | {$length = "";};
numint returns [Integer val]
    : n=NUM_INT_CONST   { $val = Integer.parseInt($n.text); }
    | n=NUM_INT_CONST_B { $val = Integer.parseInt($n.text.substring(2,$n.text.length()-1), 2); }
    | n=NUM_INT_CONST_H { $val = Integer.parseInt($n.text.substring(2,$n.text.length()-1), 16); }
    | n=NUM_INT_CONST_O { $val = Integer.parseInt($n.text.substring(2,$n.text.length()-1), 8); }
    ;

simpvalue returns [String val, String t]
    : n=numint         { $val = String.valueOf($n.val); $t = "int"; }
    | r=NUM_REAL_CONST { $val = $r.text; $t = "float"; }
    | s=STRING_CONST   { $val = $s.text; $t = "char"; }
    ;

init returns [String val, String t]
    : '=' i=init_p {$val = $i.val; $t=$i.t;}
    | {$val = ""; $t="";} ;
//init_p is meant for keeping LL1 condition after adding error alternatives
init_p returns [String val, String t]
    : s=simpvalue {$val = $s.val; $t=$s.t;}
    //Error alternatives
    | error=IDENT
        {Token offToken = $error; this.errorNotifier.notifyError(offToken, "var_init");
        $val = ""; $t="";}
    | /* empty */
        {Token offToken = _input.LT(1); this.errorNotifier.notifyError(offToken, "miss_var_init");
        $val = ""; $t="";};

/***********Declaration List***********/ //LL1
dcllist
    : dcl dcllist | ;
dcl     : type dcl_p[$type.val, $type.length] ;
dcl_p [String expectedType, String expectedLen]
    : defcte[$expectedType]
    | defvar[$expectedType, $expectedLen] ;
/*Constant*/
ctelist [String expectedType]
    : ',' i=IDENT '=' s=simpvalue ctelist[$expectedType]
        {if (!$expectedType.equals($s.t)) {
            Token offToken = $i;this.errorNotifier.notifyError(offToken, "missmatched_value_type");}
         this.program.declareCte($i.text, $s.val);}
    | ;
defcte [String expectedType]
    : ',' PARAMETER '::'
       i=IDENT '=' s=simpvalue
          {if (!$expectedType.equals($s.t)) {
             Token offToken = $i;this.errorNotifier.notifyError(offToken, "missmatched_value_type");}
          this.program.declareCte($i.text, $s.val);}

       ctelist[$expectedType] SEMI;
/*Variable*/
defvar [String expectedType, String expectedLen]
    : '::' varlist[$expectedType, $expectedLen] SEMI ;
varlist [String expectedType, String expectedLen]
    : i=IDENT ini=init {if (!$expectedType.equals($ini.t)) this.errorNotifier.notifyError($i, "missmatched_value_type");
                        this.program.declareVar($expectedType, $i.text, $ini.val, $expectedLen);}
    varlist_p[$expectedType, $expectedLen] ;
varlist_p [String expectedType, String expectedLen]
    : ',' i=IDENT ini=init {if (!$expectedType.equals($ini.t)) this.errorNotifier.notifyError($i, "missmatched_value_type");
                            this.program.declareVar($expectedType, $i.text, $ini.val, $expectedLen);}
      varlist_p[$expectedType, $expectedLen]
    | ;

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

/*Sentencies*/
//sentlist  : sent | sentlist sent // not LL
sentlist    : sent sentlist_p;
sentlist_p  : sent sentlist_p | ;
sent        : IDENT '=' exp SEMI | proc_call SEMI
            | IF '(' expcond ')' if_body
            | DO loop_body
            | SELECT CASE '(' exp ')' cases END SELECT;


if_body     : sent | THEN sentlist if_body_p;
if_body_p   : ENDIF | ELSE sentlist ENDIF;

loop_body   : WHILE '(' expcond ')' sentlist ENDDO
            | IDENT '=' doval ',' doval ',' doval sentlist ENDDO;
doval       : NUM_INT_CONST | IDENT;

cases       : CASE cases_p
            |
            | error=DEFAULT sentlist
                {Token offToken = $error;this.errorNotifier.notifyError(offToken, "miss_case_default");};

cases_p     : '(' tags ')' sentlist cases
            | DEFAULT sentlist
            //Error alternatives
            | error=tags sentlist cases
                {Token offToken = $error.start;this.errorNotifier.notifyError(offToken, "miss_cond_par");};

tags        : simpvalue tags_p | ':' simpvalue;
tags_p      : tagslist | ':' tags_pp;
tags_pp     : simpvalue | ;
tagslist    : ',' simpvalue tagslist | ;
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
subpparamlist   : '(' exp explist ')'| ;
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
codproc     : SUBROUTINE id1=IDENT formal_paramlist dec_s_paramlist dcllist sentlist END SUBROUTINE id2=IDENT
                    {/*$id1.text...*/};
codfun      : FUNCTION IDENT '(' nomparamlist ')'
                type '::' IDENT SEMI
                dec_f_paramlist
                dcllist
                //sentlist
                //IDENT = exp SEMI
                //END FUNCTION IDENT
                sentlist_fun;

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

//INTEGER TYPOS
POSSIBLE_INT_TYPO  : [iI][nN][tT][gG][eE][rR]          // INTGER
                   | [iI][nN][tT][eE][gG][rR]          // INTEGR
                   | [iI][nN][eE][gG][eE][rR]          // INEGER
                   | [iI][nN][tT][eE][rR][gG][eE][rR]  // INTERGER
                   | [iI][nN][tT][iI][gG][eE][rR]      // INTIGER
                   ;
//REAL TYPOS
POSSIBLE_REAL_TYPO : [rR][aA][eE][lL]                  // RAEL
                   | [rR][eE][aA][lL][lL]              // REALL
                   ;
//CHARACTER TYPOS
POSSIBLE_CHAR_TYPO : [cC][aA][rR][aA][cC][tT][eE][rR]          // CARACTER
                   | [cC][hH][rR][aA][cC][tT][eE][rR]          // CHRACTER
                   | [cC][hH][aA][rR][cC][tT][eE][rR]          // CHARCTER
                   | [cC][hH][aA][rR][aA][tT][eE][rR]          // CHARATER
                   | [cC][hH][aA][rR][aA][cC][tT][rR]          // CHARACTR
                   | [cC][hH][rR][aA][cC][tT][rR]              // CHRACTR
                   | [cC][hH][aA][rR][aA][cC][rR][tT][eE][rR]  // CHARACRTER
                   ;


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
WSTRN          : [ \t\r\n]+ -> skip ;

fragment SINGLE_QUOTE : '\'' ;
fragment DOUBLE_QUOTE : '"'  ;