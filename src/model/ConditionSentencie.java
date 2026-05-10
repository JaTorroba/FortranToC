package model;

public class ConditionSentencie extends Sentencie{

    /*
    * This class implements Composite pattern as condition blocks can have a full body of sentencies
    * nested within them, following an implicit tree pattern
    * */
    private ProgramBody ifBody, elseBody;

    public ConditionSentencie(String content){
        super(content);
    }

    public void addIfBody(ProgramBody body){
        this.ifBody = body;
    }

    public void addElseBody(ProgramBody body){
        this.elseBody = body;
    }

    @Override
    public void generateCode(int indentLevel) {
        System.out.print(indent(indentLevel) + this.content);
        if (this.ifBody != null) {
            System.out.println(" {");
            this.ifBody.generateCode(indentLevel + 1);
            System.out.print(indent(indentLevel) + "}");
        }
        if (this.elseBody != null) {
            System.out.println(" else {");
            this.elseBody.generateCode(indentLevel + 1);
            System.out.print(indent(indentLevel) + "}");
        }
        System.out.println();
    }
}
