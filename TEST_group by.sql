--=======================================
--=======================================
<가격대 별 상품 개수 구하기>
/*
0. 문제
 : PRODUCT 테이블에서 만원 단위의 가격대 별로 상품 개수를 출력
   각각 컬럼명은 PRICE_GROUP, PRODUCTS로 지정
   가격대 정보는 각 구간의 최소금액
   (10,000원 이상 ~ 20,000 미만인 구간인 경우 10,000)으로 표시
 - 결과는 가격대를 기준으로 오름차순 정렬
 - 상품 별로 중복되지 않는 8자리 상품코드 값을 가지며,
   앞 2자리는 카테고리 코드를 나타냅니다.
1. 테이블
 : PRODUCT 
2. 사용 컬럼
 : PRODUCT_ID           -- 상품ID
    , PRODUCT_CODE      -- 상품코드
    , PRICE             -- 판매가
3. 출력 컬럼
 : PRICE_GROUP      -- 상품 가격대
    , PRODUCTS      -- 가격대별 상품 개수



-- MIN(가격), MAX(가격)
-- MIN : 15,000원, MAX : 85,000원
SELECT MIN(PRICE), MAX(PRICE)
    FROM PRODUCT P
;
    
-- 몇만원인지 표시
SELECT PRICE, TRUNC(PRICE/10000)
    FROM PRODUCT P
;

-- 가격대별로 그룹을 나눠야 함
-- 방법> DECODE
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

-- 가격 : 중복 제거
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

-- 가격대별 COUNT
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

-- 다른 방법
SELECT  TRUNC(PRICE, -4) AS PRICE_GROUP, COUNT(PRODUCT_ID) PRODUCTS
    FROM    PRODUCT
    GROUP BY TRUNC(PRICE, -4)
    ORDER BY TRUNC(PRICE, -4)
;

--=======================================
--=======================================
<자동차 종류 별 특정 옵션이 포함된 자동차 수 구하기>
/*
0. 문제
 : CAR_RENTAL_COMPANY_CAR 테이블에서
  '통풍시트', '열선시트', '가죽시트' 중 하나 이상의 옵션이 포함된 자동차가 
  자동차 종류 별로 몇 대인지 출력하는 SQL문을 작성해주세요. 
  이때 자동차 수에 대한 컬럼명은 CARS로 지정하고, 
  결과는 자동차 종류를 기준으로 오름차순 정렬해주세요.
1. 테이블
 : CAR_RENTAL_COMPANY_CAR
2. 사용 컬럼
 : CAR_ID       -- 자동차 id
    , CAR_TYPE  -- 자동차 종류
    , DAILY_FEE -- 일일 대여요금(원)
    , OPTIONS   -- 자동차 옵션 리스트
3. 출력 컬럼
 : CAR_TYPE     -- 자동차 종류
    , CARS      -- 자동차 수

-- 자동차 옵션 포함된 자동차 종류 조회
SELECT CAR_TYPE
    FROM CAR_RENTAL_COMPANY_CAR
    WHERE OPTIONS LIKE '%통풍시트%' 
        OR OPTIONS LIKE '%열선시트%'
        OR OPTIONS LIKE '%가죽시트%'
    ORDER BY CAR_TYPE ASC
;

*/


-- 답안
-- 자동차 종류 중복 제거 + COUNT
SELECT CAR_TYPE, COUNT(*) AS  CARS
    FROM CAR_RENTAL_COMPANY_CAR
    WHERE OPTIONS LIKE '%통풍시트%' 
        OR OPTIONS LIKE '%열선시트%'
        OR OPTIONS LIKE '%가죽시트%'
    GROUP BY CAR_TYPE
    ORDER BY CAR_TYPE ASC
;

--=======================================
--=======================================
<진료과별 총 예약 횟수 출력하기>
/*
0. 문제
 : APPOINTMENT 테이블에서 2022년 5월에 예약한 환자 수를 
   진료과코드 별로 조회하는 SQL문을 작성해주세요. 
   이때, 컬럼명은 '진료과 코드', '5월예약건수'로 지정해주시고 
   결과는 진료과별 예약한 환자 수를 기준으로 오름차순 정렬하고, 
   예약한 환자 수가 같다면 진료과 코드를 기준으로 오름차순 정렬해주세요.
1. 테이블
 : APPOINTMENT 
2. 사용 컬럼
 : APNT_YMD         -- 진료예약일시
    , APNT_NO       -- 진료예약번호
    , PT_NO         -- 환자번호
    , MCDP_CD       -- 진료과코드
    , MDDR_ID       -- 의사ID
    , APNT_CNCL_YN  -- 예약취소여부
    , APNT_CNCL_YMD -- 예약취소날짜
3. 출력 컬럼
 : 진료과 코드
    , 5월예약건수
    
-- 진료과별 예약한 환자수 오름차순, 진료과 코드 오름차순
 : ORDER BY 
*/

-- 2022년 5월에 예약한 진료과코드 조회
SELECT MCDP_CD, COUNT(PT_NO)
    FROM APPOINTMENT
    WHERE TO_CHAR(APNT_YMD, 'YYYY-MM') = '2022-05'
    GROUP BY COUNT(PT_NO)
    ORDER BY COUNT(PT_NO), MCDP_CD
;

--=======================================
--=======================================
<즐겨찾기가 가장 많은 식당 정보 출력하기>
/*
0. 문제
 : REST_INFO 테이블에서 음식종류별로 즐겨찾기수가 가장 많은 식당의 
   음식 종류, ID, 식당 이름, 즐겨찾기수를 조회하는 SQL문을 작성해주세요. 
   이때 결과는 음식 종류를 기준으로 내림차순 정렬해주세요.
1. 테이블
 : REST_INFO 
2. 사용 컬럼
 : REST_ID      -- 식당 ID
  , REST_NAME   -- 식당 이름
  , FOOD_TYPE   -- 음식 종류
  , VIEWS       -- 조회수
  , FAVORITES   -- 즐겨찾기수
  , PARKING_LOT -- 주차장 유무
  , ADDRESS     -- 주소
  , TEL         -- 전화번호
3. 출력 컬럼
 : FOOD_TYPE
    , REST_ID
    , REST_NAME
    , FAVORITES
*/

-- 음식 종류, ID, 식당 이름, 즐겨찾기수
SELECT FOOD_TYPE, REST_ID, REST_NAME, FAVORITES
    FROM REST_INFO
    ORDER BY FOOD_TYPE DESC
;


-- 음식 종류 별로 MAX(즐겨찾기수)
SELECT FOOD_TYPE, MAX(FAVORITES) AS FAVORITES
    FROM REST_INFO
    GROUP BY FOOD_TYPE
    ORDER BY FOOD_TYPE DESC
;

-- 답안
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
<조건에 맞는 사용자와 총 거래금액 조회하기>
/*
0. 문제
 : USED_GOODS_BOARD와 USED_GOODS_USER 테이블에서 
   완료된 중고 거래의 총금액이 70만 원 이상인 사람의 
   회원 ID, 닉네임, 총거래금액을 조회하는 SQL문을 작성해주세요.
   결과는 총거래금액을 기준으로 오름차순 정렬해주세요.
1. 테이블1
 : USED_GOODS_BOARD B
1_2. 사용컬럼_테이블1
 : BOARD_ID         -- 게시글id
    , WRITER_ID     -- 작성자id
    , TITLE         -- 게시글 제목
    , CONTENTS      -- 게시글 내용
    , PRICE         -- 가격
    , CREATED_DATE  -- 작성일
    , STATUS        -- 거래상태
    , VIEWS         -- 조회수
2. 테이블2
 : USED_GOODS_USER U
2_2. 사용컬럼_테이블2
 : USER_ID              -- 회원 ID
    , NICKNAME          -- 닉네임
    , CITY              -- 시
    , STREET_ADDRESS1   -- 도로명 주소
    , STREET_ADDRESS2   -- 상세 주소
    , TLNO              -- 전화번호
3. 출력 컬럼
 : USER_ID U
    , NICKNAME
    , 총거래금액
    
-- 총거래금액을 기준으로 오름차순 정렬
 : ORDER BY 총거래금액

-- 완료된 중고 거래의 데이터 출력
SELECT *
    FROM USED_GOODS_BOARD B
    WHERE B.STATUS = 'DONE'
;

-- 거래완료된 목록의 B.작성자ID, B.가격, U.닉네임 조회
SELECT B.WRITER_ID, B.PRICE, U.NICKNAME
    FROM USED_GOODS_BOARD B
        , USED_GOODS_USER U
    WHERE B.WRITER_ID = U.USER_ID
        AND B.STATUS = 'DONE'
    GROUP BY B.WRITER_ID
    ORDER BY PRICE
;

-- 거래완료된 목록의 B.작성자ID, U.닉네임, B.동일 작성자의 총 판매가격 조회
SELECT B.WRITER_ID, U.NICKNAME, SUM(B.PRICE) TOTAL_PRICE
    FROM USED_GOODS_BOARD B
        , USED_GOODS_USER U
    WHERE B.WRITER_ID = U.USER_ID
        AND B.STATUS = 'DONE'
    GROUP BY B.WRITER_ID, U.NICKNAME
    ORDER BY TOTAL_PRICE
;
*/

-- 답안> 동등조건 사용
SELECT B.WRITER_ID, U.NICKNAME, SUM(B.PRICE) AS TOTAL_PRICE
    FROM USED_GOODS_BOARD B
        , USED_GOODS_USER U
    WHERE B.WRITER_ID = U.USER_ID
        AND B.STATUS = 'DONE'
    GROUP BY B.WRITER_ID, U.NICKNAME
    HAVING SUM(B.PRICE) >= 700000
    ORDER BY TOTAL_PRICE
;







