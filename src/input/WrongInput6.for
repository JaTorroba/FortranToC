PROGRAM miprograma;
INTEGER :: mivar;
INTEGER :: mivar2 = 2;
INTEGER :: mivar2 = -2;
INTEGER :: mivar2 = 4.0;
INTEGER :: mivar2 = -4.0;
INTEGER :: mivar2 = 4e10, mivar3 = 4E10;
INTEGER :: mivar2 = 0.4e10, mivar3 = -0.4E10;

INTERFACE
SUBROUTINE mimetodo (v1, v2) INTEGER, INTENT (IN) v11; END SUBROUTINE mimetodo
FUNCTION mifuncion (v1,v2) INTEGER :: v11;  INTEGER, INTENT (IN) v22; END FUNCTION mifuncion
END INTERFACE

mivar = 4 + (4 - 1);
CALL mimetodo(mivar3, mivar4);
END PROGRAM miprograma

