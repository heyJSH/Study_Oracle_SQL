<있었는데요 없었습니다>
/*
0. 문제
 : 관리자의 실수로 일부 동물의 입양일이 잘못 입력되었습니다.
   보호 시작일보다 입양일이 더 빠른 동물의 아이디와 이름을 조회하는 SQL문을 작성.
   이때 결과는 보호 시작일이 빠른 순으로 조회해야합니다.
[ANIMAL_INS I 테이블]
 : ANIMAL_ID            -- 동물id
    , ANIMAL_TYPE       -- 생물 종
    , DATETIME          -- 보호 시작일
    , INTAKE_CONDITION  -- 보호 시작 시 상태
    , NAME              -- 이름
    , SEX_UPON_INTAKE   -- 성별 및 중성화 여부
    
[ANIMAL_OUTS O 테이블]
 : ANIMAL_ID            -- 동물id
    , ANIMAL_TYPE       -- 생물 종
    , DATETIME          -- 입양일
    , NAME              -- 이름
    , SEX_UPON_OUTCOME  -- 성별 및 중성화 여부

-- 조회 : 보호 시작일이 빠른 순(오름차순)
 : ORDER BY I.DATETIME
 
-- 보호시작일 > 입양일인 ANIMAL_ID, NAME, 보호시작일, 입양일 조회(보호시작일 오름차순)
SELECT I.ANIMAL_ID, I.NAME
        , TO_CHAR(I.DATETIME, 'YYYY-MM-DD')
        , TO_CHAR(O.DATETIME, 'YYYY-MM-DD')
    FROM ANIMAL_INS I
        , ANIMAL_OUTS O
    WHERE I.ANIMAL_ID = O.ANIMAL_ID
        AND I.DATETIME > O.DATETIME
    ORDER BY I.DATETIME
;

-- 보호시작일 > 입양일인 ANIMAL_ID, NAME 조회(보호시작일 오름차순)
-- 방법1> 오라클 동등조인
SELECT I.ANIMAL_ID, I.NAME
    FROM ANIMAL_INS I
        , ANIMAL_OUTS O
    WHERE I.ANIMAL_ID = O.ANIMAL_ID
        AND I.DATETIME > O.DATETIME
    ORDER BY I.DATETIME
;
*/

-- 보호시작일 > 입양일인 ANIMAL_ID, NAME 조회(보호시작일 오름차순)
-- 방법2> ANSI 조인
SELECT I.ANIMAL_ID, I.NAME
    FROM ANIMAL_INS I
    INNER JOIN ANIMAL_OUTS O
    ON I.ANIMAL_ID = O.ANIMAL_ID
        AND I.DATETIME > O.DATETIME
    ORDER BY I.DATETIME
;

--=======================================
--=======================================
<오랜 기간 보호한 동물(1)>
/*
0. 문제
 : 아직 입양을 못 간 동물 중, 
   가장 오래 보호소에 있었던 동물 3마리의
   이름과 보호 시작일을 조회하는 SQL문을 작성해주세요. 
   이때 결과는 보호 시작일 순으로 조회해야 합니다.
[ANIMAL_INS I 테이블]
 : ANIMAL_ID            -- 동물id
    , ANIMAL_TYPE       -- 생물 종
    , DATETIME          -- 보호 시작일
    , INTAKE_CONDITION  -- 보호 시작 시 상태
    , NAME              -- 이름
    , SEX_UPON_INTAKE   -- 성별 및 중성화 여부
    
[ANIMAL_OUTS O 테이블]
 : ANIMAL_ID            -- 동물id
    , ANIMAL_TYPE       -- 생물 종
    , DATETIME          -- 입양일
    , NAME              -- 이름
    , SEX_UPON_OUTCOME  -- 성별 및 중성화 여부

-- 보호시작일 순으로 조회(오름차순)
 : ORDER BY O.DATETIME
 
-- 보호기간 = SYSDATE - 보호시작일
TRUNC( TO_CHAR(SYSDATE - I.DATETIME +1) )

-- 방법1> 외부조인
-- 입양X의 이름, 보호시작일, '보호기간 = SYSDATE - 보호시작일 +1' 조회(보호기간 내림차순)
SELECT I.NAME
        , I.DATETIME
        , TRUNC( TO_CHAR(SYSDATE - I.DATETIME +1) ) AS DURATION
    FROM ANIMAL_INS I, ANIMAL_OUTS O
    WHERE I.ANIMAL_ID = O.ANIMAL_ID(+)      -- 외부조인
        AND O.DATETIME IS NULL
    ORDER BY DURATION DESC
;

-- ROWNUM, 입양X의 이름, 보호시작일, '보호기간 = SYSDATE - 보호시작일 +1' 조회(보호기간 내림차순)
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

-- 답안1> 보호기간이 긴 3마리의 이름, 보호시작일 조회(보호시작일 오름차순)
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


-- 방법2> ANSI 외부조인
-- 입양X의 이름, 보호시작일, '보호기간 = SYSDATE - 보호시작일 +1' 조회(보호기간 내림차순)
SELECT I.NAME
        , I.DATETIME
        , TRUNC( TO_CHAR(SYSDATE - I.DATETIME +1) ) AS DURATION
    FROM ANIMAL_INS I
    LEFT JOIN ANIMAL_OUTS O
    ON I.ANIMAL_ID = O.ANIMAL_ID
    WHERE O.DATETIME IS NULL
    ORDER BY DURATION DESC
;

-- ROWNUM, 입양X의 이름, 보호시작일, '보호기간 = SYSDATE - 보호시작일 +1' 조회(보호기간 내림차순)
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

-- 답안2> 보호기간이 긴 3마리의 이름, 보호시작일 조회(보호시작일 오름차순)
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

-- 답안1> 보호기간이 긴 3마리의 이름, 보호시작일 조회(보호시작일 오름차순)
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
<보호소에서 중성화한 동물>
/*
0. 문제
 : 보호소에서 중성화 수술을 거친 동물 정보를 알아보려 합니다.
   보호소에 들어올 당시에는 중성화되지 않았지만, 
   보호소를 나갈 당시에는 중성화된 동물의 
   아이디와 생물 종, 이름을 조회하는 아이디 순으로 조회하는 SQL 문을 작성해주세요.
   
[ANIMAL_INS I 테이블]
 : ANIMAL_ID            -- 동물id
    , ANIMAL_TYPE       -- 생물 종
    , DATETIME          -- 보호 시작일
    , INTAKE_CONDITION  -- 보호 시작 시 상태
    , NAME              -- 이름
    , SEX_UPON_INTAKE   -- 성별 및 중성화 여부
    
[ANIMAL_OUTS O 테이블]
 : ANIMAL_ID            -- 동물id
    , ANIMAL_TYPE       -- 생물 종
    , DATETIME          -- 입양일
    , NAME              -- 이름
    , SEX_UPON_OUTCOME  -- 성별 및 중성화 여부

-- 아이디 순으로 조회(오름차순)
 : ORDER BY ANIMAL_ID
*/

-- 동물 ID, 생물 종, 이름, 보호 시작 시 성별 및 중성화 여부
SELECT ANIMAL_ID, ANIMAL_TYPE, NAME, SEX_UPON_INTAKE
    FROM ANIMAL_INS
    ORDER BY ANIMAL_ID
;

-- (보호 시작 시 중성화 하지 않은) 동물 ID, 생물 종, 이름
SELECT ANIMAL_ID, ANIMAL_TYPE, NAME
    FROM ANIMAL_INS
    WHERE SEX_UPON_INTAKE LIKE 'Neutered%'
    ORDER BY ANIMAL_ID
;

-- (보호 종료 시 중성화 한) 동물 ID, 생물 종, 이름
SELECT ANIMAL_ID, ANIMAL_TYPE, NAME, DATETIME
    FROM ANIMAL_OUTS
    WHERE SEX_UPON_OUTCOME LIKE 'Spayed%'
    ORDER BY ANIMAL_ID
;

-- (보호 시작 시 중성화X, 보호 종료 시 중성화O) 동물 ID, 생물 종, 이름
SELECT ANIMAL_ID, ANIMAL_TYPE, NAME
    FROM ANIMAL_INS I
    WHERE ANIMAL_ID IN (SELECT ANIMAL_ID, ANIMAL_TYPE, NAME, DATETIME
                            FROM ANIMAL_OUTS O
                            WHERE SEX_UPON_OUTCOME LIKE 'Spayed%'
                        ) T
        AND SEX_UPON_INTAKE LIKE 'Neutered%'
    ORDER BY ANIMAL_ID
;



