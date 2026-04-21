package model;

public class ConditionSentencie extends Sentencie{

    /*
    * This class implements Composite pattern as condition blocks can have a full body of sentencies
    * nested within them, following an implicit tree pattern
    * */
    private final ProgramBody body;

    public ConditionSentencie(){
        super();
        this.body = new ProgramBody();
    }


}
