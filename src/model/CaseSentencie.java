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
        System.out.println(this.content);
        this.body.generateCode();
        System.out.println("break;");
    }



}
