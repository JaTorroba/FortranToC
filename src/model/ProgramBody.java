package model;

import java.util.LinkedList;
import java.util.List;

public class ProgramBody {
    private final List<Sentencie> sentencies;

    public ProgramBody(){
        this.sentencies = new LinkedList<>();
    }

    public void addSentencie(Sentencie s) {
        this.sentencies.addLast(s);
    }

    public void generateCode() {
        for (Sentencie s : this.sentencies) {
            s.generateCode();
        }
    }
}

