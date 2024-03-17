SELECT DEPARTMENT_NAME, ROUND(AVG(POINT), 1)
FROM TB_STUDENT
JOIN TB_DEPARTMENT USING (DEPARTMENT_NO)
JOIN TB_GRADE USING (STUDENT_NO)
WHERE CATEGORY = (SELECT CATEGORY
									FROM TB_DEPARTMENT
									WHERE DEPARTMENT_NAME = '환경조경학과')
GROUP BY DEPARTMENT_NAME;