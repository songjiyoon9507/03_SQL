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