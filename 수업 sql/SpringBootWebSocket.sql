-- 채팅
CREATE TABLE "CHATTING_ROOM" (
	"CHATTING_NO"	NUMBER		NOT NULL,
	"CH_CREATE_DATE"	DATE	DEFAULT SYSDATE	NOT NULL,
	"OPEN_MEMBER"	NUMBER		NOT NULL,
	"PARTICIPANT"	NUMBER		NOT NULL
);

COMMENT ON COLUMN "CHATTING_ROOM"."CHATTING_NO" IS '채팅방 번호';
COMMENT ON COLUMN "CHATTING_ROOM"."CH_CREATE_DATE" IS '채팅방 생성일';
COMMENT ON COLUMN "CHATTING_ROOM"."OPEN_MEMBER" IS '개설자 회원 번호';
COMMENT ON COLUMN "CHATTING_ROOM"."PARTICIPANT" IS '참여자 회원 번호';

ALTER TABLE "CHATTING_ROOM" ADD CONSTRAINT "PK_CHATTING_ROOM" PRIMARY KEY (
	"CHATTING_NO"
);

ALTER TABLE "CHATTING_ROOM"
ADD CONSTRAINT "FK_OPEN_MEMBER"
FOREIGN KEY ("OPEN_MEMBER") REFERENCES "MEMBER";

ALTER TABLE "CHATTING_ROOM"
ADD CONSTRAINT "FK_PARTICIPANT"
FOREIGN KEY ("PARTICIPANT") REFERENCES "MEMBER";

CREATE TABLE "MESSAGE" (
	"MESSAGE_NO"	NUMBER		NOT NULL,
	"MESSAGE_CONTENT"	VARCHAR2(4000)		NOT NULL,
	"READ_FL"	CHAR	DEFAULT 'N'	NOT NULL,
	"SEND_TIME"	DATE	DEFAULT SYSDATE	NOT NULL,
	"SENDER_NO"	NUMBER		NOT NULL,
	"CHATTING_NO"	NUMBER		NOT NULL
);

COMMENT ON COLUMN "MESSAGE"."MESSAGE_NO" IS '메세지 번호';
COMMENT ON COLUMN "MESSAGE"."MESSAGE_CONTENT" IS '메세지 내용';
COMMENT ON COLUMN "MESSAGE"."READ_FL" IS '읽음 여부';
COMMENT ON COLUMN "MESSAGE"."SEND_TIME" IS '메세지 보낸 시간';
COMMENT ON COLUMN "MESSAGE"."SENDER_NO" IS '보낸 회원의 번호';
COMMENT ON COLUMN "MESSAGE"."CHATTING_NO" IS '채팅방 번호';

ALTER TABLE "MESSAGE" ADD CONSTRAINT "PK_MESSAGE" PRIMARY KEY (
	"MESSAGE_NO"
);

ALTER TABLE "MESSAGE"
ADD CONSTRAINT "FK_CHATTING_NO"
FOREIGN KEY ("CHATTING_NO") REFERENCES "CHATTING_ROOM";

ALTER TABLE "MESSAGE"
ADD CONSTRAINT "FK_SENDER_NO"
FOREIGN KEY ("SENDER_NO") REFERENCES "MEMBER";

-- 시퀀스 생성
CREATE SEQUENCE SEQ_ROOM_NO NOCACHE;

CREATE SEQUENCE SEQ_MESSAGE_NO NOCACHE;

SELECT * FROM "MEMBER";
SELECT * FROM "CHATTING_ROOM";
SELECT * FROM "MESSAGE";

INSERT INTO "CHATTING_ROOM"
VALUES(SEQ_ROOM_NO.NEXTVAL, SYSDATE, 1, 2);

COMMIT;

-------------------------------------------------------------------------------
SELECT * FROM CHATTING_ROOM;

DELETE FROM CHATTING_ROOM WHERE CHATTING_NO = 1;

-- 채팅방 목록 조회
SELECT CHATTING_NO
	,(SELECT MESSAGE_CONTENT FROM (
		SELECT * FROM MESSAGE M2
		WHERE M2.CHATTING_NO = R.CHATTING_NO
		ORDER BY MESSAGE_NO DESC) 
		WHERE ROWNUM = 1) LAST_MESSAGE
	,TO_CHAR(NVL((SELECT MAX(SEND_TIME) SEND_TIME 
			FROM MESSAGE M
			WHERE R.CHATTING_NO  = M.CHATTING_NO), CH_CREATE_DATE), 
			'YYYY.MM.DD') SEND_TIME
	,NVL2((SELECT OPEN_MEMBER FROM CHATTING_ROOM R2
		WHERE R2.CHATTING_NO = R.CHATTING_NO
		AND R2.OPEN_MEMBER = 1),
		R.PARTICIPANT,
		R.OPEN_MEMBER
		) TARGET_NO
	,NVL2((SELECT OPEN_MEMBER FROM CHATTING_ROOM R2
		WHERE R2.CHATTING_NO = R.CHATTING_NO
		AND R2.OPEN_MEMBER = 1),
		(SELECT MEMBER_NICKNAME FROM MEMBER WHERE MEMBER_NO = R.PARTICIPANT),
		(SELECT MEMBER_NICKNAME FROM MEMBER WHERE MEMBER_NO = R.OPEN_MEMBER)
		) TARGET_NICKNAME	
	,NVL2((SELECT OPEN_MEMBER FROM CHATTING_ROOM R2
		WHERE R2.CHATTING_NO = R.CHATTING_NO
		AND R2.OPEN_MEMBER = 1),
		(SELECT PROFILE_IMG FROM MEMBER WHERE MEMBER_NO = R.PARTICIPANT),
		(SELECT PROFILE_IMG FROM MEMBER WHERE MEMBER_NO = R.OPEN_MEMBER)
		) TARGET_PROFILE
	,(SELECT COUNT(*) FROM MESSAGE M WHERE M.CHATTING_NO = R.CHATTING_NO AND READ_FL = 'N' AND SENDER_NO != 1) NOT_READ_COUNT
	,(SELECT MAX(MESSAGE_NO) SEND_TIME FROM MESSAGE M WHERE R.CHATTING_NO  = M.CHATTING_NO) MAX_MESSAGE_NO
FROM CHATTING_ROOM R
WHERE OPEN_MEMBER = 1
OR PARTICIPANT = 1
ORDER BY MAX_MESSAGE_NO DESC NULLS LAST;
-- LAST_MESSAGE -> 가장 최근 메세지 보여주는 구문
-- NVL 함수 앞에 작성한 값이 NULL 이면 뒤에 작성한 쿼리로 대체
-- NVL2 함수 앞에 SELECT 문 조회했을 때 값이 NULL 이 아니면 1번째, NULL 이면 2번째

SELECT * FROM MEMBER;

SELECT * FROM MEMBER
WHERE TRUNC(ENROLL_DATE) BETWEEN TO_DATE('2024-05-22', 'YYYY-MM-DD') AND TO_DATE('2024-05-23', 'YYYY-MM-DD');

SELECT * FROM MEMBER
WHERE ENROLL_DATE BETWEEN TO_DATE('2024-05-22', 'YYYY-MM-DD') AND TO_DATE('2024-05-23', 'YYYY-MM-DD');