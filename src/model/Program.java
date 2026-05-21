package model;

import java.util.*;


public class Program {
    private ProgramBody main;
    private final Map<String, Subprogram> subprogramMap;
    private final List<Subprogram> subprograms;
    private final Symbols globalSymbols;


    public Program() {
        this.globalSymbols = new Symbols();
        this.main = new ProgramBody();
        this.subprogramMap = new HashMap<>();
        this.subprograms = new LinkedList<>();
    }


    public void declareVar(String type, String name, String init, String len) {
        if (this.globalSymbols.symbolIsTaken(name)) {
            throw new IllegalArgumentException("Symbol "+name+" is already taken");
        }
        this.globalSymbols.addVar(name, new Variable(name, type, init, len));
    }

    public void declareInlineVar(String type, String name, String init, String len) {
        if (this.globalSymbols.symbolIsTaken(name)) {
            throw new IllegalArgumentException("Symbol "+name+" is already taken");
        }
        this.globalSymbols.addInlineVar(new Variable(name, type, init, len));
    }

    public void declareCte(String name, String value) {
        if (this.globalSymbols.symbolIsTaken(name)) {
            throw new IllegalArgumentException("Symbol "+name+" is already taken");
        }
        this.globalSymbols.addCte(name, new Constant(name, value));
    }

    public void declareSubprogram(String name, List<String> paramNames, Set<Param> params, String returnType){
        if (this.subprogramMap.containsKey(name)) {
            throw new IllegalArgumentException("Symbol "+name+" is already taken");
        }
        Subprogram sub = new Subprogram(name, returnType, params, paramNames, this);
        this.subprogramMap.put(name, sub);
        this.subprograms.addLast(sub);
    }

    public boolean hasSubprogram(String name) {
        return this.subprogramMap.containsKey(name);
    }

    public Subprogram getSubprogram(String name) {
        return this.subprogramMap.get(name);
    }

    public Symbols getSymbols() {return this.globalSymbols;}

    public void addMain(ProgramBody main) {
        this.main = main;
    }

    public void generateCode() {
        for (Constant c : this.globalSymbols.getConstants()) {
            c.generateCode();
        }
        System.out.println();
        for (Subprogram sub : this.subprogramMap.values()) {
            sub.generateDeclarationCode();
            System.out.println(";");
        }
        System.out.println();
        System.out.println("void main (void) {");

        this.globalSymbols.generateVariablesCode(1);
        System.out.println();
        this.main.generateCode(1);

        System.out.println("}");
        System.out.println();
        for (Subprogram sub : this.subprograms) {
            sub.generateCode();
            System.out.println();
        }
    }


}
