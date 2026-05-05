package model;

import java.util.*;

public class Subprogram {
    private final String name;
    private final boolean isFunction;
    private final Map<String, Param> params;
    private final String returnType;

    public Subprogram(String name, String returnType, Set<Param> params) {
        this.name = name;
        this.isFunction = returnType != null;
        this.returnType = returnType;
        this.params = new HashMap<>();
        for (Param p : params)
            this.params.put(p.getName(), p);
    }

    public boolean hasParam(Param p) {
        return this.params.containsKey(p.getName());
    }

    public void addParam(Param p){
        if (this.params.containsKey(p.getName()))
            throw new IllegalArgumentException("Param "+p.getName()+" already exists for "+this.name);

        this.params.put(p.getName(), p);
    }

    public Set<Param> getParams() {
        return new HashSet<>(this.params.values());
    }

    public String getReturnType() { return this.returnType;}


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
    }
}
