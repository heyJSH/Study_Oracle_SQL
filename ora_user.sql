
/*
<SQL DEVELOPER - 오라클 실습 내용>
[SQL Developer 새파일 생성]
 파일 - 새로 만들기 - 데이터베이스 파일 - 파일명 : 'ora_user.sql' - 디렉토리 설정: 찾기 쉽도록(D:\work)

// 주석은 '--', 여러줄 주석처리는 'Ctrl + /'
-- 테이블 생성
    CREATE TABLE 테이블명(
        컬럼명 컬럼데이터타입 제약조건,
        컬럼명 컬럼데이터타입 제약조건,
        컬럼명 컬럼데이터타입 제약조건,
        컬럼명 컬럼데이터타입 제약조건
    );
    
-- 테이블 삭제
    DROP TABLE 테이블명;

-- 테이블생성 및 삭제 연습
    CREATE TABLE pracitce_1(
        name varchar2(3),
        age number
    );
    
    DROP TABLE pracitce_1;

-- Insert문_기본 구문
    Insert into 테이블명(컬럼1, 컬럼2, ...)
    Values('컬럼값1', '컬럼값2', ...);

-- Select문_기본 구문
    Select * (혹은 컬럼)           //  *은 All을 의미
    From 테이블명 (혹은 뷰명)       // 선택할 테이블 or 뷰
    Where 조건                    // 선택 조건, 여러 조건 기술 시에는 AND, OR로 연결
    Order by 컬럼;                // 조회 데이터 정렬 시, 정렬하고자 하는 컬럼명 기술
*/


-- 문자 데이터 타입1_(52p), 'ex2_1'
// Table 생성
CREATE TABLE ex2_1(
    column1 char(10),
    column2 varchar2(10),
    column3 nvarchar2(10),
    column4 number
);

// 데이터 삽입
Insert into ex2_1 (column1, column2)
Values('abc', 'abc');

// 데이터 조회(모든것)
// null : 데이터가 없음을 의미
/*
    Select *
    From ex2_1;
*/

// 데이터 조회(선택한 컬럼 및 데이터 크기)
Select column1, length(column1) as len1, //column1은 고정크기(10)
       column2, length(column2) as len2  //column2는 가변크기(10->3)
    From ex2_1;

//==================================================================


-- 문자 데이터 타입2_(53p), 'ex2_2'
// Table 생성
Create table ex2_2(
    column1 varchar2(3),
    column2 varchar2(3 byte),
    column3 varchar2(3 char)
);

// 데이터 입력(영어)
Insert into ex2_2 Values('abc', 'abc', 'abc');

Select column1, Length(column1) As len1,
       column2, Length(column2) As len2,
       column3, Length(column3) As len3
    From ex2_2;

// 데이터 입력(한글)
//Insert into ex2_2 Values('홍길동', '홍길동', '홍길동');
    //'홍길동' = 9byte이므로 컬럼3만 가능
    //컬럼1 = 3byte, 컬럼2 = 3byte, 컬럼3 = 3char(고정길이 문자)

Insert into ex2_2(column3) Values('홍길동');

Select column3, Length(column3) As len3, LengthB(column3) As bytelen
    From ex2_2;
    //Length : 컬럼 길이를 반환(결과값), LengthB : 해당 컬럼의 byte 수를 반환


//==================================================================


-- 숫자 데이터 타입(55p)
// Table 생성
Create Table ex2_3(
    COL_INT Integer,
    COL_DEC Decimal,
    COL_NUM Number
    --Integer : 정수, Decimal : 10진수(오라클에선 둘 다 Number에 해당함)
);

// 조회
Select column_id, column_name, data_type, data_length
    From user_tab_cols
    --사용자 계정 생성하면서 자동으로 만들어진 정보를 저장하는 곳 : 'user_tab_cols'
    Where table_name = 'EX2_3'  --여러 테이블 중, 'ex2_3'를 조건으로 설정
    Order by column_id;         --데이터 순서 정렬


//==================================================================


-- 날짜 데이터 타입(교재58p)
Create Table ex2_5(
    COL_DATE DATE,
    COL_TIMESTAMP TIMESTAMP
); 

Insert into ex2_5 Values (SYSDATE, SYSTIMESTAMP);
    --sysdate는 자주 사용하므로 기억할 것
Select *
    From ex2_5;
    

//==================================================================

-- 제약조건 구문
    /* 컬럼명  데이터타입  Primary Key 혹은
    Constraints  제약조건명 Primary Key  (컬럼명, ...) */

-- 제약조건_Not Null(60p), 'ex2_6'
/*
Create Table ex2_6(
    col_null      Varchar2(10),
    col_not_null  Varchar2(10)  Not Null
);

//Insert Into ex2_6 Values ('AA', '');
// 'col_not_null' 자리에 빈칸으로 둘 수 없으므로 오류

Insert Into ex2_6 Values ('AA', 'BB');
*/

// 예외) Not Null 제약조건은 컬럼 레벨에서만 정의 가능
// (Constraints 제약조건명 Not Null(컬럼명) : 불가능
Create Table ex2_6(
    col_null      Varchar2(10),
    col_not_null  Varchar2(10),
    Constraints unique_1 Unique (col_not_null)
);

//==================================================================

-- 제약조건 Unique(61p), 'ex2_7'
Create Table ex2_7(
    col_unique_Null  Varchar2(10) Unique,
    col_unique_NNull Varchar2(10) Unique Not Null, 
    col_nuique       Varchar2(10),
        Constraints unique_nm1 Unique(col_nuique)
);

Insert into ex2_7 Values ('AA', 'AA', 'AA');
Insert into ex2_7 Values ('', 'BB', 'BB');
Insert into ex2_7 Values ('', 'CC', 'CC');

// 제약조건 적용여부 확인
Select constraint_name, constraint_type, table_name, search_condition
    From   user_constraints --사용자의 제약조건을 담고 있는 시스템의 테이블
    Where  table_name = 'EX2_7';

//==================================================================

-- 제약조건 Primary Key, 기본키(63p)
-- Primary Key = Not Null + Unique
Create Table ex2_8(
    col1 varchar2(10) Primary Key,
    col2 varchar2(10)
);

Select constraint_name, constraint_type, table_name, search_condition
    From user_constraints
    Where table_name = 'EX2_8';


Insert into ex2_8
    Values('', 'AA'); --Primary Key 제약조건 때문에 불가능
    
Insert into ex2_8
    Values('AA', 'AA');

Insert into ex2_8
    Values('AA', 'AA'); --Primary Key 제약조건 때문에 불가능


//==================================================================

-- 제약조건 Check(66p)
Create Table ex2_9(
    num1 Number
        Constraints check1
            Check (num1 Between 1 AND 9),
    gender Varchar2(10)
        Constraints check2
            Check (gender IN ('MALE', 'FEMALE'))
);

-- 연습) 테이블 user_constraints를 사용하여 EX2_9의 제약조건을 조회하라.
Select constraint_name, constraint_type, table_name, search_condition
    From user_constraints
    Where table_name = 'EX2_9';

Insert into ex2_9 Values (10, 'MALE'); -- 10 : 제약조건에 위배됨
Insert into ex2_9 Values (9, 'MAN'); -- MAN : 제약조건에 위배됨
    
Insert into ex2_9
    Values (9, 'MALE'); -- 가능
Insert into ex2_9
    Values (1, 'FEMALE'); -- 가능

//==================================================================

-- Default(67p)
-- 컬럼속성 : 제약조건은 아니지만 컬럼의 티폴트 값을 명시하는데 사용
Create Table ex2_10(
    col1 Varchar2(10) Not Null,
    col2 Varchar2(10) Null,
    Create_date Date Default sysdate
);

Insert into ex2_10 Values ('AA', 'AA', '2023/11/01');
Insert into ex2_10(col1, col2) Values ('BB', 'BB');
Insert into ex2_10(col1, col2) Values ('CC', 'CC');
    -- 입력할 컬럼 위치와 값을 입력
    
Select * From ex2_10;

//==================================================================

-- 테이블 변경
/*
-- 컬럼명 변경 :
    Alter Table 테이블명 Rename Column 변경전_컬럼명 TO 변경후_컬럼명;
-- 컬럼 데이터타입 변경 :
    Alter Table 테이블명 Modify 컬럼명 데이터타입;
-- 컬럼 추가 :
    Alter Table 테이블명 ADD 컬럼명 데이터타입;
-- 컬럼 제거 :
    Alter Table 테이블명 Drop 컬럼명;
-- 제약조건(기본키) 추가 :
    Alter Table 테이블명 Add Constraints 제약조건명
        Primary Key (컬럼명, ...);
-- 제약조건 삭제 :
    Alter Table 테이블명 Drop Constraints 제약조건명;
*/

//==================================================================

-- 컬럼명 변경
Alter Table ex2_10 Rename Column col1 TO col11;
DESC ex2_10;    -- 테이블 컬럼 내역 확인
    
-- 컬럼 데이터타입 변경
Alter Table ex2_10 Modify col2 Varchar2(30);
DESC ex2_10;

-- 컬럼 추가
Alter Table ex2_10 ADD col3 Number;
DESC ex2_10;

-- 컬럼 삭제
Alter Table ex2_10 Drop Column col3;
DESC ex2_10;

-- 제약조건 추가
Alter Table ex2_10 ADD Constraints pk_ex2_10 Primary Key(col11);
DESC ex2_10;
Select constraint_name, constraint_type, table_name, search_condition
    From user_constraints
    Where table_name = 'EX2_10';

-- 제약조건 삭제
Alter Table ex2_10 Drop Constraints pk_ex2_10;
DESC ex2_10;
Select constraint_name, constraint_type, table_name, search_condition
    From user_constraints
    Where table_name = 'EX2_10';

//==================================================================
-- 테이블 복사
    /* 테이블 복사_구문
    Create Table 테이블명 AS
        Select 컬럼1, 컬럼2, ...
        From 복사할 테이블명;
    */
Select *
From ex2_9;
    -- 'ex2_9' 테이블 조회

Create Table ex2_9_1 AS
    Select *
    From ex2_9;
        -- 'ex2_9' 테이블 복사
    
Select *
    From ex2_9_1;
        -- 복사된 'ex2_9_1' 테이블 조회

//==================================================================

-- 혼자 연습
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

-- 뷰
-- : 뷰는 1개 이상의 테이블 or 다른 뷰의 테이터를 보도록 하는 데이터베이스 객체
    /*
    -- 뷰_구문
    Create OR Replace View 뷰명 AS
        Select 문장;
    */
    
Create OR Replace View emp_dept_v0 AS
    Select employee_id, emp_name
    From employees;

Select department_id
    From departments;

Select e.employee_id, e.emp_name, e.department_id, d.department_name
    From employees e, departments d
    Where e.department_id = d.department_id;
    -- 사용할 때마다 이 SQL을 작성하기 번거로우므로 필요한 정보가 있는 뷰를 생성하여 참조하면 편리함

//==================================================================

Create OR Replace View emp_dept_v1 AS
    Select e.employee_id, e.emp_name, e.department_id, d.department_name
    From employees e, departments d
    Where e.department_id = d.department_id; -- 뷰 생성
    
Select *
    From emp_dept_v1;  -- 뷰 조회

//==================================================================

/*
[인덱스] : 실무에서 쓸 일이 적음
 - 데이터가 10만개 이상(데이터 내용 파악 필수) 있으면 그때부터 인덱스 사용 고려하기
 - 테이블에 있는 데이터를 빨리 찾기 위한 용도의 데이터베이스 객체
 - 책의 맨 뒤에 있는 "찾아보기"와 유사
 - 별도의 저장공간에 인덱스로 지정된 컬럼 값과 저장된 컬럼(블록)의 주소 값이 저장됨
 - 구성과 컬럼 개수에 따른 분류 : 단일 인덱스와 결합 인덱스(2개 이상 컬럼 조합)
 - 유일성 여부에 따른 분류 : UNIQUE 인덱스, NON-UNIQUE 인덱스
   UNIQUE 인덱스 : 중복 없는 데이터의 인덱스
   NON-UNIQUE 인덱스 : 중복 있는 데이터의 인덱스
 - 인덱스 내부구조에 따른 분류 : B-tree 인덱스, 비트맵 인덱스
 
[B-tree 인덱스]
 - 정렬한 순서가 중간 쯤 되는 데이터를 뿌리에 해당하는 ROOT 블록으로 지정
   (한 번에 찾을 수 없어서 여러번 나눠서 찾는 느낌)
 - ROOT 블록을 기준으로 가지가 되는 BRANCH블록을 정의
 - 마지막으로 잎에 해당하는 LEAF 블록에
   인덱스의 키가 되는 데이터와 데이터의 물리적 주소 정보인 ROWID 를 저장
 - 전제조건 : 데이터가 정렬된 상태로 유지
 
[비트맵 인덱스]
 - 루트 블록과 브랜치 블록 구성은 동일.
 - 리프 블록의 경우, 비트 단위로 맵핑 테이블을 만들어 해당 속성 값에 속하면 '1',
                   속하지 않으면 '0'으로 비트맵을 구성

[인덱스 생성]
 - 구문 생성
   CREATE[UNIQUE] INDEX 인덱스명
   ON 테이블명 (컬럼1, 컬럼2, ...);
   
 - 구문 삭제
   DROP INDEX 인덱스명;
   
 - 인덱스 생성시 고려사항
   : 인덱스 컬럼 데이터의 분포가 테이블 전체 로우 수의 15%이하 시 인덱스 사용이 적절
   : 테이블 건수가 적다면 굳이 인덱스를 만들 필요 없음(테이블 전체 스캔이 더 빠를 수 있음)
   : 결합 인덱스(2개 이상 컬럼을 합쳐서 만든) 생성 시 인덱스에 포함되는 컬럼 순서가 중요
   : 테이블에 인덱스를 너무 많이 만들면 역으로 부하 발생
     (INSERT, DELETE, UPDATE 시에 인덱스 수정에 따른 성능 저하)
*/

-- 인덱스
 -- 인덱스 생성 전의 데이터 조회
SELECT *
    FROM ex2_10
    WHERE col11 = 'CC';

 -- 인덱스 생성
CREATE UNIQUE INDEX ex2_10_ix01
    ON ex2_10 (col11);

 -- 인덱스 생성 확인
  -- 인덱스 생성 전에 데이터 조회하면 시간이 좀 더 걸리고,
  -- 인덱스 생성 후에 데이터 조회하면 시간이 덜 걸림
SELECT index_name, index_type, table_name, uniqueness
    FROM user_indexes
    WHERE table_name = 'EX2_10';

 -- 인덱스 생성 후, 데이터 조회
SELECT *
    FROM ex2_10
    WHERE col11 = 'CC';
    
 -- 인덱스 삭제
DROP INDEX ex2_10_ix01;

--===========================================================
-- 테이블 복사(데이터 많은 테이블로 인덱스 실습)
CREATE TABLE customers_cp AS
    SELECT *
    FROM CUSTOMERS;
-- 테이블 복사 확인
SELECT *
    FROM customers_cp;

-- 테이블 내용 조회 : 고객id '8810'
-- 인덱스 없음, (16행, 0.009초)
SELECT *
    FROM   customers_cp
    WHERE cust_id = 8810;
    
-- NON-UNIQUE 인덱스 생성
CREATE INDEX customers_cp_ix01
    ON customers_cp (cust_id);

-- UNIQUE 인덱스 생성
CREATE UNIQUE INDEX customers_cp_ix02
    ON customers_cp (cust_id);

-- 인덱스 생성 확인
SELECT index_name, index_type, table_name, uniqueness
    FROM user_indexes
    WHERE table_name = 'CUSTOMERS_CP';

-- 테이블 내용 조회 : 고객id '8810'
-- 인덱스 있음
-- UNUNIQUE(1행, 0.004초)
-- UNIQUE  (1행, 0.004초)
SELECT *
    FROM customers_cp
    WHERE cust_id = 8810;
    
-- 인덱스 삭제
DROP INDEX customers_cp_ix01;
DROP INDEX customers_cp_ix02;

//==================================================================

/*
[시노님] : 실무에서 쓸 일이 적음
 - 데이터베이스 객체에 대한 별칭, 동의어
 - PUBLIC 시노님 : 모든 사용자 접근, 사용
 - PRIVATE 시노님 : 특정 사용자만 접근, 사용
 
[시노님 생성]
-- 구문
    CREATE OR REPLACE [PUBLIC] SYNONYM 시노님명
        FOR 객체명;
 - PUBLIC 생략 시, PRIVATE 시노님이 생성됨
 - 시노님 접근 권한 부여
    GRANT SELECT ON 시노님명 TO PUBLIC; 혹은
    GRANT SELECT ON 시노님명 TO 사용자;
*/

-- 시노님 (80P)
-- 시노님 생성
CREATE OR REPLACE SYNONYM syn_channel
    FOR channels;

-- 행 개수 확인
SELECT COUNT(*) FROM channels;
SELECT COUNT(*) FROM syn_channel;

-- 시노님 삭제
DROP SYNONYM syn_channel;

//==================================================================

/*
★★★[시퀀스]★★★
 - 자동으로 순번을 반환하는 객체
 
[시퀀스 생성]
-- 구문
CREATE SEQUENCE 시퀀스명
INCREMENT BY 증감숫자
START WITH 시작숫자
NOMINVALUE | MINVALUE 최소값
NOMAXVALUE | MAXVALUE 최대값
NOCYCLE | CYCLE
NOCACHE | CACHE;

-- 참조
INCREMENT BY 증감숫자 : (증감숫자는 0이 아닌 정수. 양수면 증가, 음수면 감소, 디폴트는 1)
NOCACHE : (디폴트로 메모리에 시퀀스 값을 미리 할당해 놓지 않으며 디폴트 값은 20)
CACHE : (메모리에 시퀀스 값을 미리 할당해 놓음)

[시퀀스 사용]
 - 시퀀스의 현재 (순번)값 : 시퀀스명.CURRVAL
 - 시퀀스의 다음 (순번)값 : 시퀀스명.NEXTVAL
 
[시퀀스 삭제]
 -- 구문
 DROP SEQUENCE 시퀀스명;
*/

--Create Table ex2_8(
--    col1 varchar2(10) Primary Key,
--    col2 varchar2(10)
--);

-- 시퀀스 삭제
DROP SEQUENCE my_seq1;
-- 시퀀스 생성(84p)
CREATE SEQUENCE my_seq1
    INCREMENT BY 2
    START WITH 3
    MINVALUE 1  -- CYCLE이 있으므로, 여러번 눌러서 20 초과하여 다시 돌아간다면 그 숫자는 1
    MAXVALUE 20
    CYCLE
    NOCACHE;

-- 기존 데이터 삭제, 'ex2_8'
DELETE ex2_8;
-- 값 입력 전, 컬럼의 데이터타입 확인(어떤 데이터를 입력할 수 있는지 확인)
DESC ex2_8;
-- 데이터 삽입
INSERT INTO ex2_8(col1) VALUES(my_seq1.NEXTVAL);
    -- col1의 'PRIMARY KEY' 때문에 무한루프 불가능
    -- 게시물 번호는 중복이 없어야 하므로, 그 경우에는 기본키 설정하면 됨
-- 데이터 조회
SELECT *
    FROM ex2_8;

-- my_seq1.CURRVAL      -- 현재 순번 확인
-- my_seq1.NEXTVAL      -- 다음 순번 확인

-- DUAL : 임시 테이블
SELECT my_seq1.CURRVAL
    FROM DUAL;

SELECT my_seq1.NEXTVAL
    FROM DUAL;

//==================================================================

-- 파티션 테이블
--  테이블의 특정 컬럼값(파티션 컬럼)을 기준으로 데이터를 분할해 저장
--  논리적인 테이블은 1개 이지만, 실 데이터는 파티션 컬럼 값을 기준으로 파티션별 저장
--  대용량 데이터가 저장될 테이블의 경우, 파티션 테이블로 생성하면 성능 효율화 GOOD
SELECT *
    FROM SALES;
    
--==================================================================

-- 파티션 조회
SELECT *
    FROM SALES
    PARTITION(SALES_Q1_1998);

--==================================================================

-- CH3. DML
/*
[SELECT문]
 - 테이블이나 뷰에 있는 데이터를 선택(조회)할 때 사용
 - 구문
  SELECT * 혹은 컬럼
    FROM 테이블명 혹은 뷰명
    WHERE 조건
    ORDER BY 컬럼;

 - SELECT : 선택하고자 하는 컬럼명, 모든 컬럼을 조회하고 싶다면 *
 - FROM : 선택할 테이블이나 뷰 명
 - WHERE : 선택조건, 여러 조건 기숙 시에는 AND, OR로 연결
 - ORDER BY : 조회 데이터 정렬 시, 정렬하고자 하는 컬럼명 기술
        오름차순(ASC) : 작은 값에서 큰 값으로
        내림차순(DESC) : 큰 값에서 작은 값으로
*/

-- (92p)
SELECT employee_id, emp_name
    FROM employees
    WHERE salary > 20000
    ORDER BY employee_id;
    
-- AND 조건
SELECT employee_id, emp_name
    FROM employees
    WHERE salary > 5000
    AND job_id = 'IT_PROG'
    ORDER BY employee_id;
    
-- OR 조건(94p)
SELECT employee_id, emp_name
    FROM employees
    WHERE salary > 5000
    OR job_id = 'IT_PROG'
    ORDER BY employee_id;
    
-- 2개의 테이블을 하나의 SQL문에서 사용하는 경우(94p)
SELECT a.employee_id, a.emp_name, a.department_id, b.department_name
    FROM employees a, departments b     
    -- a, b는 별칭(별칭은 테이블명, 컬럼명에 가능)
    -- "원컬럼명 [AS] 컬럼별칭"
    WHERE a.department_id = b.department_id;

-- 원컬럼명에 별칭을 붙이는 경우(95p)   
SELECT a.employee_id, a.emp_name, a.department_id, b.department_name AS dep_name
    FROM employees a, departments b
    WHERE a.department_id = b.department_id;

--==================================================================

-- SELECT문 혼자 연습하기
-- #1. EMP 테이블에서 급여가 3000 이상인 사원의 정보를 사원번호, 이름, 담당업무, 급여를 출력하는 SELECT 문장 작성
SELECT a.emp_name, a.employee_id, a.job_id, salary
    FROM employees a
    WHERE salary >= 3000;
    
-- #2. 조건 : 입사일이 February 20, 1998과 May 11, 1998 사이에 입사
--     출력 : 사원의 이름, 업무, 입사일
--           입사일 순으로 출력할 것
SELECT a.emp_name, a.job_id, hire_date
    FROM employees a
--    WHERE hire_date BETWEEN '98/02/20' AND '98/05/11'
    WHERE hire_date BETWEEN to_date('1998-02-20', 'YYYY-MM-DD')
                    AND     to_date('1998-05-11', 'YYYY-MM-DD')
    ORDER BY hire_date;

-- #3. 조건 : EMP 테이블에서 부서번호가 10, 20인 사원의 모든 정보를 출력
--     이름순으로 정렬
SELECT *
    FROM employees a
    WHERE a.department_id IN(10, 20)
    ORDER BY a.emp_name;
    
-- #4. EMP 테이블에서 급여 : 1500 이상, 부서번호 : 10, 30
--     출력 : 사원의 이름, 급여(단, Heading을 Employee와 Monthly Salary로 출력)
SELECT a.emp_name "Employee", a.salary "Monthly Salary"
    FROM employees a
    WHERE salary >= 1500
        AND a.department_id = 10 OR a.department_id = 30;
        
--==================================================================

-- INSERT문(96P)
/*
[구문]
INSERT INTO 테이블명(컬럼1, 컬럼2, ...) VALUES(값1, 값2, ...);
INSERT INTO 테이블명 VALUES(값1, 값2, ...);
INSERT INTO 테이블명(컬럼1, 컬럼2, ...) SELECT문;
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
[UPDATE문]
UPDATE 테이블명
    SET 컬럼명1 = 값1, 컬럼명2 = 값2
    WHERE 조건;
    -- 조건이 여러개라면 AND나 OR 사용
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
    
-- JKL, 날짜 데이터에 NULL인 것에 데이터를 넣어보라(101p)
--UPDATE ex3_1
--    SET col3 = SYSDATE
--    WHERE col3 = '';

UPDATE ex3_1
    SET col3 = SYSDATE
    WHERE col3 IS NULL;

-- 테이블 ex3_1에서 컬럼 col1의 데이터가 JKL이고,
-- 컬럼 col3의 데이터가 null이 아닌 경우, 
-- col3 컬럼의 데이터에 시스템의 날짜/시간을 수정하라.
UPDATE ex3_1
    SET col3 = SYSDATE
    WHERE col1 = 'JKL' AND col3 IS NOT NULL;
-- IS NULL <-> IS NOT NULL

UPDATE ex3_1
    SET col1 = 'MNO'
    WHERE col1 IS NULL;

-- ex3_1 테이블 조회
SELECT * FROM ex3_1;

--==================================================================

/*
[MERGE문]
 : 조건을 비교해 조건에 맞는 데이터가 없으면 INSERT,
   있으면 UPDATE를 수행하는 문장
   (쓸일이 적다)
   
[MERGE 구문]
MERGE INTO 테이블명
    USING (update나 insert 될 데이터 원천)
    ON    (update될 조건)
    
    WHEN MATCHED THEN
        UPDATE SET 컬럼1=값1, 컬럼2=값2, ...
            WHERE 조건
            DELETE WHERE 조건
    
    WHEN NOT MATCHED THEN
        INSERT(컬럼1, 컬럼2, ...) VALUES(값1, 값2, ...)
            WHERE 조건;
*/

-- MERGE 문
목표 : 2000년 10월부터 12월 사이에 월 매출을 기준으로
      적정 매출을 달성한 사원에게 더 많은 보너스를 지급함
사용 테이블 : 사원(employees), 판매(sales)

문제1. 해당월에 매출을 달성한 사원은 누구인가?
- 매출을 달성한 사원 목록을 ex3_3 테이블에 삽입
- 사원번호가 사원테이블과 판매테이블에 둘 다 있어야 함
- 2000년 10월부터 12월 사이 월 매출을 기준으로 함
      
-- 테이블 생성(102p)
DROP TABLE ex3_3;

CREATE TABLE ex3_3(
    employee_id NUMBER,
    bonus_amt   NUMBER DEFAULT 0
);

-- 2000년 10월부터 12월까지 매출 달성한 사원번호 입력
INSERT INTO ex3_3(employee_id)
    SELECT e.employee_id
    FROM employees e, sales s
    WHERE e.employee_id = s.employee_id
        AND s.SALES_MONTH BETWEEN '200010' AND '200012'
        GROUP BY e.employee_id;
        -- GROUP BY : 중복 제거
        
SELECT * FROM ex3_3
    ORDER BY employee_id;

##    ex3_3 테이블 => 매출 달성한 사원 => 보너스 받는 사람   
 1. 관리자 사번(manager_id)이 146번인 사원
 2. ex3_3 테이블에 있는 사원의 사번과 일치하면
    보너스(bonus_amt)를 자신의 급여(salary)의 1%를 보너스로 갱신
 3. ex3_3 테이블에 있는 사원의 사번과 일치하지 않으면
    1의 결과의 사원을 신규로 입력(보너스 금액은 0.1%)
    이때, 급여가 8000 미만인 사원만 처리
    
-- 1%   = salary * 0.01
-- 0.1% = salary * 0.001
    
-- ex3_3 테이블에 있는 사원의 사번, 관리자 사번, 급여, 그리고 급여*0.01을
-- 사원 테이블에서 조회
-- (보너스 1% 받는 사원의 사번, 관리자 사번, 급여, 보너스 금액 조회)
SELECT employee_id, manager_id, salary, salary*0.01
    FROM employees
    WHERE employee_id
        IN (SELECT employee_id FROM ex3_3);

-- 사원 테이블에서 관리자 사번이 146인 것 중,
-- ex3_3 테이블에 없는 사원의 사번, 관리자 사번, 급여, 급여*0.001(0.1%) 조회
-- 이중 급여가 8000 미만은 160번 사원 1명이므로
-- ex3_3 테이블의 160번 사원의 보너스 금액은 7.5로 신규 입력될 것
-- (관리자 사번 146번인 사원 중,
--  매출액 달성못한 사원의 사번, 관리자 사번, 급여, 0.1% 보너스 금액 조회)
SELECT  employee_id, manager_id, salary, salary*0.001
    FROM employees
    WHERE employee_id
        NOT IN (SELECT employee_id FROM ex3_3)
        AND manager_id = 146;

-- MERGE 문으로 작성
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
    
-- ex3_3 테이블의 데이터 삭제
DELETE ex3_3;
SELECT * FROM ex3_3;

-- MERGE 문에서 'UPDATE될 값을 평가해서 조건에 맞는 데이터를 삭제'
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
 [DELETE 문]
 테이블에 있는 데이터를 삭제하는 문장

 [DELETE 구문]
 1. 일반구문
 DELETE [FROM] 테이블명
 WHERE 조건;

 2. 특정 파티션만 삭제할 경우의 구문
 DELETE 테이블명 PARTITION (파티션명)
 WHERE 조건;
 */

--'ex3_3'의 데이터 삭제(106p)
-- 특정 데이터 삭제
DELETE ex3_3
    WHERE employee_id = 148;
    
DELETE ex3_3
    WHERE employee_id = 155;

-- 모든 데이터 삭제
DELETE ex3_3;
-- 확인
SELECT * FROM ex3_3;

-- 파티션 조회(106p)
SELECT partition_name
    FROM user_tab_partitions
    WHERE table_name = 'SALES';


--==================================================================

/*
[COMMIT]
 - 변경한 데이터를 데이터 베이스에 최종적으로 반영
[구문]
 COMMIT [WORK] [TO SAVEPOINT 세이브포인트명];
 
[ROLLBACK]
 - 변경한 데이터를 변경 전 상태로 되돌림
[구문]
 ROLLBACK [WORK] [TO SAVEPOINT 세이브포인트명];
 
[TRUNCATE]
 - DELETE처럼 테이블 데이터를 삭제
 - 실행 시, 영구적으로 데이터가 삭제되는 DDL 문으로 WHERE 조건은 붙을 수 없다.
 - 삭제 후 ROLLBACK 불가능
[구문]
 TRUNCATE TABLE 테이블명;
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
[의사컬럼]
 - 테이블의 컬럼처럼 동작하지만 실제로 테이블에 저장되지는 않는 컬럼
 - CONNECT_BY_ISCYCLE, CONNECT_BY_ISLEAF, LEVEL
   : 계층형 쿼리에서 사용하는 의사컬럼(현재 단계에서는 생략)
 - NEXTVAL, CURRVAL
   : 시퀀스에서 사용하는 의사컬럼
 - ROWNUM, ROWID(중요)
   : ROWNUM은 쿼리에서 반환되는 각 로우에 대한 순서값(입력되는 순서값이 아님)
   : ROWID는 테이블에 저장된 각 로우가 저장된 주소값(각 로우를 식별하는 값, 유일한 값)
*/

-- 의사컬럼
-- ROWNUM, ROWID (110p)
SELECT ROWNUM, employee_id
    FROM ex3_3;

INSERT INTO ex3_3 VALUES(302, 300);
INSERT INTO ex3_3 VALUES(303, 400);
INSERT INTO ex3_3 VALUES(304, 500);
-- rownum은 실제 데이터 입력 순서와는 상관없음

SELECT ROWNUM, employee_id
    FROM ex3_3
    WHERE ROWNUM = 1;

SELECT ROWNUM, employee_id, ROWID
    FROM ex3_3
    WHERE ROWNUM < 3;
    
-- 시퀀스 의사컬럼
-- NEXTVAL, CURRVAL
DROP SEQUENCE ex3_3_seq;
CREATE SEQUENCE ex3_3_seq
    INCREMENT BY    1
    START WITH      1
    MINVALUE        1
    MAXVALUE        30
    NOCYCLE
    NOCACHE
    NOORDER; -- 요청 순서대로 값을 생성할지 여부

SELECT * FROM ex3_3;

INSERT INTO ex3_3 VALUES(ex3_3_seq.NEXTVAL, 0);

-- NEXTVAL은 조회만 하더라도 다음 번호로 넘어간다(INSERT를 하지 않아도 넘어감)
SELECT ex3_3_seq.NEXTVAL
    FROM DUAL;

SELECT ex3_3_seq.CURRVAL
    FROM DUAL;

--==================================================================

/*
[연산자]
 - 수식연산자 : +, -, *, /
 - 문자연산자 : ||
 - 논리연산자 : >, <, >=, <=, =, 
               <>, !=, ^=   : '같지 않다'는 의미
 - 집합연산자 : UNION, UNION ALL, INTERSECT, MINUS
 - 계층형 쿼리 연산자 : PRIOR, CONNECT_BY_ROOT
*/

/*
  a > b
  3 > 1 : 참(True)
  2 > 4 : 거짓(False)
  3 != 3 : 거짓(False)
*/

-- 문자연산자 => ||
SELECT emp_name || ':' || email
    FROM employees;

SELECT hire_date || '~' || RETIRE_DATE
    FROM employees;
    
-- 문자연산자 || (112p)
SELECT employee_id || '-' || emp_name AS employee_info
    FROM employees
    WHERE ROWNUM < 5;
    
-- 수식연산자 : + - * /
고객이 쇼핑몰에서 'Mouse Pad'를 3개 구매했을 때 가격 계산하기
SELECT prod_name, prod_list_price || '$', (prod_list_price *3 || '$') AS Total_Price
    FROM products
    where prod_name = 'Mouse Pad';
    
-- 수식연산자 + 문자연산자
SELECT (prod_list_price * 3 || '$') AS prod_total_price
    FROM products
    WHERE prod_name = 'Mouse Pad';
    
-- 논리연산자
고객이 쇼핑몰에서 제품을 구매할 때, 10달러 이하 제품을 검색하기
SELECT prod_name, prod_list_price
    FROM products
    WHERE prod_list_price <= 10;

--==================================================================

/*
[표현식]
 - 한 개 이상의 값과 연산자, 그리고 SQL 함수 등이 결합된 식
[CASE 표현식]
CASE WHEN 조건1 THEN 값1
     WHEN 조건2 THEN 값2
     ---
     ELSE 기타 값
END
*/

-- 문제(113p). 사원의 급여에 따라
-- 5000이하의 급여 : C, 5000~15000 : B, 15000 이상 : A등급을 반환하는 쿼리
SELECT employee_id, salary,
        CASE WHEN salary <= 5000 THEN 'C등급'
             WHEN salary BETWEEN 5000 AND 15000 THEN 'B등급'
             ELSE 'A등급'
        END AS salary_grade
    FROM employees;


-- 아래 내용에서 'D등급'은 출력X(모든 조건이 A~C 등급에 해당하므로)
SELECT employee_id, salary,
        CASE WHEN salary <= 5000 THEN 'C등급'
             WHEN salary BETWEEN 5000 AND 15000 THEN 'B등급'
             WHEN salary >= 15000 THEN 'A등급'
             ELSE 'D등급'
        END AS salary_grade
    FROM employees;


--==================================================================

/*
[조건식] : 7가지
 - 조건 혹은 조건식(Condition) : 한 개 이상의 표현식과 논리연산자가 결합된 식
 - TRUE, FALSE, UNKNOWN 3가지 타입을 반환
   (UNKNOWN은 DB에서만 사용하고, 다른 언어에서는 거의 사용X)
 
[비교 조건식]
 - 논리연산자나 ANY, SOME, ALL 키워드로 비교하는 조건식
 
[논리 조건식]
 - AND, OR NOT을 사용하는 조건식
 
[NULL 조건식]
 - 특정 값이 NULL인지 여부를 체크하는 조건식
 - IS NULL, IS NOT NULL
 
[BETWEEN AND 조건식]
 - 범위에 해당되는 값을 찾을 때 사용
 
[IN 조건식]
 - 조건절에 명시한 값이 포함된 건을 반환, ANY와 비슷
 
[EXISTS 조건식]
 - IN과 비슷하지만 후행 조건절로 값의 리스트가 아닌 서브쿼리만 올 수 있다.
 - 또한, 서브쿼리 내에서 조인조건이 있어야 한다.
 
[LIKE 조건식]
 - 문자열의 패턴을 검색할 때 사용
*/

--ANY(값1, 값2, 값3, ...)
--SOME(값1, 값2, 값3, ...)
--ALL(값1, 값2, 값3, ...)
--
--SELECT 컬럼
--    FROM 테이블
--    WHERE 조건
--    ;
--==================================================================
-- 비교조건식, ANY(114p)
-- 급여가 2000, 3000, 4000 중 하나라도 일치하는 모든 사원 조회
SELECT employee_id, salary
    FROM employees
    WHERE salary = ANY(2000, 3000, 4000)
    ORDER BY employee_id
    ;
    
-- 비교조건식, ANY -> OR(115p)
-- ANY는 OR 조건으로 변환 가능
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
    
-- 비교조건식, SOME (115p)
SELECT employee_id, salary
    FROM employees
    WHERE salary = SOME(2000, 3000, 4000)
    ORDER BY employee_id;
    
-- 비교조건식, ALL (115p)
-- ALL은 모든 조건을 동시에 만족해야 함
SELECT employee_id, salary
    FROM employees
    WHERE salary = ALL(2000, 3000, 4000)
    ORDER BY employee_id;
    
-- 비교조건식, ALL -> AND 조건으로 변환가능
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
-- 논리 조건식
논리 연산자 : AND OR NOT
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
    -- WHERE salary <= 15000 과 같은 의미
    ;

--==================================================================

-- NULL 조건식
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

-- BETWEEN AND 조건식(117p)
-- 기준컬럼 BETWEEN 시작값1 AND 시작값2
SELECT employee_id, salary
    FROM employees
    WHERE salary BETWEEN 2000 AND 2500
    ;

--==================================================================

-- IN 조건식(117p)
--   : 조건절에 명시한 값이 포함된 내용을 결과로 반환 (= ANY)
-- IN(값1, 값2, 값3, ...)
SELECT employee_id, salary
    FROM employees
    WHERE salary IN(2000, 3000, 4000)
    ;

--==================================================================

-- EXISTS 조건식(118p)
--EXISTS (서브쿼리 with 조인조건)
--조인조건(join) : 테이블1.기준컬럼 + 테이블2.기준컬럼
-- ex) employees.department_id = departments.department_id
--     E.department_id = D.department_id
--<서브쿼리>
SELECT *
    FROM departments d, employees e
    WHERE e.department_id = d.department_id
        AND salary >= 3000
    ;
--<메인쿼리> : 급여가 3000만원 이상인 사원의 부서 아이디, 부서명을 조회
-- employees : 급여, 부서 아이디
-- departments : 부서 아이디, 부서명
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

-- LIKE 조건식(119p)
-- 웹에서 검색할때마다 사용됨(★웹개발에 필수★)
ex) 사원테이블에서 사원 이름이 '홍길동'인 사원 조회
ex) 사원테이블에서 사원 이름이 '홍'으로 시작하는 사원 조회
 LIKE '문자열 패턴' : 검색
  - 여러문자 : '%문자열패턴%'
  - n문자 : '문자열패턴_' → 필요한 위치에 '_'를 n개만큼 사용
    
--John 찾기
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

-- 사원테이블에서 사원 이름이 'A'로 시작되는 사원을 조회(119p)
SELECT emp_name
    FROM employees
    WHERE emp_name LIKE 'A%'
    ;

-- LIKE 예시(120p)
CREATE TABLE ex3_5(
    names VARCHAR2(30)
    );

INSERT INTO ex3_5 VALUES ('홍길동');
INSERT INTO ex3_5 VALUES ('홍길용');
INSERT INTO ex3_5 VALUES ('홍길상');
INSERT INTO ex3_5 VALUES ('홍길상동');
INSERT INTO ex3_5 VALUES ('홍길수');

SELECT * FROM ex3_5;

COMMIT;

SELECT *
    FROM ex3_5
    WHERE names LIKE '홍%'
    ;

SELECT *
    FROM ex3_5
    WHERE names LIKE '%길%'
    ;

SELECT *
    FROM ex3_5
    WHERE names LIKE '%상'
    ;

SELECT *
    FROM ex3_5
    WHERE names LIKE '홍길%'
    ;
    
SELECT *
    FROM ex3_5
    WHERE names LIKE '홍길_'
        OR names LIKE '홍길__'
    ;

--==================================================================
--==================================================================
/*
CH4. SQL 함수
[숫자함수]
 - ABS(n) : n의 절대값 반환
     ex) ABS(3) → 3, ABS(-3) → 3
 - CEIL(n) : n과 같거나 가장 큰 정수 반환
     ex) CEIL(10.123) → 11, CEIL(10.541) → 11
 - FLOOR(n) : n보다 작거나 가장 큰 정수 반환
     ex) FLOOR(10.123) → 10, FLOOR(10.541) → 10
 - ROUND(n, i) : n을 소수점 기준 (i+1)번째에서 반올림한 결과 반환
     ex) ROUND(10.154) → 10, ROUND(10.154, 2) → 10.15
 - ★TRUNC(n1, n2) ★중요★ : n1을 소수점 기준 n2자리에서 무조건 잘라낸 결과를 반환
     ex) TRUNC(115.155) → 115, TRUNC(115.155, 1) → 115.1
 - POWER(n2, n1) : n2를 n1 제곱한 결과를 반환, n2가 음수면 n1은 반드시 정수
     ex) POWER(3,2) → 9, POWER(3,3) → 27
 - SQRT(n) : n의 제곱근 반환
     ex) SQRT(2) → 1.41421356, SQRT(5) → 2.23606798
 - ★MOD(n2, n1) ★중요★ : n2를 n1으로 나눈 나머지 값을 반환
     ex) MOD(19, 4) → 3, MOD(19.123, 4.2) → 2.323
 - REMAINDER(n2, n1) : MOD와 같으나 연산수식이 다름
 - EXP(n) : 지수함수로 e의 n제곱 값을 반환
     ex) EXP(2) → 7.3890561
 - LN(n) : 자연로그 함수로 밑수가 e인 로그함수
     ex) LN(2.713) → 0.998055034
 - LOG(n2, n1) : n2를 밑수로 하는 n1의 로그값을 반환
     ex) LOG(10, 100) → 2
*/

-- ABS(n) 함수
SELECT ABS(10) FROM DUAL;
SELECT ABS(0) FROM DUAL;
SELECT ABS(-10) FROM DUAL;
-- CEIL(n) 함수
SELECT CEIL(10.123), CEIL(10.541), CEIL(10) FROM DUAL;
-- FLOOR(n) 함수
SELECT FLOOR(10.123), FLOOR(10.541), FLOOR(10) FROM DUAL;
-- ROUND(n, i) 함수
SELECT ROUND(10.123), ROUND(10.541), ROUND(10) FROM DUAL;
SELECT ROUND(10.157, 1), ROUND(10.157,2), ROUND(10.157, 3) FROM DUAL;
-- ★TRUNC(n, i) 함수, ★중요★
SELECT TRUNC(115.155), TRUNC(115.155, 1), TRUNC(115.155, -2) FROM DUAL;
-- POWER(n, i) 함수
SELECT POWER(2, 2), POWER(3, 3), POWER(4, -2) FROM DUAL;
-- SQRT(n) 함수
SELECT SQRT(2), SQRT(3), SQRT(5) FROM DUAL;
-- ★MOD(n, i) 함수, ★중요★
SELECT MOD(13, 2), MOD(19, 4) FROM DUAL;
-- REMAINDER(n, i) 함수
SELECT REMAINDER(13, 2), REMAINDER(19, 4) FROM DUAL;

--==================================================================

/*
[문자함수]
 - INITCAP(char) : char의 첫 문자는 대문자로, 나머지는 소문자로 반환
                  첫 문자 인식 기준은 공백 그리고 알파벳과 숫자를 제외한 문자
    ex) INITCAP('never say goodbye') → Never Say Goodbye
 - ★LOWER(char) : 소문자 변환 후 반환
    ex) LOWER('NEVER SAY GOODBYE') → never say goodbye
 - ★UPPER(char) : 대문자 변환 후 반환
    ex) UPPER('never say goodbye') → NEVER SAY GOODBYE
 - ★CONCAT(char1, char2) : 두 문자를 붙여 반환
    ex) CONCAT('I Have', 'A Dream') → I Have A Dream
 - ★SUBSTR(char, pos, len) : char의 pos번재 문자부터 len 길이만큼 잘라낸 결과를 반환
    ex) SUBSTR('ABCDEFG', 1, 4) → ABCD, SUBSTR('ABCDEFG', -1, 4) → G
 - ★SUBSTRB(char, pos, len) : SUBSTR과 같으나 문자 개수가 아닌 바이트 수 단위
    ex) SUBSTRB('ABCDEFG', 1, 4) → ABCD, SUBSTRB('가나다라마바사', 1, 4) → 가
 - ★LTRIM(char, set) : char에서 set으로 지정된 문자열을 왼쪽 끝에서 제거 후 나머지 문자열 반환
    ex) LTRIM('ABCDEFGABC', 'ABC') → DEFGABC
 - ★RTRIM(char, set) : LTRIM과 반대로 오른쪽 끝에서 제거한 뒤 나머지 문자열을 반환
    ex) RTRIM('ABCDEFGABC', 'ABC') → ABCDEFG
 - LPAD(expr1, n, expr2) : expr2 문자열을 n자리만큼 왼쪽부터 채워 expr1을 반환
    ex) LPAD('111-1111', 12, '(02)') → (02)111-1111
 - RPAD(expr1, n, expr2) : 오른쪽에 해당 문자열을 채워 반환
    ex) RPAD('111-1111', 12, '(02)') → 111_1111(02)
 - ★REPLACE(char, search_str, replace_str) : char에서 search_str을 찾아 이를 replace_str로 대체
    ex) REPLACE('나는 너를 모르는데', '나', '너') → 너는 너를 모르는데
 - TRANSLATE(expr, from_str, to_str) : expr에서 from_str에 해당하는 문자를 찾아 to_str로 한 글자씨 바꾼 결과 반환
    ▶ 정보보안 암호를 번역해서 사용 (ex: 공인인증서 등)
    ex) TRANSLATE('나는 너를 모르는데', '나는', '너를') → 너를 너를 모르를데
 - INSTR(str, substr, pos, oocur)
  : str에서 substr과 일치하는 위치를 반환, pos는 시작위치, occur은 몇번째 일치하는지를 명시
    ex) INSTR() → 
 - LENGTH(chr) : 문자열의 길이 반환
    ex) LENGTH('대한민국') → 4
 - LENGTHB(chr) : 문자열이 byte수 반환
    ex) LENGTHB('대한민국') → 12
*/
-- INITCAP 
SELECT INITCAP('never say goodbody')
       , INITCAP('NEVER SAY GOODBYE')
       , INITCAP('never6say*good가bye') -- *뒤는 첫글자로 인식
      FROM DUAL;

-- LOWER
SELECT LOWER('never say goodbody')
       , LOWER('NEVER SAY GOODBYE')
       , LOWER('never^say*good가bye')
      FROM DUAL;

-- UPPER
SELECT UPPER('never say goodbody')
       , UPPER('NEVER SAY GOODBYE')
       , UPPER('never^say*good가bye')
      FROM DUAL;

-- CONCAT : 2개의 문자만 연결 가능
SELECT CONCAT('never', 'say goodbody')
        , 'never '||'say '||'goodbye'
          -- 띄어쓰기 필요한 곳에 알아서 잘하기
          -- 공백 또한 문자임
      FROM DUAL;

-- SUBSTR(문자, 위치, 길이)
SELECT SUBSTR('never say goodbye', 7, 3)    -- ★공백도 문자이므로 순서에 주의
    FROM DUAL;
-- SUBSTRB(문자, 위치, 바이트)
SELECT SUBSTRB('점심시간은 언제인가요?', 7, 6)
    FROM DUAL;
SELECT SUBSTRB('가나다라마바사', 1, 4)
    FROM DUAL;
-- LTRIM(문자, 잘라낼문자)
SELECT LTRIM('never say goodbye', 'never')  -- ★공백도 문자이므로 표기에 주의
    FROM DUAL;
SELECT LTRIM('never say goodbye', 'never ') -- ★공백도 문자이므로 표기에 주의
    FROM DUAL;
-- RTRIM(문자, 잘라낼문자)
SELECT RTRIM('never say goodbye', 'bye')
    FROM DUAL;
-- LPAD(문자열1, 길이, 문자열2)
SELECT LPAD('123-4567', 13, '(032)')
    FROM DUAL;
-- RPAD(문자열1, 길이, 문자열2)
SELECT RPAD('123-4567', 13, '(032)')
    FROM DUAL;
-- REPLACE(문자열, 대상문자열, 바꿀문자열)
SELECT REPLACE('관계형 데이터베이스(RDBMS)가 가장 널리 쓰이고 있다.
 그리고 이 관계형 데이터베이스를 이용하기 위한
 표준 언어가 만들어져 있는데 그것이 SQL이다.', '관계', '소통')
    FROM DUAL;
-- TRANSLATE(문자열, 대상문자, 바꿀문자)
SELECT TRANSLATE('관계형 데이터베이스(RDBMS)가 가장 널리 쓰이고 있다.
 그리고 이 관계형 데이터베이스를 이용하기 위한
 표준 언어가 만들어져 있는데 그것이 SQL이다.', '이용가데', '사람구당')
    FROM DUAL;
-- INSTR('문장', '검색할문자열', 시작위치, 발생횟수)
SELECT INSTR('관계형 데이터베이스(RDBMS)가 가장 널리 쓰이고 있다.
 그리고 이 관계형 데이터베이스를 이용하기 위한
 표준 언어가 만들어져 있는데 그것이 SQL이다.'
        , '데이터베이스', 10, 1)
    FROM DUAL;

--==================================================================

/*
[날짜함수]
 - ★SYSDATE : 현재일자와 시간 반환
    ex) SYSDATE → 2015-03-16 22:10:56
 - SYSTIMESTAMP : 현재일자와 시간 반환 (TIMESTAMP)
    ex) SYSTIMESTAMP → 2015-03-16 22:10:56.998000000 +09:00
 - ★ADD_MONTHS(date, integer) : date에 integer만큼 월을 더한 날짜 반환
    ex) ADD_MONTHS(SYSDATE, 1) → 2015-04-16 22:10:33
 - ★MONTHS_BETWEEN(date1, date2) : 두 날짜 사이의 개월 수 반환
    ex) MONTHS_BETWEEN(ADD_MONTHS(SYSDATE,1), SYSDATE) → 1
 - LAST_DAY(date) : 해당 월의 마지막 일자 반환
    ex) LAST_DAY(SYSDATE) → 2015-03-31
 - ROUND(date, format) : 반올림한 날짜 반환
    ex) ROUND(SYSDATE, 'month') → 2015-04-01 00:00:00 (현재일자가 3/16인 경우)
 - TRUNC(date, format) : 잘라낸 날짜 반환
    ex) TRUNC(SYSDATE, 'month') → 2015-03-01 00:00:00 (현재일자가 3/16인 경우)
 - NEXT_DAY(date, char) : date를 char에 명시한 날짜로 다음주 주중 일자를 반환
    ex) NEXT_DAY(SYSDATE, '금요일') → 2015-03-20 22:16:20

***** 함수의 중첩 사용    
함수(입력값1, 입력값2)
    입력값2 ← 다른함수()
함수(입력값1, 다른함수())
※ 단, 반환되는 결과의 데이터타입이 일치하는 경우에만 가능
*/

-- ADD_MONTHS(날짜, 정수)
SELECT ADD_MONTHS(SYSDATE, 18)
    FROM DUAL;
-- MONTHS_BETWEEN(시작날짜, 종료날짜)
SELECT MONTHS_BETWEEN('2024-04-09', '2023/11/10')
    FROM DUAL;
SELECT MONTHS_BETWEEN(ADD_MONTHS(SYSDATE, 6), '2023/11/10')
    FROM DUAL;
-- LAST_DAY(날짜)
SELECT LAST_DAY('2024/2/1')
    FROM DUAL;
SELECT LAST_DAY(ADD_MONTHS(SYSDATE, 6))
    FROM DUAL;
-- ROUND(날짜, 포맷) : 반올림한 날짜
SELECT ROUND(SYSDATE, 'MONTH')
    FROM DUAL;
SELECT ROUND(TO_DATE('2023/11/15'), 'MONTH')
    FROM DUAL;
-- TRUNC(날짜, 포맷) : 잘라낸 날짜
SELECT TRUNC(TO_DATE('2023/11/15'), 'MONTH')
    FROM DUAL;
-- NEXT_DAY(날짜, 찾을요일) : 다음 해당 요일 일자 반환
SELECT NEXT_DAY(SYSDATE, '토요일')
    FROM DUAL;
SELECT NEXT_DAY(SYSDATE, '토')
    FROM DUAL;
    -- 1:일요일, 2:월요일, 3:화요일, ..., 7:토요일
SELECT NEXT_DAY(SYSDATE, 7)
    FROM DUAL;

--==================================================================

/*
[변환함수]
 - TO_CHAR(숫자 혹은 날짜, format) : format에 맞게 변환 후 결과 반환
    ex) TO_CHAR(123456789, '999,999,999') → 123,456,789
        TO_CHAR(SYSDATE, 'YYYY-MM-DD') → 2015-03-16
 - TO_NUMBER(expr, format) : 문자나 다른 유형의 숫자를 NUMBER 형으로 변환
    ex) TO_NUMBER('123456') → 123456
 - TO_DATE(char, format) : DATE형으로 변환
    ex) TO_DATE('20140101', 'YYYY-MM-DD') → 2014/01/01 00:00:00
 - TO_TIMESTAMP(char, format) : TIMESTAMP 형으로 변환
    ex) TO_TIMESTAMP('20140101', 'YYYY-MM-DD') → 2014-01-01 00:00:00.000000000
*/

-- 변환
-- 문자 변환
1. (소수점)자릿수 맞춰서
2. 음수 → <>
3. 양수/음수 표시 → + / -
SELECT TO_CHAR(1234567, '999,999,999')
    FROM DUAL;
SELECT TO_CHAR(1234567, '9,999,999')    -- 자릿수 맞춰서
    FROM DUAL;
SELECT TO_CHAR(12345.67, '999999.9')    -- 소수점 자릿수 맞춰서(반올림)
    FROM DUAL;
SELECT TO_CHAR(-123, '999PR')    -- 음수 표시
    FROM DUAL;
SELECT TO_CHAR(123, 'RN')    -- 로마숫자 표시
    FROM DUAL;
SELECT TO_CHAR(123, 'S999')    -- 양수(+)/음수(-) 표시
    FROM DUAL;
SELECT TO_CHAR(123, '00000') FROM DUAL; -- 지정한 길이 만큼 0으로 채우기
SELECT TO_CHAR(123456, 'L999,999') FROM DUAL; -- 원화 표시 붙이기
    
SELECT TO_CHAR(SYSDATE, 'YY-MM-DD HH24:MI:SS')    -- 날짜 포맷에 맞춰서
    FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'YY/MM/DD')    -- 날짜 포맷에 맞춰서
    FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'YY/MM/DD AM HH24:MI:SS')  -- 날짜 포맷에 맞춰서
    FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'YY-MM-DD DAY') FROM DUAL;  -- 요일 표시
SELECT TO_CHAR(SYSDATE-5, 'FMYY-MM-DD') FROM DUAL;  -- 날짜의 0 없애기
SELECT TO_CHAR(SYSDATE, '""YYYY"년 "MM"월 "DD"일"') FROM DUAL;  -- 임의 구분자로 날짜 형식 만들기

-- 숫자 변환
-- TO_NUMBER(문자, 포맷)
-- 문자나 날짜가 포함된 내용을 숫자로 변환하면 오류 발생
SELECT TO_NUMBER('123') FROM DUAL;
SELECT TO_NUMBER('ABC') FROM DUAL;      -- 오류
SELECT TO_NUMBER(SYSDATE) FROM DUAL;    -- 오류
SELECT TO_NUMBER('20231113') FROM DUAL;
-- SELECT TO_NUMBER(AGE) FROM DUAL;

-- 날짜 변환
TO_DATE(문자, 포맷)

SELECT TO_DATE('20140101', 'YY-MM-DD') FROM DUAL;
SELECT TO_DATE('20140101', 'YY MM DD') FROM DUAL;
SELECT TO_DATE('20140101', 'YYYY-MM-DD') FROM DUAL;
SELECT TO_DATE('20140101 13:44:50', 'YYYY-MM-DD HH24:MI:SS') FROM DUAL;
SELECT TO_DATE('20140101 134450', 'YYYY-MM-DD HH24:MI:SS') FROM DUAL;
SELECT TO_DATE('2014/01/01 13/44/50', 'YYYY-MM-DD HH24:MI:SS') FROM DUAL;
-- SELECT TO_DATE('2014&01&01 13&44&50', 'YYYY-MM-DD HH24:MI:SS') FROM DUAL;   -- 안됨

* 오라클 날짜/시간 차이 계산 방법
 종료일자 - 시작일자
 반환 값 : 차이값을 일 기준 수치값으로 반환
  ex) SYSDATE - 5 ▶ 23/11/9
    SELECT TO_DATE('2021-05-08') - TO_DATE('2021-05-01') FROM DUAL;

시간 차이 : (종료일시(YYYY-MM-DD HH:MI:SS) - 시작일시(YYYY-MM-DD HH:MI:SS)) * 24
분 차이 : (종료일시(YYYY-MM-DD HH:MI:SS) - 시작일시(YYYY-MM-DD HH:MI:SS)) * 24 * 60
초 차이 : (종료일시(YYYY-MM-DD HH:MI:SS) - 시작일시(YYYY-MM-DD HH:MI:SS)) * 24* 60 * 60

NLS(National Language Support, 국가별 언어 지원) 설정 확인
SELECT * FROM NLS_SESSION_PARAMETERS;
-- SESSION 설정 변경 명령어
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH24:MI:SS';
ALTER SESSION SET NLS_DATE_FORMAT = 'RR-MM-DD HH24:MI:SS';

--==================================================================
/*
[NULL 함수]
-- NULL값의 처리 : NULL 값의 여부에 따라 리턴 값이 달라짐
NVL(표현식1, 표현식2)
    FROM 테이블
    WHERE 조건;

NVL2(표현식1, 표현식2, 표현식3) : 표현식1이 NULL이 아니면 표현식2를 반환, NULL이면 표현식 3을 반환
    FROM 테이블
    WHERE 조건;
*/

-- NVL(표현식1, 표현식2)
SELECT manager_id, NVL(manager_id, employee_id)
    FROM employees;
    
SELECT NVL(manager_id, employee_id)
    FROM employees
    WHERE manager_id IS NULL;

-- NVL2(표현식1, 표현식2, 표현식3)
-- : 표현식1이 NULL이 아니면 표현식2를 반환, NULL이면 표현식 3을 반환
SELECT employee_id
       , NVL2(commission_pct, salary + (salary * commission_pct), salary) 
            AS salary2
    FROM employees;

-- 사원번호, 급여, 급여+보너스, 보너스 조회
SELECT employee_id
        , NVL2(commission_pct, salary+(salary*commission_pct), salary)
            AS salary_commission
        , (NVL2(commission_pct, salary+(salary*commission_pct), salary) - salary)
            AS bonus
    FROM employees;

-- NULL과 수식연산자를 사용하여 연산을 하면 결과값은 NULL
SELECT employee_id, NVL(commission_pct, salary+(salary*commission_pct))
        AS salary_commission
    FROM employees;

-- COALESCE(표현식1, 표현식2, ...)
-- : 입력값으로 들어오는 표현식들 중 NULL이 아닌 첫번째 표현식을 반환
-- 사원번호, 커미션 비율, 수령 급여
SELECT employee_id
        , commission_pct
        , COALESCE(salary+salary*commission_pct, salary)
    FROM employees;
    
-- LNNVL(조건식)
-- 목표 : 커미션이 0.2 미만인 사원을 조회(0%인 경우)
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

-- NULLIF(표현식1, 표현식2) : 표현식1과 표현식2가 같으면 NULL, 다르면 표현식1을 반환
-- 재고조사 시, 재고ID가 존재하면 null, 없으면 재고ID를 반환하는 등의 사례로 사용 가능
[문제] 직무의 시작날짜와 종료날짜의 연도가 같으면 NULL,
        같지 않으면 종료년도를 출력하는 쿼리를 작성하시오.
 - 날짜 비교 => 문자데이터 변경 및 연도 추출

SELECT employee_id
        , TO_CHAR(start_date, 'YYYY') AS start_year
        , TO_CHAR(end_date, 'YYYY') AS end_year
        , NULLIF(TO_CHAR(end_date, 'YYYY'), TO_CHAR(start_date, 'YYYY'))
            AS nullif_year      -- NULLIF(종료년도, 시작년도)
    FROM job_history;

DESC job_history;

--==================================================================

/*
[기타 함수]
 - GREATEST(표현식1, 표현식2, ...) : 매개변수로 들어오는 표현식에서 가장 큰 값을 반환
 
 - LEAST(표현식1, 표현식2, ...) : 매개변수로 들어오는 표현식에서 가장 작은 값을 반환
 
 - ★DECODE(expr, search1, result1, search2, result2, ..., default)
    : expr과 search1을 비교해 두 값이 같으면 result1을 반환.
      같지 않으면 다시 search2와 비교해 값이 같으면 result2를 반환,
      이런 식으로 계속 비교한 뒤 최종적으로 같은 값이 없으면 default 값을 반환한다.
-- DECODE는 일반 프로그래밍 언어의 IF~ELSE문과 처리방식이 같음
-- CASE WITH과도 처리방식이 비슷함
-- 다만, DECODE는 비교값과 결과값을 일일이 나열하므로 CASE WITH 사용이 코드가 더 깔끔함
*/

-- GREATEST(표현식1, 표현식2, ...) : 가장 큰 값
SELECT GREATEST(1,2+22,4,7,8,11,23)
    FROM DUAL;
    
-- LEAST(표현식1, 표현식2, ...) : 가장 작은 값
SELECT LEAST(1,2,4,7,8,11,23)
    FROM DUAL;
    
SELECT GREATEST('apple', 'banana', 'orange', 'graph', 'mango') AS greatest
        , LEAST('apple', 'banana', 'orange', 'graph', 'mango') AS least
    FROM DUAL;

SELECT GREATEST('홍길동', '유재석', '강호동', '이특', '조세훈') AS greatest
        , LEAST('홍길동', '유재석', '강호동', '이특', '조세훈') AS least
    FROM DUAL;

-- ★DECODE(표현식, 값1, 결과1, 값2, 결과2, ..., 기본값)
-- DECODE는 일반 프로그래밍 언어의 IF~ELSE문과 처리방식이 같음
-- CASE WHEN과도 처리방식이 비슷함
-- 다만, DECODE는 비교값과 결과값을 일일이 나열하므로 CASE WHEN 사용이 코드가 더 깔끔함
SELECT prod_id
       , DECODE(channel_id, 3, '이마트',
                            9, '롯데마트',
                            5, '트레이더스',
                            4, '티몬',
                               '행사매대') AS decodes
    FROM sales
    WHERE rownum < 100;

--==================================================================
--==================================================================
/*
CH5. 그룹쿼리, 집합연산자
[기본 집계함수]
 - ★COUNT : 쿼리 결과건 수, 로우 수 반환
 - ★SUM() : 전체합계
 - ★AVG() : 평균
 - ★MIN() : 최소값
 - ★MAX() : 최대값
 - VARIANCE() : 분산
 - STDDEV() : 표준편차
*/

-- 집계함수
-- 1> ★COUNT(표현식)
SELECT COUNT(*), COUNT(employee_id), COUNT(emp_name), COUNT(manager_id)
    FROM employees;
    -- null이 있으면 값이 달라짐

-- 한명의 사원이 여러 직무(부서)로 근무가 가능함
-- DISTINCT : 유일성 여부 확인, 중복 제거
SELECT COUNT(DISTINCT department_id)
    FROM employees;

SELECT COUNT(DISTINCT employee_id)
    FROM employees;

-- 고객내 미혼인 사람 수 합계
SELECT COUNT(*)
    FROM customers
    WHERE cust_marital_status='single';

-- 2> ★SUM(표현식)
SELECT SUM(salary), SUM(DISTINCT salary)
    FROM employees;

-- 표현식 연산자 활용
SELECT SUM(salary), SUM(salary + salary * 2/100), SUM(salary) + SUM(salary)*2/100
    FROM employees;

-- 집계 함수 내 함수 사용
SELECT SUM(salary + salary * 2/100), SUM(salary + ROUND(salary * 2/100))
    FROM employees;

-- 3> ★MIN(표현식), 4> ★MAX(표현식)
SELECT MIN(salary), MAX(salary)
    FROM employees;

-- 최대/최소는 이미 하나의 값을 출력하므로, DISTINCT는 효과 없음
SELECT MIN(DISTINCT salary), MAX(DISTINCT salary) 
    FROM employees;
    
-- 5> ★AVG(표현식)
SELECT AVG(salary), AVG(DISTINCT salary)
    FROM employees;

-- 제품 가격 평균
SELECT AVG(prod_list_price)
    FROM products;

-- WHERE절 집계함수 단독 사용 불가!
SELECT COUNT(*)
    FROM products
    WHERE prod_list_price <= AVG(prod_list_price);

-- VARIANCE(표현식) : 분산
SELECT VARIANCE(salary)
    FROM employees;

-- STDDEV(표현식) : 표준편차
SELECT STDDEV(salary)
    FROM employees;

--==================================================================
/*
[GROUP BY ~ HAVING 절]
 - GROUP BY절
  : 특정 그룹으로 묶어 데이터 집계 시 사용
  : WHERE과 ORDER BY절 사이에 위치
  : 집계함수와 함께 사용
  : ★SELECT 리스트에서 집계함수를 제외한 모든 컬럼과 표현식은 GROUP BY 절에 명시해야 함

 - HAVING 절
  : GROUP BY절 다음에 위치해 GROUP BY한 결과를 대상으로 다시 필터를 거는 역할
  : HAVING 다음에는 SELECT 리스트에 사용했던 집계함수를 이용한 조건을 명시
  
 - ROLLUP(표현식1, 표현식2, ...)
  : GROUP BY절에서 사용됨
  : 표현식을 기준으로 집계한 결과, 추가 정보 집계
  : 표현식 수와 순서에 따라 레벨 별로 집계
  : 표현식 개수가 n개라면, n+1 레벨까지, 하위에서 상위 레벨 순으로 집계
  
 - CUBE(표현식1, 표현식2, ...)
  : GROUP BY 절에서 사용됨
  : 명시한 표현식 개수에 따라 가능한 모든 조합별로 집계
  : 표현식 개수가 3이면 2^3, 즉 총 8가지 종류로 집계됨
  : 표현식 개수가 n이면 2^n 가지 종류로 집계됨
  
 - SQL 구문 순서
 SELECT 컬럼명         -- 5
    FROM 테이블명      -- 1
    WHERE 조건         -- 2
    GROUP BY 컬럼명    -- 3
    HAVING 그룹조건     -- 4
    ORDER BY 컬럼명    -- 6
 ;

[집합연산자]
 - UNION
  : 집합의 합집합 개념
  : 2개 이상의 개별 SELECT 쿼리를 연결
  : 개별 SELECT 쿼리 반환 결과가 중복될 경우 UNION 연산 결과는 한 로우만 반환
  ex) A = {1,2,3}, B = {2,3,4}, A [UNION] B = {1,2,3,4}

 - UNION ALL
  : UNION과 유사
  : 개별 SELECT 쿼리 반환 결과가 중복될 경우, 중복되는 건까지 모두 반환
  ex) A = {1,2,3}, B = {2,3,4}, A [UNION ALL] B = {1,2,2,3,3,4}
  
 - INTERSECT
  : 집합의 교집합 개념
  : 2개 이상의 개별 SELECT 쿼리를 연결
  : 개별 SELECT 쿼리 반환 결과 중 중복된 건만 반환
  ex) A = {1,3,5,7}, B = {2,3,4,7,8}
        A [INTERSECT] B = {3,7}

 - MINUS
  : 집합의 차집합 개념
  : 2개 이상의 개별 SELECT 쿼리를 연결
  : 개별 SELECT 쿼리 반환 결과 중 중복된 건을 제외한 선행 쿼리 결과 추출
  ex) A = {1,3,5,7}, B = {2,3,4,7,8},
        A [MINUS] B = {1,5}
        B [MINUS] B = {2,4,8}

 - 집합 연산자 제한사항
  : 개별 SELECT 쿼리의 SELECT 리스트 개수와 데이터 타입이 일치해야 함
  : ORDER BY 절은 맨 마지막 개별 SELECT 쿼리에만 명시 가능함
  : BLOB, CLOB, BFILE 같은 LOB 타입 컬럼은 집합 연산자 사용 불가
  : UNION, INTERSECT, MINUS 연산자는 LONG형 컬럼에는 사용 불가
  <주의사항>
  1. SELECT 리스트의 개수 및 데이터타입 일치
  2. ORDER BY절은 마지막 SELECT 문에서만 사용 가능
  
 - 집합연산자 구문
 SELECT 컬럼
     FROM 테이블
     WHERE 조건
     GROUP BY 그룹컬럼
     HAVING 그룹 조건
 집합연산자
 SELECT 컬럼
     FROM 테이블
     WHERE 조건
     GROUP BY 그룹컬럼
     HAVING 그룹 조건
     ORDER BY 컬럼
 ;

*/

-- GROUP BY 구문
SELECT 컬럼1, 컬럼2, 집계함수(표현식)
    FROM 테이블
    WHERE 조건
    GROUP BY 컬럼1, 컬럼2
    ORDER BY 컬럼
;

-- 사원테이블에서 부서 번호가 70번인 사원 그룹의 부서 번호와 급여 합계
SELECT department_id, SUM(salary)
    FROM employees
    WHERE department_id = 70    -- date type이 number면 '' 필요 X. 만약 타입이 문자였으면 '' 필요O.
    GROUP BY department_id
    ORDER BY department_id
;

-- 사원테이블에서 부서 번호별 사원 그룹의 부서 번호, 급여 합계, 사원수, 급여 평균
SELECT department_id, SUM(salary), COUNT(employee_id), AVG(salary)
    FROM employees
    GROUP BY department_id
    ORDER BY department_id
;

-- 사원테이블에서 부서 번호별 사원 그룹의 부서 번호, 급여 합계, 사원수
--  , 급여 평균(소수점 버림), 급여 평균을 내림차순 정리
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

-- group by : select 절의 집계함수 제외한 모든 컬럼을 group by절에 써야 함
SELECT period, region, SUM(loan_jan_amt)
    FROM kor_loan_status
    GROUP BY period, region
;

-- 기간별 대출잔액의 합계 출력
SELECT period, SUM(loan_jan_amt)
    FROM kor_loan_status
    GROUP BY period
    ORDER BY SUM(loan_jan_amt) DESC
;

-- 지역별 대출잔액의 합계 출력
SELECT region, TRUNC(SUM(loan_jan_amt))
    FROM kor_loan_status
    GROUP BY region
    ORDER BY TRUNC(SUM(loan_jan_amt)) DESC
;

-- 2013년의 대출잔액 합계 출력
SELECT period, SUM(loan_jan_amt)
    FROM kor_loan_status
    WHERE period LIKE '2013%'
    GROUP BY period
    ORDER BY SUM(loan_jan_amt) DESC
;

-- 한국 대출상태 테이블에서 2013년도 기간별 대출액 합계를 기간순서(오름차순)로 조회
SELECT period, region, SUM(loan_jan_amt)
    FROM kor_loan_status
    WHERE period LIKE '2013%'
    GROUP BY period, region
    ORDER BY SUM(loan_jan_amt)
;

-- 기간별 지역별 대출액 합계 조회
SELECT period, region, SUM(loan_jan_amt)
    FROM kor_loan_status
    WHERE period LIKE '2013%'
    GROUP BY period, region
    ORDER BY period
;

-- 지역별 기간별 대출액 합계 조회
SELECT region, period, SUM(loan_jan_amt)
    FROM kor_loan_status
    WHERE period LIKE '2013%'
    GROUP BY period, region
    ORDER BY region
;

------------------------------------------------------------
-- HAVING절
-- 2013년 11월 기간별/지역별 총 잔액이 [100억 초과] 내용 조회
SELECT period, region, SUM(loan_jan_amt)
    FROM kor_loan_status
    WHERE period = '201311'
    GROUP BY period, region
    HAVING SUM(loan_jan_amt) > 100000
    ORDER BY region
;

------------------------------------------------------------
-- ROLLUP절
-- BEFORE_ROLLUP
SELECT period, gubun, SUM(loan_jan_amt)
    FROM kor_loan_status
    WHERE period LIKE '2013%'
    GROUP BY period, gubun
--    HAVING 
--    ORDER BY period
;
-- AFTER_ROLLUP
-- 기간/구분에 따른 단계별 대출총액 조회
-- 기간에 의해서 
SELECT period, gubun, SUM(loan_jan_amt)
    FROM kor_loan_status
    WHERE period LIKE '2013%'
    GROUP BY ROLLUP(period, gubun)
;

-- 표현식 2개 : 2+1레벨
-- 구분에 의해서
SELECT period, gubun, SUM(loan_jan_amt)
    FROM kor_loan_status
    WHERE period LIKE '2013%'
    GROUP BY ROLLUP(gubun, period)
;

-- 표현식  1개 : 1+1레벨
SELECT period, SUM(loan_jan_amt)
    FROM kor_loan_status
    WHERE period LIKE '2013%'
    GROUP BY ROLLUP(period)
;

-- 표현식 3개 : 3+1레벨
SELECT period, gubun, region, SUM(loan_jan_amt)
    FROM kor_loan_status
    WHERE period LIKE '2013%'
    GROUP BY ROLLUP(gubun, period, region)
;

--
SELECT 컬럼1, 컬럼2, 집계함수(표현식)
   FROM 테이블명
   WHERE 조건
   GROUP BY ROLLUP(표현식2, 표현식3)
;
<ROLLUP만 사용한 형태 : 2+1 레벨>
(표현식2, 표현식3)
(표현식2)
(전체)
;

분할 롤업(PARTIAL ROLLUP)
SELECT 컬럼1, 컬럼2, 집계함수(표현식)
   FROM 테이블명
   WHERE 조건
   GROUP BY 표현식1, ROLLUP(표현식2, 표현식3)
;
<ROPPUP만 사용한 형태 : 2+1 레벨>
(표현식1, 표현식2, 표현식3)
(표현식1, 표현식2)
(표현식1)
;

-- 분할 롤업
SELECT 컬럼1, 컬럼2, 집계함수(표현식)
   FROM 테이블명
   WHERE 조건
   GROUP BY 표현식1, ROLLUP(표현식2)
;
<ROPPUP만 사용한 형태 : 1+1 레벨>
(표현식1, 표현식2)
(표현식1)
;

-- 표현식 1개 -> 1+1 레벨
SELECT gubun, period, SUM(loan_jan_amt)
   FROM kor_loan_status
   WHERE period LIKE '2013%'
   GROUP BY gubun, ROLLUP(period)
;

-- CUBE (162p)
-- 표현식 1개 -> 2^1가지 데이터 출력
SELECT gubun, SUM(loan_jan_amt)
    FROM kor_loan_status
    WHERE gubun = '기타대출'
    GROUP BY CUBE(gubun)
;

-- 표현식 2개 -> 2^2가지 데이터 출력
-- CUBE 안의 표현식 순서는 상관없음(출력 순서만 다름)
SELECT period, gubun, SUM(loan_jan_amt)
    FROM kor_loan_status
    WHERE gubun = '기타대출'
    GROUP BY CUBE(gubun, period)
;

SELECT period, gubun, SUM(loan_jan_amt)
    FROM kor_loan_status
    WHERE gubun = '기타대출'
    GROUP BY CUBE(period, gubun)
;

-- 표현식 3개 -> 2^3가지 데이터 출력
SELECT region, period, gubun, SUM(loan_jan_amt)
    FROM kor_loan_status
    WHERE gubun = '기타대출'
    GROUP BY CUBE(gubun, period, region)
;

------------------------------------------------------------
-- 집합연산자
-- 수출 품목
CREATE TABLE exp_goods(
    country VARCHAR2(10)
    , seq   NUMBER
    , goods VARCHAR2(80)
);

INSERT INTO exp_goods VALUES('한국', 1, '원유제외 석유류');
INSERT INTO exp_goods VALUES('한국', 2, '자동차');
INSERT INTO exp_goods VALUES('한국', 3, '전자직접회로');
INSERT INTO exp_goods VALUES('한국', 4, '선박');
INSERT INTO exp_goods VALUES('한국', 5, 'LCD');
INSERT INTO exp_goods VALUES('한국', 6, '자동차부품');
INSERT INTO exp_goods VALUES('한국', 7, '휴대전화');
INSERT INTO exp_goods VALUES('한국', 8, '환식탄화수소');
INSERT INTO exp_goods VALUES('한국', 9, '무선송신기 디스플레이 부속품');
INSERT INTO exp_goods VALUES('한국', 10, '철 또는 비합금강');

INSERT INTO exp_goods VALUES('일본', 1, '자동차');
INSERT INTO exp_goods VALUES('일본', 2, '자동차부품');
INSERT INTO exp_goods VALUES('일본', 3, '전자집적회로');
INSERT INTO exp_goods VALUES('일본', 4, '선박');
INSERT INTO exp_goods VALUES('일본', 5, '반도체웨이퍼');
INSERT INTO exp_goods VALUES('일본', 6, '화물차');
INSERT INTO exp_goods VALUES('일본', 7, '원유제외 석유류');
INSERT INTO exp_goods VALUES('일본', 8, '건설기계');
INSERT INTO exp_goods VALUES('일본', 9, '다이오드, 트랜지스터');
INSERT INTO exp_goods VALUES('일본', 10, '기계류');

COMMIT;

-- 수출품 테이블에서 국가가 한국인 상품명을 모두 조회
-- (단, 품목 번호 순서대로 조회할 것, 오름차순)
SELECT *
    FROM exp_goods
    WHERE country = '한국'
    ORDER BY seq ASC
;


-- 기본 구문
SELECT 컬럼
    FROM 테이블
    WHERE 조건
    GROUP BY 그룹컬럼
    HAVING 그룹 조건
집합연산자
SELECT 컬럼
    FROM 테이블
    WHERE 조건
    GROUP BY 그룹컬럼
    HAVING 그룹 조건
    ORDER BY 컬럼
;

-- UNION
SELECT goods
    FROM exp_goods
    WHERE country = '한국'
UNION
SELECT goods
    FROM exp_goods
    WHERE country = '일본'
    ORDER BY 1  -- 1 : 첫번째 컬럼을 기준으로 조회
;

-- UNION ALL
SELECT goods
    FROM exp_goods
    WHERE country = '한국'
UNION ALL
SELECT goods
    FROM exp_goods
    WHERE country = '일본'
    ORDER BY 1 
;

-- INTERSECT
SELECT goods
    FROM exp_goods
    WHERE country = '한국'
INTERSECT
SELECT goods
    FROM exp_goods
    WHERE country = '일본'
    ORDER BY 1
;

-- MINUS
-- 한국만 수출하는 품목
SELECT goods
    FROM exp_goods
    WHERE country = '한국'
MINUS
SELECT goods
    FROM exp_goods
    WHERE country = '일본'
    ORDER BY 1
;

-- 일본만 수출하는 품목
SELECT goods
    FROM exp_goods
    WHERE country = '일본'
MINUS
SELECT goods
    FROM exp_goods
    WHERE country = '한국'
    ORDER BY 1
;

<주의사항>
1. SELECT 리스트의 개수 및 데이터타입 일치
2. ORDER BY절은 마지막 SELECT 문에서만 사용 가능

--==================================================================
--==================================================================
/*
CH6. 조인과 서브쿼리

***** SQL (DML)
★CRUD : 소프트웨어(DB, 자바, 파이썬, SQL 등)가 가지는 기본적인 데이터 처리 기능
 - CRUP = Create(생성), Read(읽기), Update(수정), Delete(삭제)
 - Create(생성)   → INSERT
 - Read(읽기)     → SELECT
 - Update(수정)   → UPDATE
 - Delete(삭제)   → DELETE
 
***** ★조인(JOIN)
 : 테이블 간의 관계를 맺는 방법
 : 크게 '내부 조인'과 '외부 조인'으로 나뉨

## 내부 조인(INNER JOIN)
 - ★동등 조인
  : 가장 기본적이고 일반적인 조인 방법
  : WHERE절에서 등호('=') 연산자를 사용해 2개 이상의 테이블이나 뷰를 연결한 조인 → 조인조건
  : 컬럼 단위로 조인조건 기술
  : 두 컬럼 값이 같은 행을 추출
    SELECT *
        FROM TAB1 a, TAB2 b
        WHERE a.col1 = b.col1       -- col1 : 기준컬럼
        ....                        -- 컬럼을 기준으로 조인조건을 기술한다.
  
 - 세미 조인(SEMI JOIN)
  : 서브쿼리를 사용해 서브쿼리에 존재하는 데이터만 메인 쿼리에서 추출하는 조인
  : WHERE절에서 IN과 EXISTS 연산자를 사용한 조인방법
  : 세미 조인은 서브쿼리에 존재하는 메인쿼리 데이터가 여러 건 존재하더라도
    최종 반환되는 메인쿼리 데이터에는 중복되는 건이 없다
      ▶ 일반 조인과의 차이점
      
    1> 세미조인(EXISTS) : 조건에 만족하는 데이터가 한건이라도 있으면 결과 반환
    SELECT *
        FROM TAB1 a
        WHERE EXISTS ( SELECT 1
                            FROM TAB2 b
                            WHERE a.col1 = b.col1
                            ....
                    );
    2> 세미조인(IN) : OR 연산자를 사용한 형태와 같다.
    특징
        1. 서브쿼리 조건절에 조인 조건이 없다.
        2. 서브쿼리의 컬럼과 메인쿼리 조건절에 명시된 컬럼이 같다.
     
    SELECT *
    FROM TAB1 a
    WHERE a.col1 IN ( SELECT b.col1
                        FROM TAB2 b
                        WHERE ....
                        ....
                    )
;
 - 안티 조인(ANTI JOIN)
 1> NOT EXISTS
  : 서브쿼리 테이블에는 없는, 메인쿼리 테이블의 데이터만 추출하는 조인 방법
  : WHERE절에서 NOT IN과 NOT EXISTS 연산자를 사용한 조인방법
  : 구문
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
    
 - 셀프 조인(SELF JOIN)
  : 서로 다른 두 테이블이 아닌 동일한 한 테이블을 사용해 조인
    SELECT *
        FROM TAB1 a, TAB1 b
        WHERE a.col1 = b.col1
        ....
    ;

## 외부 조인(OUTER JOIN)
 : 일반 조인을 확장한 개념
 : 조인 조건에 만족하는 데이터 뿐만 아니라,
   어느 한 쪽 테이블에 조인 조건에 명시된 컬럼에 값이 없거나(NULL이더라도)
   해당 로우가 아예 없더라도 데이터를 모두 추출
 : 조인조건에서 데이터가 없는 쪽 테이블의 컬럼 끝에 (+)를 붙인다
 : 조인조건이 여러 개일 경우 모든 조인조건에 (+)를 붙여야 한다
 <특징>
    1. 기준 컬럼이 아닌 컬럼에 (+) 표시. 즉 null 값이 포함됨
    2. 외부조인 시, 조인조건 2개 상인 경우, 모든 조인 조건에 (+) 표시할 것.
    3. (+) 연산자가 붙은 조건과 OR 와 IN 연산자를 같이 사용 불가.
    4. 한번에 한 테이블에만 외부 조인 가능.

-- 일반조인, 결과는 10건
    SELECT a.department_id, a.department_name, b.job_id, b.department_id
        FROM departments a
            , job_history b
        WHERE a.department_id = b.department_id
    ;

-- 외부조인, 결과는 31건
    SELECT a.department_id, a.department_name, b.job_id, b.department_id
        FROM departments a
            , job_history b
        WHERE a.department_id = b.department_id(+)
    ;
    
 - 카타시안 조인(CATASIAN PRODUCT, 외부조인)
  : 잘 안 쓰임
  : 조인조건이 없는 조인
  : FROM 절에 A와 B, 2개의 테이블을 명시했을 경우, 추출되는 데이터는
    A 테이블 데이터 건수 * B 테이블 데이터 건수

 - ANSI 내부조인(안시조인)
  : 오라클 외의 다른 SQL에서도 사용가능한 표준 내부조인
  : 내부조인의 경우 FROM 절에 INNER JOIN을 명시
  : 조인조건은 ON 절에 명시
  : 테이블간 조인조건 외의 다른 조건은 WHERE절에 명시한다.
  [구문]
    SELECT A.컬럼1, A.컬럼2, B.컬럼1, B.컬럼2, ...
        FROM 테이블 A
        INNER JOIN 테이블 B
        ON (A.컬럼1 = B.컬럼1)  -- 조인조건
        WHERE....
    ;
 - ANSI 외부조인
  : FROM절에 LEFT(RIGHT) [OUTER] JOIN을 명시, 조인조건은 ON절에 명시
  : 일반외부조인에서는 기준테이블과 대상테이블(데이터가 없는 테이블)에서
    대상 테이블쪽 조인 조건에 (+)을 붙였지만,
    ANSI 외부 조인은 FROM절에 명시된 테이블 순서에 입각해
    먼저 명시된 테이블 기준으로 LEFT 혹은 RIGHT을 붙인다
  : OUTER는 생략 가능
  [구문]
    SELECT A.컬럼1, A.컬럼2, B.컬럼1, B.컬럼2, ...
        FROM 테이블 A
        LEFT(RIGHT) [OUTER] JOIN 테이블 B
        ON (A.컬럼1 = B.컬럼1)  -- 조인 조건
        WHERE ....
    ;
    
 - ANSI CROSS 조인
  : 카타시안 조인을 ANSI 조인에서는 CROSS 조인이라 함
  : FROM 절에 CROSS JOIN 명시
  [구문]
    SELECT A.컬럼1, A.컬럼2, B.컬럼1, B.컬럼2, ...
        FROM 테이블 A
        CROSS JOIN 테이블 B
        WHERE
    ;
    
 - ANSI FULL OUTER 조인
  : 일반적인 외부 조인은 두 테이블 중 어느 한 테이블에
    조인 조건에 만족하는 데이터가 없더라도
    두 테이블 데이터 모두 조회하는 조인 ▶ 한쪽 이빨이 빠진 형태
  : 한 쪽 테이블이 아닌 두 테이블 모두 데이터가 없는 경우,
    두 쪽 테이블 모두 이빨이 빠진 형태의 결과가 추출되는 외부조인이 FULL OUTER 조인이다.
  : 조인조건을 기준으로 두 테이블 중 어느 한 쪽에만 데이터가 있으면 조회된다.
  : FROM 절에 FULL OUTER JOIN 명시
  : FULL OUTER JOIN은 
  [구문]
    SELECT a.emp_id, b.emp_id
        FROM hong_a a
        FULL OUTER JOIN hong_b b
        ON (a.emp_id = b.emp_id)
    ;

*/
--==================================================================
[동등 조인(내부조인)]
-- 동등조인 : 조건절에 등호('=')를 사용해서 2개 테이블을 연결
SELECT T1.컬럼, T2.컬럼
    FROM 테이블1 T1, 테이블2 T2
    WHERE T1.컬럼명 = T2.컬럼명       -- 이때, 컬럼명은 같아야 함
;
-- 동등조인 예제(177p)
/* employees 테이블과 departments 테이블에서는
    manager_id, department_id를 기준컬럼(조건)으로 사용할 수 있다.*/

-- 기준컬럼(department_id)를 기준으로
-- 왼쪽에는 employees 테이블, 오른쪽에는 departments 테이블의 내용이 온다.
/* 기준컬럼(department_id)는 동일하나,
   기준컬럼이 아닌 (manager_id)는 다른 값이 나옴 ▶ 기준컬럼으로 삼고, 안삼고의 차이
 ∵ 기준컬럼 자체가 해당 컬럼을 기준으로 동일한 값을 가진 로우를 출력하므로 */
SELECT *
    FROM employees e, departments d
    WHERE e.department_id = d.department_id
;

-- 기준컬럼 : manager_id
SELECT *
    FROM employees e, departments d
    WHERE e.manager_id = d.manager_id
;

-- employees 테이블의 employee_id 컬럼 조회
SELECT e.employee_id
    FROM employees e, departments d
    WHERE e.manager_id = d.manager_id
;

-- employees 테이블의 department_id 컬럼 조회
SELECT e.department_id
    FROM employees e, departments d
    WHERE e.manager_id = d.manager_id
;

-- departments 테이블의 department_id 컬럼 조회
SELECT d.department_id
    FROM employees e, departments d
    WHERE e.manager_id = d.manager_id
;

--
SELECT e.employee_id, d.department_id
    FROM employees e, departments d
    WHERE e.manager_id = d.manager_id
;

-- 예제(177p)
/*
 employees 테이블에 없는 부서명(department_name)을 함께 조회하는 것이 목적
 - 사원, 부서 테이블의 공통 컬럼 department_id를 동등 조인의 조건으로 사용하여 조회
 - department_id는 departments 테이블에서 Primary Key이므로 필수 값이지만,
   employees 테이블에는 필수 값이 아니므로,
   employees 테이블에서 department_id 값이 있는 건만 추출함
*/
SELECT e.employee_id, e.emp_name, e.department_id, d.department_name
    FROM employees e, departments d
    WHERE e.department_id = d.department_id
;

--==================================================================
[세미 조인(내부조인)]
 : 서브쿼리에 존재하는 데이터만 메인 쿼리에서 추출하는 조인

-- 세미조인1> EXISTS 연산자 : 조건에 만족하는 데이터가 한건이라도 있으면 결과 반환
SELECT 컬럼
    FROM 테이블1
    WHERE EXISTS(
                SELECT 컬럼
                    FROM 테이블2
                    WHERE 테이블1.컬럼 = 테이블2.컬럼
);

-- 부서번호, 부서이름 조회
-- 사원이 근무하고 있는 부서번호와 이름 조회
SELECT department_id, department_name
    FROM departments d
    WHERE EXISTS(
                SELECT *
                    FROM employees e
                    WHERE d.department_id = e.department_id
                        AND e.salary > 3000
                )
;

-- 세미조인2> IN 연산자 : OR 연산자를 사용한 형태와 같다.
/* 특징
1. 서브쿼리 조건절에 조인 조건이 없다.
2. 서브쿼리의 컬럼과 메인쿼리 조건절에 명시된 컬럼이 같다. */
SELECT 컬럼
    FROM 테이블
    WHERE  컬럼  IN ( SELECT 컬럼
                        FROM 테이블
                        WHERE 조건
                      )
;

-- 예제> 세미조인(IN 연산자, 178p)
사원테이블에서 급여가 3000만원 이상인 사원의 부서번호를 조회해서
부서테이블의 부서번호에 내용이 포함되어 있으면
부서 번호와 부서 이름을 조회
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
[안티조인]

-- 서브쿼리 : 팀장이 없는 부서 번호 조회
SELECT department_id
    FROM departments
    WHERE manager_id IS NULL
;
-- 메인쿼리(동등조건) : 사원테이블과 부서테이블에서 사원번호, 사원명, 부서번호, 부서명을 조회
SELECT e.employee_id, e.emp_name, e.department_id, d.department_name
    FROM employees e, departments d
    WHERE e.department_id = d.department_id
;

-- 사원테이블과 부서테이블에서 
-- [팀장이 없는 부서 번호를 조회하여 메인쿼리의 내용과 일치하면]
-- 사원번호, 사원명, 부서번호, 부서명을 조회
SELECT e.employee_id, e.emp_name, e.department_id, d.department_name
    FROM employees e, departments d
    WHERE e.department_id = d.department_id
        AND e.department_id IN ( SELECT department_id
                                    FROM departments
                                    WHERE manager_id IS NULL
                               )
;

-- 안티조인1> NOT EXISTS
서브쿼리
SELECT *
    FROM departments
    WHERE manager_id IS NULL;
        AND 조인조건
;

메인쿼리
SELECT employee_id, emp_name, department_id
    FROM employees;
--    WHERE 조건

-- 팀장이 없는 부서에 존재하지 않는 데이터에서 사원 정보를 조회
SELECT employee_id, emp_name, department_id
    FROM employees e
    WHERE NOT EXISTS ( SELECT *
                        FROM departments d
                        WHERE manager_id IS NULL
                            AND e.department_id = d.department_id
                   )
;

-- 안티조인2> NOT IN
SELECT e.employee_id, e.emp_name, e.department_id, d.department_name
    FROM employees e, departments d
    WHERE e.department_id = d.department_id
        AND e.department_id NOT IN ( SELECT department_id
                                    FROM departments
                                    WHERE manager_id IS NULL
                               )
;
--==================================================================
-- [셀프조인(SELF JOIN) 사용 예시]
SELECT employee_id, emp_name, manager_id
    FROM employees
    WHERE salary>9000 and salary<11000
;

SELECT 
    FROM employees e1, employees e2
    WHERE e1.manager_id = e2.employee_id
;

--==================================================================

[외부조인(OUTTER JOIN)]
-- 일반조인, 결과는 10건
 [동등조인] : 기준컬럼의 값이 동일하고 NULL 값이 미포함
SELECT a.department_id, a.department_name, b.job_id, b.department_id
    FROM departments a
        , job_history b
    WHERE a.department_id = b.department_id
;

-- 외부조인, 결과는 31건
 [외부조인] : 기준컬럼의 값이 동일하지 않고, NULL 값이 포함
          (기준컬럼 값은 NULL이 있으면 동일하지 않고, NULL이 아니면 동일함)
    ▶ 기준 컬럼이 아닌 컬럼에 (+) 표시. 즉 null 값이 포함됨
SELECT a.department_id, a.department_name, b.job_id, b.department_id
    FROM departments a
        , job_history b
    WHERE a.department_id = b.department_id(+)
;

-- 만약, a.department_id에 외부조인을 해주면, 의미 없음.
-- 동등조인과 같은 결과 조회됨
--SELECT a.department_id, a.department_name, b.job_id, b.department_id
--    FROM departments a
--        , job_history b
--    WHERE a.department_id(+) = b.department_id;

-- 외부조인 예제(182p)
-- 외부조인할 때 조인조건이 2개 이상인 경우, 모든 조인 조건에 (+) 표시 할 것.
SELECT e.employee_id, e.emp_name, j.job_id, j.department_id
    FROM employees e
        , job_history j
    WHERE e.employee_id = j.employee_id(+)
        AND e.department_id = j.department_id(+)
;

-- (+) 연산자가 붙은 조건과 OR 와 IN 연산자를 같이 사용 불가.
-- 결과 : 포괄 조인 운영 (+)는 OR 또는 IN의 연산수를 허용하지 않습니다
SELECT e.employee_id, e.emp_name, j.job_id, j.department_id
    FROM employees e
        , job_history j
    WHERE e.employee_id = j.employee_id(+)
        OR e.department_id = j.department_id(+)
;

--==================================================================

-- ANSI 내부조인
<오라클 조인 : 동등 조인>
SELECT A.컬럼1, A.컬럼2, B.컬럼1, B.컬럼2
    FROM 테이블 A, 테이블 B
    WHERE A.컬럼1 = B.컬럼1     -- 조인조건
    ....
;

<ANSI 조인>
SELECT A.컬럼1, A.컬럼2, B.컬럼1, B.컬럼2
    FROM 테이블 A, 테이블 B
    INNER JOIN 테이블 B
    ON (A.컬럼1 = B.컬럼1)     -- 조인조건
    WHERE ....
    ....
;

-- ANSI 내부조인 예시(187p)
SELECT e.employee_id, d.department_name
        , TO_CHAR(e.hire_date, 'YYYY-MM-DD') AS hire_date
    FROM employees e
    INNER JOIN departments d
    ON e.department_id = d.department_id
    WHERE e.hire_date >= TO_DATE('2003-01-01', 'YYYY-MM-DD')
;

[INNER JOIN ~ USING]
 : 조인 조건 컬럼이 두 테이블 모두 동일하다면 ON 대신 USING 절 사용 가능.
   그러나, USING 대신 ON 절을 사용하는 것이 일반적이다.
   
-- ANSI 외부조인
<오라클 조인 : 외부 조인>
SELECT A.컬럼1, B.컬럼1
    FROM 테이블1 A, 테이블2 B
    WHERE A.컬럼 = B.컬럼(+)
;

<ANSI 외부조인>
SELECT A.컬럼1, B.컬럼1
    FROM 테이블1 A
    LEFT OUTER JOIN 테이블2 B
    ON A.컬럼1 = B.컬럼1
    WHERE 조건
;

-- ANSI 외부조인 예시(187p)
-- LEFT> 기준 테이블 : employees
SELECT e.employee_id, e.emp_name, j.job_id, j.department_id
    FROM employees e
    LEFT OUTER JOIN job_history j
    ON e.employee_id = j.employee_id
        AND e.department_id = j.department_id
;
-- OUTER 생략 가능
SELECT e.employee_id, e.emp_name, j.job_id, j.department_id
    FROM employees e
    LEFT JOIN job_history j
    ON e.employee_id = j.employee_id
        AND e.department_id = j.department_id
;

-- RIGHT> 기준 테이블 : job_history
SELECT e.employee_id, e.emp_name, j.job_id, j.department_id
    FROM employees e
    RIGHT OUTER JOIN job_history j
    ON e.employee_id = j.employee_id
        AND e.department_id = j.department_id
;
-- OUTER 생략가능
SELECT e.employee_id, e.emp_name, j.job_id, j.department_id
    FROM employees e
    RIGHT JOIN job_history j
    ON e.employee_id = j.employee_id
        AND e.department_id = j.department_id
;

-- CROSS 조인
<오라클 조인 : 카타시안 조인>
SELECT 컬럼
    FROM 테이블1 T1, 테이블2 T2
    WHERE 조건
;

<ANSI 조인 : CROSS 조인>
SELECT 컬럼
    FROM 테이블1 T1
    CROSS JOIN 테이블2 T2
;

-- CROSS 조인 예제(188p)
SELECT e.emp_name, d.department_name
    FROM employees e
    CROSS JOIN departments d
;

-- FULL OUTER 조인
CREATE TABLE 사원(
    사원번호    NUMBER
    , 사원이름  VARCHAR2(20)
    , 부서번호  NUMBER
);

CREATE TABLE 부서(
    부서번호        NUMBER
    , 부서명       VARCHAR2(20)
    , 관리자번호     NUMBER
);

INSERT INTO 사원 VALUES(100, '유재석', 10);
INSERT INTO 사원 VALUES(101, '강호동', 20);
INSERT INTO 사원 VALUES(102, '김구라', 50);
INSERT INTO 사원 VALUES(103, '김희철', 30);
INSERT INTO 사원 VALUES(105, '이경규', 50);
INSERT INTO 사원 VALUES(106, '박나래', 60);

INSERT INTO 부서 VALUES(10, '개발팀', 1);
INSERT INTO 부서 VALUES(20, '유지보수팀', 2);
INSERT INTO 부서 VALUES(30, '연구소', 3);
INSERT INTO 부서 VALUES(40, '영업팀', 4);
INSERT INTO 부서 VALUES(50, '인사팀', 5);
INSERT INTO 부서 VALUES(70, '기획부', 7);
INSERT INTO 부서 VALUES(70, '기획부', 7);

-- FULL OUTER JOIN 
SELECT e.사원이름, d.부서명
    FROM 사원 e
    FULL OUTER JOIN 부서 d
    ON e.부서번호 = d.부서번호
;

--==================================================================

[서브쿼리]
 - 한 SQL 문장 안에서 보조로 사용되는 
[서브쿼리의 종류]
 - 메인쿼리와의 연관성에 따라
  : 연관성 없는(Noncorrelated) 서브쿼리
  : 연관성 있는 서브쿼리
 - 형태에 따라
  : 일반 서브쿼리(SELECT절)
  : 인라인 뷰(FROM절)
  : 중첩쿼리(WHERE절)
[연관성 없는 서브쿼리]
 - 메인쿼리와의 연관성이 없는 서브쿼리 → 메인 테이블과 조인 조건이 걸리지 않음
 - 유형1
   SELECT count(*)
        FROM employees
        WHERE salary >= (SELECT AVG(salary) FROM employees);
 - 유형2
    SELECT count(*)
        FROM employees
        WHERE department_id IN (SELECT department_id
                                    FROM departments
                                    WHERE parent_id IS NULL);
[연관성 있는 서브쿼리]
 - 메인쿼리와의 연관성이 있는 서브쿼리 → 메인 테이블과 조인 조건이 걸려있다
 - 유형1
    SELECT a.department_id, a.department_name
        FROM departments a
        WHERE EXISTS (SELECT 1
                        FROM job_history b
                        WHERE a.department_id = b.department_id);

-- 서브쿼리
SELECT AVG(salary)
    FROM employees
;

-- 메인쿼리 : 내 급여가 평균의 아래?위?
-- 총 사원수(107) 평균 더 많이(51명)
SELECT COUNT(*)
    FROM employees
    WHERE salary >= (SELECT AVG(salary) FROM employees)
;

-- 서브쿼리 : 상급부서가 없는 부서번호 조회
SELECT department_id
    FROM departments
    WHERE parent_id IS NULL
;

-- 메인쿼리 : 상급부서가 없는 부서의 개수 조회
SELECT count(*)
    FROM departments
    WHERE department_id IN (SELECT department_id
                                FROM departments
                                WHERE parent_id IS NULL)
;

-- 서브쿼리 : 경력테이블로부터 사원번호와 직업번호 조회
SELECT employee_id, job_id
    FROM job_history
;

-- 메인쿼리 : 사원테이블에서 사원이름과 매칭 조회
-- 동시에 2개의 컬럼 값이 동일한 경우
SELECT employee_id, emp_name, job_id
    FROM employees
    WHERE (employee_id, job_id) IN (SELECT employee_id, job_id
                                        FROM job_history)
;

-- 1개 컬럼 값이 동일한 경우
SELECT employee_id, emp_name, job_id
    FROM employees
    WHERE employee_id IN (SELECT employee_id
                                FROM job_history)
;

COMMIT;

-- 사원테이블의 급여를 전직원 동일하게 평균급여로 수정
UPDATE employees
SET salary = (SELECT AVG(salary) FROM employees)
;
ROLLBACK;

-- 평균 급여보다 많이 받는 사람 삭제
SELECT COUNT(*) FROM employees;

DELETE employees
WHERE salary >= (SELECT AVG(salary) FROM employees)
;


-- 연관성이 있는 서브쿼리 : 조인 조건 있음!
-- 서브쿼리 : 경력테이블에서 부서번호 조회
SELECT department_id
    FROM job_history b
;

-- 메인쿼리 : 경력테이블에서 조회된 부서번호를 부서명과 함께 조회
SELECT department_id, department_name
    FROM departments d
    WHERE EXISTS (SELECT department_id
                        FROM job_history j
                        WHERE d.department_id = j.department_id)
;

-- 서브쿼리 : 사원테이블에서 사원명 조회(107건)
SELECT emp_name
    FROM employees
;

-- 서브쿼리 : 부서테이블에서 부서명 조회(27건)
SELECT department_name
    FROM departments
;

-- 메인쿼리 : 사원번호, 사원명, 부서번호, 부서명 조회
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

-- 최종 결과
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

-- 서브쿼리 : 사원테이블에서 평균 급여 조회
SELECT AVG(salary)
    FROM employees
;
-- 서브쿼리 : 평균급여보다 ㄴ높은 급여를 받는 사원의 부서번호 조회
SELECT department_id
    FROM employees
    WHERE salary > (SELECT AVG(salary) FROM employees)
;
-- 메인쿼리 : 평균급여보다 높은 급여를 받는 사원의 부서번호와 매칭되는 부서명 조회
SELECT d.department_id, d.department_name
    FROM departments d
    WHERE EXISTS (SELECT department_id
                    FROM employees e
                    WHERE d.department_id = e.department_id -- 연관성 있는 서브쿼리
                        AND e.salary > (SELECT AVG(salary) FROM employees))
;

-- 서브쿼리 : 부서테이블에서 상위부서(번호)가 90번인 부서번호 조회
SELECT department_id
    FROM departments
    WHERE parent_id = 90
;

-- 서브쿼리 : 사원테이블에서 상위부서(번호)가 90번인 부서번호, 평균급여 조회
SELECT e.department_id, AVG(e.salary)
    FROM employees e
         , departments d
    WHERE parent_id = 90
        AND e.department_id = d.department_id
    GROUP BY e.department_id
;

-- 서브쿼리 : (사원테이블에서 상위부서(번호)가 90번인 부서번호, 평균급여)에서 평균급여 조회
SELECT avg_sal
    FROM (SELECT e.department_id, AVG(e.salary) avg_sal
                FROM employees e
                    , departments d
                WHERE parent_id = 90
                    AND e.department_id = d.department_id
                GROUP BY e.department_id)
--    WHERE 조건
;

-- 메인쿼리 : 상위부서가 90번(기획부)인 모든 사원의 급여를 자신의 부셔별 평균급여로 갱신
-- [부서별 평등화]
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

UPDATE 사원테이블 e1
SET    e1.급여 = (부서별 평균급여[서브쿼리])
WHERE e1.부서번호 IN (상위부서가 기획부인 부서[서브쿼리])
;

--==================================================================

[인라인 뷰]
 - FROM절에 사용하는 서브쿼리
 SELECT a.employee_id, a.emp_name, b.department_id, b.department_name
    FROM employees a
        , departments b
        , (SELECT AVG(c.salary) AS avg_salary
                FROM departments b
                    , employees c
                WHERE b.parent_id = 90  -- 기획부
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
                WHERE b.parent_id = 90  -- 기획부
                    AND b.department_id = e.department_id) d
    WHERE a.department_id = b.department_id
        AND a.salary > d.avg_salary
;

-- 인라인뷰 : FROM절에 사용된 서브쿼리
-- 서브쿼리
/*
    판매테이블로부터 판매월, 평균판매금액 조회
조건1: 2000년 1월~2000년 12월까지 판매된
조건2: 이탈리아에서 판매된
*/

SELECT sales_month, ROUND(AVG(amount_sold)) month_avg
    FROM sales s, countries c, customers cu
    WHERE sales_month BETWEEN 200001 AND 200012
        AND country_name = 'Italy'
        AND c.country_id = cu.country_id
        AND cu.cust_id = s.cust_id
    GROUP BY sales_month
;

[문제] 조인 → 도시테이블 + 판매테이블 : 공통된 컬럼이 없다!
 [나라테이블 + 고객테이블 + 판매테이블]
 [나라번호     나라번호]
             [고객번호     고객번호]

<서브쿼리2> : 판매테이블로부터 평균판매금액 조회
조건1: 2000년1월~2000년12월까지 판매된
조건2: 이탈리아에서 판매된

SELECT ROUND(AVG(s.amount_sold)) year_avg
    FROM sales s, countries c, customers cu
    WHERE sales_month BETWEEN 200001 AND 200012
        AND country_name = 'Italy'
        AND c.country_id = cu.country_id
        AND cu.cust_id = s.cust_id
;

<메인쿼리>
2000년 이탈리아 평균 매출액(연평균)보다 큰 매출액을 달성한 월의 평균 매출액을 조회
연평균판매액 : 180
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
CH8. PL/SQL의 구조와 구성요소
/*
[블록]
 - PL/SQL 소스 프로그램의 기본 단위
 - 선언부, 실행부, 예외 처리부로 구성
 - [구문]
    이름부
 IS(AS)
    선언부
 BEGIN
    실행부
 EXCEPTION
    예외 처리부
 END;
[블록 구문]
 - 이름부 : 블록의 명칭, 생략 시 익명 블록이 된다.
 - 선언부 : DECLARE로 시작. 
           실행부와 예외 처리부에서 사용할 각종 변수, 상수, 커서 등을 선언
           변수 선언과 각 문장의 끝에 반드시 세미콜론(;)을 찍어야 한다.
 - 실행부 : 실제 로직을 처리하는 부분
           각종 문장(일반 SQL문, 조건문, 반복문 등)이 온다.
           DML문만 사용가능
 - 예외 처리부 : EXCEPTION 절로 시작.
                실행부에서 로직 처리 중 오류 발생 시 처리할 내용 기술 생략 가능

[익명블록]
 - 블록 명칭이 생략이 된 경우 이를 익명블록(anonymous block)이라 한다.
 - 익명블록 ex)
    DECLARE
        vi_num NUMBER;
    BEGIN
        vi_num := 100;
        DBMS_OUTPUT.PUT_LINE(vi_num);
    END;
    
[변수]
 - 변수선언
   변수명 데이터타입 := 초기값;
 - 초기값을 할당하지 않는 경우는 NULL 값이 할당됨
 - 변수 데이터 타입 : SQL 타입과 PL/SQL 타입
 - PL/SQL 데이터 타입 : BOOLEAN, PLS_INTEGER, BINARY_INTEGER
 
[상수]
 - 상수선언
   상수명 CONSTANT 데이터타입 := 상수값;
 - 변수와는 달리 한 번 값을 할당하면 변하지 않는다
 - 상수 역시 SQL 타입과 PL/SQL 타입 사용 가능
 
[DML 문]
 - PL/SQL 블록의 실행부에서 사용
 - SELECT INTO : 테이블에서 특정 값을 선택해 변수에 할당할 경우 사용
   SELECT a.emp_name, b.department_name
   INTO vs_emp_name, vs_dep_name
        FROM employees a
            , departments b
        WHERE a.department_id = b.department_id
        AND a.employee_id = 100
    ;
 - 테이블의 특정 컬럼 타입을 변수 타입으로 선언 가능
   변수명 테이블명.컬럼명%TYPE;

[라벨]
 - PL/SQL 프로그램 상에서 특정 부분에 이름을 부여
 - <<라벨명>> 형태로 사용
 - GOTO 문과 함께 사용되어 해당 라벨로 제어권 이동 가능
   GOTO 라벨명;
   
[PRAGMA 키워드]
 - 컴파일러가 실행되기 전에 처리하는 전처리기
 - PRAGMA AUTONOMOUS_TRANSACTION
   현재 블록의 독립적 트랜잭션 처리 시 사용
 - PRAGMA EXCEPTION_INIT (예외명, 예외번호)
   사용자 정의 예외 처리 시 사용. 특정 예외번호를 사용자 정의 예외로 사용하는 역할
 - PRAGMA RESTRICT_REFERECES (서브 프로그램명, 옵션)
   패키지에 속한 서브 프로그램(주로 함수에 사용)에서 옵션 값에 따라 특정 동작을 제한
 - PRAGMA SERIALLY_RESUABLE
   패키지에 선언된 변수에 대해 한 번 호출 된 후 메모리를 해제

★[함수] : [입력값을 활용하여] 특정 연산을 수행 후 결과 값 반환
★[프로시저] : 특정 로직을 처리하고 결과 값은 반환하지 않음. 서브 프로그램.
*/

[:=]    => 우항의 값을 좌항에 할당

-- 익명블록

DECLARE
    vi_num NUMBER;      -- vi_num 이름으로 변수 선언(생성)
BEGIN
    vi_num := 100;
    DBMS_OUTPUT.PUT_LINE(vi_num);       -- 함수(기능) : 로그 확인
END;        -- 프로그램 작성이 끝났음 => SQL*PLUS 설정 여부에 따라 선택사용
-- PL/SQL 프로시저가 성공적으로 완료되었습니다. => 컴파일 + 실행완료
-- 상단바 - 보기 - DBMS 출력 - ORA_USER 유저 접속
/

DECLARE
    -- a는 2의2승 곱하기 3의2승
    a INTEGER := 2**2*3**2;
    b NUMBER := 3+4;
BEGIN
    /* DBMS_OUTPUT.PUT_LINE() : DBMS 출력으로 입력값에 대한 로그 확인 */
    DBMS_OUTPUT.PUT_LINE('a=' || TO_CHAR(a));
    DBMS_OUTPUT.PUT_LINE('b=' || b);        -- 자동형변환
    DBMS_OUTPUT.PUT_LINE(b);
END;
/

DECLARE
    -- a는 2의2승 곱하기 3의2승
    a INTEGER := 2**2*3**2;
    b NUMBER := 3+4;
    c VARCHAR2(30) := '우리나라';
    d BOOLEAN := false;
BEGIN
    DBMS_OUTPUT.PUT_LINE('a=' || TO_CHAR(a));
    DBMS_OUTPUT.PUT_LINE('b=' || b);        -- 자동형변환
    DBMS_OUTPUT.PUT_LINE(b);
    DBMS_OUTPUT.PUT_LINE(C);
    DBMS_OUTPUT.PUT_LINE('D=' || CASE WHEN d THEN 'true' ELSE 'false' END);
END;
/

DECLARE
    -- vs_emp_name VARCHAR2(8);   -- 잘못된 데이터타입 설정 위험!
    vs_emp_name employees.emp_name%TYPE;
    vs_dep_name VARCHAR2(80);   -- 변수 선언
BEGIN
    DBMS_OUTPUT.PUT_LINE('=============================');
    SELECT e.emp_name, d.department_name
    INTO vs_emp_name, vs_dep_name   
    -- INTO절에는 테이블에 있는 데이터를 선택해 변수에 할당할 때 사용
    -- 이때, 선택하는 컬럼의 변수의 순서, 개수, 데이터 타입을 반드시 맞춰줄 것.
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