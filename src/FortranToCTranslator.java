import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;


import java.io.IOException;

public class FortranToCTranslator {
    public static void main(String[] args) {
        try{
            // Prepare source file for lexer to use
            CharStream input = CharStreams.fromFileName(args[0]);
            // Create lexer with the input source file
            FortranToCLexer lexer = new FortranToCLexer(input);
            // Identify lexer as tokens source for parser
            CommonTokenStream tokens = new CommonTokenStream(lexer);
            // Create parser
            FortranToCParser parser = new FortranToCParser(tokens);
            // Remove ConsoleErrorListener from Parser
            parser.removeErrorListeners();
            // Add self-made VerboseErrorListener
            parser.addErrorListener(new VerboseErrorListener());
            parser.prg();

        } catch (org.antlr.v4.runtime.RecognitionException e) {
            // Recognision error
            System.err.println("REC " + e.getMessage());
        } catch (IOException e) {
            // I/O error
            System.err.println("IO " + e.getMessage());
        } catch (java.lang.RuntimeException e) {
            // Other
            System.err.println("RUN " + e.getMessage());
        }
    }
}