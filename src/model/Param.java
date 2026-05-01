package model;

public class Param {
    private final java.lang.String name;
    private final ParamType paramType;
    private final String type;


    public Param(java.lang.String name, ParamType paramType, String type){
        this.name = name;
        this.paramType = paramType;
        this.type = type;
    }

    public java.lang.String getName() {
        return name;
    }

    public ParamType getParamType() {
        return paramType;
    }

    public String getType() {
        return type;
    }
}
