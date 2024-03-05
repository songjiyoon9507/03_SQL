SELECT STUDENT_NAME "학생 이름", STUDENT_ADDRESS 주소지
FROM TB_STUDENT
ORDER BY 1;

SELECT STUDENT_NAME, STUDENT_SSN
FROM TB_STUDENT
WHERE ABSENCE_YN = 'Y'
ORDER BY 2 DESC;

SELECT STUDENT_NAME 학생이름, STUDENT_NO 학번, STUDENT_ADDRESS "거주지 주소"
FROM TB_STUDENT
WHERE STUDENT_NO LIKE '9%'
AND (STUDENT_ADDRESS LIKE '강원도%' OR STUDENT_ADDRESS LIKE '경기도%')
ORDER BY STUDENT_NAME;

SELECT PROFESSOR_NAME, PROFESSOR_SSN
FROM TB_PROFESSOR
WHERE DEPARTMENT_NO = '005'
ORDER BY PROFESSOR_SSN;

SELECT STUDENT_NO, POINT
FROM TB_GRADE
WHERE TERM_NO = '200402'
AND CLASS_NO = 'C3118100'
ORDER BY POINT DESC;

SELECT STUDENT_NO, STUDENT_NAME, DEPARTMENT_NAME
FROM TB_STUDENT
JOIN TB_DEPARTMENT USING (DEPARTMENT_NO);
-- ORDER BY STUDENT_NAME;

SELECT CLASS_NAME, DEPARTMENT_NAME
FROM TB_CLASS
NATURAL JOIN TB_DEPARTMENT;

SELECT CLASS_NAME, PROFESSOR_NAME
FROM TB_CLASS
JOIN TB_CLASS_PROFESSOR USING (CLASS_NO)
JOIN TB_PROFESSOR USING (PROFESSOR_NO);
/* 출력 776개 나오지만 순서가 이상함 */

SELECT CLASS_NAME, PROFESSOR_NAME
FROM TB_CLASS
JOIN TB_CLASS_PROFESSOR USING (CLASS_NO)
JOIN TB_PROFESSOR USING (PROFESSOR_NO)
JOIN TB_DEPARTMENT ON (TB_PROFESSOR.DEPARTMENT_NO = TB_DEPARTMENT.DEPARTMENT_NO)
WHERE CATEGORY = '인문사회';

SELECT STUDENT_NO 학번, STUDENT_NAME "학생 이름", ROUND(AVG(POINT), 1) "전체 평점"
FROM TB_STUDENT
JOIN TB_GRADE USING (STUDENT_NO)
JOIN TB_CLASS USING (CLASS_NO)
JOIN TB_DEPARTMENT ON (TB_CLASS.DEPARTMENT_NO = TB_DEPARTMENT.DEPARTMENT_NO)
WHERE DEPARTMENT_NAME = '음악학과'
GROUP BY STUDENT_NO, STUDENT_NAME
ORDER BY STUDENT_NO;

SELECT D.DEPARTMENT_NAME 학과이름, S.STUDENT_NAME 학생이름, P.PROFESSOR_NAME 지도교수이름
FROM TB_PROFESSOR P 
LEFT JOIN TB_STUDENT S ON (P.PROFESSOR_NO  = S.COACH_PROFESSOR_NO)
LEFT JOIN TB_DEPARTMENT D  ON (S.DEPARTMENT_NO = D.DEPARTMENT_NO)
WHERE S.STUDENT_NO = 'A313047';
--AND S.COACH_PROFESSOR_NO = P.PROFESSOR_NO;

-- 11. 풀이 1
SELECT DEPARTMENT_NAME 학과이름,
STUDENT_NAME 학생이름,
PROFESSOR_NAME 지도교수이름
FROM TB_STUDENT
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
JOIN TB_PROFESSOR ON (COACH_PROFESSOR_NO = PROFESSOR_NO)
WHERE STUDENT_NO = 'A313047';

-- 11. 풀이 2
SELECT DEPARTMENT_NAME 학과이름,
STUDENT_NAME 학생이름,
PROFESSOR_NAME 지도교수이름
FROM TB_STUDENT S
JOIN TB_PROFESSOR P ON (COACH_PROFESSOR_NO = PROFESSOR_NO)
JOIN TB_DEPARTMENT D ON (S.DEPARTMENT_NO = D.DEPARTMENT_NO)
-- 어디서 나온 DEPARTMENT_NO 인지 모름 순서 중요 STUDENT 바로 아래 쓰면 USING 사용 가능
WHERE STUDENT_NO = 'A313047';

SELECT STUDENT_NAME, TERM_NO "TERM_NAME"
FROM TB_STUDENT S
JOIN TB_GRADE G ON (S.STUDENT_NO = G.STUDENT_NO)
JOIN TB_CLASS C ON (G.CLASS_NO = C.CLASS_NO)
WHERE G.TERM_NO LIKE '2007%'
AND C.CLASS_NAME = '인간관계론';

-- 12. 풀이
SELECT STUDENT_NAME, TERM_NO "TERM_NAME"
FROM TB_STUDENT
JOIN TB_GRADE USING(STUDENT_NO)
JOIN TB_CLASS USING(CLASS_NO)
WHERE CLASS_NAME = '인간관계론'
AND TERM_NO LIKE '2007%';

SELECT CLASS_NAME, DEPARTMENT_NAME
FROM TB_CLASS C
LEFT JOIN TB_CLASS_PROFESSOR CP ON (C.CLASS_NO = CP.CLASS_NO)
LEFT JOIN TB_DEPARTMENT D ON (C.DEPARTMENT_NO = D.DEPARTMENT_NO)
WHERE D.CATEGORY = '예체능'
AND PROFESSOR_NO IS NULL;
/* 이해하지 못함 */
-- 대충 이해함

-- 13. 풀이
SELECT CLASS_NAME, DEPARTMENT_NAME
FROM TB_CLASS
LEFT JOIN TB_CLASS_PROFESSOR USING(CLASS_NO) -- 일치하지 않는 값도 나오게 OUTER JOIN
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
WHERE CATEGORY = '예체능'
AND PROFESSOR_NO IS NULL ;

SELECT STUDENT_NAME 학생이름, NVL(PROFESSOR_NAME, '지도교수 미지정') 지도교수
FROM TB_STUDENT S
LEFT JOIN TB_PROFESSOR P ON (S.COACH_PROFESSOR_NO = P.PROFESSOR_NO)
LEFT JOIN TB_DEPARTMENT D ON (P.DEPARTMENT_NO = D.DEPARTMENT_NO)
WHERE D.DEPARTMENT_NAME = '서반아어학과';
/* 아무것도 찾지 못함 */
/* P.이 아님 */

-- 14. 풀이
SELECT STUDENT_NAME 학생이름, NVL(PROFESSOR_NAME, '지도교수 미지정') 지도교수
FROM TB_STUDENT S
LEFT JOIN TB_PROFESSOR P ON (COACH_PROFESSOR_NO = PROFESSOR_NO)
JOIN TB_DEPARTMENT D ON (S.DEPARTMENT_NO = D.DEPARTMENT_NO)
WHERE DEPARTMENT_NAME = '서반아어학과'
ORDER BY STUDENT_NO;

SELECT S.STUDENT_NO 학번, S.STUDENT_NAME 이름, D.DEPARTMENT_NAME "학과 이름", AVG(POINT) 평점
FROM TB_STUDENT S
LEFT JOIN TB_DEPARTMENT D ON (S.DEPARTMENT_NO = D.DEPARTMENT_NO)
LEFT JOIN TB_GRADE G ON (S.STUDENT_NO = G.STUDENT_NO)
WHERE S.ABSENCE_YN = 'N'
GROUP BY S.STUDENT_NO, S.STUDENT_NAME, D.DEPARTMENT_NAME
HAVING AVG(POINT) >= 4;
-- 학과 이름 홑따옴표로 쓰고 애매한 문자열 때문에 안 나옴

-- 15. 풀이
SELECT STUDENT_NO 학번, STUDENT_NAME 이름, DEPARTMENT_NAME "학과 이름", AVG(POINT) 평점
FROM TB_STUDENT
JOIN TB_DEPARTMENT USING (DEPARTMENT_NO)
JOIN TB_GRADE USING (STUDENT_NO)
WHERE ABSENCE_YN = 'N'
GROUP BY STUDENT_NO, STUDENT_NAME, DEPARTMENT_NAME
HAVING AVG(POINT) >= 4
ORDER BY 1;

-- 16. 풀이
SELECT CLASS_NO, CLASS_NAME, TRUNC( AVG(POINT), 8 ) "AVG(POINT)"
FROM TB_CLASS
JOIN TB_GRADE USING(CLASS_NO)
JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
WHERE DEPARTMENT_NAME = '환경조경학과'
AND CLASS_TYPE LIKE '전공%'
GROUP BY CLASS_NO, CLASS_NAME
ORDER BY 1;