/* MEMBER 테이블 생성 */
CREATE TABLE "MEMBER"(
	"MEMBER_NO"       NUMBER CONSTRAINT "MEMBER_PK" PRIMARY KEY,
	"MEMBER_EMAIL" 		NVARCHAR2(50)  NOT NULL,
	"MEMBER_PW"				NVARCHAR2(100) NOT NULL,
	"MEMBER_NICKNAME" NVARCHAR2(10)  NOT NULL,
	"MEMBER_TEL"			CHAR(11), -- 카카오톡 로그인 연동함으로써 회원가입시켜줄 때 를 위해 NOT NULL 지움. 
	"MEMBER_ADDRESS"	NVARCHAR2(150),
	"PROFILE_IMG"			VARCHAR2(300),
	"ENROLL_DATE"			DATE           DEFAULT SYSDATE NOT NULL,
	"MEMBER_DEL_FL"		CHAR(1) 			 DEFAULT 'N'
									  CHECK("MEMBER_DEL_FL" IN ('Y', 'N') ),
	"AUTHORITY"				NUMBER 			   DEFAULT 1
										CHECK("AUTHORITY" IN (1, 2) )
);

-- 회원 번호 시퀀스 만들기
CREATE SEQUENCE SEQ_MEMBER_NO NOCACHE;

COMMIT;
SELECT * FROM MEMBER;


INSERT INTO "MEMBER"
VALUES(SEQ_MEMBER_NO.NEXTVAL, 
			 'user01@kh.or.kr',
			 'pass01!',
			 '유저일',
			 '01012341234',
			 NULL,
			 NULL,
			 DEFAULT,
			 DEFAULT,
			 DEFAULT
);

INSERT INTO "MEMBER"
VALUES(SEQ_MEMBER_NO.NEXTVAL, 
			 'user02@kh.or.kr',
			 'pass01!',
			 '유저이',
			 '01012341234',
			 NULL,
			 NULL,
			 DEFAULT,
			 DEFAULT,
			 DEFAULT
);

SELECT * FROM "MEMBER";

DELETE FROM MEMBER WHERE MEMBER_NO = 16;

-- 이메일, 인증키 저장 테이블 생성
CREATE TABLE "AUTH_KEY"(
	"KEY_NO"    NUMBER PRIMARY KEY, -- pk 임
	"EMAIL"	    NVARCHAR2(50) NOT NULL, -- 어떤 이메일계정에게
	"AUTH_KEY"  CHAR(6)	NOT NULL, -- 어떤 인증번호를 보냈는가?
	"CREATE_TIME" DATE DEFAULT SYSDATE NOT NULL -- 생성시간
);

COMMENT ON COLUMN "TB_AUTH_KEY"."KEY_NO"      IS '인증키 구분 번호(시퀀스)';
COMMENT ON COLUMN "TB_AUTH_KEY"."EMAIL"       IS '인증 이메일';
COMMENT ON COLUMN "TB_AUTH_KEY"."AUTH_KEY"    IS '인증 번호';
COMMENT ON COLUMN "TB_AUTH_KEY"."CREATE_TIME" IS '인증 번호 생성 시간';
CREATE SEQUENCE SEQ_KEY_NO NOCACHE; -- 인증키 구분 번호 시퀀스
SELECT * FROM "AUTH_KEY";
COMMIT;


SELECT COUNT(*) FROM AUTH_KEY
WHERE 
EMAIL = 'wowns590@naver.com'
AND
AUTH_KEY = 'w60ZLo';
 	
----------------------------------------------------------------------------------------------------

--LECTURE
CREATE TABLE "LECTURE"(
	"LECTURE_NO" 	NUMBER CONSTRAINT "LECTURE_PK" PRIMARY KEY,
	"MEMBER_NO" 	NUMBER,
	
	"LECTURE_CATEGORY_NUM" NUMBER CHECK("LECTURE_CATEGORY_NUM" IN (1,2,3,4,5)), -- 강의의 분야를 나타냄. 강의 분류
	
	"LECTURE_HOME_TITLE" 	VARCHAR2(300) NOT NULL, -- 홈화면에 보여질 제목
	"LECTURE_HOME_CONTENT" VARCHAR2(300) NOT NULL, -- 홈화면에 보여질 내용
	
	"LECTURE_TITLE" VARCHAR2(300) NOT NULL, -- 상세보기의 제목
	"LECTURE_CONTENT" CLOB NOT NULL, -- 상세보기의 내용
	
	"PRICE"			NUMBER DEFAULT 0 NOT NULL,  -- 강의 가격
	
	"INSTRUCTOR_INTORODUCTION" VARCHAR2(300) NOT NULL, -- 강사 소개	
	
	"LECTURE_LEVEL" NUMBER CHECK("LECTURE_LEVEL" IN (1,2,3)), -- 1 은 초급, 2는 중급, 3은 고급. 즉, 강의의 수준을 말함.
	
	"START_TIME" NUMBER, -- 강의가 시작되는 시각
	"HOW_LONG" NUMBER,
	
	--"END_TIME" NUMBER, -- 끝나는 시각
	
	"ACCEPTABLE_NUMBER" NUMBER  NOT NULL, --수용가능인원(전체 자리 수) 
	"REST_NUMBER"		NUMBER NOT NULL, -- 현재 남은 자리 
	
	"START_DATE"	DATE NOT NULL, -- 강의 시작 날짜 
	"END_DATE" 		DATE NOT NULL,	-- 강의 종료 날짜 
	
	"ENROLL_DATE" 	  DATE DEFAULT SYSDATE NOT NULL, -- 강의 등록 날짜 
	
	"LECTURE_DEL_FL" CHAR(1) DEFAULT 'N' CHECK("LECTURE_DEL_FL" IN ('Y', 'N')), -- 강의가 지워졌는지 여부를 나타내는 컬럼.
	
	-- 외래키 제약조건
	CONSTRAINT "LECTURE_FK" FOREIGN KEY ("MEMBER_NO") REFERENCES "MEMBER"("MEMBER_NO") ON DELETE CASCADE
);

SELECT * FROM LECTURE;

-- 가격에 대한 것도 여기에 올려야 하나? 응 홈 화면에도 가격에 대한 거 표시해야되니까. 그냥 여기에 둔다.
CREATE SEQUENCE SEQ_LECTURE_NO NOCACHE; -- 인증키 구분 번호 시퀀스


INSERT INTO "LECTURE"
VALUES(SEQ_LECTURE_NO.NEXTVAL, -- LECTURE_NO
			 1, -- MEMBER_NO
			 1, -- 1은 향수를 나타냄. 
			 '나만의 향수 만들기', -- LECTURE_NAME
			 '향기로 자신을 나타내보시는게 어떠신가요..?', -- LECTURE_TITLE 
			 '향기를 배우는 수업',
			 '향수를 어떻게 배우는지 과정이 궁금하시지 않으셨나요? 실제로 향수를 만들어보면서 어떤 향기가 자신에게 어울리는지, 자신을 알아가는 시간을 가져봐요!', -- LECTURE_CONTENT
			 30000, -- PRICE
			 '안녕하세요 강사 최재준입니다. 저는 어쩌구저쩌구 갈릴레오 알리오올리오', -- INSTRUCTOR INTRODUCTION
			 1, -- 레벨 초급 중급 고급
			 1030, -- 강의 시작 시각
			 2, -- 강의 지속 시간
			 15, -- 수용가능인원
			 13, -- 남은자리
			 TO_DATE('2024-04-01', 'YYYY-MM-DD'), -- 강의 시작 날짜
			 TO_DATE('2024-04-15', 'YYYY-MM-DD'), -- 강의 종료 날짜
			 DEFAULT, -- 강의 등록 날짜
			 DEFAULT -- 강의를 삭제했는지 여부
);
COMMIT;


-- 그리고, 하나의 강의당 관련 이미지들은 많기 때문에 필연적으로, 따로 테이블로 만든다.

---------------------------------------------------------------------------------------------------------------------------------------------
-- LECTURE_DAYS : 강의가 진행되는 요일. 하나의 강의당 여러개의 요일이 배정될 수 있어서, 따로 뺌. 예를 들어, 하나의 강의당 월화수목금 이라고 하면, 12345 를 넣는거보다 이렇게 빼는 게 나을거라 생각함.
CREATE TABLE "LECTURE_DAYS"(
	"LECTURE_DAYS_NO" NUMBER CONSTRAINT "LECTURE_DAYS_PK" PRIMARY KEY,
	"LECTURE_NO" NUMBER,
	"DAY_OF_WEEK" NUMBER CHECK("DAY_OF_WEEK" IN (1,2,3,4,5,6,7)),
	-- 외래키 제약조건
	CONSTRAINT "LECTURE_DAYS_FK" FOREIGN KEY ("LECTURE_NO") REFERENCES "LECTURE"("LECTURE_NO") ON DELETE CASCADE 
);

CREATE SEQUENCE SEQ_LECTURE_DAYS_NO NOCACHE; -- 시퀀스

INSERT INTO LECTURE_DAYS VALUES(
	SEQ_LECTURE_DAYS_NO.NEXTVAL,
	2,
	3	
);

SELECT * FROM LECTURE_DAYS;

SELECT * FROM LECTURE;

COMMIT;

------------------------------------------------------------------------------------------------------------------------------------------------
-- LECTURE_REVIEW : 강의 후기
CREATE TABLE "LECTURE_REVIEW" (
	"LECTURE_REVIEW_NO" NUMBER CONSTRAINT "LECTURE_REVIEW_PK" PRIMARY KEY,
	"MEMBER_NO" NUMBER, --누가
	"LECTURE_NO" NUMBER, --어떤 강의에
	"REVIEW_CONTENT" VARCHAR2(500), -- 뭐라고 남겼냐?
	"REVIEW_IMG" VARCHAR2(300),	 -- 사진 하나만 첨부하게 해줄거임. 
	"CREATE_DATE_REVIEW" DATE DEFAULT SYSDATE, -- 생성시점
	"PARENT_REVIEW_NO" NUMBER, -- 부모 후기의 LECTURE_REVIEW_NO 값. 대댓글을 표현하기 위함임.
	"REVIEW_DEL_FL" CHAR(1) DEFAULT 'N' CHECK("REVIEW_DEL_FL" IN ('Y', 'N')), -- 삭제됬는지 여부. 강의와 상관없이 후기가 존재하는지 체크할 필요가 있어서 넣음. 
	
	-- 외래키 제약조건
	CONSTRAINT "LECTURE_REVIEW_FK_1" FOREIGN KEY ("MEMBER_NO") REFERENCES "MEMBER"("MEMBER_NO") ON DELETE CASCADE,--어차피, MEMBER 테이블 행 지워지면, LECTURE 도 지워지도록 해놨음. 
	CONSTRAINT "LECTURE_REVIEW_FK_2" FOREIGN KEY ("LECTURE_NO") REFERENCES "LECTURE"("LECTURE_NO") ON DELETE CASCADE 
);
SELECT * FROM MEMBER;

SELECT * FROM LECTURE;

SELECT * FROM LECTURE_REVIEW ;

CREATE SEQUENCE SEQ_LECTURE_REVIEW_NO NOCACHE; -- 시퀀스

INSERT INTO "LECTURE_REVIEW" VALUES(
	SEQ_LECTURE_REVIEW_NO.NEXTVAL,
	1,
	2,
	'이쁘세여^_^',
	'/lecture/file/perfume2.jpg', 
	DEFAULT, 
	NULL,
	DEFAULT
);

INSERT INTO "LECTURE_REVIEW" VALUES(
	SEQ_LECTURE_REVIEW_NO.NEXTVAL,
	1,
	2,
	'이쁘세여',
	'/lecture/file/perfume2.jpg', 
	DEFAULT, 
	NULL,
	DEFAULT
);

INSERT INTO "LECTURE_REVIEW" VALUES(
	SEQ_LECTURE_REVIEW_NO.NEXTVAL,
	1,
	2,
	'정말루',
	'/lecture/file/perfume1.jpg', 
	DEFAULT, 
	8,
	DEFAULT
);

------------------------------------------------------------------------------------------

-- FILE 이라는 테이블을 만들것.
CREATE TABLE "LECTURE_FILE"(
	"LECTURE_FILE_NO" 	 NUMBER CONSTRAINT "LECTURE_FILE_PK" PRIMARY KEY, -- 기본
	"LECTURE_NO" 	NUMBER, -- 어떤 강의에 속한 이미지인지를 나타냄.
	"FILE_PATH" 	VARCHAR2(500),
	"ORIGINAL_NAME" VARCHAR2(300),
	"FILE_RENAME" 		VARCHAR2(100),
	"UPLOAD_DATE" 	DATE DEFAULT SYSDATE,
	-- 외래키 제약조건
	CONSTRAINT "LECTURE_FILE_FK" FOREIGN KEY ("LECTURE_NO") REFERENCES "LECTURE"("LECTURE_NO") ON DELETE CASCADE
);


CREATE SEQUENCE SEQ_LECTURE_FILE_NO NOCACHE; -- 인증키 구분 번호 시퀀스

SELECT * FROM lecture_file;

INSERT INTO "LECTURE_FILE"
VALUES(SEQ_LECTURE_FILE_NO.NEXTVAL, -- LECTURE_FILE_NO
			 2, -- LECTURE_NO
			 '/lecture/file/', -- FILE_PATH
			 'perfume1.jpg', -- FILE_ORIGINAL_NAME 
			 'perfume1.jpg', -- FILE_RENAME
			 DEFAULT -- FILE_UPLOAD_DATE
);

INSERT INTO "LECTURE_FILE"
VALUES(SEQ_LECTURE_FILE_NO.NEXTVAL, -- LECTURE_FILE_NO
			 2, -- LECTURE_NO
			 '/lecture/file/', -- FILE_PATH
			 'perfume2.jpg', -- FILE_ORIGINAL_NAME 
			 'perfume2.jpg', -- FILE_RENAME
			 DEFAULT -- FILE_UPLOAD_DATE
);

COMMIT;

SELECT * FROM LECTURE_FILE;

------------------------------------------------------------------------------------------------------------------------------------------------

/* 게시판 테이블 생성 */
CREATE TABLE "BOARD" (
	"BOARD_NO"	NUMBER		NOT NULL,
	"BOARD_TITLE"	NVARCHAR2(100)		NOT NULL,
	"BOARD_CONTENT"	VARCHAR2(4000)		NOT NULL,
	"BOARD_WRITE_DATE"	DATE	DEFAULT SYSDATE	NOT NULL,
	"BOARD_UPDATE_DATE"	DATE		NULL,
	"READ_COUNT"	NUMBER	DEFAULT 0	NOT NULL,
	"BOARD_DEL_FL"	CHAR(1)	DEFAULT 'N'	NOT NULL,
	"BOARD_CODE"	NUMBER		NOT NULL,
	"MEMBER_NO"	NUMBER		NOT NULL
);
