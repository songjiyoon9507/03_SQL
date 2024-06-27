------------------------------------------------------
-- cowork final project
-- SEQ_테이블명
-- 관리자에서 회의실 정보 넣을 때 필요한 것
-- seq_meeting_room
-- meeting_room_nm
-- com_no 회사 기본키
SELECT * FROM COMPANY;
SELECT * FROM EMPLOYEE;
SELECT * FROM MEETING_ROOM;
SELECT * FROM TEAM;
-- 회사 정보 하나 넣어야함
INSERT INTO "COMPANY" VALUES (
	SEQ_COMPANY.NEXTVAL,
	'COWORK COMPANY',
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL
);

COMMIT;

-- 회사에 따른 회의실 정보 넣어야함
INSERT INTO MEETING_ROOM VALUES (
	SEQ_MEETING_ROOM.NEXTVAL,
	'1층 회의실',
	1
);

SELECT MEETING_ROOM_NO, MEETING_ROOM_NM
FROM MEETING_ROOM
WHERE COM_NO = 1;

SELECT * FROM MEETING_ROOM;

SELECT * FROM DEPARTMENT;

INSERT INTO DEPARTMENT VALUES (SEQ_DEPARTMENT.NEXTVAL, '2부서', 9);

COMMIT;

SELECT DEPT_NO, DEPT_NM
FROM DEPARTMENT
WHERE COM_NO = 1;

-- 회사 부서 개수 조회
SELECT COUNT(*) FROM DEPARTMENT WHERE COM_NO = 1; 

SELECT * FROM TEAM;
INSERT INTO TEAM VALUES (SEQ_TEAM.NEXTVAL, '1부서 2팀', 4);

COMMIT;

SELECT * FROM TEAM;
UPDATE TEAM SET TEAM_NM = '9회사 1부서 2팀' WHERE TEAM_NO = 5;
UPDATE EMPLOYEE SET COM_NO = 1 WHERE EMP_CODE = 16;

SELECT * FROM EMPLOYEE;

UPDATE EMPLOYEE SET COM_NO = 1 WHERE EMP_CODE = 60;

COMMIT;

SELECT * FROM CALENDAR;

SELECT * FROM RESERVE_INFO;

ALTER TABLE COWORK.RESERVE_INFO MODIFY COM_RESERVE VARCHAR2(3000) NULL;

-- 캘린더 컬럼 삭제
ALTER TABLE CALENDAR DROP COLUMN CALENDAR_WRITE_DATE;
ALTER TABLE CALENDAR DROP COLUMN CALENDAR_UPDATE_DATE;
ALTER TABLE CALENDAR DROP COLUMN TEAM_SHARE;
ALTER TABLE CALENDAR DROP COLUMN CALENDAR_START;
ALTER TABLE CALENDAR DROP COLUMN CALENDAR_END;
ALTER TABLE CALENDAR DROP COLUMN COM_NO_LIST;
ALTER TABLE CALENDAR DROP COLUMN DEPT_NO_LIST;
ALTER TABLE CALENDAR DROP COLUMN TEAM_NO_LIST;
ALTER TABLE CALENDAR DROP COLUMN CALENDAR_SHARE;
ALTER TABLE RESERVE_INFO DROP COLUMN RESERVE_INFO_END;

-- date 타입에서 문자 타입으로 바꾸기
ALTER TABLE CALENDAR MODIFY CALENDAR_START VARCHAR2(3000);
ALTER TABLE CALENDAR MODIFY CALENDAR_END VARCHAR2(3000);

-- 컬럼명 바꾸기
ALTER TABLE CALENDAR RENAME COLUMN COM_SHARE TO COM_NO_LIST;
ALTER TABLE CALENDAR RENAME COLUMN DEPT_SHARE TO DEPT_NO_LIST;
ALTER TABLE CALENDAR RENAME COLUMN TEAM_SHARE TO TEAM_NO_LIST;
ALTER TABLE CALENDAR RENAME COLUMN SHARE_LIST TO CALENDAR_SHARE;

-- 캘린더 컬럼 추가 회사 공유 여부, 부서 공유 여부, 팀 공유 여부
ALTER TABLE CALENDAR ADD COM_SHARE VARCHAR2(30) NULL;
ALTER TABLE CALENDAR ADD COM_NO NUMBER;
ALTER TABLE CALENDAR ADD DEPT_SHARE VARCHAR2(3000) NULL;
ALTER TABLE CALENDAR ADD TEAM_SHARE VARCHAR2(3000) NULL;
ALTER TABLE CALENDAR ADD SHARE_LIST VARCHAR2(3000) NULL;
ALTER TABLE CALENDAR ADD CALENDAR_START VARCHAR2(3000) NOT NULL;
ALTER TABLE CALENDAR ADD CALENDAR_END VARCHAR2(3000) NOT NULL;
ALTER TABLE RESERVE_INFO ADD RESERVE_INFO_START VARCHAR2(3000) NOT NULL;
ALTER TABLE RESERVE_INFO ADD RESERVE_INFO_END VARCHAR2(3000) NOT NULL;
ALTER TABLE RESERVE_INFO ADD TEAM_RESERVE VARCHAR2(3000) NOT NULL;
ALTER TABLE RESERVE_INFO ADD DEPT_RESERVE VARCHAR2(3000) NOT NULL;
ALTER TABLE RESERVE_INFO ADD COM_RESERVE VARCHAR2(3000) NOT NULL;

UPDATE CALENDAR SET COM_NO = 1 WHERE CALENDAR_NO = 3;
UPDATE CALENDAR SET COM_NO = 1 WHERE CALENDAR_NO = 4;
UPDATE CALENDAR SET COM_NO = 1 WHERE CALENDAR_NO = 6;
UPDATE CALENDAR SET COM_NO = 1 WHERE CALENDAR_NO = 7;
UPDATE EMPLOYEE SET TEAM_NO = 1 WHERE EMP_CODE = 60;

-- NOT NULL 추가하기
ALTER TABLE CALENDAR MODIFY (COM_NO NOT NULL);

-- 캘린더 seq 생성
CREATE SEQUENCE SEQ_CALENDAR NOCACHE;

INSERT INTO CALENDAR VALUES(
	SEQ_CALENDAR.NEXTVAL,
	'첫번째 일정 작성',
	'내용 작성',
	'#fc8b8b',
	60,
	NULL,
	1,
	NULL,
	2024-06-05,
	2024-06-07
);

-- 행 삭제
DELETE FROM CALENDAR WHERE CALENDAR_NO = 59;
SELECT * FROM CALENDAR;
COMMIT;

-- EMP_CODE = 60 TEAM_NO 1 개발1팀, DEPT_NO 1 TEAM 테이블에 들어있음 개발팀
SELECT * FROM TEAM;
SELECT * FROM DEPARTMENT;
SELECT * FROM EMPLOYEE WHERE EMP_CODE = 57;
SELECT * FROM CALENDAR;

-- EMPLOYEE 테이블에서 EMP_CODE 한개당 COM_NO 1개 TEAM_NO 한개가 있음 TEAM_NO 를 포함한 DEPT_NM 을 구해야함
SELECT E.EMP_CODE, T.TEAM_NM, D.DEPT_NM
FROM EMPLOYEE E
JOIN TEAM T ON E.TEAM_NO = T.TEAM_NO
JOIN DEPARTMENT D ON T.DEPT_NO = D.DEPT_NO
WHERE E.EMP_CODE = 60;

SELECT CALENDAR_NO, CALENDAR_TITLE, CALENDAR_CONTENT, CALENDAR_COLOR, EMP_CODE, CALENDAR_START,
CALENDAR_END
FROM CALENDAR
WHERE COM_NO = 1;

-- 조회해 온 teamNm, deptNm 이 포함돼있는지 조회해오기
   
SELECT * FROM CALENDAR;

SELECT * FROM EMPLOYEE WHERE EMP_CODE = 57;

SELECT * FROM TEAM;

SELECT * FROM DEPARTMENT;

SELECT C.CALENDAR_NO, 
       C.CALENDAR_TITLE, 
       C.CALENDAR_CONTENT, 
       C.CALENDAR_COLOR, 
       C.EMP_CODE,
       TO_DATE(C.CALENDAR_START, 'YYYY-MM-DD') AS CALENDAR_START,
       TO_DATE(C.CALENDAR_END, 'YYYY-MM-DD') AS CALENDAR_END,
       C.COM_SHARE,
       C.DEPT_SHARE,
       C.TEAM_SHARE
FROM CALENDAR C
JOIN (
    SELECT T.TEAM_NO, D.DEPT_NO, E.COM_NO
    FROM EMPLOYEE E
    JOIN TEAM T ON E.TEAM_NO = T.TEAM_NO
    JOIN DEPARTMENT D ON T.DEPT_NO = D.DEPT_NO
    WHERE E.EMP_CODE = 57
) E_TD 
ON (C.TEAM_SHARE LIKE '%' || E_TD.TEAM_NO || '%'
    OR C.DEPT_SHARE LIKE '%' || E_TD.DEPT_NO || '%'
    OR (C.COM_NO = E_TD.COM_NO AND C.COM_SHARE LIKE '9'))
WHERE C.COM_NO = 9;

		SELECT C.CALENDAR_NO, 
		       C.CALENDAR_TITLE, 
		       C.CALENDAR_CONTENT, 
		       C.CALENDAR_COLOR, 
		       C.EMP_CODE,
		       TO_DATE(C.CALENDAR_START, 'YYYY-MM-DD') AS CALENDAR_START,
		       TO_DATE(C.CALENDAR_END, 'YYYY-MM-DD') AS CALENDAR_END,
		       C.COM_SHARE,
		       C.DEPT_SHARE,
		       C.TEAM_SHARE,
		       C.COM_NO
		FROM CALENDAR C
		JOIN (
		    SELECT T.TEAM_NO, D.DEPT_NO, E.COM_NO
		    FROM EMPLOYEE E
		    JOIN TEAM T ON E.TEAM_NO = T.TEAM_NO
		    JOIN DEPARTMENT D ON T.DEPT_NO = D.DEPT_NO
		    WHERE E.EMP_CODE = 57
		) E_TD 
		ON (C.TEAM_SHARE LIKE '%' || E_TD.TEAM_NO || '%'
		    OR C.DEPT_SHARE LIKE '%' || E_TD.DEPT_NO || '%'
		    OR (C.COM_NO = E_TD.COM_NO AND C.COM_SHARE = '9'))
		WHERE C.COM_NO = 9;
	
SELECT * FROM RESERVE_INFO;

-- 행 삭제
DELETE FROM RESERVE_INFO WHERE RESERVE_INFO_NO = 17;
COMMIT;

		SELECT CALENDAR_TITLE, CALENDAR_START, CALENDAR_END
		FROM CALENDAR
		WHERE COM_SHARE = 9
		AND COM_NO = 9;
	
SELECT * FROM CALENDAR;

DELETE FROM CALENDAR WHERE CALENDAR_NO = 72;

COMMIT;

-- ADMIN2 TEAMNO 8 1팀
SELECT * FROM EMPLOYEE WHERE COM_NO = 10;

-- ADMIN2 DEPTNO 7 본부
SELECT * FROM TEAM WHERE DEPT_NO IN ('8','9','10');
SELECT * FROM DEPARTMENT;

SELECT * FROM TEAM;

SELECT D.DEPT_NO, D.DEPT_NM, T.TEAM_NO, T.TEAM_NM
FROM DEPARTMENT D
LEFT JOIN TEAM T ON (D.DEPT_NO = T.DEPT_NO)
WHERE D.COM_NO = 10;

DELETE FROM RESERVE_INFO WHERE RESERVE_INFO_NO = 23;

-- 직책 관리
SELECT * FROM "POSITION";

SELECT ROW_NUMBER() OVER (ORDER BY "LEVEL") AS INDEX_NO,POSITION_NO, POSITION_NM
FROM "POSITION"
WHERE COM_NO = 11
ORDER BY "LEVEL";

INSERT INTO "POSITION" VALUES(7, '사장', 1, 11);
COMMIT;


SELECT "LEVEL" 
FROM "POSITION"
WHERE "LEVEL" >= 2
AND COM_NO = 11;

SELECT ROW_NUMBER() OVER (ORDER BY "LEVEL") AS INDEX_NO, POSITION_NO, POSITION_NM, "LEVEL"
FROM "POSITION"
WHERE COM_NO = 9
AND "LEVEL" >= 2
ORDER BY "LEVEL";

SELECT * FROM "POSITION" p 
WHERE COM_NO = 10;

DELETE FROM "POSITION" WHERE POSITION_NO = 25;
COMMIT;

-- IP 테이블 조회
SELECT * FROM IP;

-- 아직 INSERT 전
INSERT INTO IP VALUES(SEQ_IP, '192.168.0.2', 10, 55);

SELECT * FROM EMPLOYEE WHERE COM_NO = 10;

UPDATE EMPLOYEE SET TEAM_NO = NULL WHERE EMP_CODE = 106;
COMMIT;

SELECT E.EMP_CODE, 
FROM EMPLOYEE E
LEFT JOIN IP I USING (EMP_CODE)
WHERE E.COM_NO = 10;

SELECT * FROM IP;
SELECT * FROM TEAM;

-- EMP_CODE로 DEPT_NM, TEAM_NM 다 조회해오기
SELECT E.COM_NO, E.EMP_CODE, EMP_LAST_NAME, EMP_FIRST_NAME,
			E.TEAM_NO, I.IP, I.IP_NO, T.DEPT_NO, T.TEAM_NM, D.DEPT_NM
FROM EMPLOYEE E
LEFT JOIN IP I ON E.EMP_CODE = I.EMP_CODE
LEFT JOIN TEAM T ON T.TEAM_NO = E.TEAM_NO
LEFT JOIN DEPARTMENT D ON D.DEPT_NO = T.DEPT_NO
WHERE E.COM_NO = 10;

<<<<<<< HEAD
SELECT C.CALENDAR_NO, 
       C.CALENDAR_TITLE, 
       C.CALENDAR_CONTENT, 
       C.CALENDAR_COLOR, 
       C.EMP_CODE,
       TO_DATE(C.CALENDAR_START, 'YYYY-MM-DD') AS CALENDAR_START,
       TO_DATE(C.CALENDAR_END, 'YYYY-MM-DD') AS CALENDAR_END,
       C.COM_SHARE,
       C.DEPT_SHARE,
       C.TEAM_SHARE,
       C.COM_NO
FROM CALENDAR C
JOIN (
    SELECT T.TEAM_NO, D.DEPT_NO, E.COM_NO
    FROM EMPLOYEE E
    JOIN TEAM T ON E.TEAM_NO = T.TEAM_NO
    JOIN DEPARTMENT D ON T.DEPT_NO = D.DEPT_NO
    WHERE E.EMP_CODE = 183
) E_TD 
ON (C.TEAM_SHARE LIKE '%' || E_TD.TEAM_NO || '%'
    OR C.DEPT_SHARE LIKE '%' || E_TD.DEPT_NO || '%'
    OR (C.COM_NO = E_TD.COM_NO AND C.COM_SHARE = '19'))
WHERE C.COM_NO = 19;

-- empCode 183
SELECT * FROM EMPLOYEE;

SELECT * FROM CALENDAR;

SELECT * FROM TEAM;

SELECT * FROM RESERVE_INFO;

SELECT T.TEAM_NO, D.DEPT_NO, E.COM_NO
    FROM EMPLOYEE E
   	LEFT JOIN TEAM T ON E.TEAM_NO = T.TEAM_NO
    LEFT JOIN DEPARTMENT D ON T.DEPT_NO = D.DEPT_NO
    WHERE E.EMP_CODE = 183;
    
   
   
   
 SELECT
		r.RESERVE_INFO_NO, 
	    r.RESERVE_INFO_TITLE, 
	    r.RESERVE_INFO_START, 
	    r.RESERVE_INFO_END, 
	    r.RESERVE_INFO_COLOR, 
	    r.EMP_CODE,
	    r.TEAM_SHARE, 
	    r.DEPT_SHARE, 
	    r.COM_SHARE, 
	    r.MEETING_ROOM_NO, 
	    r.COM_NO,
	    m.MEETING_ROOM_NM
	FROM 
	    RESERVE_INFO r
	JOIN 
	    MEETING_ROOM m ON r.MEETING_ROOM_NO = m.MEETING_ROOM_NO
	WHERE 
	    r.COM_NO = 19;  

SELECT * FROM EMPLOYEE;

COMMIT;

UPDATE EMPLOYEE
SET EMP_PW = '$2a$10$tpYzcuK3WLAo.ZBUEmmBEO6jS1mu5UnrpiPJ.idkC6e3nQn7dyo5a'
WHERE EMP_CODE >= 70
AND EMP_CODE <= 83;

SELECT * FROM RESERVE_INFO;
DELETE FROM RESERVE_INFO WHERE RESERVE_INFO_NO < 100;

-- 이름으로 조회하기
SELECT E.EMP_NO, E.COM_NO, E.EMP_CODE, EMP_LAST_NAME, EMP_FIRST_NAME,
			E.TEAM_NO, I.IP, I.IP_NO, T.DEPT_NO, T.TEAM_NM, D.DEPT_NM
FROM EMPLOYEE E
LEFT JOIN IP I ON E.EMP_CODE = I.EMP_CODE
LEFT JOIN TEAM T ON T.TEAM_NO = E.TEAM_NO
LEFT JOIN DEPARTMENT D ON D.DEPT_NO = T.DEPT_NO
WHERE E.COM_NO = 10
AND (EMP_LAST_NAME LIKE '%테%'
OR EMP_FIRST_NAME LIKE '%스%');

SELECT E.COM_NO, E.EMP_CODE, EMP_LAST_NAME, EMP_FIRST_NAME,
       E.TEAM_NO, I.IP, I.IP_NO, T.DEPT_NO, T.TEAM_NM, D.DEPT_NM
FROM EMPLOYEE E
LEFT JOIN IP I ON E.EMP_CODE = I.EMP_CODE
LEFT JOIN TEAM T ON T.TEAM_NO = E.TEAM_NO
LEFT JOIN DEPARTMENT D ON D.DEPT_NO = T.DEPT_NO
WHERE E.COM_NO = 10
AND (EMP_LAST_NAME LIKE '%테%'
);

-- 55, 61, 101~106
SELECT * FROM EMPLOYEE WHERE COM_NO = 10;

SELECT * FROM IP;
COMMIT;

INSERT INTO IP VALUES(SEQ_IP.NEXTVAL, '192.168.50.150', 10, 58);

-- 회원 삭제된 지 조회하기
SELECT EMP_DEL_FL
FROM EMPLOYEE
WHERE EMP_CODE = 55;

SELECT COUNT(*) 
		FROM EMPLOYEE E
		LEFT JOIN IP I ON E.EMP_CODE = I.EMP_CODE
		WHERE E.COM_NO = 10
		AND E.EMP_DEL_FL = 'N'
		AND I.EMP_CODE != '61'
		AND IP = '192.168.50.20';

SELECT * FROM EMPLOYEE WHERE EMP_CODE = 60;
-- EMP_CODE 60 GENERAL_MANAGER = 1 COM_NO = 1 TEAM_NO = 1
UPDATE EMPLOYEE SET EMP_ADDRESS = '63309^^^제주특별자치도 제주시 첨단로 242^^^카카오 판교아지트' WHERE EMP_CODE = 60;
COMMIT;

SELECT * FROM "POSITION";
SELECT * FROM COMPANY;
-- 63309^^^제주특별자치도 제주시 첨단로 242^^^카카오 판교아지트
SELECT EMP_CODE, EMP_LAST_NAME, EMP_FIRST_NAME FROM EMPLOYEE WHERE COM_NO = 11;
-- 88, 89, 90 이름 바꿔줘야함 62
UPDATE EMPLOYEE SET EMP_LAST_NAME = '곽' WHERE EMP_CODE = '90';
UPDATE EMPLOYEE SET EMP_FIRST_NAME = '정민' WHERE EMP_CODE = '62';
COMMIT;
-- 박태수 67 김재희 71 윤상훈 70 강기태 69 최희수 72 이지윤 68
-- 정수진 73 구배윤 74 최석훈 78
SELECT * FROM IP;
INSERT INTO IP VALUES(SEQ_IP.NEXTVAL, '192.168.50.2', 11, 78);
COMMIT;

SELECT * FROM EMPLOYEE;