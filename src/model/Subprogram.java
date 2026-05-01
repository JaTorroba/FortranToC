package model;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

public class Subprogram {
    private final java.lang.String name;
    private final boolean isFunction;
    private final Map<java.lang.String, Param> params;
    private final Optional<String> returnType;

    public Subprogram(java.lang.String name, Optional<String> returnType) {
        this.name = name;
        this.isFunction = returnType.isPresent();
        this.returnType = returnType;
        this.params = new HashMap<>();
    }

    public boolean hasParam(Param p) {
        return this.params.containsKey(p.getName());
    }

    public void addParam(Param p){
        if (this.params.containsKey(p.getName()))
            throw new IllegalArgumentException("Param "+p.getName()+" already exists for "+this.name);

        this.params.put(p.getName(), p);
    }
}
