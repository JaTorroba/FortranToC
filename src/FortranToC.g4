grammar FortranToC;

@parser::header {
    import model.*;
    import java.util.Set;
    import java.util.HashSet;
    import java.util.List;
    import java.util.ArrayList;
}

@parser::members {
    public ErrorNotifier errorNotifier = new ErrorNotifier(this);
    public Program program = Program.getInstance();
}

prg : PROGRAM IDENT SEMI
      dcllist[null]
      header
      sentlist[new HashSet<String>()]
      {this.program.addMain($sentlist.block_s);}
      END PROGRAM IDENT
      subproglist {if (this.getNumberOfSyntaxErrors() == 0) this.program.generateCode();};

/*============Syntax rules:============*/
type returns [String val, String length]
            : INTEGER {$val = "int"; $length="";}
            | REAL {$val = "float"; $length="";}
            | CHARACTER c=charlength {$val = "char"; $length=$c.length;}
            //Error alternatives
            | error=POSSIBLE_CHAR_TYPO c=charlength
                {this.errorNotifier.notifyError($error, "character_typo"); $val = "char";$length=$c.length;}
            | error=POSSIBLE_INT_TYPO
                {this.errorNotifier.notifyError($error, "integer_typo"); $val = "int"; $length="";}
            | error=POSSIBLE_REAL_TYPO
                {this.errorNotifier.notifyError($error, "real_typo"); $val = "float"; $length="";};

charlength returns [String length]
            : '(' n=numint ')' {$length = "["+$n.val+"]";}
            | {$length = "";};
numint returns [String val]
    : n=NUM_INT_CONST   { $val = $n.text; }
    | n=NUM_INT_CONST_B { $val = "0b" + $n.text.substring(2, $n.text.length()-1); }
    | n=NUM_INT_CONST_H { $val = "0x" + $n.text.substring(2, $n.text.length()-1); }
    | n=NUM_INT_CONST_O { $val = "0o" + $n.text.substring(2, $n.text.length()-1); }
    ;

simpvalue returns [String val, String t]
    : n=numint         { $val = $n.val; $t = "int"; }
    | r=NUM_REAL_CONST { $val = $r.text; $t = "float"; }
    | s=STRING_CONST   {
        String str = $s.text;
        char quote = str.charAt(0);
        str = str.substring(1, str.length() - 1);
        if (quote == '\'') str = str.replace("''", "'");
        else str = str.replace("\"\"", "\"");
        str = str.replace("\"", "\\\"");
        $val = "\"" + str + "\"";
        $t = "char";
      }
    ;

init returns [String val, String t]
    : '=' i=init_p {$val = $i.val; $t=$i.t;}
    | {$val = ""; $t="";} ;
//init_p is meant for keeping LL1 condition after adding error alternatives
init_p returns [String val, String t]
    : s=simpvalue {$val = $s.val; $t=$s.t;}
    //Error alternatives
    | error=IDENT
        {
        this.errorNotifier.notifyError($error, "var_init");
        $val = ""; $t="";
        }
    | /* empty */
        {
        this.errorNotifier.notifyError(_input.LT(1), "miss_var_init");
        $val = ""; $t="";
        };

/***********Declaration List***********/ //LL1
dcllist[Subprogram scope]
    : dcl[$scope] dcllist[$scope] | ;
dcl [Subprogram scope]
    : type dcl_p[$scope,$type.val, $type.length] ;
dcl_p [Subprogram scope, String expectedType, String expectedLen]
    : defcte[$expectedType]
    | defvar[$scope, $expectedType, $expectedLen] ;
/*Constant*/
ctelist [String expectedType]
    : ',' i=IDENT '=' s=simpvalue ctelist[$expectedType]
        {if (!$expectedType.equals($s.t)) {
            this.errorNotifier.notifyError($i, "missmatched_value_type");}
         this.program.declareCte($i.text, $s.val);}
    | ;

defcte [String expectedType]
    : ',' PARAMETER '::'
       i=IDENT '=' s=simpvalue
      {if (!$expectedType.equals($s.t)) {
           this.errorNotifier.notifyError($i, "missmatched_value_type");}
       this.program.declareCte($i.text, $s.val);}
       ctelist[$expectedType] SEMI;

/*Variable*/
defvar [Subprogram scope, String expectedType, String expectedLen]
    : '::' varlist[$scope, $expectedType, $expectedLen] SEMI ;

varlist [Subprogram scope, String expectedType, String expectedLen]
    : i=IDENT ini=init
    {if (!$ini.t.isEmpty() && !$expectedType.equals($ini.t)) this.errorNotifier.notifyError($i, "missmatched_value_type");
     if ($scope == null) {
        try {
            this.program.declareVar($expectedType, $i.text, $ini.val, $expectedLen);
        } catch (IllegalArgumentException e) {
            this.errorNotifier.notifyError($i, "symbol_already_taken");
        }
     } else {
        try {
            $scope.declareLocalVar($expectedType, $i.text, $ini.val, $expectedLen);
        } catch (IllegalArgumentException e) {
            this.errorNotifier.notifyError($i, "symbol_already_taken");
        }
     }
     }
     varlist_p[$scope, $expectedType, $expectedLen] ;

varlist_p [Subprogram scope, String expectedType, String expectedLen]
    : ',' i=IDENT ini=init
    {if (!$ini.t.isEmpty() && !$expectedType.equals($ini.t)) this.errorNotifier.notifyError($i, "missmatched_value_type");
     if ($scope == null) {
        try {
            this.program.declareInlineVar($expectedType, $i.text, $ini.val, $expectedLen);
        } catch (IllegalArgumentException e) {
            this.errorNotifier.notifyError($i, "symbol_already_taken");
        }
     } else {
        try {
            $scope.declareInlineLocalVar($expectedType, $i.text, $ini.val, $expectedLen);
        } catch (IllegalArgumentException e) {
            this.errorNotifier.notifyError($i, "symbol_already_taken");
        }
     }
     }
     varlist_p[$scope, $expectedType, $expectedLen]
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
decproc
    : SUBROUTINE i1=IDENT
      formal_paramlist
      dec_s_paramlist[new HashSet<String>($formal_paramlist.idents), new HashSet<Param>()]
      END SUBROUTINE i2=IDENT
      {if (!$i1.text.equals($i2.text)) {
            this.errorNotifier.notifyError($i2, "missmatch_subroutine_name");
       }
       this.program.declareSubprogram($i1.text, $formal_paramlist.idents, $dec_s_paramlist.paramlist_s, null);
       }
    ;


//returns a list with de Strings of the declared params IDENT for later comprobation
formal_paramlist returns [List<String> idents]
    : '(' nomparamlist[new ArrayList<String>()] ')' { $idents = $nomparamlist.paramlist_s; }
    | { $idents = new ArrayList<String>(); }
    ;
nomparamlist [List<String> paramlist_h] returns [List<String> paramlist_s]
    : IDENT {$paramlist_h.add($IDENT.text);}
      nomparamlist_p[$paramlist_h] {$paramlist_s = $nomparamlist_p.paramlist_s;} ;

nomparamlist_p [List<String> paramlist_h] returns [List<String> paramlist_s]
    : ',' IDENT
        {if ($paramlist_h.contains($IDENT.text))
            this.errorNotifier.notifyError($IDENT, "already_declared_param");
        $paramlist_h.add($IDENT.text);}
      res=nomparamlist_p[$paramlist_h] {$paramlist_s = $res.paramlist_s;}
    | {$paramlist_s = $paramlist_h;}
    ;

//Checks whether the params declared match those declared previously on formal_paramlist
dec_s_paramlist [Set<String> identlist_h, Set<Param> paramlist_h] returns [Set<Param> paramlist_s]
    : type ',' INTENT '(' paramtype ')' i=IDENT
      {
        if (!$identlist_h.contains($i.text)) {
            this.errorNotifier.notifyError($i, "undeclared_param");
        }
        $paramlist_h.add(new Param($i.text, $paramtype.val, $type.val));
      }
      SEMI res=dec_s_paramlist[$identlist_h, $paramlist_h] {$paramlist_s = $res.paramlist_s;}
    | {
        Set<String> declaredNames = new HashSet<String>();
        for (Param p : $paramlist_h) declaredNames.add(p.getName());
        for (String id : $identlist_h) {
            if (!declaredNames.contains(id)) {
                this.errorNotifier.notifyError(_input.LT(1), "missing_param_declaration");
            }
        }
        $paramlist_s = $paramlist_h;
      }
    ;

paramtype returns [String val]
          : IN    {$val = "IN";}
          | OUT   {$val = "OUT";}
          | INOUT {$val = "INOUT";};

/*Function*/
decfun
    : FUNCTION i1=IDENT
    '(' nomparamlist[new ArrayList<String>()] ')'
    type '::' i2=IDENT SEMI
    dec_f_paramlist[new HashSet<String>($nomparamlist.paramlist_s), new HashSet<Param>()]
    END FUNCTION i3=IDENT
    { String funcName = $i1.text;
      if (!funcName.equals($i2.text)) {
          this.errorNotifier.notifyError($i2, "missmatch_subroutine_name");
      }
      if (!funcName.equals($i3.text)) {
          this.errorNotifier.notifyError($i3, "missmatch_subroutine_name");
      }
      this.program.declareSubprogram($i1.text, $nomparamlist.paramlist_s, $dec_f_paramlist.paramlist_s, $type.val);
    }
    ;

dec_f_paramlist [Set<String> identlist_h, Set<Param> paramlist_h] returns [Set<Param> paramlist_s]
    : type ',' INTENT '(' IN ')' i=IDENT
    {if (!$identlist_h.contains($i.text)) {
        this.errorNotifier.notifyError($i, "undeclared_param");
    }
    $paramlist_h.add(new Param($i.text, "IN", $type.val));
    }
    SEMI res=dec_f_paramlist[$identlist_h, $paramlist_h]
    //return paramlist
    {$paramlist_s = $res.paramlist_s ; }
    | {
        Set<String> declaredNames = new HashSet<String>();
        for (Param p : $paramlist_h) declaredNames.add(p.getName());
        for (String id : $identlist_h) {
            if (!declaredNames.contains(id)) {
                this.errorNotifier.notifyError(_input.LT(1), "missing_param_declaration");
            }
        }
        $paramlist_s = $paramlist_h;
      } ;

/*
dec_f_paramlist : dec_f_paramlist_p ;
dec_f_paramlist_p   : type ',' INTENT '(' IN ')' IDENT SEMI dec_f_paramlist_p | ;
*/

/*************Sentencie List************/

/*Sentencies*/
//sentlist  : sent | sentlist sent // not LL
sentlist[Set<String> refParams] returns [ProgramBody block_s]
    :
    {ProgramBody block_h = new ProgramBody();}
    sent[$refParams]
    {block_h.addSentencie($sent.val);}
    sentlist_p[$refParams, block_h]
    {$block_s = $sentlist_p.block_s;} ;

sentlist_p  [Set<String> refParams, ProgramBody block_h] returns [ProgramBody block_s]
    :
    sent[$refParams]
        {$block_h.addSentencie($sent.val);}
    sentlist_p[$refParams, $block_h]
        {$block_s = $sentlist_p.block_s;}
    |   {$block_s = $block_h;};

sent[Set<String> refParams] returns [Sentencie val]
        : IDENT '=' exp[$refParams] SEMI  {String prefix = $refParams.contains($IDENT.text) ? "*" : ""; $val = new Sentencie(prefix+$IDENT.text + " = "+$exp.val+";");}
        | proc_call[$refParams] SEMI    {$val = new Sentencie($proc_call.val);}
        |
        IF '(' expcond[$refParams] ')' if_body[$refParams]
            {ConditionSentencie sent = new ConditionSentencie("if ("+$expcond.val+") ");
             sent.addIfBody($if_body.if);
             sent.addElseBody($if_body.else);
             $val = sent;
            }
        |
        DO loop_body[$refParams]
            {$val = $loop_body.val;}
        |
        SELECT CASE '(' exp[$refParams] ')'
            {SelectSentencie sent = new SelectSentencie("switch ("+$exp.val+")");}
        cases[$refParams, sent]
            {$val = sent;}
        END SELECT;


if_body[Set<String> refParams] returns [ProgramBody if, ProgramBody else]
    :
    sent[$refParams] {$if = new ProgramBody(); $if.addSentencie($sent.val); $else = null;}
    |
    THEN
    sentlist[$refParams]
    if_body_p[$refParams]
    {$if = $sentlist.block_s;
     $else = $if_body_p.else;}
    ;

if_body_p[Set<String> refParams]  returns [ProgramBody else]
    : ENDIF               {$else = null;}
    | ELSE sentlist[$refParams] ENDIF {$else = $sentlist.block_s;};

loop_body[Set<String> refParams] returns[LoopSentencie val]
    :
    WHILE '(' expcond[$refParams] ')'
    {LoopSentencie sent = new LoopSentencie("while ( "+$expcond.val+" ) ");}
    sentlist[$refParams]
    {sent.addBody($sentlist.block_s);}
    ENDDO
    {$val = sent;}
    |
    IDENT '=' d1=doval ',' d2=doval ',' d3=doval
    {String content = "for("+$IDENT.text+"="+$d1.val+ " ; "+$IDENT.text+"!="+$d2.val+" ; "+$IDENT.text+"="+$IDENT.text+"+"+$d3.val+" )";
     LoopSentencie sent = new LoopSentencie(content);}
    sentlist[$refParams]
    {sent.addBody($sentlist.block_s);}
    ENDDO
    {$val = sent;}
    ;


doval returns[String val]
    : NUM_INT_CONST  {$val = $NUM_INT_CONST.text;}
    | IDENT          {$val = $IDENT.text;}
    ;

cases[Set<String> refParams, SelectSentencie select]
    : CASE cases_p[$refParams, $select]
    |
    | error=DEFAULT sentlist[$refParams]
         {this.errorNotifier.notifyError($error, "miss_case_default");};

cases_p[Set<String> refParams, SelectSentencie select]
    :
    '(' tags[$select] ')'
        {CaseSentencie caseSent = new CaseSentencie("case "+$tags.val+":");
         caseSent.setValue($tags.val);}
    sentlist[$refParams]
        {caseSent.addBody($sentlist.block_s);
         $select.addCaseClause(caseSent);}
    cases[$refParams, $select]
    | DEFAULT sentlist[$refParams]
        {CaseSentencie def = new CaseSentencie("default:");
         def.addBody($sentlist.block_s);
         $select.addDefaultClause(def);}
    //Error alternatives
    | error=tags[$select] sentlist[$refParams] cases[$refParams, $select]
        {this.errorNotifier.notifyError($error.start, "miss_cond_par");};

tags[SelectSentencie select] returns[String val]
    : simpvalue tags_p[$select, $simpvalue.val]
        {if ($tags_p.val.equals(">")) $val = "> "+$simpvalue.val;
         else $val = $simpvalue.val + $tags_p.val;}
    | ':' simpvalue {$val = "< "+$simpvalue.val;};

tags_p[SelectSentencie select, String prevVal] returns[String val]
    : tagslist[$select, $prevVal] {$val = "";}
    | ':' tags_pp
         {
         if ($tags_pp.val == null) $val = ">";
         else $val = " to "+$tags_pp.val;
         };

tags_pp returns[String val]
    : simpvalue {$val = $simpvalue.val;}
    |           {$val = null;}
    ;

tagslist[SelectSentencie select, String prevVal]
    : ',' simpvalue {$select.duplicateCaseForVal($prevVal, $simpvalue.val);} tagslist[$select, $prevVal]
    | ;
/*
not LL
exp : exp op exp | factor;

not LL1 for exp_p
exp         : factor exp_p;
exp_p       : op exp exp_p | ;
*/
exp[Set<String> refParams] returns[String val]
        :
        factor[$refParams]
        {StringBuilder sb = new StringBuilder();
        sb.append($factor.val);}
        exp_p[sb, $refParams]
        {$val = $exp_p.val;}
        ;

exp_p[StringBuilder sb, Set<String> refParams] returns[String val]
      :
      oparit
      {sb.append($oparit.val);}
      factor[$refParams]
      {sb.append($factor.val);}
      res=exp_p[sb, $refParams]
      {$val = $res.val;}
      | {$val = sb.toString();};

oparit returns [String val]
    : '+' {$val = " + ";}
    | '-' {$val = " - ";}
    | '*' {$val = " * ";}
    | '/' {$val = " / ";} ;
//factor      : simpvalue | '(' exp ')' | IDENT '(' exp explist ')' | IDENT; // not LL1
factor[Set<String> refParams] returns [String val]
    : simpvalue             {$val = $simpvalue.val;}
    | '(' exp[$refParams] ')'           {$val = $exp.val;}
    | IDENT subpparamlist[$refParams]   {
        if ($subpparamlist.args.isEmpty()) {
            String deref = $refParams.contains($IDENT.text) ? "*" : "";
            $val = deref + $IDENT.text;
        } else {
            $val = $IDENT.text + "(" + String.join(", ", $subpparamlist.args) + ")";
        }
    };

proc_call[Set<String> refParams] returns[String val]
    : CALL IDENT subpparamlist[$refParams]
    {
        Subprogram sub = this.program.getSubprogram($IDENT.text);
        if (sub != null && !sub.isFunction()) {
            StringBuilder sb = new StringBuilder();
            if (!$subpparamlist.args.isEmpty()) {
                sb.append("(");
                List<String> args = $subpparamlist.args;
                for (int i = 0; i < args.size(); i++) {
                    if (sub.isRefParam(i)) {
                        sb.append("&");
                    }
                    sb.append(args.get(i));
                    if (i < args.size() - 1) sb.append(", ");
                }
                sb.append(")");
            }
            $val = $IDENT.text + sb.toString();
        } else {
            if ($subpparamlist.args.isEmpty()) {
                $val = $IDENT.text;
            } else {
                $val = $IDENT.text + "(" + String.join(", ", $subpparamlist.args) + ")";
            }
        }
    }
    ;

subpparamlist[Set<String> refParams] returns [List<String> args]
   : '(' exp[$refParams] explist[$refParams] ')'
     { $args = new ArrayList<String>(); $args.add($exp.val); $args.addAll($explist.args); }
   | { $args = new ArrayList<String>(); }
   ;

explist[Set<String> refParams] returns [List<String> args]
    : ',' exp[$refParams] res=explist[$refParams] { $args = new ArrayList<String>(); $args.add($exp.val); $args.addAll($res.args); }
    | { $args = new ArrayList<String>(); }
    ;

/*Condition sentencies*/
//expcond     : expcond oplog expcond | factorcond;
expcond[Set<String> refParams] returns [String val]
    :
    factorcond[$refParams]
    {StringBuilder sb = new StringBuilder();
    sb.append($factorcond.val);}
    expcond_p[sb, $refParams]
    {$val = $expcond_p.val;}
    ;

expcond_p[StringBuilder sb, Set<String> refParams] returns[String val]
    :
    oplog
    {$sb.append($oplog.val);}
    factorcond[$refParams]
    {$sb.append($factorcond.val);}
    res=expcond_p[sb, $refParams]
    {$val = $res.val;}
    | {$val = $sb.toString();};

oplog returns [String val]
    : OR   {$val = " || ";}
    | AND  {$val = " && ";}
    | EQV  {$val = " !^ ";}
    | NEQV {$val = " ^ ";};

factorcond[Set<String> refParams] returns [String val] //LL(k)
    :
    e1=exp[$refParams] opcomp e2=exp[$refParams]
    {$val = $e1.val + $opcomp.val + $e2.val;}
    |
    '(' expcond[$refParams] ')'
    {$val = "(" + $expcond.val + ")";}
    |
    NOT c=factorcond[$refParams]
    {$val = "!" + $c.val ;}
    | TRUE  {$val = "1";}
    | FALSE {$val = "0";}
    ;

opcomp returns [String val]
    : '<'  { $val = " < ";  }
    | '>'  { $val = " > ";  }
    | '<=' { $val = " <= "; }
    | '>=' { $val = " >= "; }
    | '==' { $val = " == "; }
    | '/=' { $val = " != "; }
    ;






/***************Subprogram***************/

subproglist : codproc subproglist | codfun subproglist | ;
codproc
    : SUBROUTINE i1=IDENT
      listP=formal_paramlist
      sParams=dec_s_paramlist[new HashSet<String>($listP.idents), new HashSet<Param>()]
      {
          Subprogram scope = null;
          Set<String> refParams = new HashSet<String>();
          if (!this.program.hasSubprogram($i1.text)) {
              this.errorNotifier.notifyError($i1, "undeclared_subprogram");
          } else {
              scope = this.program.getSubprogram($i1.text);
              refParams = scope.getRefParamNames();
          }
      }
      dcllist[scope]
      sentlist[refParams]
      END SUBROUTINE i2=IDENT
      {
          if (!$i1.text.equals($i2.text)) {
              this.errorNotifier.notifyError($i2, "missmatch_subroutine_name");
          } else {
              Subprogram declaredPrg = this.program.getSubprogram($i1.text);
              Set<Param> declaredParams = declaredPrg.getParams();
              Set<Param> implementedParams = $sParams.paramlist_s;

              if (!declaredParams.equals(implementedParams)) {
                  this.errorNotifier.notifyError($i1, "signature_missmatch_in_implementation");
              }
              declaredPrg.addImplementation($sentlist.block_s);
          }
      }
    ;

codfun
    : FUNCTION i1=IDENT
      '(' nParams=nomparamlist[new ArrayList<String>()] ')'
      type '::' i2=IDENT SEMI
      fParams=dec_f_paramlist[new HashSet<String>($nParams.paramlist_s), new HashSet<Param>()]
      {
          Subprogram scope = null;
          if (!this.program.hasSubprogram($i1.text)) {
              this.errorNotifier.notifyError($i1, "undeclared_subprogram");
          } else {
              scope = this.program.getSubprogram($i1.text);
          }
      }
      dcllist[scope]
      //Not LL1 for sentlist_p as FOLLOW = FOLLOW sentlist = IDENT.... for sent prod
      //sentlist
      //ret=IDENT '=' exp SEMI
      //END FUNCTION i3=IDENT
      {   ProgramBody imp = new ProgramBody();}
      sentlist_fun[$i1.text, new HashSet<String>(), imp]
      {
          if (!this.program.hasSubprogram($i1.text)) {
              this.errorNotifier.notifyError($i1, "undeclared_subprogram");
          } else if (!$i1.text.equals($i2.text)) {
              this.errorNotifier.notifyError($i2, "missmatch_subroutine_name");
          } else {
              Subprogram declaredFunc = this.program.getSubprogram($i1.text);

              if (!declaredFunc.getReturnType().equals($type.val)) {
                  this.errorNotifier.notifyError($i1, "return_type_missmatch");
              }

              if (!declaredFunc.getParams().equals($fParams.paramlist_s)) {
                  this.errorNotifier.notifyError($i1, "signature_missmatch_in_implementation");
              }

              declaredFunc.addImplementation(imp);
          }
      }
    ;


sentlist_fun[String funName, Set<String> refParams, ProgramBody imp]
    : IDENT '=' exp[$refParams] SEMI
        {if ($funName.equals($IDENT.text))
            $imp.addSentencie(new Sentencie("return "+$exp.val+";"));
         else {
            String prefix = $refParams.contains($IDENT.text) ? "*" : "";
            $imp.addSentencie(new Sentencie(prefix+$IDENT.text+" = "+$exp.val+";"));
         }}
      sentlist_fun_p[$funName, $refParams, $IDENT.text, $imp]
    | proc_call[$refParams] SEMI
        {$imp.addSentencie(new Sentencie($proc_call.val));}
      sentlist_fun[$funName, $refParams, $imp]
    |
    IF '(' expcond[$refParams] ')' if_body[$refParams]
        {ConditionSentencie sent = new ConditionSentencie("if ("+$expcond.val+") ");
         sent.addIfBody($if_body.if);
         sent.addElseBody($if_body.else);
         $imp.addSentencie(sent);
        }
    sentlist_fun[$funName, $refParams, $imp]
    |
    DO loop_body[$refParams]
        {$imp.addSentencie($loop_body.val);}
    sentlist_fun[$funName, $refParams, $imp]
    |
    SELECT CASE '(' exp[$refParams] ')'
        {SelectSentencie sent = new SelectSentencie("switch ("+$exp.val+")");}
    cases[$refParams, sent]
        {$imp.addSentencie(sent);}
    END SELECT
    sentlist_fun[$funName, $refParams, $imp]
    ;


sentlist_fun_p[String funName, Set<String> refParams, String lastName, ProgramBody imp]
    : END FUNCTION IDENT
        {if (!$funName.equals(lastName)) this.errorNotifier.notifyError($END, "bad_return_sentencie");
         if (!$funName.equals($IDENT.text)) this.errorNotifier.notifyError($IDENT, "missmatch_subroutine_name");
        }
    | sentlist_fun[$funName, $refParams, $imp];

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