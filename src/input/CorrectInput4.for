PROGRAM CompiladorTest ;

INTEGER , PARAMETER :: MAX_ITER = 100 , MASCARA_BIN = b'1010' ;
REAL :: alpha = 3.1415e-2 , beta = 0.0 ;
CHARACTER(20) :: saludo = "Prueba Lexica" ;
INTEGER :: contador = o'77' , clave_hex = z'A1F' ;

INTERFACE
    SUBROUTINE ProcesarDatos ( valor )
        INTEGER , INTENT ( INOUT ) valor ;
    END SUBROUTINE ProcesarDatos

    FUNCTION CalcularArea ( base , altura ) REAL :: CalcularArea ;
        REAL , INTENT ( IN ) base ;
        REAL , INTENT ( IN ) altura ;
    END FUNCTION CalcularArea

    SUBROUTINE EscribirDatos
    END SUBROUTINE EscribirDatos
END INTERFACE

beta = CalcularArea ( alpha , 2.5 ) + 10.0 ;

CALL ProcesarDatos ( contador ) ;

IF ( contador >= 10 .AND. .NOT. .FALSE. ) THEN
    contador = contador - 1 ;
ELSE
    contador = contador + 1 ;
ENDIF

DO WHILE ( alpha /= 0.0 .OR. beta < 100.0 )
    alpha = alpha - 1.0 ;
    beta = beta + 2.5 ;
ENDDO

DO i = 1 , MAX_ITER , 2
    CALL ProcesarDatos ( i ) ;
ENDDO

SELECT CASE ( clave_hex )
    CASE ( 0 )
        contador = 1 ;
    CASE ( 1 , 2 , 3 )
        contador = 2 ;
    CASE ( 10 : 20 )
        contador = 3 ;
    CASE DEFAULT
        contador = -1 ;
END SELECT

END PROGRAM CompiladorTest


SUBROUTINE ProcesarDatos ( valor )
    INTEGER , INTENT ( INOUT ) valor ;

    REAL :: delta = 3.1415e-2 ;
    valor = valor * 2 ;
END SUBROUTINE ProcesarDatos

FUNCTION CalcularArea ( base , altura ) REAL :: CalcularArea ;
    REAL , INTENT ( IN ) base ;
    REAL , INTENT ( IN ) altura ;

    REAL :: delta = 3.1415e-2 ;

    CalcularArea = base * altura ;
END FUNCTION CalcularArea

SUBROUTINE EscribirDatos

    REAL :: delta = 3.1415e-2 ;
    valor = valor * 2 ;
END SUBROUTINE EscribirDatos