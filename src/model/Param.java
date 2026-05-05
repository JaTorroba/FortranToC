package model;

import java.util.Objects;

public class Param {
    private final String name;
    private final String paramType;
    private final String type;


    public Param(String name, String paramType, String type){
        this.name = name;
        this.paramType = paramType;
        this.type = type;
    }

    public java.lang.String getName() {
        return name;
    }

    public String getParamType() {
        return paramType;
    }

    public String getType() {
        return type;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Param param = (Param) o;
        return Objects.equals(name, param.name) &&
                Objects.equals(paramType, param.paramType) &&
                Objects.equals(type, param.type);
    }

    @Override
    public int hashCode() {
        return Objects.hash(name, paramType, type);
    }
}
