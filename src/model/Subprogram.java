package model;

import java.util.*;

public class Subprogram {
    private final String name;
    private final boolean isFunction;
    private final Map<String, Param> params;
    private final String returnType;
    private final Symbols localSymbols;
    private ProgramBody implementation;
    private final List<String> paramOrder;

    public Subprogram(String name, String returnType, Set<Param> params, List<String> paramOrder) {
        this.name = name;
        this.isFunction = returnType != null;
        this.returnType = returnType;
        this.paramOrder = paramOrder;
        this.params = new HashMap<>();
        this.localSymbols = new Symbols();
        for (Param p : params)
            this.params.put(p.getName(), p);
    }

    public boolean isFunction() {
        return this.isFunction;
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

    public boolean isRefParam(String name) {
        Param p = this.params.get(name);
        if (p == null) return false;
        return p.getParamType().equals("OUT") || p.getParamType().equals("INOUT");
    }

    public boolean isRefParam(int index) {
        if (this.paramOrder == null || index < 0 || index >= this.paramOrder.size()) return false;
        return isRefParam(this.paramOrder.get(index));
    }

    public Set<String> getRefParamNames() {
        Set<String> refNames = new HashSet<>();
        for (Param p : this.params.values()) {
            if (p.getParamType().equals("OUT") || p.getParamType().equals("INOUT")) {
                refNames.add(p.getName());
            }
        }
        return refNames;
    }

    public void generateDeclarationCode() {
        if (this.isFunction)
            System.out.print(returnType+" "+this.name+" ( ");
        else
            System.out.print("void "+this.name+" ( ");
        
        for (int i = 0; i < paramOrder.size(); i++) {
            String pName = paramOrder.get(i);
            Param p = this.params.get(pName);
            if (p != null) {
                String pointer = (p.getParamType().equals("OUT") || p.getParamType().equals("INOUT")) ? "*" : "";
                System.out.print(p.getType() + " " + pointer + p.getName());
                if (i < paramOrder.size() - 1) System.out.print(", ");
            }
        }
        System.out.print(" );");
    }

    public void generateCode() {
        this.generateDeclarationCode();
        System.out.println(" {");

        this.localSymbols.generateVariablesCode(1);

        if (this.implementation != null) this.implementation.generateCode(1);

        System.out.println("}");
    }
}
