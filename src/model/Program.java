package model;

import java.util.*;


public class Program {
    private ProgramBody main;
    private final Map<String, Subprogram> subprograms;
    private final Symbols symbols;
    public static final Program INSTANCE = new Program();


    private Program() {
        this.symbols = new Symbols();
        this.main = new ProgramBody();
        this.subprograms = new HashMap<>();
    }

    public static Program getInstance() {return INSTANCE;}

    public void declareVar(String type, String name, String init, String len) {
        if (this.symbols.symbolIsTaken(name)) {
            throw new IllegalArgumentException("Symbol "+name+" is already taken");
        }
        this.symbols.addVar(name, new Variable(name, type, init, len));
    }

    public void declareCte(String name, String value) {
        if (this.symbols.symbolIsTaken(name)) {
            throw new IllegalArgumentException("Symbol "+name+" is already taken");
        }
        this.symbols.addCte(name, new Constant(name, value));
    }

    public void declareSubprogram(String name, Set<Param> params, String returnType){
        if (this.subprograms.containsKey(name)) {
            throw new IllegalArgumentException("Symbol "+name+" is already taken");
        }
        Subprogram sub = new Subprogram(name, returnType, params);
        this.subprograms.put(name, sub);
    }

    public boolean hasSubprogram(String name) {
        return this.subprograms.containsKey(name);
    }

    public Subprogram getSubprogram(String name) {
        return this.subprograms.get(name);
    }

    public Symbols getSymbols() {return this.symbols;}

    public void addMain(ProgramBody main) {
        this.main = main;
    }

    public void generateCode() {
        for (Constant c : this.symbols.getConstants()) {
            c.generateCode();
        }

        for (Subprogram sub : this.subprograms.values()) {
            sub.generateDeclarationCode();
            System.out.println(";");
        }

        System.out.println("void main (void) {");
        for (Variable v : this.symbols.getVars()) {
            v.generateCode(1);
        }

        this.main.generateCode(1);

        System.out.println("}");

        for (Subprogram sub : this.subprograms.values()) {
            sub.generateCode();
        }
    }


}
