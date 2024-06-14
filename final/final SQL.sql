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

-- 캘린더 컬럼 삭제
ALTER TABLE CALENDAR DROP COLUMN CALENDAR_WRITE_DATE;
ALTER TABLE CALENDAR DROP COLUMN CALENDAR_UPDATE_DATE;
ALTER TABLE CALENDAR DROP COLUMN TEAM_SHARE;
ALTER TABLE CALENDAR DROP COLUMN CALENDAR_START;
ALTER TABLE CALENDAR DROP COLUMN CALENDAR_END;
ALTER TABLE CALENDAR DROP COLUMN COM_NO_LIST;
ALTER TABLE CALENDAR DROP COLUMN DEPT_NO_LIST;
ALTER TABLE CALENDAR DROP COLUMN TEAM_NO_LIST;

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
ALTER TABLE CALENDAR ADD SHARE_LIST VARCHAR2(3000) NULL;
ALTER TABLE CALENDAR ADD CALENDAR_START VARCHAR2(3000) NOT NULL;
ALTER TABLE CALENDAR ADD CALENDAR_END VARCHAR2(3000) NOT NULL;

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
DELETE FROM CALENDAR WHERE CALENDAR_NO = 1;

-- EMP_CODE = 60 TEAM_NO 1 개발1팀, DEPT_NO 1 TEAM 테이블에 들어있음 개발팀
SELECT * FROM TEAM;
SELECT * FROM DEPARTMENT;
SELECT * FROM EMPLOYEE;
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

SELECT C.CALENDAR_NO, 
       C.CALENDAR_TITLE, 
       C.CALENDAR_CONTENT, 
       C.CALENDAR_COLOR, 
       C.EMP_CODE, 
       C.CALENDAR_START, 
       C.CALENDAR_END
FROM CALENDAR C
JOIN (
    SELECT T.TEAM_NM, D.DEPT_NM
    FROM EMPLOYEE E
    JOIN TEAM T ON E.TEAM_NO = T.TEAM_NO
    JOIN DEPARTMENT D ON T.DEPT_NO = D.DEPT_NO
    WHERE E.EMP_CODE = 60
) AS E_TD ON C.CALENDAR_SHARE LIKE CONCAT('%', E_TD.TEAM_NM, '%')
          OR C.CALENDAR_SHARE LIKE CONCAT('%', E_TD.DEPT_NM, '%');
         
SELECT C.CALENDAR_NO, 
       C.CALENDAR_TITLE, 
       C.CALENDAR_CONTENT, 
       C.CALENDAR_COLOR, 
       C.EMP_CODE, 
       C.CALENDAR_START, 
       C.CALENDAR_END
FROM CALENDAR C
JOIN (
    SELECT T.TEAM_NM, D.DEPT_NM, E.COM_NO
    FROM EMPLOYEE E
    JOIN TEAM T ON E.TEAM_NO = T.TEAM_NO
    JOIN DEPARTMENT D ON T.DEPT_NO = D.DEPT_NO
    WHERE E.EMP_CODE = 60
) E_TD 
ON (C.CALENDAR_SHARE LIKE '%' || E_TD.TEAM_NM || '%'
    OR C.CALENDAR_SHARE LIKE '%' || E_TD.DEPT_NM || '%'
    OR (C.COM_NO = E_TD.COM_NO AND C.CALENDAR_SHARE LIKE '%회사 전체%'));
   
SELECT * FROM CALENDAR;

SELECT * FROM EMPLOYEE;