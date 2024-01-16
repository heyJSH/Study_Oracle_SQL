[[프로그래머스 코딩테스트 연습]]

--=======================================
--=======================================
<자동차 대여 기록에서 장기/단기 대여 구분하기>
① CAR_RENTAL_COMPANY_RENTAL_HISTORY 테이블에서 조회한다.

② 2022년 9월에 대여한 것에 한하여 대여기간을 계산한다.

③ HISTORY_ID, CAR_ID, START_DATE, END_DATE, RENT_TYPE를 조회한다.

④ 이때 조회하는 START_DATE, END_DATE의 형식은 YYYY-MM-DD 이어야 한다.

⑤ CASE 표현식을 사용하여 대여기간이 30일 이상일 경우 '장기 대여', 그 밖의 경우 '단기 대여'라 표현한다.

* 대여 기간의 경우 당일 반납도 생각하여야 하기 때문에 +1을 통해 당일 반납도 포함하여 조회한다.

⑥ 조회한 HISTORY_ID, CAR_ID, START_DATE, END_DATE, RENT_TYPE를 ORDER BY를 이용하여 내림차순(DESC) 정렬한다.

1.테이블 
    : CAR_RENTAL_COMPANY_RENTAL_HISTORY H
    
2. 객체
 : history_id
   , car_id
   , start_date -- 22년도 9월만. 'YYYY-MM-DD'형식
   , end_date -- 'YYYY-MM-DD'형식
   , rent_type -- 30일 이상 대여 : '장기 대여', 30일 미만 대여 : '단기 대여'
   
 [조건]
 start_date : 9월 내에 대여
  to_char(start_date, 'YYYY-MM') = '2022-09'
 
 
 대여기간 = end_date - start_date +1
  to_char(start_date, 'YYYY-MM-DD') AS start_date
  to_char(end_date, 'YYYY-MM-DD') AS end_date
 대여기간 = duration = H.end_date - H.start_date +1
 
 대여기간 : 30일 이상 ▶ 장기 대여
          : 30일 미만(ELSE) ▶ 단기 대여
          
SELECT
        CASE WHEN to_char(H.end_date - H.start_date +1) >= 30
            THEN '장기 대여'
        ELSE '단기 대여'
        END AS rent_type
    FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY H

 history_id 내림차순으로 정렬하라 ▶ ORDER BY history_id DESC
 
 
 --=======================================
-- 방법
-- start_date, end_date 포맷은 'yyyy-mm-dd'로 출력
-- '장기 대여', '단기 대여' 띄어쓰기 주의 ㅋㅋ;
SELECT history_id
        , car_id
        , to_char(start_date, 'yyyy-mm-dd') AS start_date
        , to_char(end_date, 'yyyy-mm-dd') AS end_date
        ,   CASE WHEN to_char(H.end_date - H.start_date +1) >= 30
                THEN '장기 대여'
            ELSE '단기 대여'
            END AS rent_type
    FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY H
    WHERE to_char(start_date, 'yyyy-mm') LIKE '2022-09'
    ORDER BY history_id DESC
;
 
--=======================================
--=======================================

[문제]
: USED_GOODS_BOARD 테이블에서 2022년 10월 5일에 등록된 중고거래 게시물의 
게시글 ID, 작성자 ID, 게시글 제목, 가격, 거래상태를 조회하는 SQL문을 작성해주세요. 
거래상태가 SALE 이면 판매중, RESERVED이면 예약중, DONE이면 거래완료 분류하여 출력해주시고, 
결과는 게시글 ID를 기준으로 내림차순 정렬해주세요.
/*
-- 사용 테이블 : USED_GOODS_BOARD GB
  USED_GOODS_BOARD GB의 컬럼
  : board_id, writer_id, title, contents, price, created_date, status, views
-- 거래상태 sale이면 '판매중', reserved이면 '예약중', done이면 '거래완료'
-- 출력할 컬럼 : board_id, writer_id, title, price, status
-- 2022년 10월 5일에 등록된 중고 거래 게시물 중에서 출력
    WHERE to_date(created_date, 'yyyy-mm-dd') = '2022-10-05'
-- board_id 기준으로 내림차순 정렬
    ORDER BY board_id DESC

-- 기본 구문 틀
SELECT
        board_id, writer_id, title, price
        ,   CASE WHEN status = 'SALE' THEN '판매중'
            WHEN status = 'RESERVED' THEN '예약중'
            WHEN status = 'DONE' THEN '거래완료'
            END AS status
    FROM USED_GOODS_BOARD
    WHERE to_date(created_date, 'yyyy-mm-dd') = '2022-10-05'
    ORDER BY board_id DESC
;

*/
    
SELECT
        board_id, writer_id, title, price
        ,   CASE WHEN status = 'SALE' THEN '판매중'
            WHEN status = 'RESERVED' THEN '예약중'
            WHEN status = 'DONE' THEN '거래완료'
            END AS status
    FROM USED_GOODS_BOARD
    WHERE to_char(created_date, 'yyyy-mm-dd') = '2022-10-05'
    ORDER BY board_id DESC
;

--=======================================
--=======================================
<조건에 맞는 사용자 정보 조회하기>

/*
0. 문제
 : USED_GOODS_BOARD와 USED_GOODS_USER 테이블에서
  중고 거래 게시물을 3건 이상 등록한 사용자의
  사용자 ID, 닉네임, 전체주소, 전화번호를 조회하는 SQL문을 작성해주세요.
  이때, 전체 주소는 시, 도로명 주소, 상세 주소가 함께 출력되도록 해주시고,
  전화번호의 경우 xxx-xxxx-xxxx 같은 형태로 하이픈 문자열(-)을 삽입하여 출력.
  결과는 회원 ID를 기준으로 내림차순 정렬해주세요.

1. 테이블1
 : USED_GOODS_BOARD B
2. 테이블1_사용 컬럼
 : BOARD_ID             -- 게시글ID
    , WRITER_ID         -- 작성자ID
    , TITLE             -- 게시글 제목
    , CONTENTS          -- 게시글 내용
    , PRICE             -- 가격
    , CREATED_DATE      -- 작성일
    , STATUS            -- 거래상태
    , VIEWS             -- 조회수
3. 테이블2
 : USED_GOODS_USER U
4. 테이블2_사용 컬럼
 : USER_ID              -- 회원ID
    , NICKNAME          -- 닉네임
    , CITY              -- 시
    , STREET_ADDRESS1   -- 도로명 주소
    , STREET_ADDRESS2   -- 상세 주소
    , TLNO              -- 전화번호
5. 출력 컬럼
 : 사용자 ID
    , 닉네임
    , 전체주소  -- 시, 도로명주소, 상세주소 함께 출력
    , 전화번호  -- xxx-xxxx-xxxx처럼 하이픈'-'출력
-- 회원 id기준 내림차순 정렬
 : ORDER BY USER_ID DESC
 
-- 기본 구문
SELECT USER_ID              -- U.USER_ID = B.WRITER_ID
        , NICKNAME
        , TOTAL_ADDRESS
        , TLNO
    FROM USED_GOODS_USER U
    ORDER BY USER_ID DESC
;

-- total_address 출력
SELECT CITY || ' ' || STREET_ADDRESS1 || STREET_ADDRESS2
        AS TOTAL_ADDRESS
    FROM USED_GOODS_USER
    ORDER BY USER_ID DESC
;

-- 전화번호 포맷 변경
SELECT 
        SUBSTR(U.TLNO, 1, 3) || '-' || SUBSTR(U.TLNO, 4, 4)
            || '-' || SUBSTR(U.TLNO, 8, 4)
                AS NEW_TLNO
    FROM USED_GOODS_USER U
    ORDER BY USER_ID DESC
;

-- USER_ID, NICKNAME, TOTAL_ADDRESS, NEW_TLNO 출력
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

-- 중고거래 게시물 3건 이상 등록한 목록 조회
-- USED_GOODS_BOARD 테이블에서
    -- 동일한 WRITER_ID의
    -- CREATED_DATE을 COUNT하여 3 이상인 목록을 조회
SELECT WRITER_ID, COUNT(CREATED_DATE)
    FROM USED_GOODS_BOARD B
    GROUP BY WRITER_ID
    HAVING COUNT(CREATED_DATE) >= 3
;
*/

-- ||로 연결
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
<조회수가 가장 많은 중고거래 게시판의 첨부파일 조회하기>
/*
0. 문제
 : USED_GOODS_BOARD와 USED_GOODS_FILE 테이블에서
 조회수가 가장 높은 중고거래 게시물에 대한 첨부파일 경로를 조회하는 SQL문 작성.
 첨부파일 경로는 FILE ID를 기준으로 내림차순 정렬해주세요.
 기본적인 파일경로는 /home/grep/src/ 이며, 
 게시글 ID를 기준으로 디렉토리가 구분되고, 
 파일이름은 파일 ID, 파일 이름, 파일 확장자로 구성되도록 출력해주세요.
 조회수가 가장 높은 게시물은 하나만 존재합니다.
1. 테이블1
 : USED_GOODS_BOARD
1_1. 사용컬럼_테이블1
 : BOARD_ID         -- 게시글id
    , WRITER_ID     -- 작성자id
    , TITLE         -- 게시글 제목
    , CONTENTS      -- 게시글 내용
    , PRICE         -- 가격
    , CREATED_DATE  -- 작성일
    , STATUS        -- 거래상태
    , VIEWS         -- 조회수
2. 테이블2
 : USED_GOODS_FILE
2_1. 사용컬럼_테이블2
 : FILE_ID          -- 파일 id
    , FILE_EXT      -- 파일 확장자
    , FILE_NAME     -- 파일 이름
    , BOARD_ID      -- 게시글 id
    
-- 조회수가 가장 높은 중고거래 게시물(하나만 존재)
-- 조회수가 가장 높은 중고거래 게시물에 대한 첨부파일 경로 조회
-- 기본적인 파일경로 : /home/grep/src/
-- 파일이름(FILE_NAME)은 파일ID(FILE_ID), 파일이름(FILE_NAME)
    , 파일확장자(FILE_EXT)로 구성
-- 파일경로
 : /home/grep/src/ + BOARD_ID + '/' + FILE_ID + FILE_NAME + FILE_EXT
-- FILE_ID 기준으로 내림차순 정렬
 : ORDER BY FILE_ID DESC

-- 파일경로 조회
SELECT '/home/grep/src/' || BOARD_ID || '/' || FILE_ID
        || FILE_NAME || FILE_EXT as FILE_PATH
        , FILE_ID
    FROM USED_GOODS_FILE
    ORDER BY FILE_ID DESC
;
 
-- 가장 높은 조회수 조회
SELECT MAX(VIEWS)
    FROM USED_GOODS_BOARD
;

-- 조회수가 가장 높은 중고거래 게시물 조회
SELECT BOARD_ID
    FROM USED_GOODS_BOARD
    WHERE VIEWS = (SELECT MAX(VIEWS) FROM USED_GOODS_BOARD)
;

-- 답안1> '=' 사용
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

-- 답안2> IN 사용
-- 답안
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

-- 답안
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
<루시와 엘라 찾기>
[문제]
 : 동물 보호소에 들어온 동물 중
   이름이 Lucy, Ella, Pickle, Rogan, Sabrina, Mitty인 동물의
   아이디와 이름, 성별 및 중성화 여부를 조회하는 SQL 문을 작성해주세요.
   
/*
-- 테이블 : ANIMAL_INS
-- 컬럼명 : ANIMAL_ID              -- 동물아이디
        , ANIMAL_TYPE             -- 생물 종
        , DATETIME                -- 보호 시작일
        , INTAKE_CONDITION        -- 보호 시작 시 상태
        , NAME                    -- 이름
        , SEX_UPON_INTAKE         -- 성별 및 중성화 여부

-- 출력할 컬럼
 : 동물아이디, 동물이름, 성별 및 중성화 여부
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
<이름에 el이 들어가는 동물 찾기>
/* 0. 문제
동물 보호소에 들어온 동물 이름 중,
이름에 "EL"이 들어가는 개의 아이디와 이름을 조회하는 SQL문을 작성해주세요.
이때 결과는 이름 순으로 조회해주세요. 단, 이름의 대소문자는 구분하지 않습니다.

1. 테이블
 : ANIMAL_INS
2. 테이블 속 컬럼명
 : ANIMAL_ID            -- 동물id
   , ANIMAL_TYPE        -- 생물 종
   , DATETIME           -- 보호 시작일
   , INTAKE_CONDITION   -- 보호 시작 시 상태
   , NAME               -- 이름
   , SEX_UPON_INTAKE    -- 성별 및 중성화 여부
3. 출력할 컬럼
 : ANIMAL_ID
   , NAME
4. 조건
-- ANIMAL_TYPE = 'Dog'
-- 이름 순으로 조회
    : ORDER BY NAME  
-- NAME에 "EL"이 들어간 목록 출력
-- 이름의 대소문자 구분하지 않음
    : 이름을 대문자로 반환하여 대문자로 'EL' 들어가는 목록을 조회
      (또는 반대로 소문자로 반환하여 소문자로 'el' 들어가는 목록을 조회)
    : WHERE UPPER(TO_CHAR(NAME)) LIKE ('%EL%')

-- 기본구문
SELECT ANIMAL_ID
        , NAME
    FROM ANIMAL_INS
    ORDER BY NAME
;

*/

-- 정리
SELECT ANIMAL_ID, NAME
    FROM ANIMAL_INS i
    WHERE UPPER(TO_CHAR(NAME)) LIKE ('%EL%')
        AND ANIMAL_TYPE = 'Dog'
    ORDER BY NAME
;

--=======================================
--=======================================
<오랜 기간 보호한 동물(2)>
/*
[ANIMAL_INS I] 테이블
 : ANIMAL_ID            -- 동물id
    , ANIMAL_TYPE       -- 생물 종
    , DATETIME          -- 보호 시작일
    , INTAKE_CONDITION  -- 보호 시작 시 상태
    , NAME              -- 이름
    , SEX_UPON_INTAKE   -- 성별 및 중성화 여부
    
[ANIMAL_OUTS O] 테이블
 : ANIMAL_ID            -- 동물id, FOREIGN KEY(ins 테이블의 animal_id)
    , ANIMAL_TYPE       -- 생물 종
    , DATETIME          -- 입양일
    , NAME              -- 이름
    , SEX_UPON_OUTCOME  -- 성별 및 중성화 여부
    
[문제]
 : 입양을 간 동물 중, 보호 기간이 가장 길었던 동물 두 마리의 
  아이디와 이름을 조회하는 SQL문을 작성해주세요. 
  이때 결과는 보호 기간이 긴 순으로 조회해야 합니다.
  
-- 기본 구문
SELECT ANIMAL_ID
        , NAME
    FROM ANIMAL_OUTS
;

-- 보호기간 = TO_CHAR(O.DATETIME - I.DATETIME +1)
-- 보호기간이 가장 길었던 두마리
-- 가장 긴 것 : MAX(보호기간)
-- 그 다음 긴것 : MAX(보호기간)을 제외한 MAX(보호기간)
-- 보호 기간이 긴 순으로 조회
 : ORDER BY 보호기간
-- 동물ID, 보호시작일, 입양일, 보호기간 조회
SELECT O.ANIMAL_ID
        , I.DATETIME AS START_DATE
        , O.DATETIME AS END_DATE
        , TRUNC(O.DATETIME - I.DATETIME +1) AS DURATION
    FROM ANIMAL_INS I, ANIMAL_OUTS O
    WHERE I.ANIMAL_ID = O.ANIMAL_ID
    ORDER BY TRUNC(O.DATETIME - I.DATETIME +1) DESC
;

-- 보호기간 최대값 구하기
SELECT MAX(TRUNC(O.DATETIME - I.DATETIME +1))
            AS FIRST_DURATION
    FROM ANIMAL_INS I, ANIMAL_OUTS O
    WHERE I.ANIMAL_ID = O.ANIMAL_ID
    ORDER BY TRUNC(O.DATETIME - I.DATETIME +1) DESC
;

-- RN 포함한 동물ID, 이름, 보호기간을 보호기간 내림차순 정렬
-- ROWNUM, ORDER BY는 행번호 먼저 지정 후 순서 정렬하므로
-- ORDER BY 먼저 한 후, ROWNUM 지정해주기
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
-- 답안
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
    -- 혹은 WHERE RN=1 OR RN=2
;

--=======================================
--=======================================
<자동차 대여 기록 별 대여 금액 구하기>
/*
1. 테이블 : CAR_RENTAL_COMPANY_CAR C
           CAR_RENTAL_COMPANY_RENTAL_HISTORY H
           CAR_RENTAL_COMPANY_DISCOUNT_PLAN P

2. 객체
 : car_type
    , car_id
    , history_id
    , start_date
    , end_date
    , duration_type
    , discount_rate
    , daily fee
           
3. 출력값
    history_id
    , Fee

4. 조건
 : Fee는 정수만 출력
  , C.car_type = '트럭'
  , FEE DESC
  , H.history_id DESC
  
--=======================================
-- Fee(정수)
Fee = 대여기간 * C.daily_fee(트럭 가격) * (duration_type에 해당하는 discount_rate)
   (★ 7일 미만일 경우 ▶ Fee = 대여기간 * C.daily_fee(트럭가격))
(duration = end_date - start_date +1) duration
(duration_type에 해당하는 discount_rate)
        = duration_type에 값이 있으면 ▶ discount_rate,
          duration_type에 값이 없으면 ▶ 0 (∵ 7일 미만이면 할인없음)
        = (1 - NVL(P.discount_rate, 0) / 100)

-- FEE 결과
-- 정수로 출력할 것
TRUNC(duration * daily_fee * (1 - NVL(P.discount_rate, 0) / 100)) as FEE

-- duration 구하기
SELECT history_id,
       H.END_DATE - H.START_DATE + 1 AS DURATION
    FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY H
        , CAR_RENTAL_COMPANY_CAR C
    WHERE C.CAR_TYPE = '트럭';

-- duration_type 구하기
SELECT history_id
        ,CASE WHEN H.END_DATE - H.START_DATE + 1 BETWEEN 7 AND 29 
            THEN '7일 이상'
        WHEN H.END_DATE - H.START_DATE + 1 BETWEEN 30 AND 89 
            THEN '30일 이상'
        WHEN H.END_DATE - H.START_DATE + 1 >= 90 
            THEN '90일 이상'
        END AS DURATION_TYPE
    FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY H
        , CAR_RENTAL_COMPANY_CAR C
    WHERE C.CAR_TYPE = '트럭';
    
-- discount_rate 구하기
-- duration_type에 해당하는 discount_rate를 출력
-- car_type = '트럭'
SELECT T.history_id
    , (1 - NVL(P.discount_rate, 0) / 100) as discount_rate
    FROM (SELECT H.HISTORY_ID
                ,    CASE WHEN H.END_DATE - H.START_DATE + 1 BETWEEN 7 AND 29 
                        THEN '7일 이상'
                    WHEN H.END_DATE - H.START_DATE + 1 BETWEEN 30 AND 89 
                        THEN '30일 이상'
                    WHEN H.END_DATE - H.START_DATE + 1 >= 90 
                        THEN '90일 이상'
                    END AS DURATION_TYPE
            FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY H
                , CAR_RENTAL_COMPANY_CAR C
            WHERE C.CAR_TYPE = '트럭'
                AND C.CAR_ID = H.CAR_ID
          ) T
          ,CAR_RENTAL_COMPANY_DISCOUNT_PLAN P
;

-- daily_fee 구하기
-- CAR_ID, 트럭인 DAILY_FEE
SELECT CAR_ID, CAR_TYPE, DAILY_FEE
    FROM CAR_RENTAL_COMPANY_CAR
    WHERE CAR_TYPE = '트럭'
;

-- HISTORY_ID, FEE 구하기
-- FEE = TRUNC(duration * daily_fee
--        * (1 - NVL(P.discount_rate, 0) / 100)) as FEE
-- CAR_TYPE = '트럭'

-- [외부조인]
--  : 조인조건에서 데이터가 없는 테이블의 컬럼에 (+) 기호를 붙임
*/

-- 도출한 정답
SELECT history_id
        , TRUNC(duration * daily_fee
            * (1 - NVL(P.discount_rate, 0)/100)) AS fee
    FROM ( SELECT H.history_id
                , C.car_type
                , C.daily_fee
                , H.end_date - H.start_date +1 AS duration
                ,   CASE WHEN H.end_date - H.start_date + 1
                        BETWEEN 7 AND 29
                        THEN '7일 이상'
                    WHEN H.end_date - H.start_date + 1
                        BETWEEN 30 AND 89
                        THEN '30일 이상'
                    WHEN H.end_date - H.start_date + 1 >= 90
                        THEN '90일 이상'
                    END AS duration_type
                FROM CAR_RENTAL_COMPANY_CAR C
                    , CAR_RENTAL_COMPANY_RENTAL_HISTORY H
                WHERE C.car_id = H.car_id
                    AND C.car_type = '트럭'
            ) T
            , CAR_RENTAL_COMPANY_DISCOUNT_PLAN P
    WHERE T.car_type = P.car_type(+) --외부조인
        AND T.duration_type = P.duration_type(+) -- 외부조인
    ORDER BY fee DESC, T.history_id DESC
;


--=======================================
/* history_id가 p에 없어서 사용하려면 다른 방법을 찾아야 함
SELECT 
        CASE WHEN 조건 THEN '출력'
             WHEN 조건 THEN '출력'
             ELSE '출력'
        END AS 컬럼명 정의
    FROM 테이블
    WHERE 조건;

<서브쿼리>
SELECT *
    FROM 테이블
    WHERE 조건
;

<메인쿼리>
SELECT 객체
    FROM 테이블
    WHERE EXISTS
        (SELECT *
            FROM 테이블
            WHERE 조건
        )
    ORDER BY 기준
;
 
--=======================================
<서브쿼리1>
SELECT H.history_id
             , C.CAR_TYPE
             , C.DAILY_FEE
             , H.END_DATE - H.START_DATE + 1 AS DURATION
             , CASE WHEN H.END_DATE - H.START_DATE + 1 BETWEEN 7 AND 29 
                        THEN '7일 이상'
                    WHEN H.END_DATE - H.START_DATE + 1 BETWEEN 30 AND 89 
                        THEN '30일 이상'
                    WHEN H.END_DATE - H.START_DATE + 1 >= 90 
                        THEN '90일 이상'
                END AS DURATION_TYPE
          FROM CAR_RENTAL_COMPANY_CAR C
             , CAR_RENTAL_COMPANY_RENTAL_HISTORY H
         WHERE C.CAR_ID = H.CAR_ID
           AND C.CAR_TYPE = '트럭';


<메인쿼리1>
-- FEE = 대여기간 * C.daily_fee(트럭 가격) * (duration_type에 해당하는 discount_rate)
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
                        THEN '7일 이상'
                    WHEN H.END_DATE - H.START_DATE + 1 BETWEEN 30 AND 89 
                        THEN '30일 이상'
                    WHEN H.END_DATE - H.START_DATE + 1 >= 90 
                        THEN '90일 이상'
                END AS DURATION_TYPE
          FROM CAR_RENTAL_COMPANY_CAR C
             , CAR_RENTAL_COMPANY_RENTAL_HISTORY H
         WHERE C.CAR_ID = H.CAR_ID
           AND C.CAR_TYPE = '트럭'
           AND P.CAR_TYPE = C.CAR_TYPE
        ) 
    ORDER BY FEE DESC, P.HISTORY_ID DESC
;
*/

--=======================================
--=======================================

<카테고리 별 상품 개수 구하기>
/* 0. 문제
PRODUCT 테이블에서 상품 카테고리 코드(PRODUCT_CODE 앞 2자리) 별
상품 개수를 출력하는 SQL문을 작성해주세요
결과는 상품 카테고리 코드를 기준으로 오름차순 정렬해주세요.

1. 테이블
 : PRODUCT
2. 테이블 속 컬럼명
 : PRODUCT_ID           -- 상품ID
    , PRODUCT_CODE      -- 상품코드
    , PRICE             -- 판매가
(상품 별로 중복되지 않은 8자리 상품코드 값을 가지며,
  앞 2자기는 카테고리 코드를 의미한다.)
3. 출력할 컬럼
 : 상품 카테고리 코드(PRODUCT_CODE 앞 2자리) 별 상품 개수
 -- CATEGORY     -- 카테고리
 -- PRODUCTS     -- 상품개수
4. ORDER BY CATEGORY ASC
*/

-- 기본구문
SELECT CATEGORY         -- 정의할것
        , PRODUCTS      -- 정의할것
    FROM PRODUCT P
    ORDER BY CATEGORY ASC
;

-- CATEGORY
-- 카테고리는 PRODUCT테이블의 PRODUCT_CODE의 앞 2자리이다.
-- 카테고리 출력
SELECT SUBSTR(TO_CHAR(P.PRODUCT_CODE), 1, 2) AS CATEGORY
    FROM PRODUCT P
    ORDER BY CATEGORY ASC
;

-- 카테고리 컬럼을 추가하여 카테고리 출력
SELECT R.CATEGORY
    FROM ( SELECT SUBSTR(TO_CHAR(P.PRODUCT_CODE), 1, 2)
                    AS CATEGORY
                FROM PRODUCT P
          ) R
    ORDER BY CATEGORY ASC
;

-- 카테고리 값 중복없이 출력
-- 중복제거1. DISTINCT
SELECT DISTINCT R.CATEGORY
    FROM ( SELECT SUBSTR(TO_CHAR(P.PRODUCT_CODE), 1, 2)
                    AS CATEGORY
                FROM PRODUCT P
          ) R
    ORDER BY CATEGORY ASC
;
-- 중복제거2. GROUP BY
-- 주의 : GROUP BY에서 그룹화한 컬럼은 꼭 SELECT의 컬럼과 같아야 조회 가능
SELECT R.CATEGORY
    FROM ( SELECT SUBSTR(TO_CHAR(P.PRODUCT_CODE), 1, 2)
                    AS CATEGORY
                FROM PRODUCT P
          ) R
    GROUP BY R.CATEGORY
    ORDER BY CATEGORY ASC
;

-- 상품개수 출력 → PRODUCTS
-- COUNT 사용 : 카테고리 앞 2자리가 같은 것끼리 개수 세야 함
-- 정답1_1. COUNT1_1> DISTINCT + PARTITION BY
/* 기본 구문
 SELECT DISTINCT T1.*
    FROM ( SELECT col1
                  , COUNT(*) OVER(PARTITION BY a.col1) AS col2
            FROM 원본테이블 a
          ) T1
    WHERE T1.col > n ;      
    -- T1테이블의 col1 개수가 n개 초과하여 중복하는 것을 조건으로 하겠다.
 
 PARTITION BY는 DISTINCT를 무시한다.
 따라서, 테이블에 DISTINCT가 걸려 있어도 이를 무시하고 원본을 대상으로 작업을 수행한다.
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
    WHERE R.PRODUCTS > 0        -- 생략해도 같은 결과 출력
    ORDER BY CATEGORY ASC
;

-- 정답1_2. COUNT1_2> DISTINCT + PARTITION BY
SELECT DISTINCT R.*
    FROM ( SELECT SUBSTR(TO_CHAR(P.PRODUCT_CODE), 1, 2)
                        AS CATEGORY
                  , COUNT(*) OVER
                            (PARTITION BY
                             SUBSTR(TO_CHAR(P.PRODUCT_CODE), 1, 2))
                        AS PRODUCTS
                FROM PRODUCT P
          ) R
    WHERE R.PRODUCTS > 0        -- 생략해도 같은 결과 출력
    ORDER BY CATEGORY ASC
;

-- 정답 3. COUNT2> GROUP BY + HAVING
SELECT R.CATEGORY
       , COUNT(*) AS PRODUCTS
    FROM ( SELECT SUBSTR(TO_CHAR(P.PRODUCT_CODE), 1, 2)
                    AS CATEGORY
                FROM PRODUCT P
          ) R
    GROUP BY R.CATEGORY
        HAVING COUNT(*) > 0     -- 생략해도 같은 결과 출력
    ORDER BY CATEGORY ASC
;


--=======================================
--=======================================

<조건별로 분류하여 주문상태 출력하기>
/* 0. 문제
FOOD_ORDER 테이블에서 5월 1일을 기준으로 
주문 ID, 제품 ID, 출고일자, 출고여부를 조회하는 SQL문을 작성해주세요.
출고여부는 5월 1일까지 출고완료로 
이 후 날짜는 출고 대기로 미정이면 출고미정으로 출력해주시고, 
결과는 주문 ID를 기준으로 오름차순 정렬해주세요.

1. 테이블
 : FOOD_ORDER

2. 테이블 속 컬럼명
 : ORDER_ID         -- 주문ID
    , PRODUCT_ID    -- 제품ID
    , AMOUNT        -- 주문양
    , PRODUCE_DATE  -- 생산일자
    , IN_DATE       -- 입고일자
    , OUT_DATE      -- 출고일자
    , FACTORY_ID    -- 공장ID
    , WAREHOUSE_ID  -- 창고ID
3. 출력할 컬럼
 : ORDER_ID
   , PRODUCT_ID
   , OUT_DATE
   , 출고여부
4. 조건
 -- 주문ID를 기준으로 오름차순 정렬
 ORDER BY ORDER_ID ASC;
 
 -- 5/1을 기준으로 함
 -- 출고여부 : 5/1까지 출고완료, 이후 날짜는 출고 대기로, 미정이면 출고미정으로 출력
SELECT
        CASE WHEN TO_CHAR(OUT_DATE, 'YYYY-MM-DD') <= '2022-05-01'
            THEN '출고완료'
        WHEN TO_CHAR(OUT_DATE, 'YYYY-MM-DD') > '2022-05-01'
            THEN '출고 대기'
        WHEN TO_CHAR(OUT_DATE, 'YYYY-MM-DD') IS NULL
            THEN '출고미정'
        END AS 출고여부
    FROM FOOD_ORDER F
    ORDER BY ORDER_ID ASC;
*/

-- 기본 구문
SELECT ORDER_ID
       , PRODUCT_ID
       , OUT_DATE
       , 출고여부       -- 정의 해야함
    FROM FOOD_ORDER
    ORDER BY ORDER_ID ASC;

-- 답안    
SELECT ORDER_ID
       , PRODUCT_ID
       , TO_CHAR(OUT_DATE, 'YYYY-MM-DD') AS OUT_DATE
       , CASE WHEN TO_CHAR(OUT_DATE, 'YYYY-MM-DD') <= '2022-05-01'
            THEN '출고완료'
        WHEN TO_CHAR(OUT_DATE, 'YYYY-MM-DD') > '2022-05-01'
            THEN '출고대기'
        WHEN TO_CHAR(OUT_DATE, 'YYYY-MM-DD') IS NULL
            THEN '출고미정'
        END AS 출고여부
    FROM FOOD_ORDER
    ORDER BY ORDER_ID ASC;

--=======================================
--=======================================
<자동차 평균 대여 기간 구하기>
/*
0. 문제
 : CAR_RENTAL_COMPANY_RENTAL_HISTORY 테이블에서
   평균 대여 기간이 7일 이상인 자동차들의
   자동차 ID와 평균 대여 기간(컬럼명: AVERAGE_DURATION)
   리스트를 출력하는 SQL문을 작성해주세요.
   평균 대여 기간은 소수점 두번째 자리에서 반올림하고, 
   결과는 평균 대여 기간을 기준으로 내림차순 정렬해주시고, 
   평균 대여 기간이 같으면 자동차 ID를 기준으로 내림차순 정렬해주세요.
   
1. 테이블
 : CAR_RENTAL_COMPANY_RENTAL_HISTORY
2. 사용 컬럼
 : HISTORY_ID       -- 자동차 대여 기록 ID
   , CAR_ID         -- 자동차 ID
   , START_DATE     -- 대여 시작일
   , END_DATE       -- 대여 종료일
3. 출력 컬럼
 : CAR_ID                       -- 평균 대여 기간이 7일 이상일 것
   , AVERAGE_DURATION           -- 평균 대여 기간
4. 조건
 - 평균 대여 기간이 7일 이상일 것
 - 평균 대여 기간 : 소수점 두번째 자리에서 반올림
    ROUND(평균대여기간, 2)
 - AVERAGE_DURATION 내림차순, CAR_ID 내림차순
    ORDER BY AVERAGE_DURATION DESC
   , ORDER BY CAR_ID DESC

-- CAR_ID 별로 평균 대여기록 구하기
-- 대여기록 출력
-- 대여기록 = TO_CHAR(END_DATE - START_DATE) +1
SELECT CAR_ID
        , TO_CHAR(END_DATE - START_DATE)
            AS RENTAL_DURATION
    FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
;

-- CAR_ID 중복없이 정렬
SELECT CAR_ID
    FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
    GROUP BY CAR_ID
    ORDER BY CAR_ID DESC
;

-- 평균 대여 기간 구하기
SELECT CAR_ID
        , ROUND( AVG(TO_CHAR(END_DATE - START_DATE) +1), 1 ) 
            AS AVERAGE_DURATION
    FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
    GROUP BY CAR_ID
    ORDER BY AVERAGE_DURATION DESC, CAR_ID DESC
;
*/

-- 답안
-- 평균 대여 기간 7일 이상의 목록 조회
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
<DATETIME에서 DATE로 형 변환>
/*
0. 문제
 : ANIMAL_INS 테이블에 등록된 모든 레코드에 대해, 
    각 동물의 아이디와 이름, 들어온 날짜를 조회하는 SQL문을 작성해주세요. 
    이때 결과는 아이디 순으로 조회해야 합니다.
1. 테이블
 : ANIMAL_INS
2. 사용 컬럼
 : ANIMAL_ID            -- 동물아이디
    , ANIMAL_TYPE       -- 생물 종
    , DATETIME          -- 보호 시작일
    , INTAKE_CONDITION  -- 보호 시작 시 상태
    , NAME              -- 이름
    , SEX_UPON_INTAKE   -- 성별 및 중성화 여부
3. 출력 컬럼
 : ANIMAL_ID
    , NAME
    , TO_CHAR(DATETIME, 'YYYY-MM-DD')
-- ANIMAL_ID순으로 조회
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

<중성화 여부 파악하기>
/*
0. 문제
 : 보호소의 동물이 중성화되었는지 아닌지 파악하려 합니다.
 중성화된 동물은 SEX_UPON_INTAKE 컬럼에
 'Neutered' 또는 'Spayed'라는 단어가 들어있습니다.
 동물의 아이디와 이름, 중성화 여부를 아이디 순으로 조회하는 SQL문을 작성해주세요.
 이때 중성화가 되어있다면 'O', 아니라면 'X'라고 표시해주세요.
1. 테이블
 : ANIMAL_INS 
2. 사용 컬럼
 : ANIMAL_ID            -- 동물아이디
    , ANIMAL_TYPE       -- 생물 종
    , DATETIME          -- 보호 시작일
    , INTAKE_CONDITION  -- 보호 시작 시 상태
    , NAME              -- 이름
    , SEX_UPON_INTAKE   -- 성별 및 중성화 여부
3. 출력 컬럼
 : ANIMAL_ID
    , NAME
    , 중성화   -- 정의
    
-- ANIMAL_ID 기준으로 정렬
 : ORDER BY ANIMAL_ID
 
-- CASE WHEN SEX_UPON_INTAKE IN ('Neutered', 'Spayed') THEN 'O'
        ELSE 'X'
        END AS 중성화
        
-- 답안
SELECT ANIMAL_ID
        , NAME
        , CASE WHEN SEX_UPON_INTAKE
                LIKE '%Neutered%' THEN 'O'
            WHEN SEX_UPON_INTAKE
                LIKE '%Spayed%' THEN 'O'
            ELSE 'X'
            END AS 중성화
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
            END AS 중성화
    FROM ANIMAL_INS
    ORDER BY ANIMAL_ID
;

--=======================================
--=======================================
<취소되지 않은 진료 예약 조회하기>
/*
0. 문제
 : PATIENT, DOCTOR 그리고 APPOINTMENT 테이블에서
   2022년 4월 13일 취소되지 않은 흉부외과(CS) 진료 예약 내역을 조회.
   진료예약번호, 환자이름, 환자번호, 진료과코드, 의사이름, 진료예약일시 항목이 출력.
   결과는 진료예약일시를 기준으로 오름차순 정렬해주세요.
[PATIENT P 테이블]
 : PT_NO            -- 환자번호
   , PT_NAME        -- 환자이름
   , GEND_CD        -- 성별코드
   , AGE            -- 나이
   , TLNO           -- 전화번호

*/
















