package model;

public class LoopSentencie extends Sentencie{

    private ProgramBody body;

    public LoopSentencie(String content) {
        super(content);
    }

    public void addBody(ProgramBody body) {
        this.body = body;
    }

    @Override
    public void generateCode() {
        System.out.print(this.content);
        System.out.println(" {");
        this.body.generateCode();
        System.out.println("}");
    }

}
