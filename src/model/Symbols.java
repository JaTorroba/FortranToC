package model;

import java.util.*;

public class Symbols {
    private final Map<String, Constant> cte;
    private final Map<String, Variable> var;
    private final Map<String, Subprogram> sub;
    private final Map<Variable, List<Variable>> inlineVariables;

    private Variable lastDeclaredVar;

    private final Set<String> symbols;

    public Symbols() {
        this.var = new HashMap<>();
        this.cte = new HashMap<>();
        this.sub = new HashMap<>();
        this.inlineVariables = new HashMap<>();

        this.symbols = new HashSet<>();
    }

    public boolean symbolIsTaken(String symbol){
        return this.symbols.contains(symbol);
    }

    public void addVar(String name, Variable var) {
        this.var.put(name, var);
        this.symbols.add(name);
        this.lastDeclaredVar = var;
    }

    public void addInlineVar(Variable var) {
        if (!this.inlineVariables.containsKey(lastDeclaredVar)) {
            this.inlineVariables.put(lastDeclaredVar, new LinkedList<>());
        }
        this.symbols.add(var.getName());
        this.inlineVariables.get(lastDeclaredVar).addLast(var);
    }

    public Map<Variable, List<Variable>> getInlineVariables(){ return this.inlineVariables;}

    public void addCte(String name, Constant cte) {
        this.cte.put(name, cte);
        this.symbols.add(name);

    }

    public void addSub(String name, Subprogram sub) {
        this.sub.put(name, sub);
        this.symbols.add(name);
    }

    public Collection<Constant> getConstants() {
        return this.cte.values();
    }

    public Collection<Variable> getVars() {
        return this.var.values();
    }

    public void generateVariablesCode(int indent) {
        for (Variable v : this.var.values()) {
            v.generateCode(indent);

            if (this.inlineVariables.containsKey(v)) {
                System.out.print(", ");
                Iterator<Variable> ite = this.inlineVariables.get(v).iterator();
                while (ite.hasNext()) {
                    Variable inlineV = ite.next();
                    inlineV.generateInlineCode(!ite.hasNext());
                }
            }

            System.out.println(";");
        }
    }


}
