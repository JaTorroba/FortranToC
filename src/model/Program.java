package model;

import java.util.LinkedList;
import java.util.List;


public class Program {
    private ProgramBody main;
    private List<Subprogram> subprograms;
    private Symbols symbols;


    public Program() {
        this.symbols = new Symbols();
        this.main = new ProgramBody();
        this.subprograms = new LinkedList<>();
    }

    public void declareVar(String name, Type type) {
        if (this.symbols.symbolIsTaken(name)) {
            throw new IllegalArgumentException("Symbol "+name+" is already taken");
        }
        this.symbols.addVar(name, new Variable(name, type));
    }

    public void declareCte(String name, String value) {
        if (this.symbols.symbolIsTaken(name)) {
            throw new IllegalArgumentException("Symbol "+name+" is already taken");
        }
        this.symbols.addCte(name, new Constant(name, value));
    }

    public Symbols getSymbols() {return this.symbols;}


}
