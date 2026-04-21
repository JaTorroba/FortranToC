PROGRAM CompiladorTest ;

! 1. Declaraciones (dcllist) con constantes (defcte) y variables (defvar)
INTEGER , PARAMETER :: MAX_ITER = 100 , MASCARA_BIN = b'1010' ;
REAL :: alpha = 3.1415e-2 , beta = 0.0 ;
CHARACTER(20) :: saludo = "Prueba Lexica" ;
INTEGER :: contador = o'77' , clave_hex = z'A1F' ;

! 2. Cabeceras e Interfaces (header)
INTERFACE
    SUBROUTINE ProcesarDatos ( valor )
        INTEGER , INTENT ( INOUT ) valor ;
    END SUBROUTINE ProcesarDatos

    FUNCTION CalcularArea ( base , altura ) REAL :: CalcularArea ;
        REAL , INTENT ( IN ) base ;
        REAL , INTENT ( IN ) altura ;
    END FUNCTION CalcularArea
END INTERFACE

! 3. Sentencias (sentlist)
! Asignacion y llamada a funcion (expresiones aritmeticas)
beta = CalcularArea ( alpha , 2.5 ) + 10.0 ;

! Llamada a subrutina (proc_call)
CALL ProcesarDatos ( contador ) ;

! Condicional IF con expresiones logicas compuestas
IF ( contador >= 10 .AND. .NOT. .FALSE. ) THEN
    contador = contador - 1 ;
ELSE
    contador = contador + 1 ;
ENDIF

! Bucle DO WHILE con operadores de comparacion
DO WHILE ( alpha /= 0.0 .OR. beta < 100.0 )
    alpha = alpha - 1.0 ;
    beta = beta + 2.5 ;
ENDDO

! Bucle DO indexado con rangos y saltos (doval)
DO i = 1 , MAX_ITER , 2
    CALL ProcesarDatos ( i ) ;
ENDDO

! Sentencia SELECT CASE con multiples tipos de etiquetas (tags)
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

! 4. Definicion de Subprogramas (subproglist)

! Subrutina (codproc)
SUBROUTINE ProcesarDatos ( valor )
    INTEGER , INTENT ( INOUT ) valor ;

    ! sentlist interno
    valor = valor * 2 ;
END SUBROUTINE ProcesarDatos

! Funcion (codfun)
FUNCTION CalcularArea ( base , altura ) REAL :: CalcularArea ;
    REAL , INTENT ( IN ) base ;
    REAL , INTENT ( IN ) altura ;

    ! sentlist_fun (Termina obligatoriamente con la asignacion y el END)
    CalcularArea = base * altura ;
END FUNCTION CalcularArea