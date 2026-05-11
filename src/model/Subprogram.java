package model;

import java.util.*;

public class Subprogram {
    private final String name;
    private final boolean isFunction;
    private final Map<String, Param> params;
    private final String returnType;
    private final Symbols localSymbols;
    private ProgramBody implementation;

    public Subprogram(String name, String returnType, Set<Param> params) {
        this.name = name;
        this.isFunction = returnType != null;
        this.returnType = returnType;
        this.params = new HashMap<>();
        this.localSymbols = new Symbols();
        for (Param p : params)
            this.params.put(p.getName(), p);
    }

    public Set<Param> getParams() {
        return new HashSet<>(this.params.values());
    }

    public String getReturnType() { return this.returnType;}

    public void declareLocalVar(String type, String name, String init, String len) {
        Symbols globalSymbols = Program.getInstance().getSymbols();
        if (globalSymbols.symbolIsTaken(name) || localSymbols.symbolIsTaken(name)) {
            throw new IllegalArgumentException("Symbol "+name+" is already taken");
        }
        this.localSymbols.addVar(name, new Variable(name, type, init, len));
    }

    public void declareInlineLocalVar(String type, String name, String init, String len) {
        Symbols globalSymbols = Program.getInstance().getSymbols();
        if (globalSymbols.symbolIsTaken(name) || localSymbols.symbolIsTaken(name)) {
            throw new IllegalArgumentException("Symbol "+name+" is already taken");
        }
        this.localSymbols.addInlineVar(new Variable(name, type, init, len));
    }

    public void addImplementation(ProgramBody imp) {
        this.implementation = imp;
    }

    public void generateDeclarationCode() {
        if (this.isFunction)
            System.out.print(returnType+" "+this.name+" (");
        else
            System.out.print("void "+this.name+" (");
        Iterator<Param> ite = this.params.values().iterator();
        while (ite.hasNext()) {
            Param p = ite.next();
            System.out.print(p.getType() + " " + p.getName());
            if (ite.hasNext()) System.out.print(", ");
        }
        System.out.print(")");
    }

    public void generateCode() {
        this.generateDeclarationCode();
        System.out.println(" {");

        this.localSymbols.generateVariablesCode(1);

        if (this.implementation != null) this.implementation.generateCode(1);

        System.out.println("}");
    }
}
