package model;

public class Param {
    private final String name;
    private final ParamType paramType;
    private final Type type;


    public Param(String name, ParamType paramType, Type type){
        this.name = name;
        this.paramType = paramType;
        this.type = type;
    }

    public String getName() {
        return name;
    }

    public ParamType getParamType() {
        return paramType;
    }

    public Type getType() {
        return type;
    }
}
