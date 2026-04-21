package model;

import java.util.LinkedList;
import java.util.List;

public abstract class Sentencie {
    protected List<Expression> exp;

    public Sentencie(){
        this.exp = new LinkedList<>();
    }
}
