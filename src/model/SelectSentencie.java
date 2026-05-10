package model;

import java.util.*;

public class SelectSentencie extends Sentencie{

    private final List<CaseSentencie> casesList;
    private CaseSentencie defaultClause;
    private final Map<String, List<String>> duplicateCases;

    public SelectSentencie(String content) {
        super(content);
        this.casesList = new LinkedList<>();
        this.duplicateCases = new HashMap<>();
    }

    public void addCaseClause(CaseSentencie caseClause){
        this.casesList.addLast(caseClause);
    }

    public void addDefaultClause(CaseSentencie defaultClause) {
        this.defaultClause = defaultClause;
    }

    public void duplicateCaseForVal(String keyCase, String duplicatedCase){
        if (!this.duplicateCases.containsKey(keyCase)) {
            this.duplicateCases.put(keyCase, new LinkedList<>());
        }

        this.duplicateCases.get(keyCase).addLast(duplicatedCase);
    }

    @Override
    public void generateCode() {
        System.out.print(this.content);
        for (CaseSentencie c : this.casesList){
            if (this.duplicateCases.containsKey(c.getValue())) {
                System.out.println(c.content);
                for (String dupCase : this.duplicateCases.get(c.getValue())) {
                    System.out.println("case "+dupCase+":");
                }
                c.getBody().generateCode();
            } else {
                c.generateCode();
            }
        }
    }
}
