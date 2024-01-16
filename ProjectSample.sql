-- [환율 테이블] → Area
--==================================================================
-- Area 테이블 생성
CREATE TABLE Area (
    code NUMBER,
    name VARCHAR2(10),
    is_around NUMBER,
    country_code NUMBER
);

-- Area 테이블에 데이터 입력
INSERT INTO Area VALUES(1, '북평', 0, 1);