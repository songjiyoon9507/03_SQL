SELECT COUNT(*)
FROM "BOARD"
WHERE BOARD_DEL_FL = 'N';

-- 자유게시판 10개씩 10페이지씩 띄워서 조회
SELECT BOARD_NO, BOARD_TITLE, MEMBER_NICKNAME, READ_COUNT,
	(SELECT COUNT(*) 
	FROM "COMMENT" C 
	WHERE C.BOARD_NO = B.BOARD_NO) COMMENT_COUNT,
	(SELECT COUNT(*)
	FROM BOARD_LIKE L
	WHERE L.BOARD_NO = B.BOARD_NO) LIKE_COUNT,
	CASE 
		WHEN SYSDATE - BOARD_WRITE_DATE < 1 / 24 / 60
		THEN FLOOR((SYSDATE - BOARD_WRITE_DATE) * 24 * 60 * 60) || '초 전'
		
		WHEN SYSDATE - BOARD_WRITE_DATE < 1 / 24
		THEN FLOOR((SYSDATE - BOARD_WRITE_DATE) * 24 * 60) || '분 전'
		
		WHEN SYSDATE - BOARD_WRITE_DATE < 1
		THEN FLOOR((SYSDATE - BOARD_WRITE_DATE) * 24) || '시간 전'
		
		ELSE TO_CHAR(BOARD_WRITE_DATE, 'YYYY-MM-DD')
		
	END BOARD_WRITE_DATE
	
FROM BOARD B
JOIN "MEMBER" USING(MEMBER_NO)
WHERE BOARD_DEL_FL = 'N'
ORDER BY BOARD_NO DESC;