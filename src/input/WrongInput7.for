PROGRAM test7;
    INTEGER :: res;
    
    INTERFACE
        SUBROUTINE proc1 ( a, b )
            INTEGER, INTENT(IN) a;
        END SUBROUTINE proc1
        
        FUNCTION func1 ( x, y ) INTEGER :: func1;
            INTEGER, INTENT(IN) x;
            INTEGER, INTENT(IN) y;
        END FUNCTION func1
    END INTERFACE
    
    CALL proc1(1, 2);
    res = func1(1, 2);
END PROGRAM test7

SUBROUTINE proc1 ( a, b )
    INTEGER, INTENT(IN) a;
    INTEGER, INTENT(IN) b;
    a = b;
END SUBROUTINE proc1

FUNCTION func1 ( x ) INTEGER :: func1;
    INTEGER, INTENT(IN) x;

    INTEGER :: bad;
    bad = x;

END FUNCTION func1
