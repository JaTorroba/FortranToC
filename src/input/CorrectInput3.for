PROGRAM gestion_almacen ;
! --- Configuración inicial ---
INTEGER, PARAMETER :: stock_min = o'12', capacidad = o'144'; ! 10 y 100 en octal
REAL, PARAMETER :: tasa_iva = 0.21;

INTEGER :: items = 50, errores = 0, flags = b'0001';
REAL :: precio_unidad = 15.5, coste_total = 0.0;
CHARACTER(12) :: dpto = 'LOGISTICA';

    INTERFACE
        SUBROUTINE ActualizarStock(cantidad, operacion)
            INTEGER, INTENT(IN) cantidad;
            CHARACTER(12), INTENT(IN) operacion;
        END SUBROUTINE ActualizarStock

        FUNCTION CalcularCosto(n, p)
            REAL :: CalcularCosto;
            INTEGER, INTENT(IN) n;
            REAL, INTENT(IN) p;
        END FUNCTION CalcularCosto
    END INTERFACE

    ! Lógica de negocio
    coste_total = CalcularCosto(items, precio_unidad);

    ! Verificación de stock crítico
    IF ( items < stock_min ) THEN
        CALL ActualizarStock(20, 'REPOSICION');
        flags = b'1011';
    ELSE
        CALL ActualizarStock(0, 'LECTURA');
    ENDIF

    ! Control de errores con IF anidado
    IF ( coste_total > 1000.0 ) THEN
        IF ( .NOT. (items == 0) ) THEN
            errores = errores + 1;
        ENDIF
    ENDIF

END PROGRAM gestion_almacen

SUBROUTINE ActualizarStock(cantidad, operacion)
    INTEGER, INTENT(IN) cantidad;
    CHARACTER(12), INTENT(IN) operacion;
    ! Simulación de actualización
    cantidad = operacion * 2;
END SUBROUTINE ActualizarStock

FUNCTION CalcularCosto(n, p)
    REAL :: CalcularCosto;
    INTEGER, INTENT(IN) n;
    REAL, INTENT(IN) p;
    CalcularCosto = n * p;
END FUNCTION CalcularCosto