import org.antlr.v4.runtime.*;

import java.util.Collections;
import java.util.List;

public class VerboseErrorListener extends BaseErrorListener {

    @Override
    public void syntaxError(Recognizer<?, ?> recognizer,
                            Object offendingSymbol,
                            int line,
                            int charPositionInLine,
                            String msg,
                            RecognitionException e) {
        List<String> stack = ((Parser)recognizer).getRuleInvocationStack();
        Collections.reverse(stack);
        Vocabulary vocabulary = recognizer.getVocabulary();
        String symbolicName = vocabulary.getSymbolicName(((Token) offendingSymbol).getType());
        if (symbolicName == null) symbolicName = "missing token";
        System.err.println("Syntax error at: line "+line+":"+charPositionInLine+", recognised token: "+symbolicName+": "+msg);
        System.err.println("rule stack: "+ stack);
        this.underlineError(recognizer, (Token) offendingSymbol, line, charPositionInLine);
        System.err.println("\n"); // Add separation between errors for aesthetic pourpuses

    }

    protected void underlineError(Recognizer<?, ?> recognizer,
                                  Token offendingToken,
                                  int line,
                                  int charPositionInLine) {
        CommonTokenStream tokens = (CommonTokenStream)recognizer.getInputStream();
        String input = tokens.getTokenSource().getInputStream().toString();
        String[] lines = input.split("\n");

        if (line > 0 && line <= lines.length) {
            String errorLine = lines[line - 1];
            System.err.println(errorLine.replace("\t", " ")); // Avoid desadjustments due to tabulations

            // Print spaces until error position
            for (int i = 0; i < charPositionInLine; i++) System.err.print(" ");

            // Draw the exact ^ of the tokens size
            int start = offendingToken.getStartIndex();
            int stop = offendingToken.getStopIndex();
            if (start >= 0 && stop >= 0) {
                for (int i = 0; i <= (stop - start); i++) System.err.print("^");
            }
            System.err.println();
        }
    }

}
