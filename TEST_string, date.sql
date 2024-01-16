[[���α׷��ӽ� �ڵ��׽�Ʈ ����]]

--=======================================
--=======================================
<�ڵ��� �뿩 ��Ͽ��� ���/�ܱ� �뿩 �����ϱ�>
�� CAR_RENTAL_COMPANY_RENTAL_HISTORY ���̺��� ��ȸ�Ѵ�.

�� 2022�� 9���� �뿩�� �Ϳ� ���Ͽ� �뿩�Ⱓ�� ����Ѵ�.

�� HISTORY_ID, CAR_ID, START_DATE, END_DATE, RENT_TYPE�� ��ȸ�Ѵ�.

�� �̶� ��ȸ�ϴ� START_DATE, END_DATE�� ������ YYYY-MM-DD �̾�� �Ѵ�.

�� CASE ǥ������ ����Ͽ� �뿩�Ⱓ�� 30�� �̻��� ��� '��� �뿩', �� ���� ��� '�ܱ� �뿩'�� ǥ���Ѵ�.

* �뿩 �Ⱓ�� ��� ���� �ݳ��� �����Ͽ��� �ϱ� ������ +1�� ���� ���� �ݳ��� �����Ͽ� ��ȸ�Ѵ�.

�� ��ȸ�� HISTORY_ID, CAR_ID, START_DATE, END_DATE, RENT_TYPE�� ORDER BY�� �̿��Ͽ� ��������(DESC) �����Ѵ�.

1.���̺� 
    : CAR_RENTAL_COMPANY_RENTAL_HISTORY H
    
2. ��ü
 : history_id
   , car_id
   , start_date -- 22�⵵ 9����. 'YYYY-MM-DD'����
   , end_date -- 'YYYY-MM-DD'����
   , rent_type -- 30�� �̻� �뿩 : '��� �뿩', 30�� �̸� �뿩 : '�ܱ� �뿩'
   
 [����]
 start_date : 9�� ���� �뿩
  to_char(start_date, 'YYYY-MM') = '2022-09'
 
 
 �뿩�Ⱓ = end_date - start_date +1
  to_char(start_date, 'YYYY-MM-DD') AS start_date
  to_char(end_date, 'YYYY-MM-DD') AS end_date
 �뿩�Ⱓ = duration = H.end_date - H.start_date +1
 
 �뿩�Ⱓ : 30�� �̻� �� ��� �뿩
          : 30�� �̸�(ELSE) �� �ܱ� �뿩
          
SELECT
        CASE WHEN to_char(H.end_date - H.start_date +1) >= 30
            THEN '��� �뿩'
        ELSE '�ܱ� �뿩'
        END AS rent_type
    FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY H

 history_id ������������ �����϶� �� ORDER BY history_id DESC
 
 
 --=======================================
-- ���
-- start_date, end_date ������ 'yyyy-mm-dd'�� ���
-- '��� �뿩', '�ܱ� �뿩' ���� ���� ����;
SELECT history_id
        , car_id
        , to_char(start_date, 'yyyy-mm-dd') AS start_date
        , to_char(end_date, 'yyyy-mm-dd') AS end_date
        ,   CASE WHEN to_char(H.end_date - H.start_date +1) >= 30
                THEN '��� �뿩'
            ELSE '�ܱ� �뿩'
            END AS rent_type
    FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY H
    WHERE to_char(start_date, 'yyyy-mm') LIKE '2022-09'
    ORDER BY history_id DESC
;
 
--=======================================
--=======================================

[����]
: USED_GOODS_BOARD ���̺��� 2022�� 10�� 5�Ͽ� ��ϵ� �߰�ŷ� �Խù��� 
�Խñ� ID, �ۼ��� ID, �Խñ� ����, ����, �ŷ����¸� ��ȸ�ϴ� SQL���� �ۼ����ּ���. 
�ŷ����°� SALE �̸� �Ǹ���, RESERVED�̸� ������, DONE�̸� �ŷ��Ϸ� �з��Ͽ� ������ֽð�, 
����� �Խñ� ID�� �������� �������� �������ּ���.
/*
-- ��� ���̺� : USED_GOODS_BOARD GB
  USED_GOODS_BOARD GB�� �÷�
  : board_id, writer_id, title, contents, price, created_date, status, views
-- �ŷ����� sale�̸� '�Ǹ���', reserved�̸� '������', done�̸� '�ŷ��Ϸ�'
-- ����� �÷� : board_id, writer_id, title, price, status
-- 2022�� 10�� 5�Ͽ� ��ϵ� �߰� �ŷ� �Խù� �߿��� ���
    WHERE to_date(created_date, 'yyyy-mm-dd') = '2022-10-05'
-- board_id �������� �������� ����
    ORDER BY board_id DESC

-- �⺻ ���� Ʋ
SELECT
        board_id, writer_id, title, price
        ,   CASE WHEN status = 'SALE' THEN '�Ǹ���'
            WHEN status = 'RESERVED' THEN '������'
            WHEN status = 'DONE' THEN '�ŷ��Ϸ�'
            END AS status
    FROM USED_GOODS_BOARD
    WHERE to_date(created_date, 'yyyy-mm-dd') = '2022-10-05'
    ORDER BY board_id DESC
;

*/
    
SELECT
        board_id, writer_id, title, price
        ,   CASE WHEN status = 'SALE' THEN '�Ǹ���'
            WHEN status = 'RESERVED' THEN '������'
            WHEN status = 'DONE' THEN '�ŷ��Ϸ�'
            END AS status
    FROM USED_GOODS_BOARD
    WHERE to_char(created_date, 'yyyy-mm-dd') = '2022-10-05'
    ORDER BY board_id DESC
;

--=======================================
--=======================================
<���ǿ� �´� ����� ���� ��ȸ�ϱ�>

/*
0. ����
 : USED_GOODS_BOARD�� USED_GOODS_USER ���̺���
  �߰� �ŷ� �Խù��� 3�� �̻� ����� �������
  ����� ID, �г���, ��ü�ּ�, ��ȭ��ȣ�� ��ȸ�ϴ� SQL���� �ۼ����ּ���.
  �̶�, ��ü �ּҴ� ��, ���θ� �ּ�, �� �ּҰ� �Բ� ��µǵ��� ���ֽð�,
  ��ȭ��ȣ�� ��� xxx-xxxx-xxxx ���� ���·� ������ ���ڿ�(-)�� �����Ͽ� ���.
  ����� ȸ�� ID�� �������� �������� �������ּ���.

1. ���̺�1
 : USED_GOODS_BOARD B
2. ���̺�1_��� �÷�
 : BOARD_ID             -- �Խñ�ID
    , WRITER_ID         -- �ۼ���ID
    , TITLE             -- �Խñ� ����
    , CONTENTS          -- �Խñ� ����
    , PRICE             -- ����
    , CREATED_DATE      -- �ۼ���
    , STATUS            -- �ŷ�����
    , VIEWS             -- ��ȸ��
3. ���̺�2
 : USED_GOODS_USER U
4. ���̺�2_��� �÷�
 : USER_ID              -- ȸ��ID
    , NICKNAME          -- �г���
    , CITY              -- ��
    , STREET_ADDRESS1   -- ���θ� �ּ�
    , STREET_ADDRESS2   -- �� �ּ�
    , TLNO              -- ��ȭ��ȣ
5. ��� �÷�
 : ����� ID
    , �г���
    , ��ü�ּ�  -- ��, ���θ��ּ�, ���ּ� �Բ� ���
    , ��ȭ��ȣ  -- xxx-xxxx-xxxxó�� ������'-'���
-- ȸ�� id���� �������� ����
 : ORDER BY USER_ID DESC
 
-- �⺻ ����
SELECT USER_ID              -- U.USER_ID = B.WRITER_ID
        , NICKNAME
        , TOTAL_ADDRESS
        , TLNO
    FROM USED_GOODS_USER U
    ORDER BY USER_ID DESC
;

-- total_address ���
SELECT CITY || ' ' || STREET_ADDRESS1 || STREET_ADDRESS2
        AS TOTAL_ADDRESS
    FROM USED_GOODS_USER
    ORDER BY USER_ID DESC
;

-- ��ȭ��ȣ ���� ����
SELECT 
        SUBSTR(U.TLNO, 1, 3) || '-' || SUBSTR(U.TLNO, 4, 4)
            || '-' || SUBSTR(U.TLNO, 8, 4)
                AS NEW_TLNO
    FROM USED_GOODS_USER U
    ORDER BY USER_ID DESC
;

-- USER_ID, NICKNAME, TOTAL_ADDRESS, NEW_TLNO ���
SELECT USER_ID              -- U.USER_ID = B.WRITER_ID
        , NICKNAME
        , CITY || ' ' || STREET_ADDRESS1 || STREET_ADDRESS2
            AS TOTAL_ADDRESS
        , SUBSTR(TLNO, 1, 3) || '-' || SUBSTR(TLNO, 4, 4)
            || '-' || SUBSTR(TLNO, 8, 4)
                AS NEW_TLNO
    FROM USED_GOODS_USER
    ORDER BY USER_ID DESC
;

-- �߰�ŷ� �Խù� 3�� �̻� ����� ��� ��ȸ
-- USED_GOODS_BOARD ���̺���
    -- ������ WRITER_ID��
    -- CREATED_DATE�� COUNT�Ͽ� 3 �̻��� ����� ��ȸ
SELECT WRITER_ID, COUNT(CREATED_DATE)
    FROM USED_GOODS_BOARD B
    GROUP BY WRITER_ID
    HAVING COUNT(CREATED_DATE) >= 3
;
*/

-- ||�� ����
SELECT USER_ID              -- U.USER_ID = B.WRITER_ID
        , NICKNAME
        , CITY || ' ' || STREET_ADDRESS1 || ' ' || STREET_ADDRESS2
            AS TOTAL_ADDRESS
        , SUBSTR(TLNO, 1, 3) || '-' || SUBSTR(TLNO, 4, 4)
            || '-' || SUBSTR(TLNO, 8, 4)
                AS NEW_TLNO
    FROM USED_GOODS_USER
    WHERE USER_ID IN
            (
                SELECT WRITER_ID
                    FROM USED_GOODS_BOARD B
                    GROUP BY WRITER_ID
                    HAVING COUNT(CREATED_DATE) >= 3
              )
    ORDER BY USER_ID DESC
;

--=======================================
--=======================================
<��ȸ���� ���� ���� �߰�ŷ� �Խ����� ÷������ ��ȸ�ϱ�>
/*
0. ����
 : USED_GOODS_BOARD�� USED_GOODS_FILE ���̺���
 ��ȸ���� ���� ���� �߰�ŷ� �Խù��� ���� ÷������ ��θ� ��ȸ�ϴ� SQL�� �ۼ�.
 ÷������ ��δ� FILE ID�� �������� �������� �������ּ���.
 �⺻���� ���ϰ�δ� /home/grep/src/ �̸�, 
 �Խñ� ID�� �������� ���丮�� ���еǰ�, 
 �����̸��� ���� ID, ���� �̸�, ���� Ȯ���ڷ� �����ǵ��� ������ּ���.
 ��ȸ���� ���� ���� �Խù��� �ϳ��� �����մϴ�.
1. ���̺�1
 : USED_GOODS_BOARD
1_1. ����÷�_���̺�1
 : BOARD_ID         -- �Խñ�id
    , WRITER_ID     -- �ۼ���id
    , TITLE         -- �Խñ� ����
    , CONTENTS      -- �Խñ� ����
    , PRICE         -- ����
    , CREATED_DATE  -- �ۼ���
    , STATUS        -- �ŷ�����
    , VIEWS         -- ��ȸ��
2. ���̺�2
 : USED_GOODS_FILE
2_1. ����÷�_���̺�2
 : FILE_ID          -- ���� id
    , FILE_EXT      -- ���� Ȯ����
    , FILE_NAME     -- ���� �̸�
    , BOARD_ID      -- �Խñ� id
    
-- ��ȸ���� ���� ���� �߰�ŷ� �Խù�(�ϳ��� ����)
-- ��ȸ���� ���� ���� �߰�ŷ� �Խù��� ���� ÷������ ��� ��ȸ
-- �⺻���� ���ϰ�� : /home/grep/src/
-- �����̸�(FILE_NAME)�� ����ID(FILE_ID), �����̸�(FILE_NAME)
    , ����Ȯ����(FILE_EXT)�� ����
-- ���ϰ��
 : /home/grep/src/ + BOARD_ID + '/' + FILE_ID + FILE_NAME + FILE_EXT
-- FILE_ID �������� �������� ����
 : ORDER BY FILE_ID DESC

-- ���ϰ�� ��ȸ
SELECT '/home/grep/src/' || BOARD_ID || '/' || FILE_ID
        || FILE_NAME || FILE_EXT as FILE_PATH
        , FILE_ID
    FROM USED_GOODS_FILE
    ORDER BY FILE_ID DESC
;
 
-- ���� ���� ��ȸ�� ��ȸ
SELECT MAX(VIEWS)
    FROM USED_GOODS_BOARD
;

-- ��ȸ���� ���� ���� �߰�ŷ� �Խù� ��ȸ
SELECT BOARD_ID
    FROM USED_GOODS_BOARD
    WHERE VIEWS = (SELECT MAX(VIEWS) FROM USED_GOODS_BOARD)
;

-- ���1> '=' ���
SELECT '/home/grep/src/' || BOARD_ID || '/' || FILE_ID
        || FILE_NAME || FILE_EXT as FILE_PATH
    FROM USED_GOODS_FILE F
    WHERE F.BOARD_ID
        = (SELECT B.BOARD_ID
                FROM USED_GOODS_BOARD B
                WHERE VIEWS = 
                    (SELECT MAX(VIEWS) FROM USED_GOODS_BOARD))
    ORDER BY FILE_ID DESC
;

-- ���2> IN ���
-- ���
SELECT '/home/grep/src/' || BOARD_ID || '/' || FILE_ID
        || FILE_NAME || FILE_EXT as FILE_PATH
    FROM USED_GOODS_FILE F
    WHERE F.BOARD_ID
        IN (SELECT B.BOARD_ID
                FROM USED_GOODS_BOARD B
                WHERE VIEWS 
                    = (SELECT MAX(VIEWS) FROM USED_GOODS_BOARD))
    ORDER BY FILE_ID DESC
;
*/

-- ���
SELECT '/home/grep/src/' || BOARD_ID || '/' || FILE_ID
        || FILE_NAME || FILE_EXT as FILE_PATH
    FROM USED_GOODS_FILE F
    WHERE F.BOARD_ID
        IN (SELECT B.BOARD_ID
                FROM USED_GOODS_BOARD B
                WHERE VIEWS
                    = (SELECT MAX(VIEWS) FROM USED_GOODS_BOARD))
    ORDER BY FILE_ID DESC
;

--=======================================
--=======================================
<��ÿ� ���� ã��>
[����]
 : ���� ��ȣ�ҿ� ���� ���� ��
   �̸��� Lucy, Ella, Pickle, Rogan, Sabrina, Mitty�� ������
   ���̵�� �̸�, ���� �� �߼�ȭ ���θ� ��ȸ�ϴ� SQL ���� �ۼ����ּ���.
   
/*
-- ���̺� : ANIMAL_INS
-- �÷��� : ANIMAL_ID              -- �������̵�
        , ANIMAL_TYPE             -- ���� ��
        , DATETIME                -- ��ȣ ������
        , INTAKE_CONDITION        -- ��ȣ ���� �� ����
        , NAME                    -- �̸�
        , SEX_UPON_INTAKE         -- ���� �� �߼�ȭ ����

-- ����� �÷�
 : �������̵�, �����̸�, ���� �� �߼�ȭ ����
   ANIMAL_ID
   , NAME
   , SEX_UPON_INTAKE
*/
SELECT ANIMAL_ID, NAME, SEX_UPON_INTAKE
    FROM ANIMAL_INS A
    WHERE A.NAME
        IN ('Lucy', 'Ella', 'Pickle', 'Rogan', 'Sabrina', 'Mitty')
    ORDER BY ANIMAL_ID
;

--=======================================
--=======================================
<�̸��� el�� ���� ���� ã��>
/* 0. ����
���� ��ȣ�ҿ� ���� ���� �̸� ��,
�̸��� "EL"�� ���� ���� ���̵�� �̸��� ��ȸ�ϴ� SQL���� �ۼ����ּ���.
�̶� ����� �̸� ������ ��ȸ���ּ���. ��, �̸��� ��ҹ��ڴ� �������� �ʽ��ϴ�.

1. ���̺�
 : ANIMAL_INS
2. ���̺� �� �÷���
 : ANIMAL_ID            -- ����id
   , ANIMAL_TYPE        -- ���� ��
   , DATETIME           -- ��ȣ ������
   , INTAKE_CONDITION   -- ��ȣ ���� �� ����
   , NAME               -- �̸�
   , SEX_UPON_INTAKE    -- ���� �� �߼�ȭ ����
3. ����� �÷�
 : ANIMAL_ID
   , NAME
4. ����
-- ANIMAL_TYPE = 'Dog'
-- �̸� ������ ��ȸ
    : ORDER BY NAME  
-- NAME�� "EL"�� �� ��� ���
-- �̸��� ��ҹ��� �������� ����
    : �̸��� �빮�ڷ� ��ȯ�Ͽ� �빮�ڷ� 'EL' ���� ����� ��ȸ
      (�Ǵ� �ݴ�� �ҹ��ڷ� ��ȯ�Ͽ� �ҹ��ڷ� 'el' ���� ����� ��ȸ)
    : WHERE UPPER(TO_CHAR(NAME)) LIKE ('%EL%')

-- �⺻����
SELECT ANIMAL_ID
        , NAME
    FROM ANIMAL_INS
    ORDER BY NAME
;

*/

-- ����
SELECT ANIMAL_ID, NAME
    FROM ANIMAL_INS i
    WHERE UPPER(TO_CHAR(NAME)) LIKE ('%EL%')
        AND ANIMAL_TYPE = 'Dog'
    ORDER BY NAME
;

--=======================================
--=======================================
<���� �Ⱓ ��ȣ�� ����(2)>
/*
[ANIMAL_INS I] ���̺�
 : ANIMAL_ID            -- ����id
    , ANIMAL_TYPE       -- ���� ��
    , DATETIME          -- ��ȣ ������
    , INTAKE_CONDITION  -- ��ȣ ���� �� ����
    , NAME              -- �̸�
    , SEX_UPON_INTAKE   -- ���� �� �߼�ȭ ����
    
[ANIMAL_OUTS O] ���̺�
 : ANIMAL_ID            -- ����id, FOREIGN KEY(ins ���̺��� animal_id)
    , ANIMAL_TYPE       -- ���� ��
    , DATETIME          -- �Ծ���
    , NAME              -- �̸�
    , SEX_UPON_OUTCOME  -- ���� �� �߼�ȭ ����
    
[����]
 : �Ծ��� �� ���� ��, ��ȣ �Ⱓ�� ���� ����� ���� �� ������ 
  ���̵�� �̸��� ��ȸ�ϴ� SQL���� �ۼ����ּ���. 
  �̶� ����� ��ȣ �Ⱓ�� �� ������ ��ȸ�ؾ� �մϴ�.
  
-- �⺻ ����
SELECT ANIMAL_ID
        , NAME
    FROM ANIMAL_OUTS
;

-- ��ȣ�Ⱓ = TO_CHAR(O.DATETIME - I.DATETIME +1)
-- ��ȣ�Ⱓ�� ���� ����� �θ���
-- ���� �� �� : MAX(��ȣ�Ⱓ)
-- �� ���� ��� : MAX(��ȣ�Ⱓ)�� ������ MAX(��ȣ�Ⱓ)
-- ��ȣ �Ⱓ�� �� ������ ��ȸ
 : ORDER BY ��ȣ�Ⱓ
-- ����ID, ��ȣ������, �Ծ���, ��ȣ�Ⱓ ��ȸ
SELECT O.ANIMAL_ID
        , I.DATETIME AS START_DATE
        , O.DATETIME AS END_DATE
        , TRUNC(O.DATETIME - I.DATETIME +1) AS DURATION
    FROM ANIMAL_INS I, ANIMAL_OUTS O
    WHERE I.ANIMAL_ID = O.ANIMAL_ID
    ORDER BY TRUNC(O.DATETIME - I.DATETIME +1) DESC
;

-- ��ȣ�Ⱓ �ִ밪 ���ϱ�
SELECT MAX(TRUNC(O.DATETIME - I.DATETIME +1))
            AS FIRST_DURATION
    FROM ANIMAL_INS I, ANIMAL_OUTS O
    WHERE I.ANIMAL_ID = O.ANIMAL_ID
    ORDER BY TRUNC(O.DATETIME - I.DATETIME +1) DESC
;

-- RN ������ ����ID, �̸�, ��ȣ�Ⱓ�� ��ȣ�Ⱓ �������� ����
-- ROWNUM, ORDER BY�� ���ȣ ���� ���� �� ���� �����ϹǷ�
-- ORDER BY ���� �� ��, ROWNUM �������ֱ�
SELECT ROWNUM AS RN, T.ANIMAL_ID, T.NAME, T.DURATION
    FROM (SELECT O.ANIMAL_ID
                , O.NAME
                , I.DATETIME AS START_DATE
                , O.DATETIME AS END_DATE
                , TRUNC(O.DATETIME - I.DATETIME +1) AS DURATION
            FROM ANIMAL_INS I, ANIMAL_OUTS O
            WHERE I.ANIMAL_ID = O.ANIMAL_ID
            ORDER BY TRUNC(O.DATETIME - I.DATETIME +1) DESC
          ) T
;
*/
-- ���
SELECT ANIMAL_ID, NAME
    FROM (SELECT ROWNUM AS RN, T.ANIMAL_ID, T.NAME, T.DURATION
                FROM (SELECT O.ANIMAL_ID
                            , O.NAME
                            , I.DATETIME AS START_DATE
                            , O.DATETIME AS END_DATE
                            , TRUNC(O.DATETIME - I.DATETIME +1) 
                                AS DURATION
                        FROM ANIMAL_INS I, ANIMAL_OUTS O
                        WHERE I.ANIMAL_ID = O.ANIMAL_ID
                        ORDER BY DURATION DESC
                        ) T
            )
    WHERE RN IN (1,2)
    -- Ȥ�� WHERE RN=1 OR RN=2
;

--=======================================
--=======================================
<�ڵ��� �뿩 ��� �� �뿩 �ݾ� ���ϱ�>
/*
1. ���̺� : CAR_RENTAL_COMPANY_CAR C
           CAR_RENTAL_COMPANY_RENTAL_HISTORY H
           CAR_RENTAL_COMPANY_DISCOUNT_PLAN P

2. ��ü
 : car_type
    , car_id
    , history_id
    , start_date
    , end_date
    , duration_type
    , discount_rate
    , daily fee
           
3. ��°�
    history_id
    , Fee

4. ����
 : Fee�� ������ ���
  , C.car_type = 'Ʈ��'
  , FEE DESC
  , H.history_id DESC
  
--=======================================
-- Fee(����)
Fee = �뿩�Ⱓ * C.daily_fee(Ʈ�� ����) * (duration_type�� �ش��ϴ� discount_rate)
   (�� 7�� �̸��� ��� �� Fee = �뿩�Ⱓ * C.daily_fee(Ʈ������))
(duration = end_date - start_date +1) duration
(duration_type�� �ش��ϴ� discount_rate)
        = duration_type�� ���� ������ �� discount_rate,
          duration_type�� ���� ������ �� 0 (�� 7�� �̸��̸� ���ξ���)
        = (1 - NVL(P.discount_rate, 0) / 100)

-- FEE ���
-- ������ ����� ��
TRUNC(duration * daily_fee * (1 - NVL(P.discount_rate, 0) / 100)) as FEE

-- duration ���ϱ�
SELECT history_id,
       H.END_DATE - H.START_DATE + 1 AS DURATION
    FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY H
        , CAR_RENTAL_COMPANY_CAR C
    WHERE C.CAR_TYPE = 'Ʈ��';

-- duration_type ���ϱ�
SELECT history_id
        ,CASE WHEN H.END_DATE - H.START_DATE + 1 BETWEEN 7 AND 29 
            THEN '7�� �̻�'
        WHEN H.END_DATE - H.START_DATE + 1 BETWEEN 30 AND 89 
            THEN '30�� �̻�'
        WHEN H.END_DATE - H.START_DATE + 1 >= 90 
            THEN '90�� �̻�'
        END AS DURATION_TYPE
    FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY H
        , CAR_RENTAL_COMPANY_CAR C
    WHERE C.CAR_TYPE = 'Ʈ��';
    
-- discount_rate ���ϱ�
-- duration_type�� �ش��ϴ� discount_rate�� ���
-- car_type = 'Ʈ��'
SELECT T.history_id
    , (1 - NVL(P.discount_rate, 0) / 100) as discount_rate
    FROM (SELECT H.HISTORY_ID
                ,    CASE WHEN H.END_DATE - H.START_DATE + 1 BETWEEN 7 AND 29 
                        THEN '7�� �̻�'
                    WHEN H.END_DATE - H.START_DATE + 1 BETWEEN 30 AND 89 
                        THEN '30�� �̻�'
                    WHEN H.END_DATE - H.START_DATE + 1 >= 90 
                        THEN '90�� �̻�'
                    END AS DURATION_TYPE
            FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY H
                , CAR_RENTAL_COMPANY_CAR C
            WHERE C.CAR_TYPE = 'Ʈ��'
                AND C.CAR_ID = H.CAR_ID
          ) T
          ,CAR_RENTAL_COMPANY_DISCOUNT_PLAN P
;

-- daily_fee ���ϱ�
-- CAR_ID, Ʈ���� DAILY_FEE
SELECT CAR_ID, CAR_TYPE, DAILY_FEE
    FROM CAR_RENTAL_COMPANY_CAR
    WHERE CAR_TYPE = 'Ʈ��'
;

-- HISTORY_ID, FEE ���ϱ�
-- FEE = TRUNC(duration * daily_fee
--        * (1 - NVL(P.discount_rate, 0) / 100)) as FEE
-- CAR_TYPE = 'Ʈ��'

-- [�ܺ�����]
--  : �������ǿ��� �����Ͱ� ���� ���̺��� �÷��� (+) ��ȣ�� ����
*/

-- ������ ����
SELECT history_id
        , TRUNC(duration * daily_fee
            * (1 - NVL(P.discount_rate, 0)/100)) AS fee
    FROM ( SELECT H.history_id
                , C.car_type
                , C.daily_fee
                , H.end_date - H.start_date +1 AS duration
                ,   CASE WHEN H.end_date - H.start_date + 1
                        BETWEEN 7 AND 29
                        THEN '7�� �̻�'
                    WHEN H.end_date - H.start_date + 1
                        BETWEEN 30 AND 89
                        THEN '30�� �̻�'
                    WHEN H.end_date - H.start_date + 1 >= 90
                        THEN '90�� �̻�'
                    END AS duration_type
                FROM CAR_RENTAL_COMPANY_CAR C
                    , CAR_RENTAL_COMPANY_RENTAL_HISTORY H
                WHERE C.car_id = H.car_id
                    AND C.car_type = 'Ʈ��'
            ) T
            , CAR_RENTAL_COMPANY_DISCOUNT_PLAN P
    WHERE T.car_type = P.car_type(+) --�ܺ�����
        AND T.duration_type = P.duration_type(+) -- �ܺ�����
    ORDER BY fee DESC, T.history_id DESC
;


--=======================================
/* history_id�� p�� ��� ����Ϸ��� �ٸ� ����� ã�ƾ� ��
SELECT 
        CASE WHEN ���� THEN '���'
             WHEN ���� THEN '���'
             ELSE '���'
        END AS �÷��� ����
    FROM ���̺�
    WHERE ����;

<��������>
SELECT *
    FROM ���̺�
    WHERE ����
;

<��������>
SELECT ��ü
    FROM ���̺�
    WHERE EXISTS
        (SELECT *
            FROM ���̺�
            WHERE ����
        )
    ORDER BY ����
;
 
--=======================================
<��������1>
SELECT H.history_id
             , C.CAR_TYPE
             , C.DAILY_FEE
             , H.END_DATE - H.START_DATE + 1 AS DURATION
             , CASE WHEN H.END_DATE - H.START_DATE + 1 BETWEEN 7 AND 29 
                        THEN '7�� �̻�'
                    WHEN H.END_DATE - H.START_DATE + 1 BETWEEN 30 AND 89 
                        THEN '30�� �̻�'
                    WHEN H.END_DATE - H.START_DATE + 1 >= 90 
                        THEN '90�� �̻�'
                END AS DURATION_TYPE
          FROM CAR_RENTAL_COMPANY_CAR C
             , CAR_RENTAL_COMPANY_RENTAL_HISTORY H
         WHERE C.CAR_ID = H.CAR_ID
           AND C.CAR_TYPE = 'Ʈ��';


<��������1>
-- FEE = �뿩�Ⱓ * C.daily_fee(Ʈ�� ����) * (duration_type�� �ش��ϴ� discount_rate)
SELECT H.HISTORY_ID
       , TRUNC(duration * daily_fee 
           * (1 - NVL(P.discount_rate, 0) / 100)) as FEE
    FROM CAR_RENTAL_COMPANY_DISCOUNT_PLAN P
    WHERE EXISTS
        (SELECT H.HISTORY_ID
             , C.CAR_TYPE
             , C.DAILY_FEE
             , H.END_DATE - H.START_DATE + 1 AS DURATION
             , CASE WHEN H.END_DATE - H.START_DATE + 1 BETWEEN 7 AND 29 
                        THEN '7�� �̻�'
                    WHEN H.END_DATE - H.START_DATE + 1 BETWEEN 30 AND 89 
                        THEN '30�� �̻�'
                    WHEN H.END_DATE - H.START_DATE + 1 >= 90 
                        THEN '90�� �̻�'
                END AS DURATION_TYPE
          FROM CAR_RENTAL_COMPANY_CAR C
             , CAR_RENTAL_COMPANY_RENTAL_HISTORY H
         WHERE C.CAR_ID = H.CAR_ID
           AND C.CAR_TYPE = 'Ʈ��'
           AND P.CAR_TYPE = C.CAR_TYPE
        ) 
    ORDER BY FEE DESC, P.HISTORY_ID DESC
;
*/

--=======================================
--=======================================

<ī�װ� �� ��ǰ ���� ���ϱ�>
/* 0. ����
PRODUCT ���̺��� ��ǰ ī�װ� �ڵ�(PRODUCT_CODE �� 2�ڸ�) ��
��ǰ ������ ����ϴ� SQL���� �ۼ����ּ���
����� ��ǰ ī�װ� �ڵ带 �������� �������� �������ּ���.

1. ���̺�
 : PRODUCT
2. ���̺� �� �÷���
 : PRODUCT_ID           -- ��ǰID
    , PRODUCT_CODE      -- ��ǰ�ڵ�
    , PRICE             -- �ǸŰ�
(��ǰ ���� �ߺ����� ���� 8�ڸ� ��ǰ�ڵ� ���� ������,
  �� 2�ڱ�� ī�װ� �ڵ带 �ǹ��Ѵ�.)
3. ����� �÷�
 : ��ǰ ī�װ� �ڵ�(PRODUCT_CODE �� 2�ڸ�) �� ��ǰ ����
 -- CATEGORY     -- ī�װ�
 -- PRODUCTS     -- ��ǰ����
4. ORDER BY CATEGORY ASC
*/

-- �⺻����
SELECT CATEGORY         -- �����Ұ�
        , PRODUCTS      -- �����Ұ�
    FROM PRODUCT P
    ORDER BY CATEGORY ASC
;

-- CATEGORY
-- ī�װ��� PRODUCT���̺��� PRODUCT_CODE�� �� 2�ڸ��̴�.
-- ī�װ� ���
SELECT SUBSTR(TO_CHAR(P.PRODUCT_CODE), 1, 2) AS CATEGORY
    FROM PRODUCT P
    ORDER BY CATEGORY ASC
;

-- ī�װ� �÷��� �߰��Ͽ� ī�װ� ���
SELECT R.CATEGORY
    FROM ( SELECT SUBSTR(TO_CHAR(P.PRODUCT_CODE), 1, 2)
                    AS CATEGORY
                FROM PRODUCT P
          ) R
    ORDER BY CATEGORY ASC
;

-- ī�װ� �� �ߺ����� ���
-- �ߺ�����1. DISTINCT
SELECT DISTINCT R.CATEGORY
    FROM ( SELECT SUBSTR(TO_CHAR(P.PRODUCT_CODE), 1, 2)
                    AS CATEGORY
                FROM PRODUCT P
          ) R
    ORDER BY CATEGORY ASC
;
-- �ߺ�����2. GROUP BY
-- ���� : GROUP BY���� �׷�ȭ�� �÷��� �� SELECT�� �÷��� ���ƾ� ��ȸ ����
SELECT R.CATEGORY
    FROM ( SELECT SUBSTR(TO_CHAR(P.PRODUCT_CODE), 1, 2)
                    AS CATEGORY
                FROM PRODUCT P
          ) R
    GROUP BY R.CATEGORY
    ORDER BY CATEGORY ASC
;

-- ��ǰ���� ��� �� PRODUCTS
-- COUNT ��� : ī�װ� �� 2�ڸ��� ���� �ͳ��� ���� ���� ��
-- ����1_1. COUNT1_1> DISTINCT + PARTITION BY
/* �⺻ ����
 SELECT DISTINCT T1.*
    FROM ( SELECT col1
                  , COUNT(*) OVER(PARTITION BY a.col1) AS col2
            FROM �������̺� a
          ) T1
    WHERE T1.col > n ;      
    -- T1���̺��� col1 ������ n�� �ʰ��Ͽ� �ߺ��ϴ� ���� �������� �ϰڴ�.
 
 PARTITION BY�� DISTINCT�� �����Ѵ�.
 ����, ���̺� DISTINCT�� �ɷ� �־ �̸� �����ϰ� ������ ������� �۾��� �����Ѵ�.
 */
SELECT DISTINCT R.CATEGORY, R.PRODUCTS
    FROM ( SELECT SUBSTR(TO_CHAR(P.PRODUCT_CODE), 1, 2)
                        AS CATEGORY
                  , COUNT(*) OVER
                            (PARTITION BY
                             SUBSTR(TO_CHAR(P.PRODUCT_CODE), 1, 2))
                        AS PRODUCTS
                FROM PRODUCT P
          ) R
    WHERE R.PRODUCTS > 0        -- �����ص� ���� ��� ���
    ORDER BY CATEGORY ASC
;

-- ����1_2. COUNT1_2> DISTINCT + PARTITION BY
SELECT DISTINCT R.*
    FROM ( SELECT SUBSTR(TO_CHAR(P.PRODUCT_CODE), 1, 2)
                        AS CATEGORY
                  , COUNT(*) OVER
                            (PARTITION BY
                             SUBSTR(TO_CHAR(P.PRODUCT_CODE), 1, 2))
                        AS PRODUCTS
                FROM PRODUCT P
          ) R
    WHERE R.PRODUCTS > 0        -- �����ص� ���� ��� ���
    ORDER BY CATEGORY ASC
;

-- ���� 3. COUNT2> GROUP BY + HAVING
SELECT R.CATEGORY
       , COUNT(*) AS PRODUCTS
    FROM ( SELECT SUBSTR(TO_CHAR(P.PRODUCT_CODE), 1, 2)
                    AS CATEGORY
                FROM PRODUCT P
          ) R
    GROUP BY R.CATEGORY
        HAVING COUNT(*) > 0     -- �����ص� ���� ��� ���
    ORDER BY CATEGORY ASC
;


--=======================================
--=======================================

<���Ǻ��� �з��Ͽ� �ֹ����� ����ϱ�>
/* 0. ����
FOOD_ORDER ���̺��� 5�� 1���� �������� 
�ֹ� ID, ��ǰ ID, �������, ����θ� ��ȸ�ϴ� SQL���� �ۼ����ּ���.
����δ� 5�� 1�ϱ��� ���Ϸ�� 
�� �� ��¥�� ��� ���� �����̸� ���������� ������ֽð�, 
����� �ֹ� ID�� �������� �������� �������ּ���.

1. ���̺�
 : FOOD_ORDER

2. ���̺� �� �÷���
 : ORDER_ID         -- �ֹ�ID
    , PRODUCT_ID    -- ��ǰID
    , AMOUNT        -- �ֹ���
    , PRODUCE_DATE  -- ��������
    , IN_DATE       -- �԰�����
    , OUT_DATE      -- �������
    , FACTORY_ID    -- ����ID
    , WAREHOUSE_ID  -- â��ID
3. ����� �÷�
 : ORDER_ID
   , PRODUCT_ID
   , OUT_DATE
   , �����
4. ����
 -- �ֹ�ID�� �������� �������� ����
 ORDER BY ORDER_ID ASC;
 
 -- 5/1�� �������� ��
 -- ����� : 5/1���� ���Ϸ�, ���� ��¥�� ��� ����, �����̸� ���������� ���
SELECT
        CASE WHEN TO_CHAR(OUT_DATE, 'YYYY-MM-DD') <= '2022-05-01'
            THEN '���Ϸ�'
        WHEN TO_CHAR(OUT_DATE, 'YYYY-MM-DD') > '2022-05-01'
            THEN '��� ���'
        WHEN TO_CHAR(OUT_DATE, 'YYYY-MM-DD') IS NULL
            THEN '������'
        END AS �����
    FROM FOOD_ORDER F
    ORDER BY ORDER_ID ASC;
*/

-- �⺻ ����
SELECT ORDER_ID
       , PRODUCT_ID
       , OUT_DATE
       , �����       -- ���� �ؾ���
    FROM FOOD_ORDER
    ORDER BY ORDER_ID ASC;

-- ���    
SELECT ORDER_ID
       , PRODUCT_ID
       , TO_CHAR(OUT_DATE, 'YYYY-MM-DD') AS OUT_DATE
       , CASE WHEN TO_CHAR(OUT_DATE, 'YYYY-MM-DD') <= '2022-05-01'
            THEN '���Ϸ�'
        WHEN TO_CHAR(OUT_DATE, 'YYYY-MM-DD') > '2022-05-01'
            THEN '�����'
        WHEN TO_CHAR(OUT_DATE, 'YYYY-MM-DD') IS NULL
            THEN '������'
        END AS �����
    FROM FOOD_ORDER
    ORDER BY ORDER_ID ASC;

--=======================================
--=======================================
<�ڵ��� ��� �뿩 �Ⱓ ���ϱ�>
/*
0. ����
 : CAR_RENTAL_COMPANY_RENTAL_HISTORY ���̺���
   ��� �뿩 �Ⱓ�� 7�� �̻��� �ڵ�������
   �ڵ��� ID�� ��� �뿩 �Ⱓ(�÷���: AVERAGE_DURATION)
   ����Ʈ�� ����ϴ� SQL���� �ۼ����ּ���.
   ��� �뿩 �Ⱓ�� �Ҽ��� �ι�° �ڸ����� �ݿø��ϰ�, 
   ����� ��� �뿩 �Ⱓ�� �������� �������� �������ֽð�, 
   ��� �뿩 �Ⱓ�� ������ �ڵ��� ID�� �������� �������� �������ּ���.
   
1. ���̺�
 : CAR_RENTAL_COMPANY_RENTAL_HISTORY
2. ��� �÷�
 : HISTORY_ID       -- �ڵ��� �뿩 ��� ID
   , CAR_ID         -- �ڵ��� ID
   , START_DATE     -- �뿩 ������
   , END_DATE       -- �뿩 ������
3. ��� �÷�
 : CAR_ID                       -- ��� �뿩 �Ⱓ�� 7�� �̻��� ��
   , AVERAGE_DURATION           -- ��� �뿩 �Ⱓ
4. ����
 - ��� �뿩 �Ⱓ�� 7�� �̻��� ��
 - ��� �뿩 �Ⱓ : �Ҽ��� �ι�° �ڸ����� �ݿø�
    ROUND(��մ뿩�Ⱓ, 2)
 - AVERAGE_DURATION ��������, CAR_ID ��������
    ORDER BY AVERAGE_DURATION DESC
   , ORDER BY CAR_ID DESC

-- CAR_ID ���� ��� �뿩��� ���ϱ�
-- �뿩��� ���
-- �뿩��� = TO_CHAR(END_DATE - START_DATE) +1
SELECT CAR_ID
        , TO_CHAR(END_DATE - START_DATE)
            AS RENTAL_DURATION
    FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
;

-- CAR_ID �ߺ����� ����
SELECT CAR_ID
    FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
    GROUP BY CAR_ID
    ORDER BY CAR_ID DESC
;

-- ��� �뿩 �Ⱓ ���ϱ�
SELECT CAR_ID
        , ROUND( AVG(TO_CHAR(END_DATE - START_DATE) +1), 1 ) 
            AS AVERAGE_DURATION
    FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
    GROUP BY CAR_ID
    ORDER BY AVERAGE_DURATION DESC, CAR_ID DESC
;
*/

-- ���
-- ��� �뿩 �Ⱓ 7�� �̻��� ��� ��ȸ
SELECT CAR_ID
        , ROUND( AVG(TO_CHAR(END_DATE - START_DATE) +1), 1 ) 
            AS AVERAGE_DURATION
    FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
    GROUP BY CAR_ID
    HAVING AVG(TO_CHAR(END_DATE - START_DATE) +1) >= 7
    ORDER BY AVERAGE_DURATION DESC, CAR_ID DESC
;

--=======================================
--=======================================
<DATETIME���� DATE�� �� ��ȯ>
/*
0. ����
 : ANIMAL_INS ���̺� ��ϵ� ��� ���ڵ忡 ����, 
    �� ������ ���̵�� �̸�, ���� ��¥�� ��ȸ�ϴ� SQL���� �ۼ����ּ���. 
    �̶� ����� ���̵� ������ ��ȸ�ؾ� �մϴ�.
1. ���̺�
 : ANIMAL_INS
2. ��� �÷�
 : ANIMAL_ID            -- �������̵�
    , ANIMAL_TYPE       -- ���� ��
    , DATETIME          -- ��ȣ ������
    , INTAKE_CONDITION  -- ��ȣ ���� �� ����
    , NAME              -- �̸�
    , SEX_UPON_INTAKE   -- ���� �� �߼�ȭ ����
3. ��� �÷�
 : ANIMAL_ID
    , NAME
    , TO_CHAR(DATETIME, 'YYYY-MM-DD')
-- ANIMAL_ID������ ��ȸ
 : ORDER BY ANIMAL_ID
*/
SELECT ANIMAL_ID
        , NAME
        , TO_CHAR(DATETIME, 'YYYY-MM-DD')
    FROM ANIMAL_INS
    ORDER BY ANIMAL_ID
;

--=======================================
--=======================================

<�߼�ȭ ���� �ľ��ϱ�>
/*
0. ����
 : ��ȣ���� ������ �߼�ȭ�Ǿ����� �ƴ��� �ľ��Ϸ� �մϴ�.
 �߼�ȭ�� ������ SEX_UPON_INTAKE �÷���
 'Neutered' �Ǵ� 'Spayed'��� �ܾ ����ֽ��ϴ�.
 ������ ���̵�� �̸�, �߼�ȭ ���θ� ���̵� ������ ��ȸ�ϴ� SQL���� �ۼ����ּ���.
 �̶� �߼�ȭ�� �Ǿ��ִٸ� 'O', �ƴ϶�� 'X'��� ǥ�����ּ���.
1. ���̺�
 : ANIMAL_INS 
2. ��� �÷�
 : ANIMAL_ID            -- �������̵�
    , ANIMAL_TYPE       -- ���� ��
    , DATETIME          -- ��ȣ ������
    , INTAKE_CONDITION  -- ��ȣ ���� �� ����
    , NAME              -- �̸�
    , SEX_UPON_INTAKE   -- ���� �� �߼�ȭ ����
3. ��� �÷�
 : ANIMAL_ID
    , NAME
    , �߼�ȭ   -- ����
    
-- ANIMAL_ID �������� ����
 : ORDER BY ANIMAL_ID
 
-- CASE WHEN SEX_UPON_INTAKE IN ('Neutered', 'Spayed') THEN 'O'
        ELSE 'X'
        END AS �߼�ȭ
        
-- ���
SELECT ANIMAL_ID
        , NAME
        , CASE WHEN SEX_UPON_INTAKE
                LIKE '%Neutered%' THEN 'O'
            WHEN SEX_UPON_INTAKE
                LIKE '%Spayed%' THEN 'O'
            ELSE 'X'
            END AS �߼�ȭ
    FROM ANIMAL_INS
    ORDER BY ANIMAL_ID
;
*/
SELECT ANIMAL_ID
        , NAME
        , CASE WHEN SEX_UPON_INTAKE LIKE '%Neutered%' 
                OR SEX_UPON_INTAKE LIKE '%Spayed%'
                    THEN 'O'
            ELSE 'X'
            END AS �߼�ȭ
    FROM ANIMAL_INS
    ORDER BY ANIMAL_ID
;

--=======================================
--=======================================
<��ҵ��� ���� ���� ���� ��ȸ�ϱ�>
/*
0. ����
 : PATIENT, DOCTOR �׸��� APPOINTMENT ���̺���
   2022�� 4�� 13�� ��ҵ��� ���� ��οܰ�(CS) ���� ���� ������ ��ȸ.
   ���Ό���ȣ, ȯ���̸�, ȯ�ڹ�ȣ, ������ڵ�, �ǻ��̸�, ���Ό���Ͻ� �׸��� ���.
   ����� ���Ό���Ͻø� �������� �������� �������ּ���.
[PATIENT P ���̺�]
 : PT_NO            -- ȯ�ڹ�ȣ
   , PT_NAME        -- ȯ���̸�
   , GEND_CD        -- �����ڵ�
   , AGE            -- ����
   , TLNO           -- ��ȭ��ȣ

*/
















