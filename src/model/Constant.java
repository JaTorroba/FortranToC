package model;

public class Constant {
    private final Type type;
    private final String name;

    public Constant(String name, Type type) {
        this.type = type;
        this.name = name;
    }

    public Type getType() {
        return type;
    }

    public String getName() {
        return name;
    }
}
