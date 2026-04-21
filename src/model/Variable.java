package model;

public class Variable {
    private final Type type;
    private final String name;

    public Variable(String name, Type type){
        this.name = name;
        this.type = type;
    }

    public String getName() {
        return name;
    }

    public Type getType() {
        return type;
    }

}
