
/*
<SQL DEVELOPER - ����Ŭ �ǽ� ����>
[SQL Developer ������ ����]
 ���� - ���� ����� - �����ͺ��̽� ���� - ���ϸ� : 'ora_user.sql' - ���丮 ����: ã�� ������(D:\work)

// �ּ��� '--', ������ �ּ�ó���� 'Ctrl + /'
-- ���̺� ����
    CREATE TABLE ���̺��(
        �÷��� �÷�������Ÿ�� ��������,
        �÷��� �÷�������Ÿ�� ��������,
        �÷��� �÷�������Ÿ�� ��������,
        �÷��� �÷�������Ÿ�� ��������
    );
    
-- ���̺� ����
    DROP TABLE ���̺��;

-- ���̺���� �� ���� ����
    CREATE TABLE pracitce_1(
        name varchar2(3),
        age number
    );
    
    DROP TABLE pracitce_1;

-- Insert��_�⺻ ����
    Insert into ���̺��(�÷�1, �÷�2, ...)
    Values('�÷���1', '�÷���2', ...);

-- Select��_�⺻ ����
    Select * (Ȥ�� �÷�)           //  *�� All�� �ǹ�
    From ���̺�� (Ȥ�� ���)       // ������ ���̺� or ��
    Where ����                    // ���� ����, ���� ���� ��� �ÿ��� AND, OR�� ����
    Order by �÷�;                // ��ȸ ������ ���� ��, �����ϰ��� �ϴ� �÷��� ���
*/


-- ���� ������ Ÿ��1_(52p), 'ex2_1'
// Table ����
CREATE TABLE ex2_1(
    column1 char(10),
    column2 varchar2(10),
    column3 nvarchar2(10),
    column4 number
);

// ������ ����
Insert into ex2_1 (column1, column2)
Values('abc', 'abc');

// ������ ��ȸ(����)
// null : �����Ͱ� ������ �ǹ�
/*
    Select *
    From ex2_1;
*/

// ������ ��ȸ(������ �÷� �� ������ ũ��)
Select column1, length(column1) as len1, //column1�� ����ũ��(10)
       column2, length(column2) as len2  //column2�� ����ũ��(10->3)
    From ex2_1;

//==================================================================


-- ���� ������ Ÿ��2_(53p), 'ex2_2'
// Table ����
Create table ex2_2(
    column1 varchar2(3),
    column2 varchar2(3 byte),
    column3 varchar2(3 char)
);

// ������ �Է�(����)
Insert into ex2_2 Values('abc', 'abc', 'abc');

Select column1, Length(column1) As len1,
       column2, Length(column2) As len2,
       column3, Length(column3) As len3
    From ex2_2;

// ������ �Է�(�ѱ�)
//Insert into ex2_2 Values('ȫ�浿', 'ȫ�浿', 'ȫ�浿');
    //'ȫ�浿' = 9byte�̹Ƿ� �÷�3�� ����
    //�÷�1 = 3byte, �÷�2 = 3byte, �÷�3 = 3char(�������� ����)

Insert into ex2_2(column3) Values('ȫ�浿');

Select column3, Length(column3) As len3, LengthB(column3) As bytelen
    From ex2_2;
    //Length : �÷� ���̸� ��ȯ(�����), LengthB : �ش� �÷��� byte ���� ��ȯ


//==================================================================


-- ���� ������ Ÿ��(55p)
// Table ����
Create Table ex2_3(
    COL_INT Integer,
    COL_DEC Decimal,
    COL_NUM Number
    --Integer : ����, Decimal : 10����(����Ŭ���� �� �� Number�� �ش���)
);

// ��ȸ
Select column_id, column_name, data_type, data_length
    From user_tab_cols
    --����� ���� �����ϸ鼭 �ڵ����� ������� ������ �����ϴ� �� : 'user_tab_cols'
    Where table_name = 'EX2_3'  --���� ���̺� ��, 'ex2_3'�� �������� ����
    Order by column_id;         --������ ���� ����


//==================================================================


-- ��¥ ������ Ÿ��(����58p)
Create Table ex2_5(
    COL_DATE DATE,
    COL_TIMESTAMP TIMESTAMP
); 

Insert into ex2_5 Values (SYSDATE, SYSTIMESTAMP);
    --sysdate�� ���� ����ϹǷ� ����� ��
Select *
    From ex2_5;
    

//==================================================================

-- �������� ����
    /* �÷���  ������Ÿ��  Primary Key Ȥ��
    Constraints  �������Ǹ� Primary Key  (�÷���, ...) */

-- ��������_Not Null(60p), 'ex2_6'
/*
Create Table ex2_6(
    col_null      Varchar2(10),
    col_not_null  Varchar2(10)  Not Null
);

//Insert Into ex2_6 Values ('AA', '');
// 'col_not_null' �ڸ��� ��ĭ���� �� �� �����Ƿ� ����

Insert Into ex2_6 Values ('AA', 'BB');
*/

// ����) Not Null ���������� �÷� ���������� ���� ����
// (Constraints �������Ǹ� Not Null(�÷���) : �Ұ���
Create Table ex2_6(
    col_null      Varchar2(10),
    col_not_null  Varchar2(10),
    Constraints unique_1 Unique (col_not_null)
);

//==================================================================

-- �������� Unique(61p), 'ex2_7'
Create Table ex2_7(
    col_unique_Null  Varchar2(10) Unique,
    col_unique_NNull Varchar2(10) Unique Not Null, 
    col_nuique       Varchar2(10),
        Constraints unique_nm1 Unique(col_nuique)
);

Insert into ex2_7 Values ('AA', 'AA', 'AA');
Insert into ex2_7 Values ('', 'BB', 'BB');
Insert into ex2_7 Values ('', 'CC', 'CC');

// �������� ���뿩�� Ȯ��
Select constraint_name, constraint_type, table_name, search_condition
    From   user_constraints --������� ���������� ��� �ִ� �ý����� ���̺�
    Where  table_name = 'EX2_7';

//==================================================================

-- �������� Primary Key, �⺻Ű(63p)
-- Primary Key = Not Null + Unique
Create Table ex2_8(
    col1 varchar2(10) Primary Key,
    col2 varchar2(10)
);

Select constraint_name, constraint_type, table_name, search_condition
    From user_constraints
    Where table_name = 'EX2_8';


Insert into ex2_8
    Values('', 'AA'); --Primary Key �������� ������ �Ұ���
    
Insert into ex2_8
    Values('AA', 'AA');

Insert into ex2_8
    Values('AA', 'AA'); --Primary Key �������� ������ �Ұ���


//==================================================================

-- �������� Check(66p)
Create Table ex2_9(
    num1 Number
        Constraints check1
            Check (num1 Between 1 AND 9),
    gender Varchar2(10)
        Constraints check2
            Check (gender IN ('MALE', 'FEMALE'))
);

-- ����) ���̺� user_constraints�� ����Ͽ� EX2_9�� ���������� ��ȸ�϶�.
Select constraint_name, constraint_type, table_name, search_condition
    From user_constraints
    Where table_name = 'EX2_9';

Insert into ex2_9 Values (10, 'MALE'); -- 10 : �������ǿ� �����
Insert into ex2_9 Values (9, 'MAN'); -- MAN : �������ǿ� �����
    
Insert into ex2_9
    Values (9, 'MALE'); -- ����
Insert into ex2_9
    Values (1, 'FEMALE'); -- ����

//==================================================================

-- Default(67p)
-- �÷��Ӽ� : ���������� �ƴ����� �÷��� Ƽ��Ʈ ���� ����ϴµ� ���
Create Table ex2_10(
    col1 Varchar2(10) Not Null,
    col2 Varchar2(10) Null,
    Create_date Date Default sysdate
);

Insert into ex2_10 Values ('AA', 'AA', '2023/11/01');
Insert into ex2_10(col1, col2) Values ('BB', 'BB');
Insert into ex2_10(col1, col2) Values ('CC', 'CC');
    -- �Է��� �÷� ��ġ�� ���� �Է�
    
Select * From ex2_10;

//==================================================================

-- ���̺� ����
/*
-- �÷��� ���� :
    Alter Table ���̺�� Rename Column ������_�÷��� TO ������_�÷���;
-- �÷� ������Ÿ�� ���� :
    Alter Table ���̺�� Modify �÷��� ������Ÿ��;
-- �÷� �߰� :
    Alter Table ���̺�� ADD �÷��� ������Ÿ��;
-- �÷� ���� :
    Alter Table ���̺�� Drop �÷���;
-- ��������(�⺻Ű) �߰� :
    Alter Table ���̺�� Add Constraints �������Ǹ�
        Primary Key (�÷���, ...);
-- �������� ���� :
    Alter Table ���̺�� Drop Constraints �������Ǹ�;
*/

//==================================================================

-- �÷��� ����
Alter Table ex2_10 Rename Column col1 TO col11;
DESC ex2_10;    -- ���̺� �÷� ���� Ȯ��
    
-- �÷� ������Ÿ�� ����
Alter Table ex2_10 Modify col2 Varchar2(30);
DESC ex2_10;

-- �÷� �߰�
Alter Table ex2_10 ADD col3 Number;
DESC ex2_10;

-- �÷� ����
Alter Table ex2_10 Drop Column col3;
DESC ex2_10;

-- �������� �߰�
Alter Table ex2_10 ADD Constraints pk_ex2_10 Primary Key(col11);
DESC ex2_10;
Select constraint_name, constraint_type, table_name, search_condition
    From user_constraints
    Where table_name = 'EX2_10';

-- �������� ����
Alter Table ex2_10 Drop Constraints pk_ex2_10;
DESC ex2_10;
Select constraint_name, constraint_type, table_name, search_condition
    From user_constraints
    Where table_name = 'EX2_10';

//==================================================================
-- ���̺� ����
    /* ���̺� ����_����
    Create Table ���̺�� AS
        Select �÷�1, �÷�2, ...
        From ������ ���̺��;
    */
Select *
From ex2_9;
    -- 'ex2_9' ���̺� ��ȸ

Create Table ex2_9_1 AS
    Select *
    From ex2_9;
        -- 'ex2_9' ���̺� ����
    
Select *
    From ex2_9_1;
        -- ����� 'ex2_9_1' ���̺� ��ȸ

//==================================================================

-- ȥ�� ����
Create Table practice_00(
    col1 Varchar2(10)  Not Null Primary Key,
    col2 Varchar2(10)
        Constraints check01
            Check (col2 IN ('YES', 'NO')),
    num1 Number
        Constraints check02
            Check (num1 Between 1 AND 9),
    date_now Date Default sysdate
);

Insert into practice_00(col1, col2, num1)
    Values('AA', 'YES', 1);

Select * From practice_00;

Alter Table practice_00
    Rename Column col2 TO answer;
DESC practice_00;

Alter Table practice_00
    Modify col1 Varchar2(30);
    
Alter Table practice_00
    ADD col3 Number;
DESC practice_00;

Alter Table practice_00
    Drop Column col3;
DESC practice_00;

Alter Table practice_00 ADD Constraints uq_practice_00 Unique (answer);
DESC practice_00;

Alter Table practice_00 Drop Constraints uq_practice_00;
DESC practice_00;



//==================================================================
//==================================================================

-- ��
-- : ��� 1�� �̻��� ���̺� or �ٸ� ���� �����͸� ������ �ϴ� �����ͺ��̽� ��ü
    /*
    -- ��_����
    Create OR Replace View ��� AS
        Select ����;
    */
    
Create OR Replace View emp_dept_v0 AS
    Select employee_id, emp_name
    From employees;

Select department_id
    From departments;

Select e.employee_id, e.emp_name, e.department_id, d.department_name
    From employees e, departments d
    Where e.department_id = d.department_id;
    -- ����� ������ �� SQL�� �ۼ��ϱ� ���ŷο�Ƿ� �ʿ��� ������ �ִ� �並 �����Ͽ� �����ϸ� ����

//==================================================================

Create OR Replace View emp_dept_v1 AS
    Select e.employee_id, e.emp_name, e.department_id, d.department_name
    From employees e, departments d
    Where e.department_id = d.department_id; -- �� ����
    
Select *
    From emp_dept_v1;  -- �� ��ȸ

//==================================================================

/*
[�ε���] : �ǹ����� �� ���� ����
 - �����Ͱ� 10���� �̻�(������ ���� �ľ� �ʼ�) ������ �׶����� �ε��� ��� ����ϱ�
 - ���̺� �ִ� �����͸� ���� ã�� ���� �뵵�� �����ͺ��̽� ��ü
 - å�� �� �ڿ� �ִ� "ã�ƺ���"�� ����
 - ������ ��������� �ε����� ������ �÷� ���� ����� �÷�(���)�� �ּ� ���� �����
 - ������ �÷� ������ ���� �з� : ���� �ε����� ���� �ε���(2�� �̻� �÷� ����)
 - ���ϼ� ���ο� ���� �з� : UNIQUE �ε���, NON-UNIQUE �ε���
   UNIQUE �ε��� : �ߺ� ���� �������� �ε���
   NON-UNIQUE �ε��� : �ߺ� �ִ� �������� �ε���
 - �ε��� ���α����� ���� �з� : B-tree �ε���, ��Ʈ�� �ε���
 
[B-tree �ε���]
 - ������ ������ �߰� �� �Ǵ� �����͸� �Ѹ��� �ش��ϴ� ROOT ������� ����
   (�� ���� ã�� �� ��� ������ ������ ã�� ����)
 - ROOT ����� �������� ������ �Ǵ� BRANCH����� ����
 - ���������� �ٿ� �ش��ϴ� LEAF ��Ͽ�
   �ε����� Ű�� �Ǵ� �����Ϳ� �������� ������ �ּ� ������ ROWID �� ����
 - �������� : �����Ͱ� ���ĵ� ���·� ����
 
[��Ʈ�� �ε���]
 - ��Ʈ ��ϰ� �귣ġ ��� ������ ����.
 - ���� ����� ���, ��Ʈ ������ ���� ���̺��� ����� �ش� �Ӽ� ���� ���ϸ� '1',
                   ������ ������ '0'���� ��Ʈ���� ����

[�ε��� ����]
 - ���� ����
   CREATE[UNIQUE] INDEX �ε�����
   ON ���̺�� (�÷�1, �÷�2, ...);
   
 - ���� ����
   DROP INDEX �ε�����;
   
 - �ε��� ������ �������
   : �ε��� �÷� �������� ������ ���̺� ��ü �ο� ���� 15%���� �� �ε��� ����� ����
   : ���̺� �Ǽ��� ���ٸ� ���� �ε����� ���� �ʿ� ����(���̺� ��ü ��ĵ�� �� ���� �� ����)
   : ���� �ε���(2�� �̻� �÷��� ���ļ� ����) ���� �� �ε����� ���ԵǴ� �÷� ������ �߿�
   : ���̺� �ε����� �ʹ� ���� ����� ������ ���� �߻�
     (INSERT, DELETE, UPDATE �ÿ� �ε��� ������ ���� ���� ����)
*/

-- �ε���
 -- �ε��� ���� ���� ������ ��ȸ
SELECT *
    FROM ex2_10
    WHERE col11 = 'CC';

 -- �ε��� ����
CREATE UNIQUE INDEX ex2_10_ix01
    ON ex2_10 (col11);

 -- �ε��� ���� Ȯ��
  -- �ε��� ���� ���� ������ ��ȸ�ϸ� �ð��� �� �� �ɸ���,
  -- �ε��� ���� �Ŀ� ������ ��ȸ�ϸ� �ð��� �� �ɸ�
SELECT index_name, index_type, table_name, uniqueness
    FROM user_indexes
    WHERE table_name = 'EX2_10';

 -- �ε��� ���� ��, ������ ��ȸ
SELECT *
    FROM ex2_10
    WHERE col11 = 'CC';
    
 -- �ε��� ����
DROP INDEX ex2_10_ix01;

--===========================================================
-- ���̺� ����(������ ���� ���̺�� �ε��� �ǽ�)
CREATE TABLE customers_cp AS
    SELECT *
    FROM CUSTOMERS;
-- ���̺� ���� Ȯ��
SELECT *
    FROM customers_cp;

-- ���̺� ���� ��ȸ : ��id '8810'
-- �ε��� ����, (16��, 0.009��)
SELECT *
    FROM   customers_cp
    WHERE cust_id = 8810;
    
-- NON-UNIQUE �ε��� ����
CREATE INDEX customers_cp_ix01
    ON customers_cp (cust_id);

-- UNIQUE �ε��� ����
CREATE UNIQUE INDEX customers_cp_ix02
    ON customers_cp (cust_id);

-- �ε��� ���� Ȯ��
SELECT index_name, index_type, table_name, uniqueness
    FROM user_indexes
    WHERE table_name = 'CUSTOMERS_CP';

-- ���̺� ���� ��ȸ : ��id '8810'
-- �ε��� ����
-- UNUNIQUE(1��, 0.004��)
-- UNIQUE  (1��, 0.004��)
SELECT *
    FROM customers_cp
    WHERE cust_id = 8810;
    
-- �ε��� ����
DROP INDEX customers_cp_ix01;
DROP INDEX customers_cp_ix02;

//==================================================================

/*
[�ó��] : �ǹ����� �� ���� ����
 - �����ͺ��̽� ��ü�� ���� ��Ī, ���Ǿ�
 - PUBLIC �ó�� : ��� ����� ����, ���
 - PRIVATE �ó�� : Ư�� ����ڸ� ����, ���
 
[�ó�� ����]
-- ����
    CREATE OR REPLACE [PUBLIC] SYNONYM �ó�Ը�
        FOR ��ü��;
 - PUBLIC ���� ��, PRIVATE �ó���� ������
 - �ó�� ���� ���� �ο�
    GRANT SELECT ON �ó�Ը� TO PUBLIC; Ȥ��
    GRANT SELECT ON �ó�Ը� TO �����;
*/

-- �ó�� (80P)
-- �ó�� ����
CREATE OR REPLACE SYNONYM syn_channel
    FOR channels;

-- �� ���� Ȯ��
SELECT COUNT(*) FROM channels;
SELECT COUNT(*) FROM syn_channel;

-- �ó�� ����
DROP SYNONYM syn_channel;

//==================================================================

/*
�ڡڡ�[������]�ڡڡ�
 - �ڵ����� ������ ��ȯ�ϴ� ��ü
 
[������ ����]
-- ����
CREATE SEQUENCE ��������
INCREMENT BY ��������
START WITH ���ۼ���
NOMINVALUE | MINVALUE �ּҰ�
NOMAXVALUE | MAXVALUE �ִ밪
NOCYCLE | CYCLE
NOCACHE | CACHE;

-- ����
INCREMENT BY �������� : (�������ڴ� 0�� �ƴ� ����. ����� ����, ������ ����, ����Ʈ�� 1)
NOCACHE : (����Ʈ�� �޸𸮿� ������ ���� �̸� �Ҵ��� ���� ������ ����Ʈ ���� 20)
CACHE : (�޸𸮿� ������ ���� �̸� �Ҵ��� ����)

[������ ���]
 - �������� ���� (����)�� : ��������.CURRVAL
 - �������� ���� (����)�� : ��������.NEXTVAL
 
[������ ����]
 -- ����
 DROP SEQUENCE ��������;
*/

--Create Table ex2_8(
--    col1 varchar2(10) Primary Key,
--    col2 varchar2(10)
--);

-- ������ ����
DROP SEQUENCE my_seq1;
-- ������ ����(84p)
CREATE SEQUENCE my_seq1
    INCREMENT BY 2
    START WITH 3
    MINVALUE 1  -- CYCLE�� �����Ƿ�, ������ ������ 20 �ʰ��Ͽ� �ٽ� ���ư��ٸ� �� ���ڴ� 1
    MAXVALUE 20
    CYCLE
    NOCACHE;

-- ���� ������ ����, 'ex2_8'
DELETE ex2_8;
-- �� �Է� ��, �÷��� ������Ÿ�� Ȯ��(� �����͸� �Է��� �� �ִ��� Ȯ��)
DESC ex2_8;
-- ������ ����
INSERT INTO ex2_8(col1) VALUES(my_seq1.NEXTVAL);
    -- col1�� 'PRIMARY KEY' ������ ���ѷ��� �Ұ���
    -- �Խù� ��ȣ�� �ߺ��� ����� �ϹǷ�, �� ��쿡�� �⺻Ű �����ϸ� ��
-- ������ ��ȸ
SELECT *
    FROM ex2_8;

-- my_seq1.CURRVAL      -- ���� ���� Ȯ��
-- my_seq1.NEXTVAL      -- ���� ���� Ȯ��

-- DUAL : �ӽ� ���̺�
SELECT my_seq1.CURRVAL
    FROM DUAL;

SELECT my_seq1.NEXTVAL
    FROM DUAL;

//==================================================================

-- ��Ƽ�� ���̺�
--  ���̺��� Ư�� �÷���(��Ƽ�� �÷�)�� �������� �����͸� ������ ����
--  ������ ���̺��� 1�� ������, �� �����ʹ� ��Ƽ�� �÷� ���� �������� ��Ƽ�Ǻ� ����
--  ��뷮 �����Ͱ� ����� ���̺��� ���, ��Ƽ�� ���̺�� �����ϸ� ���� ȿ��ȭ GOOD
SELECT *
    FROM SALES;
    
--==================================================================

-- ��Ƽ�� ��ȸ
SELECT *
    FROM SALES
    PARTITION(SALES_Q1_1998);

--==================================================================

-- CH3. DML
/*
[SELECT��]
 - ���̺��̳� �信 �ִ� �����͸� ����(��ȸ)�� �� ���
 - ����
  SELECT * Ȥ�� �÷�
    FROM ���̺�� Ȥ�� ���
    WHERE ����
    ORDER BY �÷�;

 - SELECT : �����ϰ��� �ϴ� �÷���, ��� �÷��� ��ȸ�ϰ� �ʹٸ� *
 - FROM : ������ ���̺��̳� �� ��
 - WHERE : ��������, ���� ���� ��� �ÿ��� AND, OR�� ����
 - ORDER BY : ��ȸ ������ ���� ��, �����ϰ��� �ϴ� �÷��� ���
        ��������(ASC) : ���� ������ ū ������
        ��������(DESC) : ū ������ ���� ������
*/

-- (92p)
SELECT employee_id, emp_name
    FROM employees
    WHERE salary > 20000
    ORDER BY employee_id;
    
-- AND ����
SELECT employee_id, emp_name
    FROM employees
    WHERE salary > 5000
    AND job_id = 'IT_PROG'
    ORDER BY employee_id;
    
-- OR ����(94p)
SELECT employee_id, emp_name
    FROM employees
    WHERE salary > 5000
    OR job_id = 'IT_PROG'
    ORDER BY employee_id;
    
-- 2���� ���̺��� �ϳ��� SQL������ ����ϴ� ���(94p)
SELECT a.employee_id, a.emp_name, a.department_id, b.department_name
    FROM employees a, departments b     
    -- a, b�� ��Ī(��Ī�� ���̺��, �÷��� ����)
    -- "���÷��� [AS] �÷���Ī"
    WHERE a.department_id = b.department_id;

-- ���÷��� ��Ī�� ���̴� ���(95p)   
SELECT a.employee_id, a.emp_name, a.department_id, b.department_name AS dep_name
    FROM employees a, departments b
    WHERE a.department_id = b.department_id;

--==================================================================

-- SELECT�� ȥ�� �����ϱ�
-- #1. EMP ���̺��� �޿��� 3000 �̻��� ����� ������ �����ȣ, �̸�, ������, �޿��� ����ϴ� SELECT ���� �ۼ�
SELECT a.emp_name, a.employee_id, a.job_id, salary
    FROM employees a
    WHERE salary >= 3000;
    
-- #2. ���� : �Ի����� February 20, 1998�� May 11, 1998 ���̿� �Ի�
--     ��� : ����� �̸�, ����, �Ի���
--           �Ի��� ������ ����� ��
SELECT a.emp_name, a.job_id, hire_date
    FROM employees a
--    WHERE hire_date BETWEEN '98/02/20' AND '98/05/11'
    WHERE hire_date BETWEEN to_date('1998-02-20', 'YYYY-MM-DD')
                    AND     to_date('1998-05-11', 'YYYY-MM-DD')
    ORDER BY hire_date;

-- #3. ���� : EMP ���̺��� �μ���ȣ�� 10, 20�� ����� ��� ������ ���
--     �̸������� ����
SELECT *
    FROM employees a
    WHERE a.department_id IN(10, 20)
    ORDER BY a.emp_name;
    
-- #4. EMP ���̺��� �޿� : 1500 �̻�, �μ���ȣ : 10, 30
--     ��� : ����� �̸�, �޿�(��, Heading�� Employee�� Monthly Salary�� ���)
SELECT a.emp_name "Employee", a.salary "Monthly Salary"
    FROM employees a
    WHERE salary >= 1500
        AND a.department_id = 10 OR a.department_id = 30;
        
--==================================================================

-- INSERT��(96P)
/*
[����]
INSERT INTO ���̺��(�÷�1, �÷�2, ...) VALUES(��1, ��2, ...);
INSERT INTO ���̺�� VALUES(��1, ��2, ...);
INSERT INTO ���̺��(�÷�1, �÷�2, ...) SELECT��;
*/
CREATE TABLE ex3_1(
    col1    VARCHAR2(10),
    col2    NUMBER,
    col3    DATE
);

INSERT INTO ex3_1(col1, col2, col3)
    VALUES ('ABC', 10, '23/11/07');
    
INSERT INTO ex3_1(col1, col2, col3)
    VALUES ('ABC', 10, SYSDATE);
    
INSERT INTO ex3_1(col1, col2, col3)
    VALUES (30, 0, '23/11/06');
    
INSERT INTO ex3_1
    VALUES ('GHI', 10, SYSDATE);
    
INSERT INTO ex3_1
    VALUES ('GHI', 20);
    
INSERT INTO ex3_1(col1, col2, col3)
    VALUES (10, '10', '2014-01-01');

INSERT INTO ex3_1(col1, col2, col3)
    VALUES ('DEF', '10', SYSDATE);
    
INSERT INTO ex3_1(col1, col2, col3)
    VALUES ('JKL', 40, SYSDATE);
    
INSERT INTO ex3_1(col1, col2)
    VALUES ('JKL', 40);
    
INSERT INTO ex3_1(col2)
    VALUES (10);

SELECT * FROM ex3_1;

-- (98p)
CREATE TABLE ex3_2(
    emp_id   NUMBER,
    emp_name VARCHAR2(100)
);

INSERT INTO ex3_2(emp_id, emp_name)
SELECT employee_id, emp_name
    FROM employees
    WHERE salary > 5000;
    
SELECT * 
    FROM ex3_2
    ORDER BY emp_id;


--==================================================================

/*
[UPDATE��]
UPDATE ���̺��
    SET �÷���1 = ��1, �÷���2 = ��2
    WHERE ����;
    -- ������ ��������� AND�� OR ���
*/

SELECT *
    FROM ex3_1;
    
UPDATE ex3_1
    SET col2 = 0;
    
UPDATE ex3_1
    SET col2 = 20
    WHERE col1 = 'DEF';
    
UPDATE ex3_1
    SET col2 = 12
    WHERE col3 = '23/11/07 12:10:33';
    
-- JKL, ��¥ �����Ϳ� NULL�� �Ϳ� �����͸� �־��(101p)
--UPDATE ex3_1
--    SET col3 = SYSDATE
--    WHERE col3 = '';

UPDATE ex3_1
    SET col3 = SYSDATE
    WHERE col3 IS NULL;

-- ���̺� ex3_1���� �÷� col1�� �����Ͱ� JKL�̰�,
-- �÷� col3�� �����Ͱ� null�� �ƴ� ���, 
-- col3 �÷��� �����Ϳ� �ý����� ��¥/�ð��� �����϶�.
UPDATE ex3_1
    SET col3 = SYSDATE
    WHERE col1 = 'JKL' AND col3 IS NOT NULL;
-- IS NULL <-> IS NOT NULL

UPDATE ex3_1
    SET col1 = 'MNO'
    WHERE col1 IS NULL;

-- ex3_1 ���̺� ��ȸ
SELECT * FROM ex3_1;

--==================================================================

/*
[MERGE��]
 : ������ ���� ���ǿ� �´� �����Ͱ� ������ INSERT,
   ������ UPDATE�� �����ϴ� ����
   (������ ����)
   
[MERGE ����]
MERGE INTO ���̺��
    USING (update�� insert �� ������ ��õ)
    ON    (update�� ����)
    
    WHEN MATCHED THEN
        UPDATE SET �÷�1=��1, �÷�2=��2, ...
            WHERE ����
            DELETE WHERE ����
    
    WHEN NOT MATCHED THEN
        INSERT(�÷�1, �÷�2, ...) VALUES(��1, ��2, ...)
            WHERE ����;
*/

-- MERGE ��
��ǥ : 2000�� 10������ 12�� ���̿� �� ������ ��������
      ���� ������ �޼��� ������� �� ���� ���ʽ��� ������
��� ���̺� : ���(employees), �Ǹ�(sales)

����1. �ش���� ������ �޼��� ����� �����ΰ�?
- ������ �޼��� ��� ����� ex3_3 ���̺� ����
- �����ȣ�� ������̺�� �Ǹ����̺� �� �� �־�� ��
- 2000�� 10������ 12�� ���� �� ������ �������� ��
      
-- ���̺� ����(102p)
DROP TABLE ex3_3;

CREATE TABLE ex3_3(
    employee_id NUMBER,
    bonus_amt   NUMBER DEFAULT 0
);

-- 2000�� 10������ 12������ ���� �޼��� �����ȣ �Է�
INSERT INTO ex3_3(employee_id)
    SELECT e.employee_id
    FROM employees e, sales s
    WHERE e.employee_id = s.employee_id
        AND s.SALES_MONTH BETWEEN '200010' AND '200012'
        GROUP BY e.employee_id;
        -- GROUP BY : �ߺ� ����
        
SELECT * FROM ex3_3
    ORDER BY employee_id;

##    ex3_3 ���̺� => ���� �޼��� ��� => ���ʽ� �޴� ���   
 1. ������ ���(manager_id)�� 146���� ���
 2. ex3_3 ���̺� �ִ� ����� ����� ��ġ�ϸ�
    ���ʽ�(bonus_amt)�� �ڽ��� �޿�(salary)�� 1%�� ���ʽ��� ����
 3. ex3_3 ���̺� �ִ� ����� ����� ��ġ���� ������
    1�� ����� ����� �űԷ� �Է�(���ʽ� �ݾ��� 0.1%)
    �̶�, �޿��� 8000 �̸��� ����� ó��
    
-- 1%   = salary * 0.01
-- 0.1% = salary * 0.001
    
-- ex3_3 ���̺� �ִ� ����� ���, ������ ���, �޿�, �׸��� �޿�*0.01��
-- ��� ���̺��� ��ȸ
-- (���ʽ� 1% �޴� ����� ���, ������ ���, �޿�, ���ʽ� �ݾ� ��ȸ)
SELECT employee_id, manager_id, salary, salary*0.01
    FROM employees
    WHERE employee_id
        IN (SELECT employee_id FROM ex3_3);

-- ��� ���̺��� ������ ����� 146�� �� ��,
-- ex3_3 ���̺� ���� ����� ���, ������ ���, �޿�, �޿�*0.001(0.1%) ��ȸ
-- ���� �޿��� 8000 �̸��� 160�� ��� 1���̹Ƿ�
-- ex3_3 ���̺��� 160�� ����� ���ʽ� �ݾ��� 7.5�� �ű� �Էµ� ��
-- (������ ��� 146���� ��� ��,
--  ����� �޼����� ����� ���, ������ ���, �޿�, 0.1% ���ʽ� �ݾ� ��ȸ)
SELECT  employee_id, manager_id, salary, salary*0.001
    FROM employees
    WHERE employee_id
        NOT IN (SELECT employee_id FROM ex3_3)
        AND manager_id = 146;

-- MERGE ������ �ۼ�
MERGE INTO ex3_3 d
    USING (SELECT employee_id, salary, manager_id
                FROM employees
                WHERE manager_id = 146) t
    ON (d.employee_id = t.employee_id)
    
    WHEN MATCHED THEN
        UPDATE SET d.bonus_amt = d.bonus_amt + t.salary * 0.01
        
    WHEN NOT MATCHED THEN
        INSERT (d.employee_id, d.bonus_amt)
            VALUES(t.employee_id, t.salary * 0.001)
        WHERE (t.salary < 8000);
        
SELECT *
    FROM ex3_3
    ORDER BY employee_id;
    
SELECT e.employee_id, e.manager_id, e.salary, d.bonus_amt
    FROM employees e, ex3_3 d
    WHERE e.employee_id = d.employee_id
        --AND e.manager_id = 146
    ORDER BY e.employee_id;
    
-- ex3_3 ���̺��� ������ ����
DELETE ex3_3;
SELECT * FROM ex3_3;

-- MERGE ������ 'UPDATE�� ���� ���ؼ� ���ǿ� �´� �����͸� ����'
-- (DELETE WHERE d.employee_id = 161)
MERGE INTO ex3_3 d
    USING (SELECT employee_id, salary, manager_id
                FROM employees
                WHERE manager_id = 146) t
    ON (d.employee_id = t.employee_id)
    
    WHEN MATCHED THEN
        UPDATE SET d.bonus_amt = d.bonus_amt + t.salary*0.01
        DELETE WHERE (t.employee_id = 161)
    WHEN NOT MATCHED THEN
        INSERT (d.employee_id, d.bonus_amt)
            VALUES(t.employee_id, t.salary*0.001)
        WHERE t.salary < 8000;
            
SELECT *
    FROM ex3_3
    ORDER BY employee_id;
    
--==================================================================

 /*
 [DELETE ��]
 ���̺� �ִ� �����͸� �����ϴ� ����

 [DELETE ����]
 1. �Ϲݱ���
 DELETE [FROM] ���̺��
 WHERE ����;

 2. Ư�� ��Ƽ�Ǹ� ������ ����� ����
 DELETE ���̺�� PARTITION (��Ƽ�Ǹ�)
 WHERE ����;
 */

--'ex3_3'�� ������ ����(106p)
-- Ư�� ������ ����
DELETE ex3_3
    WHERE employee_id = 148;
    
DELETE ex3_3
    WHERE employee_id = 155;

-- ��� ������ ����
DELETE ex3_3;
-- Ȯ��
SELECT * FROM ex3_3;

-- ��Ƽ�� ��ȸ(106p)
SELECT partition_name
    FROM user_tab_partitions
    WHERE table_name = 'SALES';


--==================================================================

/*
[COMMIT]
 - ������ �����͸� ������ ���̽��� ���������� �ݿ�
[����]
 COMMIT [WORK] [TO SAVEPOINT ���̺�����Ʈ��];
 
[ROLLBACK]
 - ������ �����͸� ���� �� ���·� �ǵ���
[����]
 ROLLBACK [WORK] [TO SAVEPOINT ���̺�����Ʈ��];
 
[TRUNCATE]
 - DELETEó�� ���̺� �����͸� ����
 - ���� ��, ���������� �����Ͱ� �����Ǵ� DDL ������ WHERE ������ ���� �� ����.
 - ���� �� ROLLBACK �Ұ���
[����]
 TRUNCATE TABLE ���̺��;
*/

INSERT INTO ex3_3 VALUES(300, 100);
SELECT * FROM ex3_3;

COMMIT;

INSERT INTO ex3_3 VALUES(301, 200);
SELECT * FROM ex3_3;

ROLLBACK;
SELECT * FROM ex3_3;

--==================================================================

/*
[�ǻ��÷�]
 - ���̺��� �÷�ó�� ���������� ������ ���̺� ��������� �ʴ� �÷�
 - CONNECT_BY_ISCYCLE, CONNECT_BY_ISLEAF, LEVEL
   : ������ �������� ����ϴ� �ǻ��÷�(���� �ܰ迡���� ����)
 - NEXTVAL, CURRVAL
   : ���������� ����ϴ� �ǻ��÷�
 - ROWNUM, ROWID(�߿�)
   : ROWNUM�� �������� ��ȯ�Ǵ� �� �ο쿡 ���� ������(�ԷµǴ� �������� �ƴ�)
   : ROWID�� ���̺� ����� �� �ο찡 ����� �ּҰ�(�� �ο츦 �ĺ��ϴ� ��, ������ ��)
*/

-- �ǻ��÷�
-- ROWNUM, ROWID (110p)
SELECT ROWNUM, employee_id
    FROM ex3_3;

INSERT INTO ex3_3 VALUES(302, 300);
INSERT INTO ex3_3 VALUES(303, 400);
INSERT INTO ex3_3 VALUES(304, 500);
-- rownum�� ���� ������ �Է� �����ʹ� �������

SELECT ROWNUM, employee_id
    FROM ex3_3
    WHERE ROWNUM = 1;

SELECT ROWNUM, employee_id, ROWID
    FROM ex3_3
    WHERE ROWNUM < 3;
    
-- ������ �ǻ��÷�
-- NEXTVAL, CURRVAL
DROP SEQUENCE ex3_3_seq;
CREATE SEQUENCE ex3_3_seq
    INCREMENT BY    1
    START WITH      1
    MINVALUE        1
    MAXVALUE        30
    NOCYCLE
    NOCACHE
    NOORDER; -- ��û ������� ���� �������� ����

SELECT * FROM ex3_3;

INSERT INTO ex3_3 VALUES(ex3_3_seq.NEXTVAL, 0);

-- NEXTVAL�� ��ȸ�� �ϴ��� ���� ��ȣ�� �Ѿ��(INSERT�� ���� �ʾƵ� �Ѿ)
SELECT ex3_3_seq.NEXTVAL
    FROM DUAL;

SELECT ex3_3_seq.CURRVAL
    FROM DUAL;

--==================================================================

/*
[������]
 - ���Ŀ����� : +, -, *, /
 - ���ڿ����� : ||
 - �������� : >, <, >=, <=, =, 
               <>, !=, ^=   : '���� �ʴ�'�� �ǹ�
 - ���տ����� : UNION, UNION ALL, INTERSECT, MINUS
 - ������ ���� ������ : PRIOR, CONNECT_BY_ROOT
*/

/*
  a > b
  3 > 1 : ��(True)
  2 > 4 : ����(False)
  3 != 3 : ����(False)
*/

-- ���ڿ����� => ||
SELECT emp_name || ':' || email
    FROM employees;

SELECT hire_date || '~' || RETIRE_DATE
    FROM employees;
    
-- ���ڿ����� || (112p)
SELECT employee_id || '-' || emp_name AS employee_info
    FROM employees
    WHERE ROWNUM < 5;
    
-- ���Ŀ����� : + - * /
���� ���θ����� 'Mouse Pad'�� 3�� �������� �� ���� ����ϱ�
SELECT prod_name, prod_list_price || '$', (prod_list_price *3 || '$') AS Total_Price
    FROM products
    where prod_name = 'Mouse Pad';
    
-- ���Ŀ����� + ���ڿ�����
SELECT (prod_list_price * 3 || '$') AS prod_total_price
    FROM products
    WHERE prod_name = 'Mouse Pad';
    
-- ��������
���� ���θ����� ��ǰ�� ������ ��, 10�޷� ���� ��ǰ�� �˻��ϱ�
SELECT prod_name, prod_list_price
    FROM products
    WHERE prod_list_price <= 10;

--==================================================================

/*
[ǥ����]
 - �� �� �̻��� ���� ������, �׸��� SQL �Լ� ���� ���յ� ��
[CASE ǥ����]
CASE WHEN ����1 THEN ��1
     WHEN ����2 THEN ��2
     ---
     ELSE ��Ÿ ��
END
*/

-- ����(113p). ����� �޿��� ����
-- 5000������ �޿� : C, 5000~15000 : B, 15000 �̻� : A����� ��ȯ�ϴ� ����
SELECT employee_id, salary,
        CASE WHEN salary <= 5000 THEN 'C���'
             WHEN salary BETWEEN 5000 AND 15000 THEN 'B���'
             ELSE 'A���'
        END AS salary_grade
    FROM employees;


-- �Ʒ� ���뿡�� 'D���'�� ���X(��� ������ A~C ��޿� �ش��ϹǷ�)
SELECT employee_id, salary,
        CASE WHEN salary <= 5000 THEN 'C���'
             WHEN salary BETWEEN 5000 AND 15000 THEN 'B���'
             WHEN salary >= 15000 THEN 'A���'
             ELSE 'D���'
        END AS salary_grade
    FROM employees;


--==================================================================

/*
[���ǽ�] : 7����
 - ���� Ȥ�� ���ǽ�(Condition) : �� �� �̻��� ǥ���İ� �������ڰ� ���յ� ��
 - TRUE, FALSE, UNKNOWN 3���� Ÿ���� ��ȯ
   (UNKNOWN�� DB������ ����ϰ�, �ٸ� ������ ���� ���X)
 
[�� ���ǽ�]
 - �������ڳ� ANY, SOME, ALL Ű����� ���ϴ� ���ǽ�
 
[�� ���ǽ�]
 - AND, OR NOT�� ����ϴ� ���ǽ�
 
[NULL ���ǽ�]
 - Ư�� ���� NULL���� ���θ� üũ�ϴ� ���ǽ�
 - IS NULL, IS NOT NULL
 
[BETWEEN AND ���ǽ�]
 - ������ �ش�Ǵ� ���� ã�� �� ���
 
[IN ���ǽ�]
 - �������� ����� ���� ���Ե� ���� ��ȯ, ANY�� ���
 
[EXISTS ���ǽ�]
 - IN�� ��������� ���� �������� ���� ����Ʈ�� �ƴ� ���������� �� �� �ִ�.
 - ����, �������� ������ ���������� �־�� �Ѵ�.
 
[LIKE ���ǽ�]
 - ���ڿ��� ������ �˻��� �� ���
*/

--ANY(��1, ��2, ��3, ...)
--SOME(��1, ��2, ��3, ...)
--ALL(��1, ��2, ��3, ...)
--
--SELECT �÷�
--    FROM ���̺�
--    WHERE ����
--    ;
--==================================================================
-- �����ǽ�, ANY(114p)
-- �޿��� 2000, 3000, 4000 �� �ϳ��� ��ġ�ϴ� ��� ��� ��ȸ
SELECT employee_id, salary
    FROM employees
    WHERE salary = ANY(2000, 3000, 4000)
    ORDER BY employee_id
    ;
    
-- �����ǽ�, ANY -> OR(115p)
-- ANY�� OR �������� ��ȯ ����
SELECT employee_id, salary
    FROM employees
    WHERE salary = 2000
        OR salary = 3000
        OR salary = 4000
    ORDER BY employee_id
    ;
    
-- 
SELECT employee_id, salary
    FROM employees
    WHERE salary > ANY(2000, 3000, 4000)
    ORDER BY employee_id
    ;
    
--
SELECT employee_id, salary
    FROM employees
    WHERE  salary > 4000
        OR salary > 3000
        OR salary > 2000
    ;
    
-- �����ǽ�, SOME (115p)
SELECT employee_id, salary
    FROM employees
    WHERE salary = SOME(2000, 3000, 4000)
    ORDER BY employee_id;
    
-- �����ǽ�, ALL (115p)
-- ALL�� ��� ������ ���ÿ� �����ؾ� ��
SELECT employee_id, salary
    FROM employees
    WHERE salary = ALL(2000, 3000, 4000)
    ORDER BY employee_id;
    
-- �����ǽ�, ALL -> AND �������� ��ȯ����
SELECT employee_id, salary
    FROM employees
    WHERE salary = 2000
        AND salary = 3000
        AND salary = 4000
    ORDER BY employee_id;
    
--
SELECT employee_id, salary
    FROM employees
    WHERE salary < ALL(3000, 4000, 5000)
    ORDER BY employee_id;

--
SELECT employee_id, salary
    FROM employees
    WHERE salary < 3000
        OR salary < 4000
        OR salary < 5000
    ORDER BY employee_id;

--==================================================================
-- �� ���ǽ�
�� ������ : AND OR NOT
-- AND
SELECT employee_id, salary
    FROM employees
    WHERE salary > 8000 AND salary < 10000
    ;
-- OR
SELECT employee_id, salary
    FROM employees
    WHERE salary > 8000 OR salary < 10000
    ;

-- NOT
SELECT employee_id, salary
    FROM employees
    WHERE NOT (salary > 15000)
    -- WHERE salary <= 15000 �� ���� �ǹ�
    ;

--==================================================================

-- NULL ���ǽ�
--IS NULL / IS NOT NULL
SELECT employee_id, salary
    FROM employees
    WHERE manager_id IS NULL
    ;

SELECT employee_id, salary
    FROM employees
    WHERE manager_id IS NOT NULL
    ;

--==================================================================

-- BETWEEN AND ���ǽ�(117p)
-- �����÷� BETWEEN ���۰�1 AND ���۰�2
SELECT employee_id, salary
    FROM employees
    WHERE salary BETWEEN 2000 AND 2500
    ;

--==================================================================

-- IN ���ǽ�(117p)
--   : �������� ����� ���� ���Ե� ������ ����� ��ȯ (= ANY)
-- IN(��1, ��2, ��3, ...)
SELECT employee_id, salary
    FROM employees
    WHERE salary IN(2000, 3000, 4000)
    ;

--==================================================================

-- EXISTS ���ǽ�(118p)
--EXISTS (�������� with ��������)
--��������(join) : ���̺�1.�����÷� + ���̺�2.�����÷�
-- ex) employees.department_id = departments.department_id
--     E.department_id = D.department_id
--<��������>
SELECT *
    FROM departments d, employees e
    WHERE e.department_id = d.department_id
        AND salary >= 3000
    ;
--<��������> : �޿��� 3000���� �̻��� ����� �μ� ���̵�, �μ����� ��ȸ
-- employees : �޿�, �μ� ���̵�
-- departments : �μ� ���̵�, �μ���
SELECT department_id, department_name
    FROM departments D
    WHERE EXISTS
        (SELECT *
            FROM employees E
            WHERE D.department_id = E.department_id
                AND E.salary >= 9000
        )
    ORDER BY D.department_name
    ;

--==================================================================

-- LIKE ���ǽ�(119p)
-- ������ �˻��Ҷ����� ����(�������߿� �ʼ���)
ex) ������̺��� ��� �̸��� 'ȫ�浿'�� ��� ��ȸ
ex) ������̺��� ��� �̸��� 'ȫ'���� �����ϴ� ��� ��ȸ
 LIKE '���ڿ� ����' : �˻�
  - �������� : '%���ڿ�����%'
  - n���� : '���ڿ�����_' �� �ʿ��� ��ġ�� '_'�� n����ŭ ���
    
--John ã��
SELECT emp_name
    FROM employees
    WHERE emp_name LIKE 'John%'
    ;

SELECT emp_name
    FROM employees
    WHERE emp_name LIKE '%John'
    ;

SELECT emp_name
    FROM employees
    WHERE emp_name LIKE '%John%'
    ;

-- ������̺��� ��� �̸��� 'A'�� ���۵Ǵ� ����� ��ȸ(119p)
SELECT emp_name
    FROM employees
    WHERE emp_name LIKE 'A%'
    ;

-- LIKE ����(120p)
CREATE TABLE ex3_5(
    names VARCHAR2(30)
    );

INSERT INTO ex3_5 VALUES ('ȫ�浿');
INSERT INTO ex3_5 VALUES ('ȫ���');
INSERT INTO ex3_5 VALUES ('ȫ���');
INSERT INTO ex3_5 VALUES ('ȫ���');
INSERT INTO ex3_5 VALUES ('ȫ���');

SELECT * FROM ex3_5;

COMMIT;

SELECT *
    FROM ex3_5
    WHERE names LIKE 'ȫ%'
    ;

SELECT *
    FROM ex3_5
    WHERE names LIKE '%��%'
    ;

SELECT *
    FROM ex3_5
    WHERE names LIKE '%��'
    ;

SELECT *
    FROM ex3_5
    WHERE names LIKE 'ȫ��%'
    ;
    
SELECT *
    FROM ex3_5
    WHERE names LIKE 'ȫ��_'
        OR names LIKE 'ȫ��__'
    ;

--==================================================================
--==================================================================
/*
CH4. SQL �Լ�
[�����Լ�]
 - ABS(n) : n�� ���밪 ��ȯ
     ex) ABS(3) �� 3, ABS(-3) �� 3
 - CEIL(n) : n�� ���ų� ���� ū ���� ��ȯ
     ex) CEIL(10.123) �� 11, CEIL(10.541) �� 11
 - FLOOR(n) : n���� �۰ų� ���� ū ���� ��ȯ
     ex) FLOOR(10.123) �� 10, FLOOR(10.541) �� 10
 - ROUND(n, i) : n�� �Ҽ��� ���� (i+1)��°���� �ݿø��� ��� ��ȯ
     ex) ROUND(10.154) �� 10, ROUND(10.154, 2) �� 10.15
 - ��TRUNC(n1, n2) ���߿�� : n1�� �Ҽ��� ���� n2�ڸ����� ������ �߶� ����� ��ȯ
     ex) TRUNC(115.155) �� 115, TRUNC(115.155, 1) �� 115.1
 - POWER(n2, n1) : n2�� n1 ������ ����� ��ȯ, n2�� ������ n1�� �ݵ�� ����
     ex) POWER(3,2) �� 9, POWER(3,3) �� 27
 - SQRT(n) : n�� ������ ��ȯ
     ex) SQRT(2) �� 1.41421356, SQRT(5) �� 2.23606798
 - ��MOD(n2, n1) ���߿�� : n2�� n1���� ���� ������ ���� ��ȯ
     ex) MOD(19, 4) �� 3, MOD(19.123, 4.2) �� 2.323
 - REMAINDER(n2, n1) : MOD�� ������ ��������� �ٸ�
 - EXP(n) : �����Լ��� e�� n���� ���� ��ȯ
     ex) EXP(2) �� 7.3890561
 - LN(n) : �ڿ��α� �Լ��� �ؼ��� e�� �α��Լ�
     ex) LN(2.713) �� 0.998055034
 - LOG(n2, n1) : n2�� �ؼ��� �ϴ� n1�� �αװ��� ��ȯ
     ex) LOG(10, 100) �� 2
*/

-- ABS(n) �Լ�
SELECT ABS(10) FROM DUAL;
SELECT ABS(0) FROM DUAL;
SELECT ABS(-10) FROM DUAL;
-- CEIL(n) �Լ�
SELECT CEIL(10.123), CEIL(10.541), CEIL(10) FROM DUAL;
-- FLOOR(n) �Լ�
SELECT FLOOR(10.123), FLOOR(10.541), FLOOR(10) FROM DUAL;
-- ROUND(n, i) �Լ�
SELECT ROUND(10.123), ROUND(10.541), ROUND(10) FROM DUAL;
SELECT ROUND(10.157, 1), ROUND(10.157,2), ROUND(10.157, 3) FROM DUAL;
-- ��TRUNC(n, i) �Լ�, ���߿��
SELECT TRUNC(115.155), TRUNC(115.155, 1), TRUNC(115.155, -2) FROM DUAL;
-- POWER(n, i) �Լ�
SELECT POWER(2, 2), POWER(3, 3), POWER(4, -2) FROM DUAL;
-- SQRT(n) �Լ�
SELECT SQRT(2), SQRT(3), SQRT(5) FROM DUAL;
-- ��MOD(n, i) �Լ�, ���߿��
SELECT MOD(13, 2), MOD(19, 4) FROM DUAL;
-- REMAINDER(n, i) �Լ�
SELECT REMAINDER(13, 2), REMAINDER(19, 4) FROM DUAL;

--==================================================================

/*
[�����Լ�]
 - INITCAP(char) : char�� ù ���ڴ� �빮�ڷ�, �������� �ҹ��ڷ� ��ȯ
                  ù ���� �ν� ������ ���� �׸��� ���ĺ��� ���ڸ� ������ ����
    ex) INITCAP('never say goodbye') �� Never Say Goodbye
 - ��LOWER(char) : �ҹ��� ��ȯ �� ��ȯ
    ex) LOWER('NEVER SAY GOODBYE') �� never say goodbye
 - ��UPPER(char) : �빮�� ��ȯ �� ��ȯ
    ex) UPPER('never say goodbye') �� NEVER SAY GOODBYE
 - ��CONCAT(char1, char2) : �� ���ڸ� �ٿ� ��ȯ
    ex) CONCAT('I Have', 'A Dream') �� I Have A Dream
 - ��SUBSTR(char, pos, len) : char�� pos���� ���ں��� len ���̸�ŭ �߶� ����� ��ȯ
    ex) SUBSTR('ABCDEFG', 1, 4) �� ABCD, SUBSTR('ABCDEFG', -1, 4) �� G
 - ��SUBSTRB(char, pos, len) : SUBSTR�� ������ ���� ������ �ƴ� ����Ʈ �� ����
    ex) SUBSTRB('ABCDEFG', 1, 4) �� ABCD, SUBSTRB('�����ٶ󸶹ٻ�', 1, 4) �� ��
 - ��LTRIM(char, set) : char���� set���� ������ ���ڿ��� ���� ������ ���� �� ������ ���ڿ� ��ȯ
    ex) LTRIM('ABCDEFGABC', 'ABC') �� DEFGABC
 - ��RTRIM(char, set) : LTRIM�� �ݴ�� ������ ������ ������ �� ������ ���ڿ��� ��ȯ
    ex) RTRIM('ABCDEFGABC', 'ABC') �� ABCDEFG
 - LPAD(expr1, n, expr2) : expr2 ���ڿ��� n�ڸ���ŭ ���ʺ��� ä�� expr1�� ��ȯ
    ex) LPAD('111-1111', 12, '(02)') �� (02)111-1111
 - RPAD(expr1, n, expr2) : �����ʿ� �ش� ���ڿ��� ä�� ��ȯ
    ex) RPAD('111-1111', 12, '(02)') �� 111_1111(02)
 - ��REPLACE(char, search_str, replace_str) : char���� search_str�� ã�� �̸� replace_str�� ��ü
    ex) REPLACE('���� �ʸ� �𸣴µ�', '��', '��') �� �ʴ� �ʸ� �𸣴µ�
 - TRANSLATE(expr, from_str, to_str) : expr���� from_str�� �ش��ϴ� ���ڸ� ã�� to_str�� �� ���ھ� �ٲ� ��� ��ȯ
    �� �������� ��ȣ�� �����ؼ� ��� (ex: ���������� ��)
    ex) TRANSLATE('���� �ʸ� �𸣴µ�', '����', '�ʸ�') �� �ʸ� �ʸ� �𸣸���
 - INSTR(str, substr, pos, oocur)
  : str���� substr�� ��ġ�ϴ� ��ġ�� ��ȯ, pos�� ������ġ, occur�� ���° ��ġ�ϴ����� ���
    ex) INSTR() �� 
 - LENGTH(chr) : ���ڿ��� ���� ��ȯ
    ex) LENGTH('���ѹα�') �� 4
 - LENGTHB(chr) : ���ڿ��� byte�� ��ȯ
    ex) LENGTHB('���ѹα�') �� 12
*/
-- INITCAP 
SELECT INITCAP('never say goodbody')
       , INITCAP('NEVER SAY GOODBYE')
       , INITCAP('never6say*good��bye') -- *�ڴ� ù���ڷ� �ν�
      FROM DUAL;

-- LOWER
SELECT LOWER('never say goodbody')
       , LOWER('NEVER SAY GOODBYE')
       , LOWER('never^say*good��bye')
      FROM DUAL;

-- UPPER
SELECT UPPER('never say goodbody')
       , UPPER('NEVER SAY GOODBYE')
       , UPPER('never^say*good��bye')
      FROM DUAL;

-- CONCAT : 2���� ���ڸ� ���� ����
SELECT CONCAT('never', 'say goodbody')
        , 'never '||'say '||'goodbye'
          -- ���� �ʿ��� ���� �˾Ƽ� ���ϱ�
          -- ���� ���� ������
      FROM DUAL;

-- SUBSTR(����, ��ġ, ����)
SELECT SUBSTR('never say goodbye', 7, 3)    -- �ڰ��鵵 �����̹Ƿ� ������ ����
    FROM DUAL;
-- SUBSTRB(����, ��ġ, ����Ʈ)
SELECT SUBSTRB('���ɽð��� �����ΰ���?', 7, 6)
    FROM DUAL;
SELECT SUBSTRB('�����ٶ󸶹ٻ�', 1, 4)
    FROM DUAL;
-- LTRIM(����, �߶󳾹���)
SELECT LTRIM('never say goodbye', 'never')  -- �ڰ��鵵 �����̹Ƿ� ǥ�⿡ ����
    FROM DUAL;
SELECT LTRIM('never say goodbye', 'never ') -- �ڰ��鵵 �����̹Ƿ� ǥ�⿡ ����
    FROM DUAL;
-- RTRIM(����, �߶󳾹���)
SELECT RTRIM('never say goodbye', 'bye')
    FROM DUAL;
-- LPAD(���ڿ�1, ����, ���ڿ�2)
SELECT LPAD('123-4567', 13, '(032)')
    FROM DUAL;
-- RPAD(���ڿ�1, ����, ���ڿ�2)
SELECT RPAD('123-4567', 13, '(032)')
    FROM DUAL;
-- REPLACE(���ڿ�, ����ڿ�, �ٲܹ��ڿ�)
SELECT REPLACE('������ �����ͺ��̽�(RDBMS)�� ���� �θ� ���̰� �ִ�.
 �׸��� �� ������ �����ͺ��̽��� �̿��ϱ� ����
 ǥ�� �� ������� �ִµ� �װ��� SQL�̴�.', '����', '����')
    FROM DUAL;
-- TRANSLATE(���ڿ�, �����, �ٲܹ���)
SELECT TRANSLATE('������ �����ͺ��̽�(RDBMS)�� ���� �θ� ���̰� �ִ�.
 �׸��� �� ������ �����ͺ��̽��� �̿��ϱ� ����
 ǥ�� �� ������� �ִµ� �װ��� SQL�̴�.', '�̿밡��', '�������')
    FROM DUAL;
-- INSTR('����', '�˻��ҹ��ڿ�', ������ġ, �߻�Ƚ��)
SELECT INSTR('������ �����ͺ��̽�(RDBMS)�� ���� �θ� ���̰� �ִ�.
 �׸��� �� ������ �����ͺ��̽��� �̿��ϱ� ����
 ǥ�� �� ������� �ִµ� �װ��� SQL�̴�.'
        , '�����ͺ��̽�', 10, 1)
    FROM DUAL;

--==================================================================

/*
[��¥�Լ�]
 - ��SYSDATE : �������ڿ� �ð� ��ȯ
    ex) SYSDATE �� 2015-03-16 22:10:56
 - SYSTIMESTAMP : �������ڿ� �ð� ��ȯ (TIMESTAMP)
    ex) SYSTIMESTAMP �� 2015-03-16 22:10:56.998000000 +09:00
 - ��ADD_MONTHS(date, integer) : date�� integer��ŭ ���� ���� ��¥ ��ȯ
    ex) ADD_MONTHS(SYSDATE, 1) �� 2015-04-16 22:10:33
 - ��MONTHS_BETWEEN(date1, date2) : �� ��¥ ������ ���� �� ��ȯ
    ex) MONTHS_BETWEEN(ADD_MONTHS(SYSDATE,1), SYSDATE) �� 1
 - LAST_DAY(date) : �ش� ���� ������ ���� ��ȯ
    ex) LAST_DAY(SYSDATE) �� 2015-03-31
 - ROUND(date, format) : �ݿø��� ��¥ ��ȯ
    ex) ROUND(SYSDATE, 'month') �� 2015-04-01 00:00:00 (�������ڰ� 3/16�� ���)
 - TRUNC(date, format) : �߶� ��¥ ��ȯ
    ex) TRUNC(SYSDATE, 'month') �� 2015-03-01 00:00:00 (�������ڰ� 3/16�� ���)
 - NEXT_DAY(date, char) : date�� char�� ����� ��¥�� ������ ���� ���ڸ� ��ȯ
    ex) NEXT_DAY(SYSDATE, '�ݿ���') �� 2015-03-20 22:16:20

***** �Լ��� ��ø ���    
�Լ�(�Է°�1, �Է°�2)
    �Է°�2 �� �ٸ��Լ�()
�Լ�(�Է°�1, �ٸ��Լ�())
�� ��, ��ȯ�Ǵ� ����� ������Ÿ���� ��ġ�ϴ� ��쿡�� ����
*/

-- ADD_MONTHS(��¥, ����)
SELECT ADD_MONTHS(SYSDATE, 18)
    FROM DUAL;
-- MONTHS_BETWEEN(���۳�¥, ���ᳯ¥)
SELECT MONTHS_BETWEEN('2024-04-09', '2023/11/10')
    FROM DUAL;
SELECT MONTHS_BETWEEN(ADD_MONTHS(SYSDATE, 6), '2023/11/10')
    FROM DUAL;
-- LAST_DAY(��¥)
SELECT LAST_DAY('2024/2/1')
    FROM DUAL;
SELECT LAST_DAY(ADD_MONTHS(SYSDATE, 6))
    FROM DUAL;
-- ROUND(��¥, ����) : �ݿø��� ��¥
SELECT ROUND(SYSDATE, 'MONTH')
    FROM DUAL;
SELECT ROUND(TO_DATE('2023/11/15'), 'MONTH')
    FROM DUAL;
-- TRUNC(��¥, ����) : �߶� ��¥
SELECT TRUNC(TO_DATE('2023/11/15'), 'MONTH')
    FROM DUAL;
-- NEXT_DAY(��¥, ã������) : ���� �ش� ���� ���� ��ȯ
SELECT NEXT_DAY(SYSDATE, '�����')
    FROM DUAL;
SELECT NEXT_DAY(SYSDATE, '��')
    FROM DUAL;
    -- 1:�Ͽ���, 2:������, 3:ȭ����, ..., 7:�����
SELECT NEXT_DAY(SYSDATE, 7)
    FROM DUAL;

--==================================================================

/*
[��ȯ�Լ�]
 - TO_CHAR(���� Ȥ�� ��¥, format) : format�� �°� ��ȯ �� ��� ��ȯ
    ex) TO_CHAR(123456789, '999,999,999') �� 123,456,789
        TO_CHAR(SYSDATE, 'YYYY-MM-DD') �� 2015-03-16
 - TO_NUMBER(expr, format) : ���ڳ� �ٸ� ������ ���ڸ� NUMBER ������ ��ȯ
    ex) TO_NUMBER('123456') �� 123456
 - TO_DATE(char, format) : DATE������ ��ȯ
    ex) TO_DATE('20140101', 'YYYY-MM-DD') �� 2014/01/01 00:00:00
 - TO_TIMESTAMP(char, format) : TIMESTAMP ������ ��ȯ
    ex) TO_TIMESTAMP('20140101', 'YYYY-MM-DD') �� 2014-01-01 00:00:00.000000000
*/

-- ��ȯ
-- ���� ��ȯ
1. (�Ҽ���)�ڸ��� ���缭
2. ���� �� <>
3. ���/���� ǥ�� �� + / -
SELECT TO_CHAR(1234567, '999,999,999')
    FROM DUAL;
SELECT TO_CHAR(1234567, '9,999,999')    -- �ڸ��� ���缭
    FROM DUAL;
SELECT TO_CHAR(12345.67, '999999.9')    -- �Ҽ��� �ڸ��� ���缭(�ݿø�)
    FROM DUAL;
SELECT TO_CHAR(-123, '999PR')    -- ���� ǥ��
    FROM DUAL;
SELECT TO_CHAR(123, 'RN')    -- �θ����� ǥ��
    FROM DUAL;
SELECT TO_CHAR(123, 'S999')    -- ���(+)/����(-) ǥ��
    FROM DUAL;
SELECT TO_CHAR(123, '00000') FROM DUAL; -- ������ ���� ��ŭ 0���� ä���
SELECT TO_CHAR(123456, 'L999,999') FROM DUAL; -- ��ȭ ǥ�� ���̱�
    
SELECT TO_CHAR(SYSDATE, 'YY-MM-DD HH24:MI:SS')    -- ��¥ ���˿� ���缭
    FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'YY/MM/DD')    -- ��¥ ���˿� ���缭
    FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'YY/MM/DD AM HH24:MI:SS')  -- ��¥ ���˿� ���缭
    FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'YY-MM-DD DAY') FROM DUAL;  -- ���� ǥ��
SELECT TO_CHAR(SYSDATE-5, 'FMYY-MM-DD') FROM DUAL;  -- ��¥�� 0 ���ֱ�
SELECT TO_CHAR(SYSDATE, '""YYYY"�� "MM"�� "DD"��"') FROM DUAL;  -- ���� �����ڷ� ��¥ ���� �����

-- ���� ��ȯ
-- TO_NUMBER(����, ����)
-- ���ڳ� ��¥�� ���Ե� ������ ���ڷ� ��ȯ�ϸ� ���� �߻�
SELECT TO_NUMBER('123') FROM DUAL;
SELECT TO_NUMBER('ABC') FROM DUAL;      -- ����
SELECT TO_NUMBER(SYSDATE) FROM DUAL;    -- ����
SELECT TO_NUMBER('20231113') FROM DUAL;
-- SELECT TO_NUMBER(AGE) FROM DUAL;

-- ��¥ ��ȯ
TO_DATE(����, ����)

SELECT TO_DATE('20140101', 'YY-MM-DD') FROM DUAL;
SELECT TO_DATE('20140101', 'YY MM DD') FROM DUAL;
SELECT TO_DATE('20140101', 'YYYY-MM-DD') FROM DUAL;
SELECT TO_DATE('20140101 13:44:50', 'YYYY-MM-DD HH24:MI:SS') FROM DUAL;
SELECT TO_DATE('20140101 134450', 'YYYY-MM-DD HH24:MI:SS') FROM DUAL;
SELECT TO_DATE('2014/01/01 13/44/50', 'YYYY-MM-DD HH24:MI:SS') FROM DUAL;
-- SELECT TO_DATE('2014&01&01 13&44&50', 'YYYY-MM-DD HH24:MI:SS') FROM DUAL;   -- �ȵ�

* ����Ŭ ��¥/�ð� ���� ��� ���
 �������� - ��������
 ��ȯ �� : ���̰��� �� ���� ��ġ������ ��ȯ
  ex) SYSDATE - 5 �� 23/11/9
    SELECT TO_DATE('2021-05-08') - TO_DATE('2021-05-01') FROM DUAL;

�ð� ���� : (�����Ͻ�(YYYY-MM-DD HH:MI:SS) - �����Ͻ�(YYYY-MM-DD HH:MI:SS)) * 24
�� ���� : (�����Ͻ�(YYYY-MM-DD HH:MI:SS) - �����Ͻ�(YYYY-MM-DD HH:MI:SS)) * 24 * 60
�� ���� : (�����Ͻ�(YYYY-MM-DD HH:MI:SS) - �����Ͻ�(YYYY-MM-DD HH:MI:SS)) * 24* 60 * 60

NLS(National Language Support, ������ ��� ����) ���� Ȯ��
SELECT * FROM NLS_SESSION_PARAMETERS;
-- SESSION ���� ���� ��ɾ�
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH24:MI:SS';
ALTER SESSION SET NLS_DATE_FORMAT = 'RR-MM-DD HH24:MI:SS';

--==================================================================
/*
[NULL �Լ�]
-- NULL���� ó�� : NULL ���� ���ο� ���� ���� ���� �޶���
NVL(ǥ����1, ǥ����2)
    FROM ���̺�
    WHERE ����;

NVL2(ǥ����1, ǥ����2, ǥ����3) : ǥ����1�� NULL�� �ƴϸ� ǥ����2�� ��ȯ, NULL�̸� ǥ���� 3�� ��ȯ
    FROM ���̺�
    WHERE ����;
*/

-- NVL(ǥ����1, ǥ����2)
SELECT manager_id, NVL(manager_id, employee_id)
    FROM employees;
    
SELECT NVL(manager_id, employee_id)
    FROM employees
    WHERE manager_id IS NULL;

-- NVL2(ǥ����1, ǥ����2, ǥ����3)
-- : ǥ����1�� NULL�� �ƴϸ� ǥ����2�� ��ȯ, NULL�̸� ǥ���� 3�� ��ȯ
SELECT employee_id
       , NVL2(commission_pct, salary + (salary * commission_pct), salary) 
            AS salary2
    FROM employees;

-- �����ȣ, �޿�, �޿�+���ʽ�, ���ʽ� ��ȸ
SELECT employee_id
        , NVL2(commission_pct, salary+(salary*commission_pct), salary)
            AS salary_commission
        , (NVL2(commission_pct, salary+(salary*commission_pct), salary) - salary)
            AS bonus
    FROM employees;

-- NULL�� ���Ŀ����ڸ� ����Ͽ� ������ �ϸ� ������� NULL
SELECT employee_id, NVL(commission_pct, salary+(salary*commission_pct))
        AS salary_commission
    FROM employees;

-- COALESCE(ǥ����1, ǥ����2, ...)
-- : �Է°����� ������ ǥ���ĵ� �� NULL�� �ƴ� ù��° ǥ������ ��ȯ
-- �����ȣ, Ŀ�̼� ����, ���� �޿�
SELECT employee_id
        , commission_pct
        , COALESCE(salary+salary*commission_pct, salary)
    FROM employees;
    
-- LNNVL(���ǽ�)
-- ��ǥ : Ŀ�̼��� 0.2 �̸��� ����� ��ȸ(0%�� ���)
SELECT employee_id, commission_pct
    FROM employees
    WHERE commission_pct < 0.2;

SELECT COUNT(*)
    FROM employees
    WHERE commission_pct < 0.2;
    
SELECT COUNT(*)
    FROM employees
    WHERE NVL(commission_pct, 0) < 0.2;

SELECT COUNT(*)
    FROM employees
    WHERE LNNVL(commission_pct >= 0.2);

-- NULLIF(ǥ����1, ǥ����2) : ǥ����1�� ǥ����2�� ������ NULL, �ٸ��� ǥ����1�� ��ȯ
-- ������� ��, ���ID�� �����ϸ� null, ������ ���ID�� ��ȯ�ϴ� ���� ��ʷ� ��� ����
[����] ������ ���۳�¥�� ���ᳯ¥�� ������ ������ NULL,
        ���� ������ ����⵵�� ����ϴ� ������ �ۼ��Ͻÿ�.
 - ��¥ �� => ���ڵ����� ���� �� ���� ����

SELECT employee_id
        , TO_CHAR(start_date, 'YYYY') AS start_year
        , TO_CHAR(end_date, 'YYYY') AS end_year
        , NULLIF(TO_CHAR(end_date, 'YYYY'), TO_CHAR(start_date, 'YYYY'))
            AS nullif_year      -- NULLIF(����⵵, ���۳⵵)
    FROM job_history;

DESC job_history;

--==================================================================

/*
[��Ÿ �Լ�]
 - GREATEST(ǥ����1, ǥ����2, ...) : �Ű������� ������ ǥ���Ŀ��� ���� ū ���� ��ȯ
 
 - LEAST(ǥ����1, ǥ����2, ...) : �Ű������� ������ ǥ���Ŀ��� ���� ���� ���� ��ȯ
 
 - ��DECODE(expr, search1, result1, search2, result2, ..., default)
    : expr�� search1�� ���� �� ���� ������ result1�� ��ȯ.
      ���� ������ �ٽ� search2�� ���� ���� ������ result2�� ��ȯ,
      �̷� ������ ��� ���� �� ���������� ���� ���� ������ default ���� ��ȯ�Ѵ�.
-- DECODE�� �Ϲ� ���α׷��� ����� IF~ELSE���� ó������� ����
-- CASE WITH���� ó������� �����
-- �ٸ�, DECODE�� �񱳰��� ������� ������ �����ϹǷ� CASE WITH ����� �ڵ尡 �� �����
*/

-- GREATEST(ǥ����1, ǥ����2, ...) : ���� ū ��
SELECT GREATEST(1,2+22,4,7,8,11,23)
    FROM DUAL;
    
-- LEAST(ǥ����1, ǥ����2, ...) : ���� ���� ��
SELECT LEAST(1,2,4,7,8,11,23)
    FROM DUAL;
    
SELECT GREATEST('apple', 'banana', 'orange', 'graph', 'mango') AS greatest
        , LEAST('apple', 'banana', 'orange', 'graph', 'mango') AS least
    FROM DUAL;

SELECT GREATEST('ȫ�浿', '���缮', '��ȣ��', '��Ư', '������') AS greatest
        , LEAST('ȫ�浿', '���缮', '��ȣ��', '��Ư', '������') AS least
    FROM DUAL;

-- ��DECODE(ǥ����, ��1, ���1, ��2, ���2, ..., �⺻��)
-- DECODE�� �Ϲ� ���α׷��� ����� IF~ELSE���� ó������� ����
-- CASE WHEN���� ó������� �����
-- �ٸ�, DECODE�� �񱳰��� ������� ������ �����ϹǷ� CASE WHEN ����� �ڵ尡 �� �����
SELECT prod_id
       , DECODE(channel_id, 3, '�̸�Ʈ',
                            9, '�Ե���Ʈ',
                            5, 'Ʈ���̴���',
                            4, 'Ƽ��',
                               '���Ŵ�') AS decodes
    FROM sales
    WHERE rownum < 100;

--==================================================================
--==================================================================
/*
CH5. �׷�����, ���տ�����
[�⺻ �����Լ�]
 - ��COUNT : ���� ����� ��, �ο� �� ��ȯ
 - ��SUM() : ��ü�հ�
 - ��AVG() : ���
 - ��MIN() : �ּҰ�
 - ��MAX() : �ִ밪
 - VARIANCE() : �л�
 - STDDEV() : ǥ������
*/

-- �����Լ�
-- 1> ��COUNT(ǥ����)
SELECT COUNT(*), COUNT(employee_id), COUNT(emp_name), COUNT(manager_id)
    FROM employees;
    -- null�� ������ ���� �޶���

-- �Ѹ��� ����� ���� ����(�μ�)�� �ٹ��� ������
-- DISTINCT : ���ϼ� ���� Ȯ��, �ߺ� ����
SELECT COUNT(DISTINCT department_id)
    FROM employees;

SELECT COUNT(DISTINCT employee_id)
    FROM employees;

-- ���� ��ȥ�� ��� �� �հ�
SELECT COUNT(*)
    FROM customers
    WHERE cust_marital_status='single';

-- 2> ��SUM(ǥ����)
SELECT SUM(salary), SUM(DISTINCT salary)
    FROM employees;

-- ǥ���� ������ Ȱ��
SELECT SUM(salary), SUM(salary + salary * 2/100), SUM(salary) + SUM(salary)*2/100
    FROM employees;

-- ���� �Լ� �� �Լ� ���
SELECT SUM(salary + salary * 2/100), SUM(salary + ROUND(salary * 2/100))
    FROM employees;

-- 3> ��MIN(ǥ����), 4> ��MAX(ǥ����)
SELECT MIN(salary), MAX(salary)
    FROM employees;

-- �ִ�/�ּҴ� �̹� �ϳ��� ���� ����ϹǷ�, DISTINCT�� ȿ�� ����
SELECT MIN(DISTINCT salary), MAX(DISTINCT salary) 
    FROM employees;
    
-- 5> ��AVG(ǥ����)
SELECT AVG(salary), AVG(DISTINCT salary)
    FROM employees;

-- ��ǰ ���� ���
SELECT AVG(prod_list_price)
    FROM products;

-- WHERE�� �����Լ� �ܵ� ��� �Ұ�!
SELECT COUNT(*)
    FROM products
    WHERE prod_list_price <= AVG(prod_list_price);

-- VARIANCE(ǥ����) : �л�
SELECT VARIANCE(salary)
    FROM employees;

-- STDDEV(ǥ����) : ǥ������
SELECT STDDEV(salary)
    FROM employees;

--==================================================================
/*
[GROUP BY ~ HAVING ��]
 - GROUP BY��
  : Ư�� �׷����� ���� ������ ���� �� ���
  : WHERE�� ORDER BY�� ���̿� ��ġ
  : �����Լ��� �Բ� ���
  : ��SELECT ����Ʈ���� �����Լ��� ������ ��� �÷��� ǥ������ GROUP BY ���� ����ؾ� ��

 - HAVING ��
  : GROUP BY�� ������ ��ġ�� GROUP BY�� ����� ������� �ٽ� ���͸� �Ŵ� ����
  : HAVING �������� SELECT ����Ʈ�� ����ߴ� �����Լ��� �̿��� ������ ���
  
 - ROLLUP(ǥ����1, ǥ����2, ...)
  : GROUP BY������ ����
  : ǥ������ �������� ������ ���, �߰� ���� ����
  : ǥ���� ���� ������ ���� ���� ���� ����
  : ǥ���� ������ n�����, n+1 ��������, �������� ���� ���� ������ ����
  
 - CUBE(ǥ����1, ǥ����2, ...)
  : GROUP BY ������ ����
  : ����� ǥ���� ������ ���� ������ ��� ���պ��� ����
  : ǥ���� ������ 3�̸� 2^3, �� �� 8���� ������ �����
  : ǥ���� ������ n�̸� 2^n ���� ������ �����
  
 - SQL ���� ����
 SELECT �÷���         -- 5
    FROM ���̺��      -- 1
    WHERE ����         -- 2
    GROUP BY �÷���    -- 3
    HAVING �׷�����     -- 4
    ORDER BY �÷���    -- 6
 ;

[���տ�����]
 - UNION
  : ������ ������ ����
  : 2�� �̻��� ���� SELECT ������ ����
  : ���� SELECT ���� ��ȯ ����� �ߺ��� ��� UNION ���� ����� �� �ο츸 ��ȯ
  ex) A = {1,2,3}, B = {2,3,4}, A [UNION] B = {1,2,3,4}

 - UNION ALL
  : UNION�� ����
  : ���� SELECT ���� ��ȯ ����� �ߺ��� ���, �ߺ��Ǵ� �Ǳ��� ��� ��ȯ
  ex) A = {1,2,3}, B = {2,3,4}, A [UNION ALL] B = {1,2,2,3,3,4}
  
 - INTERSECT
  : ������ ������ ����
  : 2�� �̻��� ���� SELECT ������ ����
  : ���� SELECT ���� ��ȯ ��� �� �ߺ��� �Ǹ� ��ȯ
  ex) A = {1,3,5,7}, B = {2,3,4,7,8}
        A [INTERSECT] B = {3,7}

 - MINUS
  : ������ ������ ����
  : 2�� �̻��� ���� SELECT ������ ����
  : ���� SELECT ���� ��ȯ ��� �� �ߺ��� ���� ������ ���� ���� ��� ����
  ex) A = {1,3,5,7}, B = {2,3,4,7,8},
        A [MINUS] B = {1,5}
        B [MINUS] B = {2,4,8}

 - ���� ������ ���ѻ���
  : ���� SELECT ������ SELECT ����Ʈ ������ ������ Ÿ���� ��ġ�ؾ� ��
  : ORDER BY ���� �� ������ ���� SELECT �������� ��� ������
  : BLOB, CLOB, BFILE ���� LOB Ÿ�� �÷��� ���� ������ ��� �Ұ�
  : UNION, INTERSECT, MINUS �����ڴ� LONG�� �÷����� ��� �Ұ�
  <���ǻ���>
  1. SELECT ����Ʈ�� ���� �� ������Ÿ�� ��ġ
  2. ORDER BY���� ������ SELECT �������� ��� ����
  
 - ���տ����� ����
 SELECT �÷�
     FROM ���̺�
     WHERE ����
     GROUP BY �׷��÷�
     HAVING �׷� ����
 ���տ�����
 SELECT �÷�
     FROM ���̺�
     WHERE ����
     GROUP BY �׷��÷�
     HAVING �׷� ����
     ORDER BY �÷�
 ;

*/

-- GROUP BY ����
SELECT �÷�1, �÷�2, �����Լ�(ǥ����)
    FROM ���̺�
    WHERE ����
    GROUP BY �÷�1, �÷�2
    ORDER BY �÷�
;

-- ������̺��� �μ� ��ȣ�� 70���� ��� �׷��� �μ� ��ȣ�� �޿� �հ�
SELECT department_id, SUM(salary)
    FROM employees
    WHERE department_id = 70    -- date type�� number�� '' �ʿ� X. ���� Ÿ���� ���ڿ����� '' �ʿ�O.
    GROUP BY department_id
    ORDER BY department_id
;

-- ������̺��� �μ� ��ȣ�� ��� �׷��� �μ� ��ȣ, �޿� �հ�, �����, �޿� ���
SELECT department_id, SUM(salary), COUNT(employee_id), AVG(salary)
    FROM employees
    GROUP BY department_id
    ORDER BY department_id
;

-- ������̺��� �μ� ��ȣ�� ��� �׷��� �μ� ��ȣ, �޿� �հ�, �����
--  , �޿� ���(�Ҽ��� ����), �޿� ����� �������� ����
SELECT department_id, SUM(salary), COUNT(employee_id), TRUNC(AVG(salary))
    FROM employees
    GROUP BY department_id
    ORDER BY TRUNC(AVG(salary)) DESC
;

-- 
SELECT SUM(loan_jan_amt)
    FROM kor_loan_status
;

-- 
SELECT period, region
    FROM kor_loan_status
    GROUP BY period, region
;

-- group by : select ���� �����Լ� ������ ��� �÷��� group by���� ��� ��
SELECT period, region, SUM(loan_jan_amt)
    FROM kor_loan_status
    GROUP BY period, region
;

-- �Ⱓ�� �����ܾ��� �հ� ���
SELECT period, SUM(loan_jan_amt)
    FROM kor_loan_status
    GROUP BY period
    ORDER BY SUM(loan_jan_amt) DESC
;

-- ������ �����ܾ��� �հ� ���
SELECT region, TRUNC(SUM(loan_jan_amt))
    FROM kor_loan_status
    GROUP BY region
    ORDER BY TRUNC(SUM(loan_jan_amt)) DESC
;

-- 2013���� �����ܾ� �հ� ���
SELECT period, SUM(loan_jan_amt)
    FROM kor_loan_status
    WHERE period LIKE '2013%'
    GROUP BY period
    ORDER BY SUM(loan_jan_amt) DESC
;

-- �ѱ� ������� ���̺��� 2013�⵵ �Ⱓ�� ����� �հ踦 �Ⱓ����(��������)�� ��ȸ
SELECT period, region, SUM(loan_jan_amt)
    FROM kor_loan_status
    WHERE period LIKE '2013%'
    GROUP BY period, region
    ORDER BY SUM(loan_jan_amt)
;

-- �Ⱓ�� ������ ����� �հ� ��ȸ
SELECT period, region, SUM(loan_jan_amt)
    FROM kor_loan_status
    WHERE period LIKE '2013%'
    GROUP BY period, region
    ORDER BY period
;

-- ������ �Ⱓ�� ����� �հ� ��ȸ
SELECT region, period, SUM(loan_jan_amt)
    FROM kor_loan_status
    WHERE period LIKE '2013%'
    GROUP BY period, region
    ORDER BY region
;

------------------------------------------------------------
-- HAVING��
-- 2013�� 11�� �Ⱓ��/������ �� �ܾ��� [100�� �ʰ�] ���� ��ȸ
SELECT period, region, SUM(loan_jan_amt)
    FROM kor_loan_status
    WHERE period = '201311'
    GROUP BY period, region
    HAVING SUM(loan_jan_amt) > 100000
    ORDER BY region
;

------------------------------------------------------------
-- ROLLUP��
-- BEFORE_ROLLUP
SELECT period, gubun, SUM(loan_jan_amt)
    FROM kor_loan_status
    WHERE period LIKE '2013%'
    GROUP BY period, gubun
--    HAVING 
--    ORDER BY period
;
-- AFTER_ROLLUP
-- �Ⱓ/���п� ���� �ܰ躰 �����Ѿ� ��ȸ
-- �Ⱓ�� ���ؼ� 
SELECT period, gubun, SUM(loan_jan_amt)
    FROM kor_loan_status
    WHERE period LIKE '2013%'
    GROUP BY ROLLUP(period, gubun)
;

-- ǥ���� 2�� : 2+1����
-- ���п� ���ؼ�
SELECT period, gubun, SUM(loan_jan_amt)
    FROM kor_loan_status
    WHERE period LIKE '2013%'
    GROUP BY ROLLUP(gubun, period)
;

-- ǥ����  1�� : 1+1����
SELECT period, SUM(loan_jan_amt)
    FROM kor_loan_status
    WHERE period LIKE '2013%'
    GROUP BY ROLLUP(period)
;

-- ǥ���� 3�� : 3+1����
SELECT period, gubun, region, SUM(loan_jan_amt)
    FROM kor_loan_status
    WHERE period LIKE '2013%'
    GROUP BY ROLLUP(gubun, period, region)
;

--
SELECT �÷�1, �÷�2, �����Լ�(ǥ����)
   FROM ���̺��
   WHERE ����
   GROUP BY ROLLUP(ǥ����2, ǥ����3)
;
<ROLLUP�� ����� ���� : 2+1 ����>
(ǥ����2, ǥ����3)
(ǥ����2)
(��ü)
;

���� �Ѿ�(PARTIAL ROLLUP)
SELECT �÷�1, �÷�2, �����Լ�(ǥ����)
   FROM ���̺��
   WHERE ����
   GROUP BY ǥ����1, ROLLUP(ǥ����2, ǥ����3)
;
<ROPPUP�� ����� ���� : 2+1 ����>
(ǥ����1, ǥ����2, ǥ����3)
(ǥ����1, ǥ����2)
(ǥ����1)
;

-- ���� �Ѿ�
SELECT �÷�1, �÷�2, �����Լ�(ǥ����)
   FROM ���̺��
   WHERE ����
   GROUP BY ǥ����1, ROLLUP(ǥ����2)
;
<ROPPUP�� ����� ���� : 1+1 ����>
(ǥ����1, ǥ����2)
(ǥ����1)
;

-- ǥ���� 1�� -> 1+1 ����
SELECT gubun, period, SUM(loan_jan_amt)
   FROM kor_loan_status
   WHERE period LIKE '2013%'
   GROUP BY gubun, ROLLUP(period)
;

-- CUBE (162p)
-- ǥ���� 1�� -> 2^1���� ������ ���
SELECT gubun, SUM(loan_jan_amt)
    FROM kor_loan_status
    WHERE gubun = '��Ÿ����'
    GROUP BY CUBE(gubun)
;

-- ǥ���� 2�� -> 2^2���� ������ ���
-- CUBE ���� ǥ���� ������ �������(��� ������ �ٸ�)
SELECT period, gubun, SUM(loan_jan_amt)
    FROM kor_loan_status
    WHERE gubun = '��Ÿ����'
    GROUP BY CUBE(gubun, period)
;

SELECT period, gubun, SUM(loan_jan_amt)
    FROM kor_loan_status
    WHERE gubun = '��Ÿ����'
    GROUP BY CUBE(period, gubun)
;

-- ǥ���� 3�� -> 2^3���� ������ ���
SELECT region, period, gubun, SUM(loan_jan_amt)
    FROM kor_loan_status
    WHERE gubun = '��Ÿ����'
    GROUP BY CUBE(gubun, period, region)
;

------------------------------------------------------------
-- ���տ�����
-- ���� ǰ��
CREATE TABLE exp_goods(
    country VARCHAR2(10)
    , seq   NUMBER
    , goods VARCHAR2(80)
);

INSERT INTO exp_goods VALUES('�ѱ�', 1, '�������� ������');
INSERT INTO exp_goods VALUES('�ѱ�', 2, '�ڵ���');
INSERT INTO exp_goods VALUES('�ѱ�', 3, '��������ȸ��');
INSERT INTO exp_goods VALUES('�ѱ�', 4, '����');
INSERT INTO exp_goods VALUES('�ѱ�', 5, 'LCD');
INSERT INTO exp_goods VALUES('�ѱ�', 6, '�ڵ�����ǰ');
INSERT INTO exp_goods VALUES('�ѱ�', 7, '�޴���ȭ');
INSERT INTO exp_goods VALUES('�ѱ�', 8, 'ȯ��źȭ����');
INSERT INTO exp_goods VALUES('�ѱ�', 9, '�����۽ű� ���÷��� �μ�ǰ');
INSERT INTO exp_goods VALUES('�ѱ�', 10, 'ö �Ǵ� ���ձݰ�');

INSERT INTO exp_goods VALUES('�Ϻ�', 1, '�ڵ���');
INSERT INTO exp_goods VALUES('�Ϻ�', 2, '�ڵ�����ǰ');
INSERT INTO exp_goods VALUES('�Ϻ�', 3, '��������ȸ��');
INSERT INTO exp_goods VALUES('�Ϻ�', 4, '����');
INSERT INTO exp_goods VALUES('�Ϻ�', 5, '�ݵ�ü������');
INSERT INTO exp_goods VALUES('�Ϻ�', 6, 'ȭ����');
INSERT INTO exp_goods VALUES('�Ϻ�', 7, '�������� ������');
INSERT INTO exp_goods VALUES('�Ϻ�', 8, '�Ǽ����');
INSERT INTO exp_goods VALUES('�Ϻ�', 9, '���̿���, Ʈ��������');
INSERT INTO exp_goods VALUES('�Ϻ�', 10, '����');

COMMIT;

-- ����ǰ ���̺��� ������ �ѱ��� ��ǰ���� ��� ��ȸ
-- (��, ǰ�� ��ȣ ������� ��ȸ�� ��, ��������)
SELECT *
    FROM exp_goods
    WHERE country = '�ѱ�'
    ORDER BY seq ASC
;


-- �⺻ ����
SELECT �÷�
    FROM ���̺�
    WHERE ����
    GROUP BY �׷��÷�
    HAVING �׷� ����
���տ�����
SELECT �÷�
    FROM ���̺�
    WHERE ����
    GROUP BY �׷��÷�
    HAVING �׷� ����
    ORDER BY �÷�
;

-- UNION
SELECT goods
    FROM exp_goods
    WHERE country = '�ѱ�'
UNION
SELECT goods
    FROM exp_goods
    WHERE country = '�Ϻ�'
    ORDER BY 1  -- 1 : ù��° �÷��� �������� ��ȸ
;

-- UNION ALL
SELECT goods
    FROM exp_goods
    WHERE country = '�ѱ�'
UNION ALL
SELECT goods
    FROM exp_goods
    WHERE country = '�Ϻ�'
    ORDER BY 1 
;

-- INTERSECT
SELECT goods
    FROM exp_goods
    WHERE country = '�ѱ�'
INTERSECT
SELECT goods
    FROM exp_goods
    WHERE country = '�Ϻ�'
    ORDER BY 1
;

-- MINUS
-- �ѱ��� �����ϴ� ǰ��
SELECT goods
    FROM exp_goods
    WHERE country = '�ѱ�'
MINUS
SELECT goods
    FROM exp_goods
    WHERE country = '�Ϻ�'
    ORDER BY 1
;

-- �Ϻ��� �����ϴ� ǰ��
SELECT goods
    FROM exp_goods
    WHERE country = '�Ϻ�'
MINUS
SELECT goods
    FROM exp_goods
    WHERE country = '�ѱ�'
    ORDER BY 1
;

<���ǻ���>
1. SELECT ����Ʈ�� ���� �� ������Ÿ�� ��ġ
2. ORDER BY���� ������ SELECT �������� ��� ����

--==================================================================
--==================================================================
/*
CH6. ���ΰ� ��������

***** SQL (DML)
��CRUD : ����Ʈ����(DB, �ڹ�, ���̽�, SQL ��)�� ������ �⺻���� ������ ó�� ���
 - CRUP = Create(����), Read(�б�), Update(����), Delete(����)
 - Create(����)   �� INSERT
 - Read(�б�)     �� SELECT
 - Update(����)   �� UPDATE
 - Delete(����)   �� DELETE
 
***** ������(JOIN)
 : ���̺� ���� ���踦 �δ� ���
 : ũ�� '���� ����'�� '�ܺ� ����'���� ����

## ���� ����(INNER JOIN)
 - �ڵ��� ����
  : ���� �⺻���̰� �Ϲ����� ���� ���
  : WHERE������ ��ȣ('=') �����ڸ� ����� 2�� �̻��� ���̺��̳� �並 ������ ���� �� ��������
  : �÷� ������ �������� ���
  : �� �÷� ���� ���� ���� ����
    SELECT *
        FROM TAB1 a, TAB2 b
        WHERE a.col1 = b.col1       -- col1 : �����÷�
        ....                        -- �÷��� �������� ���������� ����Ѵ�.
  
 - ���� ����(SEMI JOIN)
  : ���������� ����� ���������� �����ϴ� �����͸� ���� �������� �����ϴ� ����
  : WHERE������ IN�� EXISTS �����ڸ� ����� ���ι��
  : ���� ������ ���������� �����ϴ� �������� �����Ͱ� ���� �� �����ϴ���
    ���� ��ȯ�Ǵ� �������� �����Ϳ��� �ߺ��Ǵ� ���� ����
      �� �Ϲ� ���ΰ��� ������
      
    1> ��������(EXISTS) : ���ǿ� �����ϴ� �����Ͱ� �Ѱ��̶� ������ ��� ��ȯ
    SELECT *
        FROM TAB1 a
        WHERE EXISTS ( SELECT 1
                            FROM TAB2 b
                            WHERE a.col1 = b.col1
                            ....
                    );
    2> ��������(IN) : OR �����ڸ� ����� ���¿� ����.
    Ư¡
        1. �������� �������� ���� ������ ����.
        2. ���������� �÷��� �������� �������� ��õ� �÷��� ����.
     
    SELECT *
    FROM TAB1 a
    WHERE a.col1 IN ( SELECT b.col1
                        FROM TAB2 b
                        WHERE ....
                        ....
                    )
;
 - ��Ƽ ����(ANTI JOIN)
 1> NOT EXISTS
  : �������� ���̺��� ����, �������� ���̺��� �����͸� �����ϴ� ���� ���
  : WHERE������ NOT IN�� NOT EXISTS �����ڸ� ����� ���ι��
  : ����
    SELECT *
        FROM TAB1 a
        WHERE NOT EXISTS ( SELECT 1
                                FROM TAB2 b
                                WHERE a.col1 = b.col1
                                ....
                           )
    ;
    
    1> NOT IN
    SELECT *
        FROM TAB1 a
        WHERE a.col1 IN ( SELECT 1
                            FROM TAB2 b
                            WHERE ....
                            ....
                          )
    ;
    
 - ���� ����(SELF JOIN)
  : ���� �ٸ� �� ���̺��� �ƴ� ������ �� ���̺��� ����� ����
    SELECT *
        FROM TAB1 a, TAB1 b
        WHERE a.col1 = b.col1
        ....
    ;

## �ܺ� ����(OUTER JOIN)
 : �Ϲ� ������ Ȯ���� ����
 : ���� ���ǿ� �����ϴ� ������ �Ӹ� �ƴ϶�,
   ��� �� �� ���̺� ���� ���ǿ� ��õ� �÷��� ���� ���ų�(NULL�̴���)
   �ش� �ο찡 �ƿ� ������ �����͸� ��� ����
 : �������ǿ��� �����Ͱ� ���� �� ���̺��� �÷� ���� (+)�� ���δ�
 : ���������� ���� ���� ��� ��� �������ǿ� (+)�� �ٿ��� �Ѵ�
 <Ư¡>
    1. ���� �÷��� �ƴ� �÷��� (+) ǥ��. �� null ���� ���Ե�
    2. �ܺ����� ��, �������� 2�� ���� ���, ��� ���� ���ǿ� (+) ǥ���� ��.
    3. (+) �����ڰ� ���� ���ǰ� OR �� IN �����ڸ� ���� ��� �Ұ�.
    4. �ѹ��� �� ���̺��� �ܺ� ���� ����.

-- �Ϲ�����, ����� 10��
    SELECT a.department_id, a.department_name, b.job_id, b.department_id
        FROM departments a
            , job_history b
        WHERE a.department_id = b.department_id
    ;

-- �ܺ�����, ����� 31��
    SELECT a.department_id, a.department_name, b.job_id, b.department_id
        FROM departments a
            , job_history b
        WHERE a.department_id = b.department_id(+)
    ;
    
 - īŸ�þ� ����(CATASIAN PRODUCT, �ܺ�����)
  : �� �� ����
  : ���������� ���� ����
  : FROM ���� A�� B, 2���� ���̺��� ������� ���, ����Ǵ� �����ʹ�
    A ���̺� ������ �Ǽ� * B ���̺� ������ �Ǽ�

 - ANSI ��������(�Ƚ�����)
  : ����Ŭ ���� �ٸ� SQL������ ��밡���� ǥ�� ��������
  : ���������� ��� FROM ���� INNER JOIN�� ���
  : ���������� ON ���� ���
  : ���̺� �������� ���� �ٸ� ������ WHERE���� ����Ѵ�.
  [����]
    SELECT A.�÷�1, A.�÷�2, B.�÷�1, B.�÷�2, ...
        FROM ���̺� A
        INNER JOIN ���̺� B
        ON (A.�÷�1 = B.�÷�1)  -- ��������
        WHERE....
    ;
 - ANSI �ܺ�����
  : FROM���� LEFT(RIGHT) [OUTER] JOIN�� ���, ���������� ON���� ���
  : �Ϲݿܺ����ο����� �������̺�� ������̺�(�����Ͱ� ���� ���̺�)����
    ��� ���̺��� ���� ���ǿ� (+)�� �ٿ�����,
    ANSI �ܺ� ������ FROM���� ��õ� ���̺� ������ �԰���
    ���� ��õ� ���̺� �������� LEFT Ȥ�� RIGHT�� ���δ�
  : OUTER�� ���� ����
  [����]
    SELECT A.�÷�1, A.�÷�2, B.�÷�1, B.�÷�2, ...
        FROM ���̺� A
        LEFT(RIGHT) [OUTER] JOIN ���̺� B
        ON (A.�÷�1 = B.�÷�1)  -- ���� ����
        WHERE ....
    ;
    
 - ANSI CROSS ����
  : īŸ�þ� ������ ANSI ���ο����� CROSS �����̶� ��
  : FROM ���� CROSS JOIN ���
  [����]
    SELECT A.�÷�1, A.�÷�2, B.�÷�1, B.�÷�2, ...
        FROM ���̺� A
        CROSS JOIN ���̺� B
        WHERE
    ;
    
 - ANSI FULL OUTER ����
  : �Ϲ����� �ܺ� ������ �� ���̺� �� ��� �� ���̺�
    ���� ���ǿ� �����ϴ� �����Ͱ� ������
    �� ���̺� ������ ��� ��ȸ�ϴ� ���� �� ���� �̻��� ���� ����
  : �� �� ���̺��� �ƴ� �� ���̺� ��� �����Ͱ� ���� ���,
    �� �� ���̺� ��� �̻��� ���� ������ ����� ����Ǵ� �ܺ������� FULL OUTER �����̴�.
  : ���������� �������� �� ���̺� �� ��� �� �ʿ��� �����Ͱ� ������ ��ȸ�ȴ�.
  : FROM ���� FULL OUTER JOIN ���
  : FULL OUTER JOIN�� 
  [����]
    SELECT a.emp_id, b.emp_id
        FROM hong_a a
        FULL OUTER JOIN hong_b b
        ON (a.emp_id = b.emp_id)
    ;

*/
--==================================================================
[���� ����(��������)]
-- �������� : �������� ��ȣ('=')�� ����ؼ� 2�� ���̺��� ����
SELECT T1.�÷�, T2.�÷�
    FROM ���̺�1 T1, ���̺�2 T2
    WHERE T1.�÷��� = T2.�÷���       -- �̶�, �÷����� ���ƾ� ��
;
-- �������� ����(177p)
/* employees ���̺�� departments ���̺�����
    manager_id, department_id�� �����÷�(����)���� ����� �� �ִ�.*/

-- �����÷�(department_id)�� ��������
-- ���ʿ��� employees ���̺�, �����ʿ��� departments ���̺��� ������ �´�.
/* �����÷�(department_id)�� �����ϳ�,
   �����÷��� �ƴ� (manager_id)�� �ٸ� ���� ���� �� �����÷����� ���, �Ȼ���� ����
 �� �����÷� ��ü�� �ش� �÷��� �������� ������ ���� ���� �ο츦 ����ϹǷ� */
SELECT *
    FROM employees e, departments d
    WHERE e.department_id = d.department_id
;

-- �����÷� : manager_id
SELECT *
    FROM employees e, departments d
    WHERE e.manager_id = d.manager_id
;

-- employees ���̺��� employee_id �÷� ��ȸ
SELECT e.employee_id
    FROM employees e, departments d
    WHERE e.manager_id = d.manager_id
;

-- employees ���̺��� department_id �÷� ��ȸ
SELECT e.department_id
    FROM employees e, departments d
    WHERE e.manager_id = d.manager_id
;

-- departments ���̺��� department_id �÷� ��ȸ
SELECT d.department_id
    FROM employees e, departments d
    WHERE e.manager_id = d.manager_id
;

--
SELECT e.employee_id, d.department_id
    FROM employees e, departments d
    WHERE e.manager_id = d.manager_id
;

-- ����(177p)
/*
 employees ���̺� ���� �μ���(department_name)�� �Բ� ��ȸ�ϴ� ���� ����
 - ���, �μ� ���̺��� ���� �÷� department_id�� ���� ������ �������� ����Ͽ� ��ȸ
 - department_id�� departments ���̺��� Primary Key�̹Ƿ� �ʼ� ��������,
   employees ���̺��� �ʼ� ���� �ƴϹǷ�,
   employees ���̺��� department_id ���� �ִ� �Ǹ� ������
*/
SELECT e.employee_id, e.emp_name, e.department_id, d.department_name
    FROM employees e, departments d
    WHERE e.department_id = d.department_id
;

--==================================================================
[���� ����(��������)]
 : ���������� �����ϴ� �����͸� ���� �������� �����ϴ� ����

-- ��������1> EXISTS ������ : ���ǿ� �����ϴ� �����Ͱ� �Ѱ��̶� ������ ��� ��ȯ
SELECT �÷�
    FROM ���̺�1
    WHERE EXISTS(
                SELECT �÷�
                    FROM ���̺�2
                    WHERE ���̺�1.�÷� = ���̺�2.�÷�
);

-- �μ���ȣ, �μ��̸� ��ȸ
-- ����� �ٹ��ϰ� �ִ� �μ���ȣ�� �̸� ��ȸ
SELECT department_id, department_name
    FROM departments d
    WHERE EXISTS(
                SELECT *
                    FROM employees e
                    WHERE d.department_id = e.department_id
                        AND e.salary > 3000
                )
;

-- ��������2> IN ������ : OR �����ڸ� ����� ���¿� ����.
/* Ư¡
1. �������� �������� ���� ������ ����.
2. ���������� �÷��� �������� �������� ��õ� �÷��� ����. */
SELECT �÷�
    FROM ���̺�
    WHERE  �÷�  IN ( SELECT �÷�
                        FROM ���̺�
                        WHERE ����
                      )
;

-- ����> ��������(IN ������, 178p)
������̺��� �޿��� 3000���� �̻��� ����� �μ���ȣ�� ��ȸ�ؼ�
�μ����̺��� �μ���ȣ�� ������ ���ԵǾ� ������
�μ� ��ȣ�� �μ� �̸��� ��ȸ
SELECT e.department_id
    FROM employees e
    WHERE e.salary > 3000
;

SELECT d.department_id
    FROM departments d
    WHERE  d.department_id  IN ( SELECT e.department_id
                                    FROM employees e
                                    WHERE e.salary > 3000
                                )
;

SELECT d.department_id
    FROM departments d
    WHERE  d.department_id  IN ( SELECT e.department_id
                                    FROM employees e
                                    WHERE e.salary > 13000
                                )
;

--==================================================================
[��Ƽ����]

-- �������� : ������ ���� �μ� ��ȣ ��ȸ
SELECT department_id
    FROM departments
    WHERE manager_id IS NULL
;
-- ��������(��������) : ������̺�� �μ����̺��� �����ȣ, �����, �μ���ȣ, �μ����� ��ȸ
SELECT e.employee_id, e.emp_name, e.department_id, d.department_name
    FROM employees e, departments d
    WHERE e.department_id = d.department_id
;

-- ������̺�� �μ����̺��� 
-- [������ ���� �μ� ��ȣ�� ��ȸ�Ͽ� ���������� ����� ��ġ�ϸ�]
-- �����ȣ, �����, �μ���ȣ, �μ����� ��ȸ
SELECT e.employee_id, e.emp_name, e.department_id, d.department_name
    FROM employees e, departments d
    WHERE e.department_id = d.department_id
        AND e.department_id IN ( SELECT department_id
                                    FROM departments
                                    WHERE manager_id IS NULL
                               )
;

-- ��Ƽ����1> NOT EXISTS
��������
SELECT *
    FROM departments
    WHERE manager_id IS NULL;
        AND ��������
;

��������
SELECT employee_id, emp_name, department_id
    FROM employees;
--    WHERE ����

-- ������ ���� �μ��� �������� �ʴ� �����Ϳ��� ��� ������ ��ȸ
SELECT employee_id, emp_name, department_id
    FROM employees e
    WHERE NOT EXISTS ( SELECT *
                        FROM departments d
                        WHERE manager_id IS NULL
                            AND e.department_id = d.department_id
                   )
;

-- ��Ƽ����2> NOT IN
SELECT e.employee_id, e.emp_name, e.department_id, d.department_name
    FROM employees e, departments d
    WHERE e.department_id = d.department_id
        AND e.department_id NOT IN ( SELECT department_id
                                    FROM departments
                                    WHERE manager_id IS NULL
                               )
;
--==================================================================
-- [��������(SELF JOIN) ��� ����]
SELECT employee_id, emp_name, manager_id
    FROM employees
    WHERE salary>9000 and salary<11000
;

SELECT 
    FROM employees e1, employees e2
    WHERE e1.manager_id = e2.employee_id
;

--==================================================================

[�ܺ�����(OUTTER JOIN)]
-- �Ϲ�����, ����� 10��
 [��������] : �����÷��� ���� �����ϰ� NULL ���� ������
SELECT a.department_id, a.department_name, b.job_id, b.department_id
    FROM departments a
        , job_history b
    WHERE a.department_id = b.department_id
;

-- �ܺ�����, ����� 31��
 [�ܺ�����] : �����÷��� ���� �������� �ʰ�, NULL ���� ����
          (�����÷� ���� NULL�� ������ �������� �ʰ�, NULL�� �ƴϸ� ������)
    �� ���� �÷��� �ƴ� �÷��� (+) ǥ��. �� null ���� ���Ե�
SELECT a.department_id, a.department_name, b.job_id, b.department_id
    FROM departments a
        , job_history b
    WHERE a.department_id = b.department_id(+)
;

-- ����, a.department_id�� �ܺ������� ���ָ�, �ǹ� ����.
-- �������ΰ� ���� ��� ��ȸ��
--SELECT a.department_id, a.department_name, b.job_id, b.department_id
--    FROM departments a
--        , job_history b
--    WHERE a.department_id(+) = b.department_id;

-- �ܺ����� ����(182p)
-- �ܺ������� �� ���������� 2�� �̻��� ���, ��� ���� ���ǿ� (+) ǥ�� �� ��.
SELECT e.employee_id, e.emp_name, j.job_id, j.department_id
    FROM employees e
        , job_history j
    WHERE e.employee_id = j.employee_id(+)
        AND e.department_id = j.department_id(+)
;

-- (+) �����ڰ� ���� ���ǰ� OR �� IN �����ڸ� ���� ��� �Ұ�.
-- ��� : ���� ���� � (+)�� OR �Ǵ� IN�� ������� ������� �ʽ��ϴ�
SELECT e.employee_id, e.emp_name, j.job_id, j.department_id
    FROM employees e
        , job_history j
    WHERE e.employee_id = j.employee_id(+)
        OR e.department_id = j.department_id(+)
;

--==================================================================

-- ANSI ��������
<����Ŭ ���� : ���� ����>
SELECT A.�÷�1, A.�÷�2, B.�÷�1, B.�÷�2
    FROM ���̺� A, ���̺� B
    WHERE A.�÷�1 = B.�÷�1     -- ��������
    ....
;

<ANSI ����>
SELECT A.�÷�1, A.�÷�2, B.�÷�1, B.�÷�2
    FROM ���̺� A, ���̺� B
    INNER JOIN ���̺� B
    ON (A.�÷�1 = B.�÷�1)     -- ��������
    WHERE ....
    ....
;

-- ANSI �������� ����(187p)
SELECT e.employee_id, d.department_name
        , TO_CHAR(e.hire_date, 'YYYY-MM-DD') AS hire_date
    FROM employees e
    INNER JOIN departments d
    ON e.department_id = d.department_id
    WHERE e.hire_date >= TO_DATE('2003-01-01', 'YYYY-MM-DD')
;

[INNER JOIN ~ USING]
 : ���� ���� �÷��� �� ���̺� ��� �����ϴٸ� ON ��� USING �� ��� ����.
   �׷���, USING ��� ON ���� ����ϴ� ���� �Ϲ����̴�.
   
-- ANSI �ܺ�����
<����Ŭ ���� : �ܺ� ����>
SELECT A.�÷�1, B.�÷�1
    FROM ���̺�1 A, ���̺�2 B
    WHERE A.�÷� = B.�÷�(+)
;

<ANSI �ܺ�����>
SELECT A.�÷�1, B.�÷�1
    FROM ���̺�1 A
    LEFT OUTER JOIN ���̺�2 B
    ON A.�÷�1 = B.�÷�1
    WHERE ����
;

-- ANSI �ܺ����� ����(187p)
-- LEFT> ���� ���̺� : employees
SELECT e.employee_id, e.emp_name, j.job_id, j.department_id
    FROM employees e
    LEFT OUTER JOIN job_history j
    ON e.employee_id = j.employee_id
        AND e.department_id = j.department_id
;
-- OUTER ���� ����
SELECT e.employee_id, e.emp_name, j.job_id, j.department_id
    FROM employees e
    LEFT JOIN job_history j
    ON e.employee_id = j.employee_id
        AND e.department_id = j.department_id
;

-- RIGHT> ���� ���̺� : job_history
SELECT e.employee_id, e.emp_name, j.job_id, j.department_id
    FROM employees e
    RIGHT OUTER JOIN job_history j
    ON e.employee_id = j.employee_id
        AND e.department_id = j.department_id
;
-- OUTER ��������
SELECT e.employee_id, e.emp_name, j.job_id, j.department_id
    FROM employees e
    RIGHT JOIN job_history j
    ON e.employee_id = j.employee_id
        AND e.department_id = j.department_id
;

-- CROSS ����
<����Ŭ ���� : īŸ�þ� ����>
SELECT �÷�
    FROM ���̺�1 T1, ���̺�2 T2
    WHERE ����
;

<ANSI ���� : CROSS ����>
SELECT �÷�
    FROM ���̺�1 T1
    CROSS JOIN ���̺�2 T2
;

-- CROSS ���� ����(188p)
SELECT e.emp_name, d.department_name
    FROM employees e
    CROSS JOIN departments d
;

-- FULL OUTER ����
CREATE TABLE ���(
    �����ȣ    NUMBER
    , ����̸�  VARCHAR2(20)
    , �μ���ȣ  NUMBER
);

CREATE TABLE �μ�(
    �μ���ȣ        NUMBER
    , �μ���       VARCHAR2(20)
    , �����ڹ�ȣ     NUMBER
);

INSERT INTO ��� VALUES(100, '���缮', 10);
INSERT INTO ��� VALUES(101, '��ȣ��', 20);
INSERT INTO ��� VALUES(102, '�豸��', 50);
INSERT INTO ��� VALUES(103, '����ö', 30);
INSERT INTO ��� VALUES(105, '�̰��', 50);
INSERT INTO ��� VALUES(106, '�ڳ���', 60);

INSERT INTO �μ� VALUES(10, '������', 1);
INSERT INTO �μ� VALUES(20, '����������', 2);
INSERT INTO �μ� VALUES(30, '������', 3);
INSERT INTO �μ� VALUES(40, '������', 4);
INSERT INTO �μ� VALUES(50, '�λ���', 5);
INSERT INTO �μ� VALUES(70, '��ȹ��', 7);
INSERT INTO �μ� VALUES(70, '��ȹ��', 7);

-- FULL OUTER JOIN 
SELECT e.����̸�, d.�μ���
    FROM ��� e
    FULL OUTER JOIN �μ� d
    ON e.�μ���ȣ = d.�μ���ȣ
;

--==================================================================

[��������]
 - �� SQL ���� �ȿ��� ������ ���Ǵ� 
[���������� ����]
 - ������������ �������� ����
  : ������ ����(Noncorrelated) ��������
  : ������ �ִ� ��������
 - ���¿� ����
  : �Ϲ� ��������(SELECT��)
  : �ζ��� ��(FROM��)
  : ��ø����(WHERE��)
[������ ���� ��������]
 - ������������ �������� ���� �������� �� ���� ���̺�� ���� ������ �ɸ��� ����
 - ����1
   SELECT count(*)
        FROM employees
        WHERE salary >= (SELECT AVG(salary) FROM employees);
 - ����2
    SELECT count(*)
        FROM employees
        WHERE department_id IN (SELECT department_id
                                    FROM departments
                                    WHERE parent_id IS NULL);
[������ �ִ� ��������]
 - ������������ �������� �ִ� �������� �� ���� ���̺�� ���� ������ �ɷ��ִ�
 - ����1
    SELECT a.department_id, a.department_name
        FROM departments a
        WHERE EXISTS (SELECT 1
                        FROM job_history b
                        WHERE a.department_id = b.department_id);

-- ��������
SELECT AVG(salary)
    FROM employees
;

-- �������� : �� �޿��� ����� �Ʒ�?��?
-- �� �����(107) ��� �� ����(51��)
SELECT COUNT(*)
    FROM employees
    WHERE salary >= (SELECT AVG(salary) FROM employees)
;

-- �������� : ��޺μ��� ���� �μ���ȣ ��ȸ
SELECT department_id
    FROM departments
    WHERE parent_id IS NULL
;

-- �������� : ��޺μ��� ���� �μ��� ���� ��ȸ
SELECT count(*)
    FROM departments
    WHERE department_id IN (SELECT department_id
                                FROM departments
                                WHERE parent_id IS NULL)
;

-- �������� : ������̺�κ��� �����ȣ�� ������ȣ ��ȸ
SELECT employee_id, job_id
    FROM job_history
;

-- �������� : ������̺��� ����̸��� ��Ī ��ȸ
-- ���ÿ� 2���� �÷� ���� ������ ���
SELECT employee_id, emp_name, job_id
    FROM employees
    WHERE (employee_id, job_id) IN (SELECT employee_id, job_id
                                        FROM job_history)
;

-- 1�� �÷� ���� ������ ���
SELECT employee_id, emp_name, job_id
    FROM employees
    WHERE employee_id IN (SELECT employee_id
                                FROM job_history)
;

COMMIT;

-- ������̺��� �޿��� ������ �����ϰ� ��ձ޿��� ����
UPDATE employees
SET salary = (SELECT AVG(salary) FROM employees)
;
ROLLBACK;

-- ��� �޿����� ���� �޴� ��� ����
SELECT COUNT(*) FROM employees;

DELETE employees
WHERE salary >= (SELECT AVG(salary) FROM employees)
;


-- �������� �ִ� �������� : ���� ���� ����!
-- �������� : ������̺��� �μ���ȣ ��ȸ
SELECT department_id
    FROM job_history b
;

-- �������� : ������̺��� ��ȸ�� �μ���ȣ�� �μ���� �Բ� ��ȸ
SELECT department_id, department_name
    FROM departments d
    WHERE EXISTS (SELECT department_id
                        FROM job_history j
                        WHERE d.department_id = j.department_id)
;

-- �������� : ������̺��� ����� ��ȸ(107��)
SELECT emp_name
    FROM employees
;

-- �������� : �μ����̺��� �μ��� ��ȸ(27��)
SELECT department_name
    FROM departments
;

-- �������� : �����ȣ, �����, �μ���ȣ, �μ��� ��ȸ
SELECT employee_id
        , (SELECT emp_name 
                FROM employees e 
                WHERE e.employee_id = j.employee_id) emp_name
        , department_id
    FROM job_history j
;

SELECT employee_id
        , department_id
        , (SELECT department_name
                FROM departments d
                WHERE d.department_id = j.department_id) dep_name
    FROM job_history j
;

-- ���� ���
SELECT employee_id
        , (SELECT emp_name 
                FROM employees e 
                WHERE e.employee_id = j.employee_id) emp_name
        , department_id
        , (SELECT department_name
                FROM departments d
                WHERE d.department_id = j.department_id) dep_name
    FROM job_history j
;

-- �������� : ������̺��� ��� �޿� ��ȸ
SELECT AVG(salary)
    FROM employees
;
-- �������� : ��ձ޿����� ������ �޿��� �޴� ����� �μ���ȣ ��ȸ
SELECT department_id
    FROM employees
    WHERE salary > (SELECT AVG(salary) FROM employees)
;
-- �������� : ��ձ޿����� ���� �޿��� �޴� ����� �μ���ȣ�� ��Ī�Ǵ� �μ��� ��ȸ
SELECT d.department_id, d.department_name
    FROM departments d
    WHERE EXISTS (SELECT department_id
                    FROM employees e
                    WHERE d.department_id = e.department_id -- ������ �ִ� ��������
                        AND e.salary > (SELECT AVG(salary) FROM employees))
;

-- �������� : �μ����̺��� �����μ�(��ȣ)�� 90���� �μ���ȣ ��ȸ
SELECT department_id
    FROM departments
    WHERE parent_id = 90
;

-- �������� : ������̺��� �����μ�(��ȣ)�� 90���� �μ���ȣ, ��ձ޿� ��ȸ
SELECT e.department_id, AVG(e.salary)
    FROM employees e
         , departments d
    WHERE parent_id = 90
        AND e.department_id = d.department_id
    GROUP BY e.department_id
;

-- �������� : (������̺��� �����μ�(��ȣ)�� 90���� �μ���ȣ, ��ձ޿�)���� ��ձ޿� ��ȸ
SELECT avg_sal
    FROM (SELECT e.department_id, AVG(e.salary) avg_sal
                FROM employees e
                    , departments d
                WHERE parent_id = 90
                    AND e.department_id = d.department_id
                GROUP BY e.department_id)
--    WHERE ����
;

-- �������� : �����μ��� 90��(��ȹ��)�� ��� ����� �޿��� �ڽ��� �μź� ��ձ޿��� ����
-- [�μ��� ���ȭ]
COMMIT;
UPDATE employees e1
    SET e1.salary = (SELECT avg_sal
                        FROM (SELECT e.department_id, AVG(e.salary) avg_sal
                                FROM employees e
                                    , departments d
                                WHERE parent_id = 90
                                    AND e.department_id = d.department_id
                                GROUP BY e.department_id) x1
                        WHERE e1.department_id = x1.department_id
                    )
    WHERE department_id IN (SELECT department_id
                                FROM departments
                                WHERE parent_id = 90)
;
ROLLBACK;

UPDATE ������̺� e1
SET    e1.�޿� = (�μ��� ��ձ޿�[��������])
WHERE e1.�μ���ȣ IN (�����μ��� ��ȹ���� �μ�[��������])
;

--==================================================================

[�ζ��� ��]
 - FROM���� ����ϴ� ��������
 SELECT a.employee_id, a.emp_name, b.department_id, b.department_name
    FROM employees a
        , departments b
        , (SELECT AVG(c.salary) AS avg_salary
                FROM departments b
                    , employees c
                WHERE b.parent_id = 90  -- ��ȹ��
                    AND b.department_id = c.department_id) d
    WHERE a.department_id = b.department_id
        AND a.salary > d.avg_salary
;

 SELECT a.employee_id, a.emp_name, b.department_id, b.department_name
    FROM employees a
        , departments b
        , (SELECT AVG(e.salary) AS avg_salary
                FROM departments b
                    , employees e
                WHERE b.parent_id = 90  -- ��ȹ��
                    AND b.department_id = e.department_id) d
    WHERE a.department_id = b.department_id
        AND a.salary > d.avg_salary
;

-- �ζ��κ� : FROM���� ���� ��������
-- ��������
/*
    �Ǹ����̺�κ��� �Ǹſ�, ����Ǹűݾ� ��ȸ
����1: 2000�� 1��~2000�� 12������ �Ǹŵ�
����2: ��Ż���ƿ��� �Ǹŵ�
*/

SELECT sales_month, ROUND(AVG(amount_sold)) month_avg
    FROM sales s, countries c, customers cu
    WHERE sales_month BETWEEN 200001 AND 200012
        AND country_name = 'Italy'
        AND c.country_id = cu.country_id
        AND cu.cust_id = s.cust_id
    GROUP BY sales_month
;

[����] ���� �� �������̺� + �Ǹ����̺� : ����� �÷��� ����!
 [�������̺� + �����̺� + �Ǹ����̺�]
 [�����ȣ     �����ȣ]
             [����ȣ     ����ȣ]

<��������2> : �Ǹ����̺�κ��� ����Ǹűݾ� ��ȸ
����1: 2000��1��~2000��12������ �Ǹŵ�
����2: ��Ż���ƿ��� �Ǹŵ�

SELECT ROUND(AVG(s.amount_sold)) year_avg
    FROM sales s, countries c, customers cu
    WHERE sales_month BETWEEN 200001 AND 200012
        AND country_name = 'Italy'
        AND c.country_id = cu.country_id
        AND cu.cust_id = s.cust_id
;

<��������>
2000�� ��Ż���� ��� �����(�����)���� ū ������� �޼��� ���� ��� ������� ��ȸ
������Ǹž� : 180
200001 100
200002 182

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

--==================================================================
--==================================================================
CH8. PL/SQL�� ������ �������
/*
[���]
 - PL/SQL �ҽ� ���α׷��� �⺻ ����
 - �����, �����, ���� ó���η� ����
 - [����]
    �̸���
 IS(AS)
    �����
 BEGIN
    �����
 EXCEPTION
    ���� ó����
 END;
[��� ����]
 - �̸��� : ����� ��Ī, ���� �� �͸� ����� �ȴ�.
 - ����� : DECLARE�� ����. 
           ����ο� ���� ó���ο��� ����� ���� ����, ���, Ŀ�� ���� ����
           ���� ����� �� ������ ���� �ݵ�� �����ݷ�(;)�� ���� �Ѵ�.
 - ����� : ���� ������ ó���ϴ� �κ�
           ���� ����(�Ϲ� SQL��, ���ǹ�, �ݺ��� ��)�� �´�.
           DML���� ��밡��
 - ���� ó���� : EXCEPTION ���� ����.
                ����ο��� ���� ó�� �� ���� �߻� �� ó���� ���� ��� ���� ����

[�͸���]
 - ��� ��Ī�� ������ �� ��� �̸� �͸���(anonymous block)�̶� �Ѵ�.
 - �͸��� ex)
    DECLARE
        vi_num NUMBER;
    BEGIN
        vi_num := 100;
        DBMS_OUTPUT.PUT_LINE(vi_num);
    END;
    
[����]
 - ��������
   ������ ������Ÿ�� := �ʱⰪ;
 - �ʱⰪ�� �Ҵ����� �ʴ� ���� NULL ���� �Ҵ��
 - ���� ������ Ÿ�� : SQL Ÿ�԰� PL/SQL Ÿ��
 - PL/SQL ������ Ÿ�� : BOOLEAN, PLS_INTEGER, BINARY_INTEGER
 
[���]
 - �������
   ����� CONSTANT ������Ÿ�� := �����;
 - �����ʹ� �޸� �� �� ���� �Ҵ��ϸ� ������ �ʴ´�
 - ��� ���� SQL Ÿ�԰� PL/SQL Ÿ�� ��� ����
 
[DML ��]
 - PL/SQL ����� ����ο��� ���
 - SELECT INTO : ���̺��� Ư�� ���� ������ ������ �Ҵ��� ��� ���
   SELECT a.emp_name, b.department_name
   INTO vs_emp_name, vs_dep_name
        FROM employees a
            , departments b
        WHERE a.department_id = b.department_id
        AND a.employee_id = 100
    ;
 - ���̺��� Ư�� �÷� Ÿ���� ���� Ÿ������ ���� ����
   ������ ���̺��.�÷���%TYPE;

[��]
 - PL/SQL ���α׷� �󿡼� Ư�� �κп� �̸��� �ο�
 - <<�󺧸�>> ���·� ���
 - GOTO ���� �Բ� ���Ǿ� �ش� �󺧷� ����� �̵� ����
   GOTO �󺧸�;
   
[PRAGMA Ű����]
 - �����Ϸ��� ����Ǳ� ���� ó���ϴ� ��ó����
 - PRAGMA AUTONOMOUS_TRANSACTION
   ���� ����� ������ Ʈ����� ó�� �� ���
 - PRAGMA EXCEPTION_INIT (���ܸ�, ���ܹ�ȣ)
   ����� ���� ���� ó�� �� ���. Ư�� ���ܹ�ȣ�� ����� ���� ���ܷ� ����ϴ� ����
 - PRAGMA RESTRICT_REFERECES (���� ���α׷���, �ɼ�)
   ��Ű���� ���� ���� ���α׷�(�ַ� �Լ��� ���)���� �ɼ� ���� ���� Ư�� ������ ����
 - PRAGMA SERIALLY_RESUABLE
   ��Ű���� ����� ������ ���� �� �� ȣ�� �� �� �޸𸮸� ����

��[�Լ�] : [�Է°��� Ȱ���Ͽ�] Ư�� ������ ���� �� ��� �� ��ȯ
��[���ν���] : Ư�� ������ ó���ϰ� ��� ���� ��ȯ���� ����. ���� ���α׷�.
*/

[:=]    => ������ ���� ���׿� �Ҵ�

-- �͸���

DECLARE
    vi_num NUMBER;      -- vi_num �̸����� ���� ����(����)
BEGIN
    vi_num := 100;
    DBMS_OUTPUT.PUT_LINE(vi_num);       -- �Լ�(���) : �α� Ȯ��
END;        -- ���α׷� �ۼ��� ������ => SQL*PLUS ���� ���ο� ���� ���û��
-- PL/SQL ���ν����� ���������� �Ϸ�Ǿ����ϴ�. => ������ + ����Ϸ�
-- ��ܹ� - ���� - DBMS ��� - ORA_USER ���� ����
/

DECLARE
    -- a�� 2��2�� ���ϱ� 3��2��
    a INTEGER := 2**2*3**2;
    b NUMBER := 3+4;
BEGIN
    /* DBMS_OUTPUT.PUT_LINE() : DBMS ������� �Է°��� ���� �α� Ȯ�� */
    DBMS_OUTPUT.PUT_LINE('a=' || TO_CHAR(a));
    DBMS_OUTPUT.PUT_LINE('b=' || b);        -- �ڵ�����ȯ
    DBMS_OUTPUT.PUT_LINE(b);
END;
/

DECLARE
    -- a�� 2��2�� ���ϱ� 3��2��
    a INTEGER := 2**2*3**2;
    b NUMBER := 3+4;
    c VARCHAR2(30) := '�츮����';
    d BOOLEAN := false;
BEGIN
    DBMS_OUTPUT.PUT_LINE('a=' || TO_CHAR(a));
    DBMS_OUTPUT.PUT_LINE('b=' || b);        -- �ڵ�����ȯ
    DBMS_OUTPUT.PUT_LINE(b);
    DBMS_OUTPUT.PUT_LINE(C);
    DBMS_OUTPUT.PUT_LINE('D=' || CASE WHEN d THEN 'true' ELSE 'false' END);
END;
/

DECLARE
    -- vs_emp_name VARCHAR2(8);   -- �߸��� ������Ÿ�� ���� ����!
    vs_emp_name employees.emp_name%TYPE;
    vs_dep_name VARCHAR2(80);   -- ���� ����
BEGIN
    DBMS_OUTPUT.PUT_LINE('=============================');
    SELECT e.emp_name, d.department_name
    INTO vs_emp_name, vs_dep_name   
    -- INTO������ ���̺� �ִ� �����͸� ������ ������ �Ҵ��� �� ���
    -- �̶�, �����ϴ� �÷��� ������ ����, ����, ������ Ÿ���� �ݵ�� ������ ��.
        FROM employees e, departments d
        WHERE e.department_id = d.department_id
            AND employee_id = 100
    ;
    DBMS_OUTPUT.PUT_LINE(vs_emp_name);
    DBMS_OUTPUT.PUT_LINE(vs_dep_name);
END;
/

DECLARE
    num CONSTANT NUMBER := 10;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=============================');
    DBMS_OUTPUT.PUT_LINE('num=' || num);
END;
/


DECLARE
    num1 NUMBER := 10;
    num2 CONSTANT NUMBER := 10;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=============================');
    DBMS_OUTPUT.PUT_LINE('num1=' || num1);
    DBMS_OUTPUT.PUT_LINE('num2=' || num2);
    num1 := 20;
    DBMS_OUTPUT.PUT_LINE('num1=' || num1);
END;
/