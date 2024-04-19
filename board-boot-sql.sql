-- 비밀번호 update
UPDATE "MEMBER" SET MEMBER_PW = '$2a$10$h9WqHozrLDEPb2H.WeksFu/84M8bLDi4pDYU9.kTabNp5pdDF9Lae'
WHERE MEMBER_NO = 1;

-- 로그인 SQL
SELECT MEMBER_NO, MEMBER_EMAIL, MEMBER_NICKNAME, MEMBER_PW,
MEMBER_TEL, MEMBER_ADDRESS, PROFILE_IMG, AUTHORITY,
TO_CHAR(ENROLL_DATE, 'YYYY"년" MM"월" DD"일" HH24"시" MI"분" SS"초"') ENROLL_DATE
FROM "MEMBER"
WHERE MEMBER_EMAIL = 'user01@kh.or.kr'
AND MEMBER_DEL_FL = 'N';

-- 이메일 중복검사
SELECT COUNT(*)
FROM "MEMBER"
WHERE MEMBER_DEL_FL = 'N'
AND MEMBER_EMAIL = 'user01@kh.or.kr';

-- 인증번호 테이블 조회
SELECT * FROM "TB_AUTH_KEY";

-- 이메일, 인증번호 확인
SELECT COUNT(*)
FROM TB_AUTH_KEY
WHERE EMAIL = ''
AND AUTH_KEY = '';

UPDATE "MEMBER" SET
MEMBER_DEL_FL = 'Y'
WHERE MEMBER_NO = 6;

UPDATE "MEMBER" SET
MEMBER_NO = 3
WHERE MEMBER_NO = 8;

COMMIT;

DELETE FROM "MEMBER" WHERE MEMBER_NO = 3;

-- 파일 목록 조회
SELECT FILE_NO, FILE_PATH, FILE_ORIGINAL_NAME, FILE_RENAME, MEMBER_NICKNAME,
TO_CHAR(FILE_UPLOAD_DATE, 'YYYY-MM-DD') FILE_UPLOAD_DATE
FROM "UPLOAD_FILE"
JOIN "MEMBER" USING (MEMBER_NO)
ORDER BY FILE_NO DESC;

UPDATE "MEMBER" SET
MEMBER_PW = '$2a$10$cUjrg0EjalRgh9w0i0Dg6OGV67WviEYVFwPL/U7krKx4l2Bdid8SO'
WHERE MEMBER_NO = 1;

SELECT * FROM "MEMBER";