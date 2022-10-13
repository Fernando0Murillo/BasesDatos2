--FERNANDO LUIS MURILLO CHACON 20141001980
SET SERVEROUTPUT ON

--SELECT * FROM employees;
--SELECT * FROM departments;

/*
--------------------------
    Bloquees Anonimos
--------------------------
*/

--Ejercicio 1

DECLARE
    CURSOR cur_empleados 
    IS 
        SELECT FIRST_NAME, LAST_NAME, SALARY 
        FROM employees;
        v_fname employees.FIRST_NAME%TYPE;
        v_lname employees.LAST_NAME%TYPE;
        v_salry employees.SALARY%TYPE; 
BEGIN
    OPEN cur_empleados;
        LOOP
            FETCH 
                cur_empleados 
            INTO
                v_fname,
                v_lname,
                v_salry;
            IF v_fname = 'Peter' and v_lname = 'Tucker' THEN
                RAISE_APPLICATION_ERROR(-20111,'ACCESO A SALARIO NO AUTORIZADO POR LA GERENCIA');
            ELSE
                DBMS_OUTPUT.PUT_LINE('El empleado '||v_fname||' '||v_lname||' tiene un salario de '||v_salry);
            END IF;
        END LOOP;
    CLOSE cur_empleados;
END;

--Ejercicio 2

DECLARE
    CURSOR cur_contemp
    IS
        SELECT  department_name, Count(*) AS CANTIDAD
        FROM departments dep, employees emp 
        WHERE dep.department_id = emp.department_id
        group by department_name;
    v_dnomb departments.department_name%TYPE;
    v_dnumEmp NUMBER;
BEGIN
    OPEN cur_contemp;
    DBMS_OUTPUT.PUT_LINE('El siguiente listado nos proporciona la cantidad de empleados existentes por departamento:');
        FETCH cur_contemp INTO v_dnomb,v_dnumEmp;
            WHILE cur_contemp%FOUND  
                LOOP
                    DBMS_OUTPUT.PUT_LINE(v_dnomb||' TIENE '||v_dnumEmp||' EMPLEADOS');
                    FETCH cur_contemp 
                    INTO v_dnomb,v_dnumEmp;
                END LOOP;       
    CLOSE cur_contemp;
END;

--Ejercicio 3
--SELECT SALARY FROM employees;

DECLARE
    CURSOR cur_ajustesaly 
    IS
    SELECT * FROM employees for update;
BEGIN
    FOR empl IN cur_ajustesaly LOOP
        IF empl.salary > 8000 THEN
            UPDATE employees SET SALARY = SALARY*1.02 
            WHERE CURRENT OF cur_ajustesaly;
        ELSE
            UPDATE employees SET SALARY = SALARY*1.03 
            WHERE CURRENT OF cur_ajustesaly;
        END IF;
    END LOOP;
    EXCEPTION   
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Err. ninguna fila actualizada');
    COMMIT;
    --ROLLBACK;
END;
/
/*
--------------------------
    Funciones
--------------------------
*/
--Ejercicio 1
--SELECT * FROM regions;
--NO ESTA CORRECTO
CREATE OR REPLACE FUNCTION CREAR_REGION (nom_region VARCHAR) 
RETURN NUMBER
IS
    max_cod number;
    Maximo number;
    reg_exist VARCHAR(25);
BEGIN
    SELECT REGION_NAME INTO reg_exist FROM regions WHERE nom_region = regions.region_name;
    IF reg_exist is NULL THEN
       RAISE_APPLICATION_ERROR(-20011,'YA EXISTE UNA REGION SIMILAR');
       SELECT MAX(REGION_ID) INTO Maximo FROM regions;
       max_cod := Maximo;
       RETURN max_cod;
    ELSE
       SELECT MAX(REGION_ID) INTO Maximo FROM regions;
       max_cod := Maximo +1;
       INSERT INTO regions VALUES(reg_exist,nom_region);
       RETURN max_cod;
    END IF;
    COMMIT;
    --ROLLBACK;
END;

DECLARE
    nombre_region VARCHAR(25) := 'Oceania'; 
    numero_region NUMBER :=0;   
BEGIN
    CREAR_REGION(nombre_region);
    DBMS_OUTPUT.PUT_LINE(
    'LA NUEVA REGION '
    ||nombre_region||
    ' TIENE ASIGNADO EL NUMERO '||
    numero_region);
END;

/*
--------------------------
    Procedimentos
--------------------------
*/
--Ejercicio 1
CREATE OR REPLACE PROCEDURE CALCULADORA (
    v_num1 IN NUMBER,
    v_num2 IN NUMBER,
    op IN varchar2
    )
    IS
    v_res NUMBER := 0; 
    BEGIN
        CASE op
            WHEN '+' THEN          
                v_res := v_num1 + v_num2;
                DBMS_OUTPUT.PUT_LINE('SE SUMARA LOS NUMERO SELECIONADOS');
                DBMS_OUTPUT.PUT_LINE('EL RESULTADO ES: '||v_res);
            WHEN '-' THEN
                v_res := v_num1 - v_num2;
                DBMS_OUTPUT.PUT_LINE('SE RESTARA LOS NUMERO SELECIONADOS');
                DBMS_OUTPUT.PUT_LINE('EL RESULTADO ES: '||v_res);
            WHEN '*' THEN
                v_res := v_num1 * v_num2;
                DBMS_OUTPUT.PUT_LINE('SE MULTIPLICARA LOS NUMERO SELECIONADOS');
                DBMS_OUTPUT.PUT_LINE('EL RESULTADO ES: '||v_res);
            WHEN '/' THEN
                IF v_num2 = 0 THEN
                    DBMS_OUTPUT.PUT_LINE('DIVISION ENTRE ZERO NO VALIDA');
                ELSE
                    v_res := v_num1 / v_num2;
                    DBMS_OUTPUT.PUT_LINE('SE DIVIDIRA LOS NUMERO SELECIONADOS');
                    DBMS_OUTPUT.PUT_LINE('EL RESULTADO ES: '||v_res);
                END IF;
            ELSE
                RAISE_APPLICATION_ERROR(-20031,'LA OPERACION NO ES VALIDA');       
        END CASE;
END CALCULADORA;

DECLARE
    N1 NUMBER :=-3;
    N2 NUMBER :=0;
BEGIN
    CALCULADORA(N1,N2,'/');
END;
/
/*
NO logre agregar una excepcion en la que si se recibe un valor nulo o vacio
envie un RAISE de forma correcta.
*/

--Ejercicio 2
DROP TABLE EMPLOYEES_COPIA

CREATE TABLE
EMPLOYEES_COPIA(
    EMPLOYEE_ID NUMBER (6,0) PRIMARY KEY, 
    FIRST_NAME VARCHAR2(20 BYTE), 
    LAST_NAME VARCHAR2(25 BYTE), 
    EMAIL VARCHAR2(25 BYTE), 
    PHONE_NUMBER VARCHAR2(20 BYTE), 
    HIRE_DATE DATE, 
    JOB_ID VARCHAR2(10 BYTE), 
    SALARY NUMBER(8,2), 
    COMMISSION_PCT NUMBER(2,2), 
    MANAGER_ID NUMBER(6,0), 
    DEPARTMENT_ID NUMBER(4,0)
    
);

SELECT * FROM EMPLOYEES_COPIA;
CREATE OR REPLACE PROCEDURE RELLENO 
    IS
        X NUMBER;
        --COMMIT;
    BEGIN
        INSERT INTO EMPLOYEES_COPIA SELECT * FROM EMPLOYEES;
        --ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Carga Finalizada');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_line('SE A PRODUCIDO UN ERROR');
END;
/    
EXECUTE RELLENO;

/*



--------------------------
    Triggers
--------------------------
*/
--SELECT * FROM departments;

--Ejercicio 1
CREATE OR REPLACE TRIGGER TR1_CHECK
BEFORE INSERT
ON DEPARTMENTS
FOR EACH ROW
DECLARE
    CURSOR CKDEP IS SELECT * FROM DEPARTMENTS;

BEGIN
    FOR i IN CKDEP LOOP
        IF i.DEPARTMENT_ID = :NEW.DEPARTMENT_ID THEN
            RAISE_APPLICATION_ERROR(-20000,'SE A PRODUCIDO UN ERROR');
        ELSIF i.MANAGER_ID IS NULL THEN
            :new.MANAGER_ID := 200;        
        ELSIF i.LOCATION_ID IS NULL THEN
            :new.LOCATION_ID := 1700;            
        ELSE
            DBMS_OUTPUT.PUT_LINE('a');
        END IF;
    END LOOP;
END;
ROLLBACK;
INSERT INTO DEPARTMENTS VALUES(141,'NADA','','');
--Ejercicio 2
CREATE TABLE AUDITORIA ( 
    USUARIO VARCHAR(50), 
    FECHA DATE,
    SALARIO_ANTIGUO NUMBER, 
    SALARIO_NUEVO NUMBER
);

CREATE OR REPLACE TRIGGER TR_STATE
BEFORE INSERT
ON REGIONS

BEGIN

END;