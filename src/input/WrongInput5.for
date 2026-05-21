PROGRAM error_case ;
INTEGER :: opcion = 10;

SELECT CASE (opcion)
    CASE (1)
        resultado = 10;
    CASE (2, 3, 4)
        resultado = 20;
    CASE (5 : 10)
        resultado = 30;
    CASE DEFAULT
        resultado = 0;
END SELECT

SELECT CASE (sensor_id)
    CASE (101)
        estado = 1;
    CASE 202
        estado = 0;
    DEFAULT
        estado = -1;
END SELECT

END PROGRAM error_case
