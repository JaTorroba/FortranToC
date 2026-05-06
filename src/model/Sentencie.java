package model;

import java.util.LinkedList;
import java.util.List;

public class Sentencie {

    protected final String content;

    public Sentencie(String content) {
        this.content = content;
    }

    public void generateCode() {
        System.out.println(content);
    }
}
