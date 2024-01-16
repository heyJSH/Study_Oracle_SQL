--=======================================
--=======================================
<���ݴ� �� ��ǰ ���� ���ϱ�>
/*
0. ����
 : PRODUCT ���̺��� ���� ������ ���ݴ� ���� ��ǰ ������ ���
   ���� �÷����� PRICE_GROUP, PRODUCTS�� ����
   ���ݴ� ������ �� ������ �ּұݾ�
   (10,000�� �̻� ~ 20,000 �̸��� ������ ��� 10,000)���� ǥ��
 - ����� ���ݴ븦 �������� �������� ����
 - ��ǰ ���� �ߺ����� �ʴ� 8�ڸ� ��ǰ�ڵ� ���� ������,
   �� 2�ڸ��� ī�װ� �ڵ带 ��Ÿ���ϴ�.
1. ���̺�
 : PRODUCT 
2. ��� �÷�
 : PRODUCT_ID           -- ��ǰID
    , PRODUCT_CODE      -- ��ǰ�ڵ�
    , PRICE             -- �ǸŰ�
3. ��� �÷�
 : PRICE_GROUP      -- ��ǰ ���ݴ�
    , PRODUCTS      -- ���ݴ뺰 ��ǰ ����



-- MIN(����), MAX(����)
-- MIN : 15,000��, MAX : 85,000��
SELECT MIN(PRICE), MAX(PRICE)
    FROM PRODUCT P
;
    
-- ������� ǥ��
SELECT PRICE, TRUNC(PRICE/10000)
    FROM PRODUCT P
;

-- ���ݴ뺰�� �׷��� ������ ��
-- ���> DECODE
SELECT PRODUCT_ID
        , DECODE( TRUNC(PRICE/10000)
                    , 0, '0'
                    , 1, '10000'
                    , 2, '20000'
                    , 3, '30000'
                    , 4, '40000'
                    , 5, '50000'
                    , 6, '60000'
                    , 7, '70000'
                    , 8, '80000') AS PRICE_GROUP
    FROM PRODUCT P
    ORDER BY PRICE_GROUP
;

-- ���� : �ߺ� ����
SELECT *
    FROM (SELECT DECODE( TRUNC(PRICE/10000)
                    , 0, '0'
                    , 1, '10000'
                    , 2, '20000'
                    , 3, '30000'
                    , 4, '40000'
                    , 5, '50000'
                    , 6, '60000'
                    , 7, '70000'
                    , 8, '80000') AS PRICE_GROUP
                FROM PRODUCT P
                ) T
    GROUP BY T.PRICE_GROUP
    ORDER BY PRICE_GROUP
;

-- ���ݴ뺰 COUNT
SELECT T.PRICE_GROUP
        , COUNT(*) AS PRODUCTS
     FROM (SELECT DECODE( TRUNC(PRICE/10000)
                    , 0, '0'
                    , 1, '10000'
                    , 2, '20000'
                    , 3, '30000'
                    , 4, '40000'
                    , 5, '50000'
                    , 6, '60000'
                    , 7, '70000'
                    , 8, '80000') AS PRICE_GROUP
                FROM PRODUCT P
                ) T
    GROUP BY T.PRICE_GROUP
    ORDER BY PRICE_GROUP
;
*/

-- �ٸ� ���
SELECT  TRUNC(PRICE, -4) AS PRICE_GROUP, COUNT(PRODUCT_ID) PRODUCTS
    FROM    PRODUCT
    GROUP BY TRUNC(PRICE, -4)
    ORDER BY TRUNC(PRICE, -4)
;

--=======================================
--=======================================
<�ڵ��� ���� �� Ư�� �ɼ��� ���Ե� �ڵ��� �� ���ϱ�>
/*
0. ����
 : CAR_RENTAL_COMPANY_CAR ���̺���
  '��ǳ��Ʈ', '������Ʈ', '���׽�Ʈ' �� �ϳ� �̻��� �ɼ��� ���Ե� �ڵ����� 
  �ڵ��� ���� ���� �� ������ ����ϴ� SQL���� �ۼ����ּ���. 
  �̶� �ڵ��� ���� ���� �÷����� CARS�� �����ϰ�, 
  ����� �ڵ��� ������ �������� �������� �������ּ���.
1. ���̺�
 : CAR_RENTAL_COMPANY_CAR
2. ��� �÷�
 : CAR_ID       -- �ڵ��� id
    , CAR_TYPE  -- �ڵ��� ����
    , DAILY_FEE -- ���� �뿩���(��)
    , OPTIONS   -- �ڵ��� �ɼ� ����Ʈ
3. ��� �÷�
 : CAR_TYPE     -- �ڵ��� ����
    , CARS      -- �ڵ��� ��

-- �ڵ��� �ɼ� ���Ե� �ڵ��� ���� ��ȸ
SELECT CAR_TYPE
    FROM CAR_RENTAL_COMPANY_CAR
    WHERE OPTIONS LIKE '%��ǳ��Ʈ%' 
        OR OPTIONS LIKE '%������Ʈ%'
        OR OPTIONS LIKE '%���׽�Ʈ%'
    ORDER BY CAR_TYPE ASC
;

*/


-- ���
-- �ڵ��� ���� �ߺ� ���� + COUNT
SELECT CAR_TYPE, COUNT(*) AS  CARS
    FROM CAR_RENTAL_COMPANY_CAR
    WHERE OPTIONS LIKE '%��ǳ��Ʈ%' 
        OR OPTIONS LIKE '%������Ʈ%'
        OR OPTIONS LIKE '%���׽�Ʈ%'
    GROUP BY CAR_TYPE
    ORDER BY CAR_TYPE ASC
;

--=======================================
--=======================================
<������� �� ���� Ƚ�� ����ϱ�>
/*
0. ����
 : APPOINTMENT ���̺��� 2022�� 5���� ������ ȯ�� ���� 
   ������ڵ� ���� ��ȸ�ϴ� SQL���� �ۼ����ּ���. 
   �̶�, �÷����� '����� �ڵ�', '5������Ǽ�'�� �������ֽð� 
   ����� ������� ������ ȯ�� ���� �������� �������� �����ϰ�, 
   ������ ȯ�� ���� ���ٸ� ����� �ڵ带 �������� �������� �������ּ���.
1. ���̺�
 : APPOINTMENT 
2. ��� �÷�
 : APNT_YMD         -- ���Ό���Ͻ�
    , APNT_NO       -- ���Ό���ȣ
    , PT_NO         -- ȯ�ڹ�ȣ
    , MCDP_CD       -- ������ڵ�
    , MDDR_ID       -- �ǻ�ID
    , APNT_CNCL_YN  -- ������ҿ���
    , APNT_CNCL_YMD -- ������ҳ�¥
3. ��� �÷�
 : ����� �ڵ�
    , 5������Ǽ�
    
-- ������� ������ ȯ�ڼ� ��������, ����� �ڵ� ��������
 : ORDER BY 
*/

-- 2022�� 5���� ������ ������ڵ� ��ȸ
SELECT MCDP_CD, COUNT(PT_NO)
    FROM APPOINTMENT
    WHERE TO_CHAR(APNT_YMD, 'YYYY-MM') = '2022-05'
    GROUP BY COUNT(PT_NO)
    ORDER BY COUNT(PT_NO), MCDP_CD
;

--=======================================
--=======================================
<���ã�Ⱑ ���� ���� �Ĵ� ���� ����ϱ�>
/*
0. ����
 : REST_INFO ���̺��� ������������ ���ã����� ���� ���� �Ĵ��� 
   ���� ����, ID, �Ĵ� �̸�, ���ã����� ��ȸ�ϴ� SQL���� �ۼ����ּ���. 
   �̶� ����� ���� ������ �������� �������� �������ּ���.
1. ���̺�
 : REST_INFO 
2. ��� �÷�
 : REST_ID      -- �Ĵ� ID
  , REST_NAME   -- �Ĵ� �̸�
  , FOOD_TYPE   -- ���� ����
  , VIEWS       -- ��ȸ��
  , FAVORITES   -- ���ã���
  , PARKING_LOT -- ������ ����
  , ADDRESS     -- �ּ�
  , TEL         -- ��ȭ��ȣ
3. ��� �÷�
 : FOOD_TYPE
    , REST_ID
    , REST_NAME
    , FAVORITES
*/

-- ���� ����, ID, �Ĵ� �̸�, ���ã���
SELECT FOOD_TYPE, REST_ID, REST_NAME, FAVORITES
    FROM REST_INFO
    ORDER BY FOOD_TYPE DESC
;


-- ���� ���� ���� MAX(���ã���)
SELECT FOOD_TYPE, MAX(FAVORITES) AS FAVORITES
    FROM REST_INFO
    GROUP BY FOOD_TYPE
    ORDER BY FOOD_TYPE DESC
;

-- ���
SELECT I.FOOD_TYPE, I.REST_ID, I.REST_NAME, I.FAVORITES
    FROM REST_INFO I
        , (SELECT FOOD_TYPE, MAX(FAVORITES) AS FAVORITES
                FROM REST_INFO
                GROUP BY FOOD_TYPE) T
    WHERE I.FAVORITES(+) = T.FAVORITES
        AND I.FOOD_TYPE IN (T.FOOD_TYPE)
    ORDER BY FOOD_TYPE DESC
;

--=======================================
--=======================================
<���ǿ� �´� ����ڿ� �� �ŷ��ݾ� ��ȸ�ϱ�>
/*
0. ����
 : USED_GOODS_BOARD�� USED_GOODS_USER ���̺��� 
   �Ϸ�� �߰� �ŷ��� �ѱݾ��� 70�� �� �̻��� ����� 
   ȸ�� ID, �г���, �Ѱŷ��ݾ��� ��ȸ�ϴ� SQL���� �ۼ����ּ���.
   ����� �Ѱŷ��ݾ��� �������� �������� �������ּ���.
1. ���̺�1
 : USED_GOODS_BOARD B
1_2. ����÷�_���̺�1
 : BOARD_ID         -- �Խñ�id
    , WRITER_ID     -- �ۼ���id
    , TITLE         -- �Խñ� ����
    , CONTENTS      -- �Խñ� ����
    , PRICE         -- ����
    , CREATED_DATE  -- �ۼ���
    , STATUS        -- �ŷ�����
    , VIEWS         -- ��ȸ��
2. ���̺�2
 : USED_GOODS_USER U
2_2. ����÷�_���̺�2
 : USER_ID              -- ȸ�� ID
    , NICKNAME          -- �г���
    , CITY              -- ��
    , STREET_ADDRESS1   -- ���θ� �ּ�
    , STREET_ADDRESS2   -- �� �ּ�
    , TLNO              -- ��ȭ��ȣ
3. ��� �÷�
 : USER_ID U
    , NICKNAME
    , �Ѱŷ��ݾ�
    
-- �Ѱŷ��ݾ��� �������� �������� ����
 : ORDER BY �Ѱŷ��ݾ�

-- �Ϸ�� �߰� �ŷ��� ������ ���
SELECT *
    FROM USED_GOODS_BOARD B
    WHERE B.STATUS = 'DONE'
;

-- �ŷ��Ϸ�� ����� B.�ۼ���ID, B.����, U.�г��� ��ȸ
SELECT B.WRITER_ID, B.PRICE, U.NICKNAME
    FROM USED_GOODS_BOARD B
        , USED_GOODS_USER U
    WHERE B.WRITER_ID = U.USER_ID
        AND B.STATUS = 'DONE'
    GROUP BY B.WRITER_ID
    ORDER BY PRICE
;

-- �ŷ��Ϸ�� ����� B.�ۼ���ID, U.�г���, B.���� �ۼ����� �� �ǸŰ��� ��ȸ
SELECT B.WRITER_ID, U.NICKNAME, SUM(B.PRICE) TOTAL_PRICE
    FROM USED_GOODS_BOARD B
        , USED_GOODS_USER U
    WHERE B.WRITER_ID = U.USER_ID
        AND B.STATUS = 'DONE'
    GROUP BY B.WRITER_ID, U.NICKNAME
    ORDER BY TOTAL_PRICE
;
*/

-- ���> �������� ���
SELECT B.WRITER_ID, U.NICKNAME, SUM(B.PRICE) AS TOTAL_PRICE
    FROM USED_GOODS_BOARD B
        , USED_GOODS_USER U
    WHERE B.WRITER_ID = U.USER_ID
        AND B.STATUS = 'DONE'
    GROUP BY B.WRITER_ID, U.NICKNAME
    HAVING SUM(B.PRICE) >= 700000
    ORDER BY TOTAL_PRICE
;







