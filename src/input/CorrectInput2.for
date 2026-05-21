

PROGRAM test_params ;

INTEGER, PARAMETER :: mask1 = b'1101', mask2 = o'75', mask3 = z'A1B2' ;
INTEGER :: var_in = 10, var_out = 0, var_inout = 5 ;
REAL :: f_result = 0.0 ;

    INTERFACE
        SUBROUTINE ModificarValores ( p_in, p_out, p_inout )
            INTEGER, INTENT(IN) p_in ;
            INTEGER, INTENT(OUT) p_out ;
            INTEGER, INTENT(INOUT) p_inout ;
        END SUBROUTINE ModificarValores
        
        FUNCTION Calcular ( base, mult )
            REAL :: Calcular ;
            INTEGER, INTENT(IN) base ;
            REAL, INTENT(IN) mult ;
        END FUNCTION Calcular
    END INTERFACE

    CALL ModificarValores(var_in, var_out, var_inout) ;
    
    CALL ModificarValores(z'FF', var_out, var_inout) ;

    f_result = Calcular(var_in, 2.5) + Calcular(var_inout, 1.5) ;
    
    var_in = var_out + var_inout ;

END PROGRAM test_params

SUBROUTINE ModificarValores ( p_in, p_out, p_inout )
    INTEGER, INTENT(IN) p_in ;
    INTEGER, INTENT(OUT) p_out ;
    INTEGER, INTENT(INOUT) p_inout ;
    
    p_out = p_in + 1 ;
    p_inout = p_inout * p_in ;
END SUBROUTINE ModificarValores

FUNCTION Calcular ( base, mult )
    REAL :: Calcular ;
    INTEGER, INTENT(IN) base ;
    REAL, INTENT(IN) mult ;
    
    Calcular = base * mult ;
END FUNCTION Calcular
