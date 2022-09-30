/*
    Ejercicio 1
*/
SET SERVEROUTPUT ON

DECLARE
    nombre VARCHAR2(10):= 'jose';
    apellido1 VARCHAR2(10):= 'VALLE';
    apellido2 VARCHAR2(10):= 'Cerrato';  
BEGIN
    DBMS_OUTPUT.put_line (
        UPPER(SUBSTR(nombre,1,1))
        || '.' ||
        UPPER(SUBSTR(apellido1,1,1)) 
        || '.' ||
        UPPER(SUBSTR(apellido2,1,1))
        );
END;

/*
    Ejercicio 2
*/

DECLARE
    n NUMBER:= ROUND(DBMS_RANDOM.VALUE(1,999)); 
    r NUMBER;
BEGIN  
    r := MOD(n,2);
    IF r = 0 THEN
        DBMS_OUTPUT.put_line (n
        || ' ES PAR' );
    ELSE
        DBMS_OUTPUT.put_line (n
        || ' ES IMPAR' );
    END IF;    
END;

/*
    Ejercicio 3
*/
DECLARE 
    max_sal EMPLOYEES.SALARY%TYPE;
BEGIN
    SELECT MAX(SALARY)INTO max_sal
    FROM EMPLOYEES 
    WHERE DEPARTMENT_ID = 100;
    DBMS_OUTPUT.PUT_LINE('El salario maximo del departamento es: ' || max_sal);
END;       

/*
    Ejercicio 4
*/

--SELECT * FROM departments;
--SELECT * FROM employees;

DECLARE
    dept DEPARTMENTS.DEPARTMENT_ID%TYPE;
    dept_nom VARCHAR2(40);
    num_empl NUMBER;
BEGIN
    dept := 10;
    SELECT COUNT(EMPLOYEE_ID) INTO num_empl FROM employees WHERE DEPARTMENT_ID = dept;
    SELECT DEPARTMENT_NAME INTO dept_nom FROM departments WHERE DEPARTMENT_ID = dept;
    DBMS_OUTPUT.PUT_LINE('El nombre del Departamento es '
    ||dept_nom
    ||' y tiene la total cantidad de empleados de '
    ||num_empl);
END;

/*
    Ejercicio 5
*/
DECLARE
    max_salario EMPLOYEES.SALARY%TYPE;
    min_salario EMPLOYEES.SALARY%TYPE;
    dif NUMBER;
BEGIN
    SELECT MAX(SALARY)INTO max_salario FROM EMPLOYEES;
    SELECT MIN(SALARY)INTO min_salario FROM EMPLOYEES;
    dif := (max_salario - min_salario);
    
    DBMS_OUTPUT.PUT_LINE('El salario maximo otorgado es de '
    ||max_salario
    ||', El salario minimo otorgado es de '
    ||min_salario
    ||' y la diferencia entre ambos es de '
    ||dif);
END;

