package model;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

public class Subprogram {
    private final String name;
    private final boolean isFunction;
    private final Map<String, Param> params;
    private final Optional<Type> returnType;

    public Subprogram(String name, Optional<Type> returnType) {
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
