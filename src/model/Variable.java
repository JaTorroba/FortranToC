package model;

public class Variable {
    private final String type;
    private final String name;
    private final String init;
    private final String length;
    private final boolean isChar;

    public Variable(String name, String type, String init, String len){
        this.name = name;
        this.type = type;
        this.init = init;
        this.isChar = !len.isEmpty();
        this.length = len;
    }

    public String getName() {
        return name;
    }

    public String getType() {
        return type;
    }

    public String getInit() {return init;}

    public void generateCode() {
        if (this.isChar)
            System.out.println(this.type+" "+this.name+this.length+" = "+this.init+";");
        else
            System.out.println(this.type+" "+this.name+" = "+this.init+";");

    }

}
