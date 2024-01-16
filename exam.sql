-- Ch2. ��������
-- #1. ������ ���� ������ ���̺��� �����غ���
CREATE TABLE orders(
    order_id        NUMBER(12,0),
    order_date      DATE,
    order_mode      VARCHAR2(8 byte),
    customer_id     NUMBER(6,0),
    order_status    NUMBER(2,0),
    order_total     NUMBER(8,2) DEFAULT 0,
    sales_rep_id    NUMBER(6,0),
    promotion_id    NUMBER(6,0),
        CONSTRAINTS  order_id PRIMARY KEY (order_id),
        CONSTRAINTS ck_order_mode CHECK (order_mode IN ('direct', 'online'))
);

-- �������� Ȯ��
SELECT constraint_name, constraint_type, table_name, search_condition
    FROM user_constraints
    WHERE table_name = 'ORDERS';
    
--==================================================================

-- #2. ������ ���� ������ ���̺��� �����غ���.
CREATE TABLE ORDER_ITEMS(
    order_id        NUMBER(12,0),
    line_item_id    NUMBER(3,0),
    product_id      NUMBER(3,0),
    unit_price      NUMBER(8,2) DEFAULT 0,
    quantity        NUMBER(8,0) DEFAULT 0,
        CONSTRAINTS pk_order_items PRIMARY KEY (order_id, line_item_id)
);

-- �������� Ȯ��
SELECT constraint_name, constraint_type, table_name, search_condition
    FROM user_constraints
    WHERE table_name = 'ORDER_ITEMS';
    
--==================================================================

-- #3. ������ ���� ������ ���̺��� �����غ���.
CREATE TABLE promotions(
    promo_id NUMBER(6,0),
    promo_name VARCHAR2(20),
        CONSTRAINTS pk_promotions PRIMARY KEY(promo_id)
);

-- �������� Ȯ��
SELECT constraint_name, constraint_type, table_name, search_condition
    FROM user_constraints
    WHERE table_name = 'PROMOTIONS';
    
--==================================================================

-- #4. FLOAT���� ��ȣ �ȿ� �����ϴ� ���� ������ ���� �ڸ������ �ߴ�.
-- FLOAT(126)�� ��� 126*0.30103 = 37.92978�� �Ǿ� NUMBER Ÿ���� 38 �ڸ��� ����.
-- �׷��� �� 0.30103�� ���ϴ��� ������ ����.
-- �亯 : �������� �������� ��ȯ�ϴ� ���̴�. 10���� �������� log(2)�� ���� �ٷ� 0.30103�̴�.
-- ��, 10���� 0.30103 ������ �ϸ� 2�� ������ ���̴�.

--==================================================================

-- #5. �ּڰ� 1, �ִ� 99999999, 1000���� �����ؼ� 1�� �����ϴ� ORDERS_SEQ��� �������� ����� ����.
CREATE SEQUENCE order_seq
    INCREMENT BY 1
    START WITH 1000
    MINVALUE 1
    MAXVALUE 99999999
    NOCYCLE
    NOCACHE;
-- ������ ����
INSERT INTO orders(order_id) VALUES(order_seq.NEXTVAL);
-- ���� �� ���� ���� Ȯ��
SELECT order_seq.CURRVAL
    FROM DUAL;
SELECT order_seq.NEXTVAL
    FROM DUAL;
    
--==================================================================
--==================================================================
-- Ch3. ��������(122p)
-- #1. 'ex3_6' ���̺� ����
--     ������ ��� : 124, �޿� : 2000 ~ 3000 ������ �����
--     ���, �����, �޿�, ������ ���
CREATE TABLE ex3_6(
    employee_id NUMBER(6,0),
    emp_name    VARCHAR2(80),
    salary      NUMBER(8,2),
    manager_id  NUMBER(6,0)
);

SELECT e.employee_id,e.emp_name, e.salary, e.manager_id
        FROM employees e
        WHERE manager_id = 124
            AND salary BETWEEN 2000 AND 3000
        ORDER BY e.employee_id
        ;

INSERT INTO ex3_6(employee_id, emp_name, salary, manager_id)
    SELECT e.employee_id, e.emp_name, e.salary, e.manager_id
        FROM employees e
        WHERE e.manager_id = 124
            AND e.salary BETWEEN 2000 AND 3000
    ;

DELETE ex3_6;

SELECT * FROM ex3_6;

--==================================================================
-- #2. ���� ������ �����϶�
DELETE ex3_3;

INSERT INTO ex3_3(employee_id)
    SELECT e.employee_id
    FROM employees e, sales s
    WHERE e.employee_id = s.employee_id
        AND s.SALES_MONTH BETWEEN '200010' AND '200012'
    GROUP BY e.employee_id
    ;
COMMIT;

SELECT * FROM ex3_3;

/*
 - manager_id = 145�� ����� ����� �� ���̺� �ִ� ����� ����� ��ġ�ϸ�
   ���ʽ�(bonus_amt) = �޿��� 0.01(1%) ����
   ��ġ���� ������, ���ʽ� = �޿��� 0.005(0.5%) �ű� �Է�
   
   ���̺� : ex3_3, employees
   �÷� : manager_id, employee_id, bonus_amt, salary
   manager_id = 145
   
   ex3_3.employee_id = employees.employee_id
   MATCHED �� bonus_amt = bonus_amt + salary * 0.01
   NOT MATCHED �� bonus_amt = bonus_amt + salary * 0.005
*/


-- ex3_3 ���̺� �ִ� ��� �� ������ ��� 145�� ����� ���ʽ� �޿�(1%)
SELECT employee_id, manager_id, salary, salary*0.01 AS bonus_amt
    FROM employees
    WHERE employee_id IN (SELECT employee_id FROM ex3_3)
        AND manager_id = 145
    ;

-- ex3_3 ���̺� ���� ����� ������ ��� 145�� ����� ���ʽ� �޿�(0.5%)
SELECT employee_id, manager_id, salary, salary*0.005 AS bonus_amt
    FROM employees
    WHERE employee_id NOT IN (SELECT employee_id FROM EX3_3)
        AND manager_id = 145
    ;
    
-- MERGE ������ �ۼ�
MERGE INTO ex3_3 x
    USING (SELECT employee_id, salary
        -- ����(104p)������ select�ϴ� �÷� ���뿡 manager_id�� ������,
        -- SELECT employee_id, salary, manager_id
        -- ���� ��ü�� 'manager_id = 145' �̹Ƿ� ���� �߰����� �ʾƵ� ��
            FROM employees
            WHERE manager_id = 145) e
    ON (x.employee_id = e.employee_id)
    
WHEN MATCHED THEN
    UPDATE SET x.bonus_amt = x.bonus_amt + e.salary*0.01
    
WHEN NOT MATCHED THEN
    INSERT (x.employee_id, x.bonus_amt)
        VALUES(e.employee_id, e.salary*0.005)
;

SELECT * FROM ex3_3;

--==================================================================

-- #3. ��� ���̺��� Ŀ�̼� ���� ���� ����� ����� ������� �����϶�.
-- 1) �����ϴ� ���� �ۼ� �� SELECT
-- 2) ���̺� : employees
--    �÷� : commission_pct, employee_id, emp_name
--    ���� : commission_pct IS NULL

SELECT employee_id, emp_name
    FROM employees
    WHERE commission_pct IS NULL
;

--==================================================================

-- #4. �Ʒ��� ������ �� �����ڷ� ��ȯ�غ���.
SELECT employee_id, salary
    FROM employees
    WHERE salary BETWEEN 2000 AND 2500
    ORDER BY employee_id
;

-- �� �����ڷ� ��ȯ
SELECT employee_id, salary
    FROM employees
    WHERE salary >= 2000
        AND salary <= 2500
    ORDER BY employee_id
;

--==================================================================
--#5. ������ �� ������ ANY, ALL�� ����ؼ� ������ ����� �����ϵ��� �����϶�.
--      (�����ǽ� ANY, ALL)
/*
�÷��� (�񱳿�����) ANY(��1, ��2, ��3)
�÷��� (�񱳿�����) ALL(��1, ��2, ��3)
*/

-- ���� 1
SELECT employee_id, salary              -- �����ȣ, �޿���ȸ
    FROM employees                      -- ��� ���̺�κ���
    WHERE salary IN (2000, 3000, 4000)  -- �޿��� 2000, 3000, 4000 ���� ���ԵǸ�
    ORDER BY employee_id                -- �����ȣ�� ����
;

-- ���� 1 : ANY ���
SELECT employee_id, salary
    FROM employees
    WHERE salary = ANY(2000, 3000, 4000)
    ORDER BY employee_id
;

-- ���� 1 : OR ���
SELECT employee_id, salary
    FROM employees
    WHERE salary = 2000 OR salary = 3000 OR salary = 4000
;

-- ���� 2
SELECT employee_id, salary                  -- �����ȣ, �޿���ȸ
    FROM employees                          -- ��� ���̺�κ���
    WHERE salary NOT IN (2000, 3000, 4000)  -- �޿��� 2000, 3000, 4000 ���� ���� �ȵǸ�
    ORDER BY employee_id                    -- �����ȣ�� ����
;

-- ���� 2 : ALL ���
SELECT employee_id, salary
    FROM employees
    WHERE salary != ALL(2000, 3000, 4000)
    ORDER BY employee_id
;

-- ���� 2: AND ���
SELECT employee_id, salary
    FROM employees
    WHERE salary != 2000 AND salary != 3000 AND salary != 4000
;

--==================================================================
--==================================================================
-- Ch4. ��������(150p)
-- #1. ��ȭ��ȣ�� ó�� �� �ڸ� ���� ��� ���� ���� ��ȣ�� '(02)'�� �ٿ� ��ȭ��ȣ�� ���
/*
1. ���̺�
 : employees
2. �÷�
 : phone_number
3. ###.###.#### �� ###.#### �� (02)###.####
*/

-- ���1> ���ڿ����� ||
-- '(02)' + || + SUBSTR(phone_number, 5, 12)
SELECT SUBSTR(phone_number, 5, 12)
    FROM employees;

SELECT employee_id, '(02)' || SUBSTR(phone_number, 5, 12) AS phone_number
    FROM employees;
    
-- ���2> LPAD
SELECT phone_number
        , LPAD(SUBSTR(phone_number, 5, 12), 12, '(02)')
    FROM employees;

-- ���3> CONCAT
-- ������ ���
SELECT employee_id
        , CONCAT('(02)', SUBSTR(phone_number, 5, 12))
    FROM employees;

SELECT employee_id
       , CONCAT('(02)', LTRIM(phone_number, SUBSTR(phone_number, 1, 3)))
    FROM employees;

-- ���4>REPLACE
SELECT employee_id
       , REPLACE(phone_number, SUBSTR(phone_number, 1, 4), '(02)')
    FROM employees;
    
---- LTRIM
---- �� ���ڸ� ���� ��ȸ
--SELECT employee_id, SUBSTR(phone_number, 1, 3)
--    FROM employees;
---- �� ���ڸ� ���� ����
--SELECT employee_id
--        , LTRIM(phone_number, SUBSTR(phone_number, 1, 3)) AS phone_number
--    FROM employees;
---- �տ� (02) ���̱�
---- SUBSTR(phone_number, 1, 4)�� �ϸ� �̻��ϰ� ����
---- LTRIM : ������ ���� �����ִ� ��ɵ� �־ �� ��������. ���� �� ���������� �������� �Լ���.

--==================================================================

/*
[���� #2]
 : �������ڸ� �������� ��� ���̺��� �Ի�����(hire_date)�� �����ؼ�
   �ټӳ���� 10�� �̻��� ����� ������ ���� ������ ����� ����ϵ��� ������ �ۼ��϶�.
   (�ټӳ���� ���� ��� ������� ��� ���)
1. ���̺�
 : employees
 
2. ��� �÷�
 : employee_id
   , hire_date
   
3. ����� �÷�
 : employee_id
   , emp_name
   , hire_date
   , service_years   -- �ټӳ��, ���� �ʿ�

-- �ټӳ���� ���� ��� ������� ���
ORDER BY service_years DESC;

*/

-- �ټӳ�� : ROUND((�������� - hire_date)/365)
--365��/365�� = 1��
--500��/365 = 1.xxx�� �� �Ҽ��� ����(FLOOR/TRUNC) / �ø�(CEIL) / �ݿø�(ROUND)
--730��/365 = 2��

-- �ټӳ�� ��ȸ
SELECT ROUND((SYSDATE - hire_date)/365) AS �ټӳ��
    FROM employees
    WHERE TO_CHAR(SYSDATE - hire_date) >= 10
    ORDER BY �ټӳ�� DESC;

-- ���
SELECT employee_id
        , emp_name
        , TO_CHAR(hire_date, 'YYYY-MM-DD') AS hire_date
        , ROUND((SYSDATE - hire_date)/365) AS �ټӳ��
    FROM employees
    WHERE TO_CHAR(SYSDATE - hire_date) >= 10
    ORDER BY �ټӳ�� DESC;

--==================================================================
/*
[���� #3]
 : �����̺�(CUSTOMERS)�� �� ��ȭ��ȣ(cust_main_phone_number)�÷��� �ִ�.
   �� �÷� ���� '###-###-####' �����ε�,
   '-' ��� '/'�� �ٲ� ����ϴ� ������ �ۼ��϶�.
1. ���̺�
 : CUSTOMERS
2. ����� �÷�
 : cust_main_phone_number
*/
SELECT cust_id, REPLACE(CUST_MAIN_PHONE_NUMBER, '-', '/')
        as new_phone_number
    FROM CUSTOMERS;

--==================================================================

/*
[���� #4]
 : �� ���̺�(CUSTOMERS)�� �� ��ȭ��ȣ(CUST_MAIN_PHONE_NUMBER)�÷���
   �ٸ� ���ڷ� ��ü(������ ��ȣȭ)�ϵ��� ������ �ۼ��϶�.
   0123456789 => hellothank
1. ���̺�
 : CUSTOMERS
2. ����� �÷�
 : CUST_MAIN_PHONE_NUMBER
 
��ü(������ ��ȣȭ)        => TRANSLATE
������ �ۼ�               => SELECT? UPDATE?
*/
SELECT CUST_ID
        , CUST_MAIN_PHONE_NUMBER
        , TRANSLATE(CUST_MAIN_PHONE_NUMBER, '0123456789', 'abcdefghij')
            AS trans_phone_number
    FROM CUSTOMERS;
COMMIT;
ROLLBACK;

UPDATE CUSTOMERS
    SET CUST_MAIN_PHONE_NUMBER
        = TRANSLATE(CUST_MAIN_PHONE_NUMBER, '0123456789', 'abcdefghij')
;

UPDATE CUSTOMERS
    SET CUST_MAIN_PHONE_NUMBER
        = TRANSLATE(CUST_MAIN_PHONE_NUMBER, 'hellothank', 'abcdefghij')
;

--==================================================================

/*
[���� #5]
 : �� ���̺�(CUSTOMERS)���� ���� ����⵵(CUST_YEAR_OF_BIRTH)�÷��� �ִ�.
   �������� �������� �� �÷��� Ȱ���� 30��, 40��, 50�븦 ������ ����ϰ�,
   ������ ���ɴ�� '��Ÿ'�� ����ϴ� ������ �ۼ��϶�.
1. ���̺�
 : CUSTOMERS
2. ����� �÷�
 : CUST_NAME, CUST_YEAR_OF_BIRTH
 
-- ���� ���ϱ�
���� = �������� - CUST_YEAR_OF_BIRTH
cust_age = TRUNC(sysdate - CUST_YEAR_OF_BIRTH)
*/
-- �� ����
SELECT TRUNC((TO_CHAR(SYSDATE, 'YYYY') - CUST_YEAR_OF_BIRTH)/10) AS cust_age
    FROM CUSTOMERS;

-- ���ɴ� ����(DECODE)
-- DECODE�� �������� ��� �Ұ���
-- DECODE�� ��/������ �Ǻ��ϹǷ� '����/10'�� ��, ���ڸ������� ��/���� �Ǻ�
--  �� ex) TRUNC(94��/10) = TRUNC(9.4) = 9
SELECT CUST_NAME
       , TO_CHAR(SYSDATE, 'YYYY')- CUST_YEAR_OF_BIRTH AS cust_age
       , DECODE( TRUNC((TO_CHAR(SYSDATE, 'YYYY') - CUST_YEAR_OF_BIRTH)/10 )
            , 3, '30��'
            , 4, '40��'
            , 5, '50��', '��Ÿ') AS generation
    FROM CUSTOMERS;

--==================================================================

/*
[���� #6]
 : ����#5�� ���ɴ븦 ��� ���ɴ븦 ǥ���ϵ��� ���� �ۼ�
   CASE ǥ���� ���
1. ���̺�
 : CUSTOMERS
2. ����� �÷�
 : CUST_NAME, CUST_YEAR_OF_BIRTH
 
-- ���� ���ϱ�
���� = �������� - CUST_YEAR_OF_BIRTH
���� = TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY') - CUST_YEAR_OF_BIRTH)
*/

-- ���1> BETWEEN AND ���
SELECT CUST_NAME
        , TRUNC(TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')) - CUST_YEAR_OF_BIRTH) AS cust_age
        , CASE WHEN  TRUNC((TO_CHAR(SYSDATE, 'YYYY') - CUST_YEAR_OF_BIRTH))
                < 10
                    THEN '10�� �̸�'
            WHEN TRUNC((TO_CHAR(SYSDATE, 'YYYY') - CUST_YEAR_OF_BIRTH))
                BETWEEN 10 AND 19
                    THEN '10��'
            WHEN TRUNC((TO_CHAR(SYSDATE, 'YYYY') - CUST_YEAR_OF_BIRTH))
                BETWEEN 20 AND 29
                    THEN '20��'
            WHEN TRUNC((TO_CHAR(SYSDATE, 'YYYY') - CUST_YEAR_OF_BIRTH))
                BETWEEN 30 AND 39
                    THEN '30��'
            WHEN TRUNC((TO_CHAR(SYSDATE, 'YYYY') - CUST_YEAR_OF_BIRTH))
                BETWEEN 40 AND 49
                    THEN '40��'
            WHEN TRUNC((TO_CHAR(SYSDATE, 'YYYY') - CUST_YEAR_OF_BIRTH))
                BETWEEN 50 AND 59
                    THEN '50��'
            WHEN TRUNC((TO_CHAR(SYSDATE, 'YYYY') - CUST_YEAR_OF_BIRTH))
                >= 60
                    THEN '60�� �̻�'
            END AS generation
    FROM CUSTOMERS;

-- ���2> = ���
SELECT CUST_NAME
       , TO_CHAR(SYSDATE, 'YYYY')- CUST_YEAR_OF_BIRTH AS cust_age
       , CASE WHEN TRUNC((TO_CHAR(SYSDATE, 'YYYY') - CUST_YEAR_OF_BIRTH)/10) = 1
                THEN '10��'
            WHEN TRUNC((TO_CHAR(SYSDATE, 'YYYY') - CUST_YEAR_OF_BIRTH)/10) = 2
                THEN '20��'
            WHEN TRUNC((TO_CHAR(SYSDATE, 'YYYY') - CUST_YEAR_OF_BIRTH)/10) = 3
                THEN '30��'
            WHEN TRUNC((TO_CHAR(SYSDATE, 'YYYY') - CUST_YEAR_OF_BIRTH)/10) = 4
                THEN '40��'
            WHEN TRUNC((TO_CHAR(SYSDATE, 'YYYY') - CUST_YEAR_OF_BIRTH)/10) = 5
                THEN '50��'
            WHEN TRUNC((TO_CHAR(SYSDATE, 'YYYY') - CUST_YEAR_OF_BIRTH)/10) = 6
                THEN '60��'
            WHEN TRUNC((TO_CHAR(SYSDATE, 'YYYY') - CUST_YEAR_OF_BIRTH)/10) = 7
                THEN '70��'
            ELSE '��Ÿ'
            END AS generation
    FROM CUSTOMERS;

-- ���3> LIKE ���
SELECT CUST_NAME
       , TO_CHAR(SYSDATE, 'YYYY')- CUST_YEAR_OF_BIRTH AS cust_age
       , CASE WHEN TRUNC(TO_CHAR(SYSDATE, 'YYYY') - CUST_YEAR_OF_BIRTH)
                LIKE '1%' THEN '10��'
            WHEN TRUNC(TO_CHAR(SYSDATE, 'YYYY') - CUST_YEAR_OF_BIRTH)
                LIKE '2%' THEN '20��'
            WHEN TRUNC(TO_CHAR(SYSDATE, 'YYYY') - CUST_YEAR_OF_BIRTH)
                LIKE '3%' THEN '30��'
            WHEN TRUNC(TO_CHAR(SYSDATE, 'YYYY') - CUST_YEAR_OF_BIRTH)
                LIKE '4%' THEN '40��'
            WHEN TRUNC(TO_CHAR(SYSDATE, 'YYYY') - CUST_YEAR_OF_BIRTH)
                LIKE '5%' THEN '50��'
            WHEN TRUNC(TO_CHAR(SYSDATE, 'YYYY') - CUST_YEAR_OF_BIRTH)
                LIKE '6%' THEN '60��'
            WHEN TRUNC(TO_CHAR(SYSDATE, 'YYYY') - CUST_YEAR_OF_BIRTH)
                LIKE '7%' THEN '70��'
            ELSE '��Ÿ'
            END AS generation
    FROM CUSTOMERS;

--==================================================================
--==================================================================
-- Ch5. ��������(174p)
/*
[����#1] ��� ���̺��� �Ի�⵵�� ��� ���� ���ϴ� ������ �ۼ��϶�
1. ���̺�
 : employees
2. ��� �÷�
 : hire_date
*/
SELECT TO_CHAR(hire_date, 'YYYY') AS hire_year, COUNT(employee_id) AS emp_cnt
    FROM employees
    GROUP BY TO_CHAR(hire_date, 'YYYY')
    ORDER BY TO_CHAR(hire_date, 'YYYY') DESC
;

--==================================================================
/*
[����#2]
 : kor_loan_status ���̺��� 2012�⵵ ����, ������ ���� �� �ܾ��� ���ϴ� ������ �ۼ��϶�.
1. ���̺�
 : kor_loan_status
2. ��� �÷�
 : period, region, gubun, loan_jan_amt
*/

SELECT period, region, gubun, loan_jan_amt
    FROM kor_loan_status
    WHERE period LIKE '2012%'
    GROUP BY period, region, gubun, loan_jan_amt
    ORDER BY period, region
;


--==================================================================
/*
[����#3]
 : ���� ������ ���� ROLLUP�� ������ ������
   �� ������ ROLLUP�� ������� �ʰ�, ���� �����ڷ� ������ ����� �������� ������ �ۼ��϶�.
 
 period     gubun       totl_jan
 ----------------------------------
 201310     ��Ÿ����      676078
 201310     ���ô㺸����   411415.9
 201310     (null)       1087493.9
 201311     ��Ÿ����      681121.3
 201311     ���ô㺸����   414236.9
 201311     (null)       1095358.2
*/
SELECT period, gubun, SUM(loan_jan_amt) totl_jan
    FROM kor_loan_status
    WHERE period LIKE '2013%'
    GROUP BY period, ROLLUP(gubun);

-- 2013�� 10���� ��Ÿ����+���ô㺸����
-- 2013�� 11���� ��Ÿ����+���ô㺸����
SELECT  period, gubun, SUM(loan_jan_amt) totl_jan
    FROM kor_loan_status
    WHERE period LIKE '2013%'
    GROUP BY period, gubun
UNION
SELECT period, NULL, SUM(loan_jan_amt) totl_jan
    FROM kor_loan_status
    WHERE period LIKE '2013%'
    GROUP BY period
    ORDER BY period
;


--==================================================================
/*
[����#4]
 : ���� ������ ���� ROLLUP�� ������ ������.
   �� ������ ROLLUP�� ������� �ʰ�, ���� �����ڷ� ������ ����� �������� ������ �ۼ��϶�.
   
period      ���ô㺸        ��Ÿ�����
-------------------------------------
201311      0               681121.3
201311      414236.9        0
*/
SELECT period
        , CASE WHEN gubun = '���ô㺸����'
                THEN SUM(loan_jan_amt) ELSE 0 END ���ô㺸�����
        , CASE WHEN gubun = '��Ÿ����'
                THEN SUM(loan_jan_amt) ELSE 0 END ��Ÿ�����
    FROM kor_loan_status
    WHERE period = '201311'
    GROUP BY period, gubun
;

-- ���
SELECT period, 0 AS ���ô㺸�����, SUM(loan_jan_amt) AS ��Ÿ�����
    FROM kor_loan_status
    WHERE period = '201311'
        AND gubun = '��Ÿ����'
    GROUP BY period, gubun
UNION
SELECT period, SUM(loan_jan_amt) AS ���ô㺸�����, 0 AS ��Ÿ�����
    FROM kor_loan_status
    WHERE period = '201311'
        AND gubun = '���ô㺸����'
    GROUP BY period, gubun
;

--==================================================================
/*
[����#5]
 : ������ ���� ����, �� ������ �� ���� ���� �� �ܾ��� ���ϴ� ������ �ۼ��϶�.
 ����     201111  201112  201210  201211  201212  201310  201311
 ----------------------------------------------------------------
 ����
 �λ�
 ...
 ...
*/
-- ������ GROUP BY�� �ߺ�����
SELECT region
    FROM kor_loan_status
    GROUP BY region
;

-- ������ �� ������ ��
SELECT region
     , CASE WHEN period = '201111' THEN loan_jan_amt ELSE 0 END AMT1
     , CASE WHEN period = '201112' THEN loan_jan_amt ELSE 0 END AMT2
     , CASE WHEN period = '201210' THEN loan_jan_amt ELSE 0 END AMT3
     , CASE WHEN period = '201211' THEN loan_jan_amt ELSE 0 END AMT4
     , CASE WHEN period = '201212' THEN loan_jan_amt ELSE 0 END AMT5
     , CASE WHEN period = '201310' THEN loan_jan_amt ELSE 0 END AMT6
     , CASE WHEN period = '201311' THEN loan_jan_amt ELSE 0 END AMT7
    FROM kor_loan_status
    ORDER BY region
;

-- �� ���>Ʋ��(��������)
SELECT S.region ����
        , SUM(loan_jan_amt) AS "201111"
    FROM kor_loan_status S
    GROUP BY S.region
    ORDER BY S.region
;

-- ����, ���� ���� �� �ܾ�
-- ���1> �������� ���
-- �������� �ȿ� �ִ� �����Ϳ� �̹� �ʿ��� ������ ���� ��������Ƿ�,
-- ���� ���̺��� ������� ���ƾ� �Ѵ�.
SELECT  region ����
        , SUM(AMT1) AS "201111"
        , SUM(AMT2) AS "201112"
        , SUM(AMT3) AS "201210"
        , SUM(AMT4) AS "201211"
        , SUM(AMT5) AS "201212"
        , SUM(AMT6) AS "201310"
        , SUM(AMT7) AS "201311"
    FROM  (
            SELECT region
                , CASE WHEN period = '201111' THEN loan_jan_amt ELSE 0 END AMT1
                , CASE WHEN period = '201112' THEN loan_jan_amt ELSE 0 END AMT2
                , CASE WHEN period = '201210' THEN loan_jan_amt ELSE 0 END AMT3
                , CASE WHEN period = '201211' THEN loan_jan_amt ELSE 0 END AMT4
                , CASE WHEN period = '201212' THEN loan_jan_amt ELSE 0 END AMT5
                , CASE WHEN period = '201310' THEN loan_jan_amt ELSE 0 END AMT6
                , CASE WHEN period = '201311' THEN loan_jan_amt ELSE 0 END AMT7
            FROM kor_loan_status
           )
    GROUP BY region
    ORDER BY region
;

-- ���2> �ٷ� SUM ���
SELECT region
        , SUM(CASE WHEN period = '201111' THEN loan_jan_amt ELSE 0 END) "201111"
        , SUM(CASE WHEN period = '201112' THEN loan_jan_amt ELSE 0 END) "201112"
        , SUM(CASE WHEN period = '201210' THEN loan_jan_amt ELSE 0 END) "201210"
        , SUM(CASE WHEN period = '201211' THEN loan_jan_amt ELSE 0 END) "201211"
        , SUM(CASE WHEN period = '201212' THEN loan_jan_amt ELSE 0 END) "201212"
        , SUM(CASE WHEN period = '201310' THEN loan_jan_amt ELSE 0 END) "201310"
        , SUM(CASE WHEN period = '201311' THEN loan_jan_amt ELSE 0 END) "201311"
    FROM kor_loan_status
    GROUP BY region
    ORDER BY region
;

--==================================================================
-- CH6. ��������(205p)
/*
[����#1]
 : 101�� ����� ���� �Ʒ��� ����� �����ϴ� ������ �ۼ��� ����.
 ���     �����     job��Ī   job��������     job��������     job����μ���
*/

[�μ����̺� + ������̺� + ������̺� + �������̺�]
[�μ���ȣ     �μ���ȣ]
             [�����ȣ    �����ȣ]
                         [������ȣ    ������ȣ]

SELECT e.employee_id
        , e.emp_name
        , j.job_title
        , TO_CHAR(jh.start_date, 'YYYY-MM-DD') start_date
        , TO_CHAR(jh.end_date, 'YYYY-MM-DD') end_date
        , d.department_name
    FROM employees e, departments d, job_history jh, jobs j
    WHERE e.employee_id = 101
        AND e.department_id = d.department_id
        AND e.employee_id = jh.employee_id
        AND jh.job_id = j.job_id
;

/*
[����#2]
 : �Ʒ��� ������ �����ϸ� ������ �����Ѵ�. ������ ������ �������� ������ ����.
*/
SELECT a.employee_id, a.emp_name, b.job_id, b.department_id
    FROM employees a
        , job_history b
    WHERE a.employee_id = b.employee_id(+)
        AND a.department_id(+) = b.department_id;

: �ܺ������� 1���� ������

SELECT department_id
    FROM employees
    GROUP BY department_id
    ORDER BY department_id
;
SELECT department_id
    FROM job_history
    GROUP BY department_id
    ORDER BY department_id
;

SELECT a.employee_id, a.emp_name, b.job_id, b.department_id
    FROM employees a
        , job_history b
    WHERE a.employee_id = b.employee_id(+)
        AND a.department_id = b.department_id(+);
        
null�� ���� ���̺�� �ܺ������� �Ǿ���.

/*
[����#3]
 : �ܺ� ������ �� �� (+) �����ڸ� IN �����ڿ� ���� ����� �� ���µ�,
   IN���� ����ϴ� ���� �� ���̸� ����� �� �ִ�.
   �� ������ �������� ������ ����.
*/
<����>
1. �ܺ������� IN�� �Բ� ���� ���,
SELECT e.employee_id, d.department_name
    FROM employees e, departments d
    WHERE d.department_id IN (e.department_id(+), 200)
;
2. ���� �ǹ��� �ڵ�
SELECT e.employee_id, d.department_name
    FROM employees e, departments d
    WHERE d.department_id = e.department_id(+)
        OR d.department_id = 200
        
3. IN���� �����͸� 1���� �ִ� ���, (����)
SELECT e.employee_id, d.department_name
    FROM employees e, departments d
    WHERE d.department_id IN (e.department_id(+))
;

4. 3���� ���� �ǹ��� �ڵ� (����)
SELECT e.employee_id, d.department_name
    FROM employees e, departments d
    WHERE 

SELECT employee_id
    FROM employees
    WHERE department_id IN (10,20,30)
;

SELECT e.employee_id, de.department_name
    FROM employees e, departments d
    WHERE e.department_id(+) = d.department_id
        AND department_id = 10 
        OR department_id = 20
        OR department_id = 30
;

<IN���� ����ϴ� ���� 1���� ���>
SELECT e.employee_id, d.department_name
    FROM employees e, departments d
    WHERE e.department_id(+) = d.department_id
        AND e.department_id IN (10)
;
SELECT e.employee_id, d.department_name
    FROM employees e, departments d
    WHERE e.department_id(+) = d.department_id
        AND e.department_id = 10
;
���� : IN���� ����ϴ� ���� 1���� ���
      �ǹ̻� OR�� ����� ���� �ƴϹǷ� �ܺ����� ����
      
-- �ܺ� ���ν� (+) ��ȣ�� � �÷��� �ٿ��� �ұ�
SELECT department_id
    FROM employees
    GROUP BY department_id
    ORDER BY department_id
;
SELECT department_id
    FROM departments
    GROUP BY department_id
    ORDER BY department_id
;


/*
[����#4]
 : ������ ������ ANSI �������� ������ ����.

*/
SELECT a.department_id, a.department_name
    FROM departments a, employees b
    WHERE a.department_id = b.department_id
        AND b.salary > 3000
    ORDER BY a.department_name
;

-- ANSI ����, ����(����) ����
SELECT d.department_id, d.department_name
    FROM departments d
    INNER JOIN employees e
    ON (d.department_id = e.department_id)  -- ��������
    WHERE e.salary > 3000
    ORDER BY d.department_name
;


/*
[����#5]
 : ������ ������ �ִ� ���� ������. �̸� ������ ���� ���� ������ ��ȯ�غ���.

EXISTS �����ڸ� ����� ��������    => ������ �ִ�(�������� ��)
IN �����ڸ� ����� ��������        => ������ ����(�������� ��)
*/
SELECT a.department_id, a.department_name
    FROM departments a
    WHERE EXISTS (SELECT 1
                        FROM job_history b
                        WHERE a.department_id = b.department_id)
;

SELECT a.department_id, a.department_name
    FROM departments a
    WHERE department_id IN (SELECT department_id
                                FROM job_history)
;


/*
[����#6]
 : ������ ��Ż���� �ִ����װ� ����� �ۼ��ϴ� ������ �н��ߴ�.
   �� ������ �������� �ִ����� �Ӹ� �ƴ϶�
   �ּҸ���װ� �ش� ����� ��ȸ�ϴ� ������ �ۼ��� ����.
*/
-- 2000�� ��Ż���� ��� �����(�����)���� ū ������� �޼��� ���� ��� ������� ��ȸ
SELECT a.*
    FROM (SELECT sales_month, ROUND(AVG(amount_sold)) month_avg
                FROM sales s, countries c, customers cu
                WHERE sales_month BETWEEN 200001 AND 200012
                    AND country_name = 'Italy'
                    AND c.country_id = cu.country_id
                    AND cu.cust_id = s.cust_id
                GROUP BY sales_month
            ) a
         , (SELECT ROUND(AVG(s.amount_sold)) year_avg
                FROM sales s, countries c, customers cu
                WHERE sales_month BETWEEN 200001 AND 200012
                    AND country_name = 'Italy'
                    AND c.country_id = cu.country_id
                    AND cu.cust_id = s.cust_id
            ) b
    WHERE a.month_avg > b.year_avg
;

-- ������ ��Ż���� �ִ�����, ���, �ּҸ����, �ش��� ��ȸ
-- ���̺� : sales s, countries c, customers cu

--==================================================================
-- CH8. ��������(272p)

/*
[#����1]
 : ������ �� 3���� ����ϴ� �͸� ����� ����� ����.
*/

-- loop�� 3*i
DECLARE
    NUM1 NUMBER := 1;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=============================');
    LOOP
    DBMS_OUTPUT.PUT_LINE('3 * ' || NUM1 || ' = ' || NUM1*3);
    NUM1 := NUM1+1;
    EXIT WHEN NUM1 > 9;
    END LOOP;
END;
/

-- loop�� dan*i
DECLARE
    NUM1 NUMBER := 1;
    DAN  NUMBER := 3;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=============================');
    LOOP
    DBMS_OUTPUT.PUT_LINE(DAN || ' * ' || NUM1 || ' = ' || DAN*NUM1);
    NUM1 := NUM1+1;
    EXIT WHEN NUM1 > 9;
    END LOOP;
END;
/

-- for ��
declare
    i number;
begin
    i := 1;
    DBMS_OUTPUT.PUT_LINE('===================================================');
    for i in 1..9 loop
    DBMS_OUTPUT.PUT_LINE('3 * ' || i ||' = ' || 3 * i );
    end loop;
end;
/

-- while ��
declare
    NUM number;
begin
    NUM := 1;
    DBMS_OUTPUT.PUT_LINE('=============================');
    WHILE NUM<10 LOOP
        DBMS_OUTPUT.PUT_LINE('3 * ' || NUM ||' = ' || 3 * NUM);
        NUM := NUM + 1;
     END LOOP;
end;
/
-- ������ ���
DECLARE
    num NUMBER := 1;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=============================');
    DBMS_OUTPUT.PUT_LINE('3 * ' || num || ' = ' || 3*num);
    NUM := NUM +1;
    DBMS_OUTPUT.PUT_LINE('3 * ' || num || ' = ' || 3*num);
    NUM := NUM +1;
    DBMS_OUTPUT.PUT_LINE('3 * ' || num || ' = ' || 3*num);
    NUM := NUM +1;
    DBMS_OUTPUT.PUT_LINE('3 * ' || num || ' = ' || 3*num);
    NUM := NUM +1;
    DBMS_OUTPUT.PUT_LINE('3 * ' || num || ' = ' || 3*num);
    NUM := NUM +1;
    DBMS_OUTPUT.PUT_LINE('3 * ' || num || ' = ' || 3*num);
    NUM := NUM +1;
    DBMS_OUTPUT.PUT_LINE('3 * ' || num || ' = ' || 3*num);
    NUM := NUM +1;
    DBMS_OUTPUT.PUT_LINE('3 * ' || num || ' = ' || 3*num);
    NUM := NUM +1;
    DBMS_OUTPUT.PUT_LINE('3 * ' || num || ' = ' || 3*num);
    NUM := NUM +1;
END;
/

/*
[#����2]
 : ��� ���̺��� 201�� ����� �̸��� �̸��� �ּҸ� ����ϴ� �͸� ����� ����� ����.
*/

DECLARE
    vs_emp_name employees.emp_name%TYPE;
    vs_email employees.email%TYPE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=============================');
    SELECT e.emp_name, e.email
    INTO vs_emp_name, vs_email
        FROM employees e
        WHERE e.employee_id = 201
    ;
    DBMS_OUTPUT.PUT_LINE(vs_emp_name);
    DBMS_OUTPUT.PUT_LINE(vs_email);
END;
/
