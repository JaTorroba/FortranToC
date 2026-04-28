package model;

public class Constant {
    private final String value;
    private final String name;

    public Constant(String name, String value) {
        this.value = value;
        this.name = name;
    }

    public String getValue() {
        return value;
    }

    public String getName() {
        return name;
    }

    public void generateCode() {
        System.out.println("#define "+this.name+" "+this.value);
    }
}
