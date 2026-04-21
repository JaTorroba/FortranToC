// Generated from C:/Users/jtm-e/OneDrive - Universidad Rey Juan Carlos/Escritorio/Procesadores de Lenguajes/PRACTICAS/FortranToC/src/FortranToC.g4 by ANTLR 4.13.2
import org.antlr.v4.runtime.tree.ParseTreeVisitor;

/**
 * This interface defines a complete generic visitor for a parse tree produced
 * by {@link FortranToCParser}.
 *
 * @param <T> The return type of the visit operation. Use {@link Void} for
 * operations with no return type.
 */
public interface FortranToCVisitor<T> extends ParseTreeVisitor<T> {
	/**
	 * Visit a parse tree produced by {@link FortranToCParser#prg}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitPrg(FortranToCParser.PrgContext ctx);
	/**
	 * Visit a parse tree produced by {@link FortranToCParser#type}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitType(FortranToCParser.TypeContext ctx);
	/**
	 * Visit a parse tree produced by {@link FortranToCParser#charlength}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCharlength(FortranToCParser.CharlengthContext ctx);
	/**
	 * Visit a parse tree produced by {@link FortranToCParser#numint}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitNumint(FortranToCParser.NumintContext ctx);
	/**
	 * Visit a parse tree produced by {@link FortranToCParser#simpvalue}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSimpvalue(FortranToCParser.SimpvalueContext ctx);
	/**
	 * Visit a parse tree produced by {@link FortranToCParser#init}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitInit(FortranToCParser.InitContext ctx);
	/**
	 * Visit a parse tree produced by {@link FortranToCParser#init_p}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitInit_p(FortranToCParser.Init_pContext ctx);
	/**
	 * Visit a parse tree produced by {@link FortranToCParser#dcllist}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDcllist(FortranToCParser.DcllistContext ctx);
	/**
	 * Visit a parse tree produced by {@link FortranToCParser#dcl}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDcl(FortranToCParser.DclContext ctx);
	/**
	 * Visit a parse tree produced by {@link FortranToCParser#dcl_p}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDcl_p(FortranToCParser.Dcl_pContext ctx);
	/**
	 * Visit a parse tree produced by {@link FortranToCParser#ctelist}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCtelist(FortranToCParser.CtelistContext ctx);
	/**
	 * Visit a parse tree produced by {@link FortranToCParser#defcte}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDefcte(FortranToCParser.DefcteContext ctx);
	/**
	 * Visit a parse tree produced by {@link FortranToCParser#defvar}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDefvar(FortranToCParser.DefvarContext ctx);
	/**
	 * Visit a parse tree produced by {@link FortranToCParser#varlist}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitVarlist(FortranToCParser.VarlistContext ctx);
	/**
	 * Visit a parse tree produced by {@link FortranToCParser#varlist_p}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitVarlist_p(FortranToCParser.Varlist_pContext ctx);
	/**
	 * Visit a parse tree produced by {@link FortranToCParser#header}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitHeader(FortranToCParser.HeaderContext ctx);
	/**
	 * Visit a parse tree produced by {@link FortranToCParser#headlist}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitHeadlist(FortranToCParser.HeadlistContext ctx);
	/**
	 * Visit a parse tree produced by {@link FortranToCParser#decsubprog}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDecsubprog(FortranToCParser.DecsubprogContext ctx);
	/**
	 * Visit a parse tree produced by {@link FortranToCParser#decproc}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDecproc(FortranToCParser.DecprocContext ctx);
	/**
	 * Visit a parse tree produced by {@link FortranToCParser#formal_paramlist}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitFormal_paramlist(FortranToCParser.Formal_paramlistContext ctx);
	/**
	 * Visit a parse tree produced by {@link FortranToCParser#nomparamlist}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitNomparamlist(FortranToCParser.NomparamlistContext ctx);
	/**
	 * Visit a parse tree produced by {@link FortranToCParser#nomparamlist_p}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitNomparamlist_p(FortranToCParser.Nomparamlist_pContext ctx);
	/**
	 * Visit a parse tree produced by {@link FortranToCParser#dec_s_paramlist}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDec_s_paramlist(FortranToCParser.Dec_s_paramlistContext ctx);
	/**
	 * Visit a parse tree produced by {@link FortranToCParser#paramtype}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitParamtype(FortranToCParser.ParamtypeContext ctx);
	/**
	 * Visit a parse tree produced by {@link FortranToCParser#decfun}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDecfun(FortranToCParser.DecfunContext ctx);
	/**
	 * Visit a parse tree produced by {@link FortranToCParser#dec_f_paramlist}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDec_f_paramlist(FortranToCParser.Dec_f_paramlistContext ctx);
	/**
	 * Visit a parse tree produced by {@link FortranToCParser#sentlist}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSentlist(FortranToCParser.SentlistContext ctx);
	/**
	 * Visit a parse tree produced by {@link FortranToCParser#sentlist_p}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSentlist_p(FortranToCParser.Sentlist_pContext ctx);
	/**
	 * Visit a parse tree produced by {@link FortranToCParser#sent}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSent(FortranToCParser.SentContext ctx);
	/**
	 * Visit a parse tree produced by {@link FortranToCParser#sent_if}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSent_if(FortranToCParser.Sent_ifContext ctx);
	/**
	 * Visit a parse tree produced by {@link FortranToCParser#if_body}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitIf_body(FortranToCParser.If_bodyContext ctx);
	/**
	 * Visit a parse tree produced by {@link FortranToCParser#if_body_p}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitIf_body_p(FortranToCParser.If_body_pContext ctx);
	/**
	 * Visit a parse tree produced by {@link FortranToCParser#loop_body}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitLoop_body(FortranToCParser.Loop_bodyContext ctx);
	/**
	 * Visit a parse tree produced by {@link FortranToCParser#doval}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDoval(FortranToCParser.DovalContext ctx);
	/**
	 * Visit a parse tree produced by {@link FortranToCParser#cases}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCases(FortranToCParser.CasesContext ctx);
	/**
	 * Visit a parse tree produced by {@link FortranToCParser#cases_p}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCases_p(FortranToCParser.Cases_pContext ctx);
	/**
	 * Visit a parse tree produced by {@link FortranToCParser#tags}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTags(FortranToCParser.TagsContext ctx);
	/**
	 * Visit a parse tree produced by {@link FortranToCParser#tags_p}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTags_p(FortranToCParser.Tags_pContext ctx);
	/**
	 * Visit a parse tree produced by {@link FortranToCParser#tags_pp}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTags_pp(FortranToCParser.Tags_ppContext ctx);
	/**
	 * Visit a parse tree produced by {@link FortranToCParser#tagslist}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitTagslist(FortranToCParser.TagslistContext ctx);
	/**
	 * Visit a parse tree produced by {@link FortranToCParser#exp}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExp(FortranToCParser.ExpContext ctx);
	/**
	 * Visit a parse tree produced by {@link FortranToCParser#exp_p}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExp_p(FortranToCParser.Exp_pContext ctx);
	/**
	 * Visit a parse tree produced by {@link FortranToCParser#oparit}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitOparit(FortranToCParser.OparitContext ctx);
	/**
	 * Visit a parse tree produced by {@link FortranToCParser#factor}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitFactor(FortranToCParser.FactorContext ctx);
	/**
	 * Visit a parse tree produced by {@link FortranToCParser#proc_call}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitProc_call(FortranToCParser.Proc_callContext ctx);
	/**
	 * Visit a parse tree produced by {@link FortranToCParser#subpparamlist}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSubpparamlist(FortranToCParser.SubpparamlistContext ctx);
	/**
	 * Visit a parse tree produced by {@link FortranToCParser#explist}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExplist(FortranToCParser.ExplistContext ctx);
	/**
	 * Visit a parse tree produced by {@link FortranToCParser#expcond}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExpcond(FortranToCParser.ExpcondContext ctx);
	/**
	 * Visit a parse tree produced by {@link FortranToCParser#expcond_p}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExpcond_p(FortranToCParser.Expcond_pContext ctx);
	/**
	 * Visit a parse tree produced by {@link FortranToCParser#oplog}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitOplog(FortranToCParser.OplogContext ctx);
	/**
	 * Visit a parse tree produced by {@link FortranToCParser#factorcond}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitFactorcond(FortranToCParser.FactorcondContext ctx);
	/**
	 * Visit a parse tree produced by {@link FortranToCParser#opcomp}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitOpcomp(FortranToCParser.OpcompContext ctx);
	/**
	 * Visit a parse tree produced by {@link FortranToCParser#subproglist}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSubproglist(FortranToCParser.SubproglistContext ctx);
	/**
	 * Visit a parse tree produced by {@link FortranToCParser#codproc}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCodproc(FortranToCParser.CodprocContext ctx);
	/**
	 * Visit a parse tree produced by {@link FortranToCParser#codfun}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCodfun(FortranToCParser.CodfunContext ctx);
	/**
	 * Visit a parse tree produced by {@link FortranToCParser#sentlist_fun}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSentlist_fun(FortranToCParser.Sentlist_funContext ctx);
	/**
	 * Visit a parse tree produced by {@link FortranToCParser#sentlist_fun_p}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSentlist_fun_p(FortranToCParser.Sentlist_fun_pContext ctx);
}