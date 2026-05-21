import org.antlr.v4.runtime.Token;

import java.util.Map;
import java.util.HashMap;


/*
*@author JaTorroba
*/

public class ErrorNotifier {
    private final FortranToCParser parser;
    private final Map<String, String> msgMap;

    public ErrorNotifier(FortranToCParser parser) {
        this.parser = parser;
        this.msgMap = new HashMap<>();
        this.initializeMapEsp();
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
        this.msgMap.put("bad_return_sentencie", "Missing return sentencie: the returns value for the function must be assigned with the same identifier declared for the subroutine");
        this.msgMap.put("missing_param_declaration", "Not all parameters declared in the signature were typed in the parameter list");
        this.msgMap.put("code_after_return", "Sentencies found after functions' return statement");
        this.msgMap.put("already_declared_param","Theres is already a parameter declared by the name; '%1$s'");
    }

    private void initializeMapEsp(){
        this.msgMap.put("character_typo", "Posible error tipográfico en la declaración del carácter, encontrado: '%1$s', se esperaba: CHARACTER(NUMBER)");
        this.msgMap.put("real_typo", "Posible error tipográfico en la declaración del real, encontrado: '%1$s', se esperaba: REAL");
        this.msgMap.put("integer_typo", "Posible error tipográfico en la declaración del entero, encontrado: '%1$s', se esperaba: INTEGER");
        this.msgMap.put("var_init", "Inicialización de variable incorrecta, encontrado: '%1$s', se esperaba: {NUM_REAL_CONST, NUM_INT_CONST, NUM_INT_CONST_B, NUM_INT_CONST_O, NUM_INT_CONST_H, STRING_CONST}");
        this.msgMap.put("miss_var_init","Falta el valor de inicialización de la variable antes de '%1$s'");
        this.msgMap.put("miss_cond_par", "Faltan '( )' alrededor de la condición, encontrado: '%1$s...', se esperaba: (%1$s...)");
        this.msgMap.put("miss_case_default", "Falta 'CASE' antes de DEFAULT, encontrado: '%1$s', se esperaba: CASE DEFAULT");
        this.msgMap.put("missmatched_value_type", "El tipo declarado para: '%1$s', no corresponde con el valor asignado");
        this.msgMap.put("undeclared_param", "No hay ningún parámetro declarado con el nombre: '%1$s'");
        this.msgMap.put("missmatch_subroutine_name", "El nombre de la subrutina debe ser el mismo en todas las partes de la declaración");
        this.msgMap.put("signature_missmatch_in_implementation", "La implementación de la subrutina: '%1$s' no se corresponde con la firma de la declaración anterior");
        this.msgMap.put("return_type_missmatch", "El tipo de retorno declarado previamente para la función: '%1$s' no coincide con el nuevo tipo proporcionado");
        this.msgMap.put("undeclared_subprogram", "No hay ninguna subrutina declarada con el nombre: '%1$s'");
        this.msgMap.put("symbol_already_taken", "El nombre: '%1$s' ya ha sido asignado a otro símbolo");
        this.msgMap.put("bad_return_sentencie", "Falta la sentencia de retorno: el valor de retorno de la función debe ser asignado con el mismo identificador declarado para la subrutina");
        this.msgMap.put("missing_param_declaration", "No todos los parámetros declarados en la firma tienen su tipo especificado en la lista de parámetros");
        this.msgMap.put("code_after_return", "Se han encontrado sentencias después de la instrucción de retorno de la función");
        this.msgMap.put("already_declared_param","Ya existe un parámetro declarado con el nombre: '%1$s'");
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
