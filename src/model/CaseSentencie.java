package model;

public class CaseSentencie extends Sentencie{

    private ProgramBody body;
    private String value;

    public CaseSentencie(String content) {
        super(content);
    }

    public void addBody(ProgramBody body) {
        this.body = body;
    }

    public ProgramBody getBody() {
        return this.body;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    @Override
    public void generateCode(){
        generateCode(0);
    }

    @Override
    public void generateCode(int indentLevel){
        System.out.println(indent(indentLevel) + this.content);
        this.body.generateCode(indentLevel + 1);
    }



}
