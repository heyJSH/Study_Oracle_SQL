<�־��µ��� �������ϴ�>
/*
0. ����
 : �������� �Ǽ��� �Ϻ� ������ �Ծ����� �߸� �ԷµǾ����ϴ�.
   ��ȣ �����Ϻ��� �Ծ����� �� ���� ������ ���̵�� �̸��� ��ȸ�ϴ� SQL���� �ۼ�.
   �̶� ����� ��ȣ �������� ���� ������ ��ȸ�ؾ��մϴ�.
[ANIMAL_INS I ���̺�]
 : ANIMAL_ID            -- ����id
    , ANIMAL_TYPE       -- ���� ��
    , DATETIME          -- ��ȣ ������
    , INTAKE_CONDITION  -- ��ȣ ���� �� ����
    , NAME              -- �̸�
    , SEX_UPON_INTAKE   -- ���� �� �߼�ȭ ����
    
[ANIMAL_OUTS O ���̺�]
 : ANIMAL_ID            -- ����id
    , ANIMAL_TYPE       -- ���� ��
    , DATETIME          -- �Ծ���
    , NAME              -- �̸�
    , SEX_UPON_OUTCOME  -- ���� �� �߼�ȭ ����

-- ��ȸ : ��ȣ �������� ���� ��(��������)
 : ORDER BY I.DATETIME
 
-- ��ȣ������ > �Ծ����� ANIMAL_ID, NAME, ��ȣ������, �Ծ��� ��ȸ(��ȣ������ ��������)
SELECT I.ANIMAL_ID, I.NAME
        , TO_CHAR(I.DATETIME, 'YYYY-MM-DD')
        , TO_CHAR(O.DATETIME, 'YYYY-MM-DD')
    FROM ANIMAL_INS I
        , ANIMAL_OUTS O
    WHERE I.ANIMAL_ID = O.ANIMAL_ID
        AND I.DATETIME > O.DATETIME
    ORDER BY I.DATETIME
;

-- ��ȣ������ > �Ծ����� ANIMAL_ID, NAME ��ȸ(��ȣ������ ��������)
-- ���1> ����Ŭ ��������
SELECT I.ANIMAL_ID, I.NAME
    FROM ANIMAL_INS I
        , ANIMAL_OUTS O
    WHERE I.ANIMAL_ID = O.ANIMAL_ID
        AND I.DATETIME > O.DATETIME
    ORDER BY I.DATETIME
;
*/

-- ��ȣ������ > �Ծ����� ANIMAL_ID, NAME ��ȸ(��ȣ������ ��������)
-- ���2> ANSI ����
SELECT I.ANIMAL_ID, I.NAME
    FROM ANIMAL_INS I
    INNER JOIN ANIMAL_OUTS O
    ON I.ANIMAL_ID = O.ANIMAL_ID
        AND I.DATETIME > O.DATETIME
    ORDER BY I.DATETIME
;

--=======================================
--=======================================
<���� �Ⱓ ��ȣ�� ����(1)>
/*
0. ����
 : ���� �Ծ��� �� �� ���� ��, 
   ���� ���� ��ȣ�ҿ� �־��� ���� 3������
   �̸��� ��ȣ �������� ��ȸ�ϴ� SQL���� �ۼ����ּ���. 
   �̶� ����� ��ȣ ������ ������ ��ȸ�ؾ� �մϴ�.
[ANIMAL_INS I ���̺�]
 : ANIMAL_ID            -- ����id
    , ANIMAL_TYPE       -- ���� ��
    , DATETIME          -- ��ȣ ������
    , INTAKE_CONDITION  -- ��ȣ ���� �� ����
    , NAME              -- �̸�
    , SEX_UPON_INTAKE   -- ���� �� �߼�ȭ ����
    
[ANIMAL_OUTS O ���̺�]
 : ANIMAL_ID            -- ����id
    , ANIMAL_TYPE       -- ���� ��
    , DATETIME          -- �Ծ���
    , NAME              -- �̸�
    , SEX_UPON_OUTCOME  -- ���� �� �߼�ȭ ����

-- ��ȣ������ ������ ��ȸ(��������)
 : ORDER BY O.DATETIME
 
-- ��ȣ�Ⱓ = SYSDATE - ��ȣ������
TRUNC( TO_CHAR(SYSDATE - I.DATETIME +1) )

-- ���1> �ܺ�����
-- �Ծ�X�� �̸�, ��ȣ������, '��ȣ�Ⱓ = SYSDATE - ��ȣ������ +1' ��ȸ(��ȣ�Ⱓ ��������)
SELECT I.NAME
        , I.DATETIME
        , TRUNC( TO_CHAR(SYSDATE - I.DATETIME +1) ) AS DURATION
    FROM ANIMAL_INS I, ANIMAL_OUTS O
    WHERE I.ANIMAL_ID = O.ANIMAL_ID(+)      -- �ܺ�����
        AND O.DATETIME IS NULL
    ORDER BY DURATION DESC
;

-- ROWNUM, �Ծ�X�� �̸�, ��ȣ������, '��ȣ�Ⱓ = SYSDATE - ��ȣ������ +1' ��ȸ(��ȣ�Ⱓ ��������)
SELECT ROWNUM AS RN, T.*
    FROM (SELECT I.NAME
                , I.DATETIME
                , TRUNC( TO_CHAR(SYSDATE - I.DATETIME +1) ) AS DURATION
            FROM ANIMAL_INS I, ANIMAL_OUTS O
            WHERE I.ANIMAL_ID = O.ANIMAL_ID(+)
                AND O.DATETIME IS NULL
            ORDER BY DURATION DESC
           ) T
;

-- ���1> ��ȣ�Ⱓ�� �� 3������ �̸�, ��ȣ������ ��ȸ(��ȣ������ ��������)
SELECT T2.NAME, T2.DATETIME
    FROM ( SELECT ROWNUM AS RN, T1.*
                FROM (SELECT I.NAME
                            , I.DATETIME
                            , TRUNC( TO_CHAR(SYSDATE 
                                - I.DATETIME +1) ) AS DURATION
                        FROM ANIMAL_INS I, ANIMAL_OUTS O
                        WHERE I.ANIMAL_ID = O.ANIMAL_ID(+)
                            AND O.DATETIME IS NULL
                        ORDER BY DURATION DESC
                    ) T1
           ) T2
    WHERE RN IN (1,2,3)
    ORDER BY T2.DATETIME
;


-- ���2> ANSI �ܺ�����
-- �Ծ�X�� �̸�, ��ȣ������, '��ȣ�Ⱓ = SYSDATE - ��ȣ������ +1' ��ȸ(��ȣ�Ⱓ ��������)
SELECT I.NAME
        , I.DATETIME
        , TRUNC( TO_CHAR(SYSDATE - I.DATETIME +1) ) AS DURATION
    FROM ANIMAL_INS I
    LEFT JOIN ANIMAL_OUTS O
    ON I.ANIMAL_ID = O.ANIMAL_ID
    WHERE O.DATETIME IS NULL
    ORDER BY DURATION DESC
;

-- ROWNUM, �Ծ�X�� �̸�, ��ȣ������, '��ȣ�Ⱓ = SYSDATE - ��ȣ������ +1' ��ȸ(��ȣ�Ⱓ ��������)
SELECT ROWNUM AS RN, T.*
    FROM ( SELECT I.NAME
                , I.DATETIME
                , TRUNC( TO_CHAR(SYSDATE - I.DATETIME +1) ) AS DURATION
            FROM ANIMAL_INS I
            LEFT JOIN ANIMAL_OUTS O
            ON I.ANIMAL_ID = O.ANIMAL_ID
            WHERE O.DATETIME IS NULL
            ORDER BY DURATION DESC
          ) T
;

-- ���2> ��ȣ�Ⱓ�� �� 3������ �̸�, ��ȣ������ ��ȸ(��ȣ������ ��������)
SELECT T2.NAME, T2.DATETIME
    FROM ( SELECT ROWNUM AS RN, T1.*
            FROM ( SELECT I.NAME
                        , I.DATETIME
                        , TRUNC( TO_CHAR(SYSDATE 
                            - I.DATETIME +1) ) AS DURATION
                    FROM ANIMAL_INS I
                    LEFT JOIN ANIMAL_OUTS O
                    ON I.ANIMAL_ID = O.ANIMAL_ID
                    WHERE O.DATETIME IS NULL
                    ORDER BY DURATION DESC
                ) T1
           ) T2
    WHERE RN IN (1,2,3)
    ORDER BY T2.DATETIME
;
*/

-- ���1> ��ȣ�Ⱓ�� �� 3������ �̸�, ��ȣ������ ��ȸ(��ȣ������ ��������)
SELECT T2.NAME, T2.DATETIME
    FROM ( SELECT ROWNUM AS RN, T1.*
                FROM (SELECT I.NAME
                            , I.DATETIME
                            , TRUNC( TO_CHAR(SYSDATE 
                                - I.DATETIME +1) ) AS DURATION
                        FROM ANIMAL_INS I, ANIMAL_OUTS O
                        WHERE I.ANIMAL_ID = O.ANIMAL_ID(+)
                            AND O.DATETIME IS NULL
                        ORDER BY DURATION DESC
                    ) T1
           ) T2
    WHERE RN IN (1,2,3)
    ORDER BY T2.DATETIME
;

--=======================================
--=======================================
<��ȣ�ҿ��� �߼�ȭ�� ����>
/*
0. ����
 : ��ȣ�ҿ��� �߼�ȭ ������ ��ģ ���� ������ �˾ƺ��� �մϴ�.
   ��ȣ�ҿ� ���� ��ÿ��� �߼�ȭ���� �ʾ�����, 
   ��ȣ�Ҹ� ���� ��ÿ��� �߼�ȭ�� ������ 
   ���̵�� ���� ��, �̸��� ��ȸ�ϴ� ���̵� ������ ��ȸ�ϴ� SQL ���� �ۼ����ּ���.
   
[ANIMAL_INS I ���̺�]
 : ANIMAL_ID            -- ����id
    , ANIMAL_TYPE       -- ���� ��
    , DATETIME          -- ��ȣ ������
    , INTAKE_CONDITION  -- ��ȣ ���� �� ����
    , NAME              -- �̸�
    , SEX_UPON_INTAKE   -- ���� �� �߼�ȭ ����
    
[ANIMAL_OUTS O ���̺�]
 : ANIMAL_ID            -- ����id
    , ANIMAL_TYPE       -- ���� ��
    , DATETIME          -- �Ծ���
    , NAME              -- �̸�
    , SEX_UPON_OUTCOME  -- ���� �� �߼�ȭ ����

-- ���̵� ������ ��ȸ(��������)
 : ORDER BY ANIMAL_ID
*/

-- ���� ID, ���� ��, �̸�, ��ȣ ���� �� ���� �� �߼�ȭ ����
SELECT ANIMAL_ID, ANIMAL_TYPE, NAME, SEX_UPON_INTAKE
    FROM ANIMAL_INS
    ORDER BY ANIMAL_ID
;

-- (��ȣ ���� �� �߼�ȭ ���� ����) ���� ID, ���� ��, �̸�
SELECT ANIMAL_ID, ANIMAL_TYPE, NAME
    FROM ANIMAL_INS
    WHERE SEX_UPON_INTAKE LIKE 'Neutered%'
    ORDER BY ANIMAL_ID
;

-- (��ȣ ���� �� �߼�ȭ ��) ���� ID, ���� ��, �̸�
SELECT ANIMAL_ID, ANIMAL_TYPE, NAME, DATETIME
    FROM ANIMAL_OUTS
    WHERE SEX_UPON_OUTCOME LIKE 'Spayed%'
    ORDER BY ANIMAL_ID
;

-- (��ȣ ���� �� �߼�ȭX, ��ȣ ���� �� �߼�ȭO) ���� ID, ���� ��, �̸�
SELECT ANIMAL_ID, ANIMAL_TYPE, NAME
    FROM ANIMAL_INS I
    WHERE ANIMAL_ID IN (SELECT ANIMAL_ID, ANIMAL_TYPE, NAME, DATETIME
                            FROM ANIMAL_OUTS O
                            WHERE SEX_UPON_OUTCOME LIKE 'Spayed%'
                        ) T
        AND SEX_UPON_INTAKE LIKE 'Neutered%'
    ORDER BY ANIMAL_ID
;



