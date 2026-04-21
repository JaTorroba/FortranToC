package model;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

public class Symbols {
    private final Map<String, Constant> cte;
    private final Map<String, Variable> var;
    private final Map<String, Subprogram> sub;

    private final Set<String> symbols;

    public Symbols() {
        this.var = new HashMap<>();
        this.cte = new HashMap<>();
        this.sub = new HashMap<>();

        this.symbols = new HashSet<>();
    }

    public boolean symbolIsTaken(String symbol){
        return this.symbols.contains(symbol);
    }

    public void addVar(String name, Variable var) {
        this.var.put(name, var);
        this.symbols.add(name);
    }

    public void addCte(String name, Constant cte) {
        this.cte.put(name, cte);
        this.symbols.add(name);

    }

    public void addSub(String name, Subprogram sub) {
        this.sub.put(name, sub);
        this.symbols.add(name);
    }



}
