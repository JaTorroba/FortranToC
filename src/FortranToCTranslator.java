import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;


import java.io.IOException;

//TIP To <b>Run</b> code, press <shortcut actionId="Run"/> or
// click the <icon src="AllIcons.Actions.Execute"/> icon in the gutter.
public class FortranToCTranslator {
    public static void main(String[] args) {
        try{
            // Preparar el fichero de entrada para asignarlo al analizador léxico
            CharStream input = CharStreams.fromFileName(args[0]);
            // Crear el objeto correspondiente al analizador léxico con el fichero de
            // entrada
            FortranToCLexer lexer = new FortranToCLexer(input);
            // Identificar al analizador léxico como fuente de tokens para el
            // sintactico
            CommonTokenStream tokens = new CommonTokenStream(lexer);
            // Crear el objeto correspondiente al analizador sintáctico
            FortranToCParser parser = new FortranToCParser(tokens);
            /*
            Si se quiere pasar al analizador algún objeto externo con el que trabajar,
            este deberá ser de una clase del mismo paquete
            Aquí se le llama "sintesis", pero puede ser cualquier nombre.
            NumbersParser anasint = new NumbersParser(tokens, new sintesis());
            */
            /*
            Remove ConsoleErrorListener from Parser
            */
            parser.removeErrorListeners();
            /*
            Add self-made VerboseErrorListener
            */
            parser.addErrorListener(new VerboseErrorListener());
            parser.prg();

        } catch (org.antlr.v4.runtime.RecognitionException e) {
            //Fallo al reconocer la entrada
            System.err.println("REC " + e.getMessage());
        } catch (IOException e) {
            //Fallo de entrada/salida
            System.err.println("IO " + e.getMessage());
        } catch (java.lang.RuntimeException e) {
            //Cualquier otro fallo
            System.err.println("RUN " + e.getMessage());
        }
    }
}