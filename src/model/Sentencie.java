package model;

import java.util.LinkedList;
import java.util.List;

public class Sentencie {

    protected final String content;

    public Sentencie(String content) {
        this.content = content;
    }

    protected String indent(int level) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < level; i++) sb.append("\t");
        return sb.toString();
    }

    public void generateCode() {
        generateCode(0);
    }

    public void generateCode(int indentLevel) {
        System.out.println(indent(indentLevel) + content);
    }
}
