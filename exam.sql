-- Ch2. 연습문제
-- #1. 다음과 같은 구조의 테이블을 생성해보자
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

-- 제약조건 확인
SELECT constraint_name, constraint_type, table_name, search_condition
    FROM user_constraints
    WHERE table_name = 'ORDERS';
    
--==================================================================

-- #2. 다음과 같은 구조의 테이블을 생성해보자.
CREATE TABLE ORDER_ITEMS(
    order_id        NUMBER(12,0),
    line_item_id    NUMBER(3,0),
    product_id      NUMBER(3,0),
    unit_price      NUMBER(8,2) DEFAULT 0,
    quantity        NUMBER(8,0) DEFAULT 0,
        CONSTRAINTS pk_order_items PRIMARY KEY (order_id, line_item_id)
);

-- 제약조건 확인
SELECT constraint_name, constraint_type, table_name, search_condition
    FROM user_constraints
    WHERE table_name = 'ORDER_ITEMS';
    
--==================================================================

-- #3. 다음과 같은 구조의 테이블을 생성해보자.
CREATE TABLE promotions(
    promo_id NUMBER(6,0),
    promo_name VARCHAR2(20),
        CONSTRAINTS pk_promotions PRIMARY KEY(promo_id)
);

-- 제약조건 확인
SELECT constraint_name, constraint_type, table_name, search_condition
    FROM user_constraints
    WHERE table_name = 'PROMOTIONS';
    
--==================================================================

-- #4. FLOAT형은 괄호 안에 지정하는 수는 이진수 기준 자릿수라고 했다.
-- FLOAT(126)의 경우 126*0.30103 = 37.92978이 되어 NUMBER 타입의 38 자리와 같다.
-- 그런데 왜 0.30103을 곱하는지 설명해 보자.
-- 답변 : 이진수를 십진수로 변환하는 것이다. 10진수 기준으로 log(2)의 값이 바로 0.30103이다.
-- 즉, 10에다 0.30103 제곱을 하면 2가 나오는 것이다.

--==================================================================

-- #5. 최솟값 1, 최댓값 99999999, 1000부터 시작해서 1씩 증가하는 ORDERS_SEQ라는 시퀀스를 만들어 보자.
CREATE SEQUENCE order_seq
    INCREMENT BY 1
    START WITH 1000
    MINVALUE 1
    MAXVALUE 99999999
    NOCYCLE
    NOCACHE;
-- 데이터 삽입
INSERT INTO orders(order_id) VALUES(order_seq.NEXTVAL);
-- 현재 및 다음 순번 확인
SELECT order_seq.CURRVAL
    FROM DUAL;
SELECT order_seq.NEXTVAL
    FROM DUAL;
    
--==================================================================
--==================================================================
-- Ch3. 연습문제(122p)
-- #1. 'ex3_6' 테이블 생성
--     관리자 사번 : 124, 급여 : 2000 ~ 3000 사이인 사원의
--     사번, 사원명, 급여, 관리자 사번
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
-- #2. 다음 문장을 실행하라
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
 - manager_id = 145인 사원의 사번이 위 테이블에 있는 사원의 사번과 일치하면
   보너스(bonus_amt) = 급여의 0.01(1%) 갱신
   일치하지 않으면, 보너스 = 급여의 0.005(0.5%) 신규 입력
   
   테이블 : ex3_3, employees
   컬럼 : manager_id, employee_id, bonus_amt, salary
   manager_id = 145
   
   ex3_3.employee_id = employees.employee_id
   MATCHED ▶ bonus_amt = bonus_amt + salary * 0.01
   NOT MATCHED ▶ bonus_amt = bonus_amt + salary * 0.005
*/


-- ex3_3 테이블에 있는 사원 중 관리자 사번 145인 사원의 보너스 급여(1%)
SELECT employee_id, manager_id, salary, salary*0.01 AS bonus_amt
    FROM employees
    WHERE employee_id IN (SELECT employee_id FROM ex3_3)
        AND manager_id = 145
    ;

-- ex3_3 테이블에 없는 사원의 관리자 사번 145인 사원의 보너스 급여(0.5%)
SELECT employee_id, manager_id, salary, salary*0.005 AS bonus_amt
    FROM employees
    WHERE employee_id NOT IN (SELECT employee_id FROM EX3_3)
        AND manager_id = 145
    ;
    
-- MERGE 문으로 작성
MERGE INTO ex3_3 x
    USING (SELECT employee_id, salary
        -- 예제(104p)에서는 select하는 컬럼 내용에 manager_id도 있으나,
        -- SELECT employee_id, salary, manager_id
        -- 조건 자체가 'manager_id = 145' 이므로 굳이 추가하지 않아도 됨
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

-- #3. 사원 테이블에서 커미션 값이 없는 사원의 사번과 사원명을 추출하라.
-- 1) 추출하는 쿼리 작성 ▶ SELECT
-- 2) 테이블 : employees
--    컬럼 : commission_pct, employee_id, emp_name
--    조건 : commission_pct IS NULL

SELECT employee_id, emp_name
    FROM employees
    WHERE commission_pct IS NULL
;

--==================================================================

-- #4. 아래의 쿼리를 논리 연산자로 변환해보자.
SELECT employee_id, salary
    FROM employees
    WHERE salary BETWEEN 2000 AND 2500
    ORDER BY employee_id
;

-- 논리 연산자로 변환
SELECT employee_id, salary
    FROM employees
    WHERE salary >= 2000
        AND salary <= 2500
    ORDER BY employee_id
;

--==================================================================
--#5. 다음의 두 쿼리를 ANY, ALL을 사용해서 동일한 결과를 추출하도록 변경하라.
--      (비교조건식 ANY, ALL)
/*
컬럼명 (비교연산자) ANY(값1, 값2, 값3)
컬럼명 (비교연산자) ALL(값1, 값2, 값3)
*/

-- 쿼리 1
SELECT employee_id, salary              -- 사원번호, 급여조회
    FROM employees                      -- 사원 테이블로부터
    WHERE salary IN (2000, 3000, 4000)  -- 급여에 2000, 3000, 4000 값이 포함되면
    ORDER BY employee_id                -- 사원번호로 정렬
;

-- 쿼리 1 : ANY 사용
SELECT employee_id, salary
    FROM employees
    WHERE salary = ANY(2000, 3000, 4000)
    ORDER BY employee_id
;

-- 쿼리 1 : OR 사용
SELECT employee_id, salary
    FROM employees
    WHERE salary = 2000 OR salary = 3000 OR salary = 4000
;

-- 쿼리 2
SELECT employee_id, salary                  -- 사원번호, 급여조회
    FROM employees                          -- 사원 테이블로부터
    WHERE salary NOT IN (2000, 3000, 4000)  -- 급여에 2000, 3000, 4000 값이 포함 안되면
    ORDER BY employee_id                    -- 사원번호로 정렬
;

-- 쿼리 2 : ALL 사용
SELECT employee_id, salary
    FROM employees
    WHERE salary != ALL(2000, 3000, 4000)
    ORDER BY employee_id
;

-- 쿼리 2: AND 사용
SELECT employee_id, salary
    FROM employees
    WHERE salary != 2000 AND salary != 3000 AND salary != 4000
;

--==================================================================
--==================================================================
-- Ch4. 연습문제(150p)
-- #1. 전화번호의 처음 세 자리 숫자 대신 서울 지역 번호인 '(02)'를 붙여 전화번호를 출력
/*
1. 테이블
 : employees
2. 컬럼
 : phone_number
3. ###.###.#### → ###.#### → (02)###.####
*/

-- 방법1> 문자연산자 ||
-- '(02)' + || + SUBSTR(phone_number, 5, 12)
SELECT SUBSTR(phone_number, 5, 12)
    FROM employees;

SELECT employee_id, '(02)' || SUBSTR(phone_number, 5, 12) AS phone_number
    FROM employees;
    
-- 방법2> LPAD
SELECT phone_number
        , LPAD(SUBSTR(phone_number, 5, 12), 12, '(02)')
    FROM employees;

-- 방법3> CONCAT
-- 교수님 답안
SELECT employee_id
        , CONCAT('(02)', SUBSTR(phone_number, 5, 12))
    FROM employees;

SELECT employee_id
       , CONCAT('(02)', LTRIM(phone_number, SUBSTR(phone_number, 1, 3)))
    FROM employees;

-- 방법4>REPLACE
SELECT employee_id
       , REPLACE(phone_number, SUBSTR(phone_number, 1, 4), '(02)')
    FROM employees;
    
---- LTRIM
---- 앞 세자리 숫자 조회
--SELECT employee_id, SUBSTR(phone_number, 1, 3)
--    FROM employees;
---- 앞 세자리 숫자 제거
--SELECT employee_id
--        , LTRIM(phone_number, SUBSTR(phone_number, 1, 3)) AS phone_number
--    FROM employees;
---- 앞에 (02) 붙이기
---- SUBSTR(phone_number, 1, 4)로 하면 이상하게 나옴
---- LTRIM : 유사한 값을 지워주는 기능도 있어서 싹 지워버림. 따라서 이 문제에서는 부적절한 함수임.

--==================================================================

/*
[문제 #2]
 : 현재일자를 기준으로 사원 테이블의 입사일자(hire_date)를 참조해서
   근속년수가 10년 이상인 사원을 다음과 같은 형태의 결과를 출력하도록 쿼리를 작성하라.
   (근속년수가 높은 사원 순서대로 결과 출력)
1. 테이블
 : employees
 
2. 사용 컬럼
 : employee_id
   , hire_date
   
3. 출력할 컬럼
 : employee_id
   , emp_name
   , hire_date
   , service_years   -- 근속년수, 정의 필요

-- 근속년수가 높은 사원 순서대로 출력
ORDER BY service_years DESC;

*/

-- 근속년수 : ROUND((현재일자 - hire_date)/365)
--365일/365일 = 1년
--500일/365 = 1.xxx년 → 소수점 버림(FLOOR/TRUNC) / 올림(CEIL) / 반올림(ROUND)
--730일/365 = 2년

-- 근속년수 조회
SELECT ROUND((SYSDATE - hire_date)/365) AS 근속년수
    FROM employees
    WHERE TO_CHAR(SYSDATE - hire_date) >= 10
    ORDER BY 근속년수 DESC;

-- 답안
SELECT employee_id
        , emp_name
        , TO_CHAR(hire_date, 'YYYY-MM-DD') AS hire_date
        , ROUND((SYSDATE - hire_date)/365) AS 근속년수
    FROM employees
    WHERE TO_CHAR(SYSDATE - hire_date) >= 10
    ORDER BY 근속년수 DESC;

--==================================================================
/*
[문제 #3]
 : 고객테이블(CUSTOMERS)의 고객 전화번호(cust_main_phone_number)컬럼이 있다.
   이 컬럼 값은 '###-###-####' 형태인데,
   '-' 대신 '/'로 바꿔 출력하는 쿼리를 작성하라.
1. 테이블
 : CUSTOMERS
2. 사용할 컬럼
 : cust_main_phone_number
*/
SELECT cust_id, REPLACE(CUST_MAIN_PHONE_NUMBER, '-', '/')
        as new_phone_number
    FROM CUSTOMERS;

--==================================================================

/*
[문제 #4]
 : 고객 테이블(CUSTOMERS)의 고객 전화번호(CUST_MAIN_PHONE_NUMBER)컬럼을
   다른 문자로 대체(일종의 암호화)하도록 쿼리를 작성하라.
   0123456789 => hellothank
1. 테이블
 : CUSTOMERS
2. 사용할 컬럼
 : CUST_MAIN_PHONE_NUMBER
 
대체(일종의 암호화)        => TRANSLATE
쿼리를 작성               => SELECT? UPDATE?
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
[문제 #5]
 : 고객 테이블(CUSTOMERS)에는 고객의 출생년도(CUST_YEAR_OF_BIRTH)컬럼이 있다.
   현재일자 기준으로 이 컬럼을 활용해 30대, 40대, 50대를 구분해 출력하고,
   나머지 연령대는 '기타'로 출력하는 쿼리를 작성하라.
1. 테이블
 : CUSTOMERS
2. 사용할 컬럼
 : CUST_NAME, CUST_YEAR_OF_BIRTH
 
-- 나이 구하기
나이 = 현재일자 - CUST_YEAR_OF_BIRTH
cust_age = TRUNC(sysdate - CUST_YEAR_OF_BIRTH)
*/
-- 고객 나이
SELECT TRUNC((TO_CHAR(SYSDATE, 'YYYY') - CUST_YEAR_OF_BIRTH)/10) AS cust_age
    FROM CUSTOMERS;

-- 연령대 구분(DECODE)
-- DECODE는 논리연산자 사용 불가능
-- DECODE는 참/거짓만 판별하므로 '나이/10'한 후, 앞자리만으로 참/거짓 판별
--  ▶ ex) TRUNC(94살/10) = TRUNC(9.4) = 9
SELECT CUST_NAME
       , TO_CHAR(SYSDATE, 'YYYY')- CUST_YEAR_OF_BIRTH AS cust_age
       , DECODE( TRUNC((TO_CHAR(SYSDATE, 'YYYY') - CUST_YEAR_OF_BIRTH)/10 )
            , 3, '30대'
            , 4, '40대'
            , 5, '50대', '기타') AS generation
    FROM CUSTOMERS;

--==================================================================

/*
[문제 #6]
 : 문제#5의 연령대를 모든 연령대를 표시하도록 쿼리 작성
   CASE 표현식 사용
1. 테이블
 : CUSTOMERS
2. 사용할 컬럼
 : CUST_NAME, CUST_YEAR_OF_BIRTH
 
-- 나이 구하기
나이 = 현재일자 - CUST_YEAR_OF_BIRTH
나이 = TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY') - CUST_YEAR_OF_BIRTH)
*/

-- 방법1> BETWEEN AND 사용
SELECT CUST_NAME
        , TRUNC(TO_NUMBER(TO_CHAR(SYSDATE, 'YYYY')) - CUST_YEAR_OF_BIRTH) AS cust_age
        , CASE WHEN  TRUNC((TO_CHAR(SYSDATE, 'YYYY') - CUST_YEAR_OF_BIRTH))
                < 10
                    THEN '10대 미만'
            WHEN TRUNC((TO_CHAR(SYSDATE, 'YYYY') - CUST_YEAR_OF_BIRTH))
                BETWEEN 10 AND 19
                    THEN '10대'
            WHEN TRUNC((TO_CHAR(SYSDATE, 'YYYY') - CUST_YEAR_OF_BIRTH))
                BETWEEN 20 AND 29
                    THEN '20대'
            WHEN TRUNC((TO_CHAR(SYSDATE, 'YYYY') - CUST_YEAR_OF_BIRTH))
                BETWEEN 30 AND 39
                    THEN '30대'
            WHEN TRUNC((TO_CHAR(SYSDATE, 'YYYY') - CUST_YEAR_OF_BIRTH))
                BETWEEN 40 AND 49
                    THEN '40대'
            WHEN TRUNC((TO_CHAR(SYSDATE, 'YYYY') - CUST_YEAR_OF_BIRTH))
                BETWEEN 50 AND 59
                    THEN '50대'
            WHEN TRUNC((TO_CHAR(SYSDATE, 'YYYY') - CUST_YEAR_OF_BIRTH))
                >= 60
                    THEN '60대 이상'
            END AS generation
    FROM CUSTOMERS;

-- 방법2> = 사용
SELECT CUST_NAME
       , TO_CHAR(SYSDATE, 'YYYY')- CUST_YEAR_OF_BIRTH AS cust_age
       , CASE WHEN TRUNC((TO_CHAR(SYSDATE, 'YYYY') - CUST_YEAR_OF_BIRTH)/10) = 1
                THEN '10대'
            WHEN TRUNC((TO_CHAR(SYSDATE, 'YYYY') - CUST_YEAR_OF_BIRTH)/10) = 2
                THEN '20대'
            WHEN TRUNC((TO_CHAR(SYSDATE, 'YYYY') - CUST_YEAR_OF_BIRTH)/10) = 3
                THEN '30대'
            WHEN TRUNC((TO_CHAR(SYSDATE, 'YYYY') - CUST_YEAR_OF_BIRTH)/10) = 4
                THEN '40대'
            WHEN TRUNC((TO_CHAR(SYSDATE, 'YYYY') - CUST_YEAR_OF_BIRTH)/10) = 5
                THEN '50대'
            WHEN TRUNC((TO_CHAR(SYSDATE, 'YYYY') - CUST_YEAR_OF_BIRTH)/10) = 6
                THEN '60대'
            WHEN TRUNC((TO_CHAR(SYSDATE, 'YYYY') - CUST_YEAR_OF_BIRTH)/10) = 7
                THEN '70대'
            ELSE '기타'
            END AS generation
    FROM CUSTOMERS;

-- 방법3> LIKE 사용
SELECT CUST_NAME
       , TO_CHAR(SYSDATE, 'YYYY')- CUST_YEAR_OF_BIRTH AS cust_age
       , CASE WHEN TRUNC(TO_CHAR(SYSDATE, 'YYYY') - CUST_YEAR_OF_BIRTH)
                LIKE '1%' THEN '10대'
            WHEN TRUNC(TO_CHAR(SYSDATE, 'YYYY') - CUST_YEAR_OF_BIRTH)
                LIKE '2%' THEN '20대'
            WHEN TRUNC(TO_CHAR(SYSDATE, 'YYYY') - CUST_YEAR_OF_BIRTH)
                LIKE '3%' THEN '30대'
            WHEN TRUNC(TO_CHAR(SYSDATE, 'YYYY') - CUST_YEAR_OF_BIRTH)
                LIKE '4%' THEN '40대'
            WHEN TRUNC(TO_CHAR(SYSDATE, 'YYYY') - CUST_YEAR_OF_BIRTH)
                LIKE '5%' THEN '50대'
            WHEN TRUNC(TO_CHAR(SYSDATE, 'YYYY') - CUST_YEAR_OF_BIRTH)
                LIKE '6%' THEN '60대'
            WHEN TRUNC(TO_CHAR(SYSDATE, 'YYYY') - CUST_YEAR_OF_BIRTH)
                LIKE '7%' THEN '70대'
            ELSE '기타'
            END AS generation
    FROM CUSTOMERS;

--==================================================================
--==================================================================
-- Ch5. 연습문제(174p)
/*
[문제#1] 사원 테이블에서 입사년도별 사원 수를 구하는 쿼리를 작성하라
1. 테이블
 : employees
2. 사용 컬럼
 : hire_date
*/
SELECT TO_CHAR(hire_date, 'YYYY') AS hire_year, COUNT(employee_id) AS emp_cnt
    FROM employees
    GROUP BY TO_CHAR(hire_date, 'YYYY')
    ORDER BY TO_CHAR(hire_date, 'YYYY') DESC
;

--==================================================================
/*
[문제#2]
 : kor_loan_status 테이블에서 2012년도 월별, 지역별 대출 총 잔액을 구하는 쿼리를 작성하라.
1. 테이블
 : kor_loan_status
2. 사용 컬럼
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
[문제#3]
 : 다음 쿼리는 분할 ROLLUP을 적용한 쿼리다
   이 쿼리를 ROLLUP을 사용하지 않고, 집합 연산자로 동일한 결과가 나오도록 쿼리를 작성하라.
 
 period     gubun       totl_jan
 ----------------------------------
 201310     기타대출      676078
 201310     주택담보대출   411415.9
 201310     (null)       1087493.9
 201311     기타대출      681121.3
 201311     주택담보대출   414236.9
 201311     (null)       1095358.2
*/
SELECT period, gubun, SUM(loan_jan_amt) totl_jan
    FROM kor_loan_status
    WHERE period LIKE '2013%'
    GROUP BY period, ROLLUP(gubun);

-- 2013년 10월의 기타대출+주택담보대출
-- 2013년 11월의 기타대출+주택담보대출
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
[문제#4]
 : 다음 쿼리는 분할 ROLLUP을 적용한 쿼리다.
   이 쿼리를 ROLLUP을 사용하지 않고, 집합 연산자로 동일한 결과가 나오도록 쿼리를 작성하라.
   
period      주택담보        기타대출액
-------------------------------------
201311      0               681121.3
201311      414236.9        0
*/
SELECT period
        , CASE WHEN gubun = '주택담보대출'
                THEN SUM(loan_jan_amt) ELSE 0 END 주택담보대출액
        , CASE WHEN gubun = '기타대출'
                THEN SUM(loan_jan_amt) ELSE 0 END 기타대출액
    FROM kor_loan_status
    WHERE period = '201311'
    GROUP BY period, gubun
;

-- 답안
SELECT period, 0 AS 주택담보대출액, SUM(loan_jan_amt) AS 기타대출액
    FROM kor_loan_status
    WHERE period = '201311'
        AND gubun = '기타대출'
    GROUP BY period, gubun
UNION
SELECT period, SUM(loan_jan_amt) AS 주택담보대출액, 0 AS 기타대출액
    FROM kor_loan_status
    WHERE period = '201311'
        AND gubun = '주택담보대출'
    GROUP BY period, gubun
;

--==================================================================
/*
[문제#5]
 : 다음과 같은 형태, 즉 지역과 각 월별 대출 총 잔액을 구하는 쿼리를 작성하라.
 지역     201111  201112  201210  201211  201212  201310  201311
 ----------------------------------------------------------------
 서울
 부산
 ...
 ...
*/
-- 지역은 GROUP BY로 중복제거
SELECT region
    FROM kor_loan_status
    GROUP BY region
;

-- 월별로 행 만들어야 함
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

-- 내 답안>틀림(메인쿼리)
SELECT S.region 지역
        , SUM(loan_jan_amt) AS "201111"
    FROM kor_loan_status S
    GROUP BY S.region
    ORDER BY S.region
;

-- 지역, 월별 대출 총 잔액
-- 답안1> 서브쿼리 사용
-- 서브쿼리 안에 있는 데이터에 이미 필요한 내용이 전부 들어있으므로,
-- 원래 테이블은 사용하지 말아야 한다.
SELECT  region 지역
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

-- 답안2> 바로 SUM 사용
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
-- CH6. 연습문제(205p)
/*
[문제#1]
 : 101번 사원에 대해 아래의 결과를 산출하는 쿼리를 작성해 보자.
 사번     사원명     job명칭   job시작일자     job종료일자     job수행부서명
*/

[부서테이블 + 사원테이블 + 경력테이블 + 직업테이블]
[부서번호     부서번호]
             [사원번호    사원번호]
                         [직업번호    직업번호]

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
[문제#2]
 : 아래의 쿼리를 수행하면 오류가 발행한다. 오류의 원인은 무엇인지 설명해 보자.
*/
SELECT a.employee_id, a.emp_name, b.job_id, b.department_id
    FROM employees a
        , job_history b
    WHERE a.employee_id = b.employee_id(+)
        AND a.department_id(+) = b.department_id;

: 외부조인은 1개만 가능함

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
        
null이 없는 테이블과 외부조인이 되었음.

/*
[문제#3]
 : 외부 조인을 할 때 (+) 연산자를 IN 연산자와 같이 사용할 수 없는데,
   IN절에 사용하는 값이 한 개이면 사용할 수 있다.
   그 이유는 무엇인지 설명해 보자.
*/
<예시>
1. 외부조인을 IN과 함께 쓰는 경우,
SELECT e.employee_id, d.department_name
    FROM employees e, departments d
    WHERE d.department_id IN (e.department_id(+), 200)
;
2. 같은 의미의 코드
SELECT e.employee_id, d.department_name
    FROM employees e, departments d
    WHERE d.department_id = e.department_id(+)
        OR d.department_id = 200
        
3. IN절에 데이터를 1개만 넣는 경우, (정상)
SELECT e.employee_id, d.department_name
    FROM employees e, departments d
    WHERE d.department_id IN (e.department_id(+))
;

4. 3번과 같은 의미의 코드 (정상)
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

<IN절에 사용하는 값이 1개인 경우>
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
정답 : IN절에 사용하는 값이 1개인 경우
      의미상 OR을 사용한 것이 아니므로 외부조인 가능
      
-- 외부 조인시 (+) 기호를 어떤 컬럼에 붙여야 할까
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
[문제#4]
 : 다음의 쿼리를 ANSI 문법으로 변경해 보자.

*/
SELECT a.department_id, a.department_name
    FROM departments a, employees b
    WHERE a.department_id = b.department_id
        AND b.salary > 3000
    ORDER BY a.department_name
;

-- ANSI 문법, 내부(동등) 조인
SELECT d.department_id, d.department_name
    FROM departments d
    INNER JOIN employees e
    ON (d.department_id = e.department_id)  -- 조인조건
    WHERE e.salary > 3000
    ORDER BY d.department_name
;


/*
[문제#5]
 : 다음은 연관성 있는 서브 쿼리다. 이를 연관성 없는 서브 쿼리로 변환해보자.

EXISTS 연산자를 사용한 세미조인    => 연관성 있다(조인조건 有)
IN 연산자를 사용한 세미조인        => 연관성 없다(조인조건 無)
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
[문제#6]
 : 연도별 이탈리아 최대매출액과 사원을 작성하는 쿼리를 학습했다.
   이 쿼리를 기준으로 최대매출액 뿐만 아니라
   최소매출액과 해당 사원을 조회하는 쿼리를 작성해 보자.
*/
-- 2000년 이탈리아 평균 매출액(연평균)보다 큰 매출액을 달성한 월의 평균 매출액을 조회
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

-- 연도별 이탈리아 최대매출액, 사원, 최소매출액, 해당사원 조회
-- 테이블 : sales s, countries c, customers cu

--==================================================================
-- CH8. 연습문제(272p)

/*
[#문제1]
 : 구구단 중 3단을 출력하는 익명 블록을 만들어 보자.
*/

-- loop문 3*i
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

-- loop문 dan*i
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

-- for 문
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

-- while 문
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
-- 교수님 답안
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
[#문제2]
 : 사원 테이블에서 201번 사원의 이름과 이메일 주소를 출력하는 익명 블록을 만들어 보자.
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
