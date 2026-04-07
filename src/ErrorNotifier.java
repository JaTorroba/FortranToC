import org.antlr.v4.runtime.Token;

import java.util.Map;
import java.util.HashMap;


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
    }

    public void notifyError(Token offToken, String msgKey) {
        String template = msgMap.getOrDefault(msgKey, "Syntax error near: '%1$s'");

        // Extraemos el texto del token de forma segura
        String tokenText = (offToken != null) ? offToken.getText() : "missing token";

        // Inyectamos el texto del token en la plantilla
        String msg = String.format(template, tokenText);

        // Notificamos al parser
        parser.notifyErrorListeners(offToken, msg, null);
    }
}
