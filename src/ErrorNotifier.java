import org.antlr.v4.runtime.Token;

import java.util.Map;
import java.util.HashMap;


/*
*@author JaTorroba
*Decorator class for enhanced error notification with personalized messages for error alternatives
*/

public class ErrorNotifier {
    private final FortranToCParser parser;
    private final Map<String, String> msgMap;

    public ErrorNotifier(FortranToCParser parser) {
        this.parser = parser;
        this.msgMap = new HashMap<>();
        this.initializeMap();
    }

    private void initializeMap(){
        this.msgMap.put("character_typo", "Posible typo at character declaration, found: '%1$s', expecting: CHARACTER(NUMBER)");
        this.msgMap.put("real_typo", "Posible typo at real declaration, found: '%1$s', expecting: REAL");
        this.msgMap.put("integer_typo", "Posible typo at integer declaration, found: '%1$s', expecting: INTEGER");
        this.msgMap.put("var_init", "Wrong variable initilization, found: '%1$s', expecting: {NUM_REAL_CONST, NUM_INT_CONST, NUM_INT_CONST_B, NUM_INT_CONST_O, NUM_INT_CONST_H, STRING_CONST}");
        this.msgMap.put("miss_var_init","Missing variable initialization value before '%1$s'");
        this.msgMap.put("miss_cond_par", "Missing '( )' around condition, found: '%1$s...', expecting: (%1$s...)");
        this.msgMap.put("miss_case_default", "Missing 'CASE' before DEFAULT, found: '%1$s', expecting: CASE DEFAULT");
        this.msgMap.put("missmatched_value_type", "Type declared for: '%1$s', does not correspond to the assigned value");
        this.msgMap.put("undeclared_param", "No param declared by the name: '%1$s'");
        this.msgMap.put("missmatch_subroutine_name", "The subroutine's name must be the same in all parts of the declaration");
        this.msgMap.put("signature_missmatch_in_implementation", "The implementation for the subroutine: '%1$s' does not corespond to the previous declaration signature");
        this.msgMap.put("return_type_missmatch", "The return type previously declared for the function: '%1$s' does not match the new given type");
        this.msgMap.put("undeclared_subprogram", "There is no subroutine declared for the name: '%1$s'");
        this.msgMap.put("symbol_already_taken", "The name: '%1$s' has already been assigned to another symbol");
        this.msgMap.put("bad_return_sentencie", "The returns value for the function must be assigned with the same identifier declared for the subroutine");
        this.msgMap.put("missing_param_declaration", "Not all parameters declared in the signature were typed in the parameter list");
    }

    public void notifyError(Token offToken, String msgKey) {
        String template = msgMap.getOrDefault(msgKey, "Syntax error near: '%1$s'");

        // Safely extract text from token
        String tokenText = (offToken != null) ? offToken.getText() : "missing token";

        // Inyect text in the message template
        String msg = String.format(template, tokenText);

        // Notify parser
        parser.notifyErrorListeners(offToken, msg, null);
    }
}
