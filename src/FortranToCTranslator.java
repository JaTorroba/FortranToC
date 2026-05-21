import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;

import java.io.ByteArrayOutputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintStream;

public class FortranToCTranslator {
    public static void main(String[] args) {
        if (args.length < 1) {
            System.err.println("Usage: java -jar FortranToC.jar <input.for>");
            return;
        }

        PrintStream originalOut = System.out;
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        PrintStream memoryOut = new PrintStream(baos);

        try {
            String inputFileName = args[0];
            String outputFileName = inputFileName.contains(".") 
                    ? inputFileName.substring(0, inputFileName.lastIndexOf('.')) + ".c"
                    : inputFileName + ".c";
            
            // Redirect System.out to memory buffer
            System.setOut(memoryOut);

            // Prepare source file for lexer to use
            CharStream input = CharStreams.fromFileName(inputFileName);
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
            //Start analysis and translation
            parser.prg();

            System.out.flush();

            // If there are no syntax errors, write the output to the file
            if (parser.getNumberOfSyntaxErrors() == 0) {
                try (FileOutputStream fos = new FileOutputStream(outputFileName)) {
                    baos.writeTo(fos);
                }
            } else {
                System.err.println("Translation aborted due to syntax errors. No output file generated.");
            }

        } catch (org.antlr.v4.runtime.RecognitionException e) {
            // Recognision error
            System.err.println("REC " + e.getMessage());
        } catch (IOException e) {
            // I/O error
            System.err.println("IO " + e.getMessage());
        } catch (java.lang.RuntimeException e) {
            // Other
            System.err.println("RUN " + e.getMessage());
        } finally {
            // Restore original System.out and close memory stream
            System.setOut(originalOut);
            memoryOut.close();
        }
    }
}