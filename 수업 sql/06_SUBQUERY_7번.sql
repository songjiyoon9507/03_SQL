SELECT EMP_ID, EMP_NAME, JOB_NAME, 나이, 보너스포함연봉
FROM (SELECT EMP_ID, EMP_NAME, JOB_NAME,
			'2024'  - TO_CHAR ( TO_DATE(SUBSTR((EMP_NO),1,2), 'RR'), 'YYYY' ) "나이",
			SALARY * ( 1 + NVL(BONUS, 0) ) * 12 "보너스포함연봉"
			FROM EMPLOYEE
			NATURAL JOIN JOB)
WHERE "나이" IN (SELECT MIN('2024'  - TO_CHAR ( TO_DATE(SUBSTR((EMP_NO),1,2), 'RR'), 'YYYY' ))
               FROM EMPLOYEE
               GROUP BY JOB_CODE)
ORDER BY "나이" DESC;

SELECT EMP_ID, EMP_NAME, JOB_NAME, 나이, 보너스포함연봉
FROM (SELECT EMP_ID, EMP_NAME, JOB_NAME,
			'2024'  - TO_CHAR ( TO_DATE(SUBSTR((EMP_NO),1,2), 'RR'), 'YYYY' ) "나이",
			SALARY * ( 1 + NVL(BONUS, 0) ) * 12 "보너스포함연봉"
			FROM EMPLOYEE
			NATURAL JOIN JOB
		 )
WHERE "나이" IN (SELECT MIN('2024'  - TO_CHAR ( TO_DATE(SUBSTR((EMP_NO),1,2), 'RR'), 'YYYY' )) 
                FROM EMPLOYEE
                NATURAL JOIN JOB
                GROUP BY JOB_NAME
                )
          
ORDER BY "나이" DESC;

-- 내가 넣고 싶은 문장
SELECT JOB_NAME, MIN('2024' - TO_CHAR ( TO_DATE(SUBSTR((EMP_NO),1,2), 'RR'), 'YYYY' )) "나이"
FROM JOB
NATURAL JOIN EMPLOYEE
GROUP BY JOB_NAME
ORDER BY 2 DESC;

SELECT JOB_NAME, MIN('2024'  - TO_CHAR ( TO_DATE(SUBSTR((EMP_NO),1,2), 'RR'), 'YYYY' ))
FROM EMPLOYEE
NATURAL JOIN JOB
GROUP BY JOB_NAME;

SELECT EMP_ID, EMP_NAME, JOB_NAME,
			'2024'  - TO_CHAR ( TO_DATE(SUBSTR((EMP_NO),1,2), 'RR'), 'YYYY' )"나이",
			 SALARY * ( 1 + NVL(BONUS, 0) ) * 12 "보너스포함연봉"
FROM EMPLOYEE
NATURAL JOIN JOB
WHERE ('2024'  - TO_CHAR ( TO_DATE(SUBSTR((EMP_NO),1,2), 'RR'), 'YYYY')) IN (SELECT MIN('2024'  - TO_CHAR ( TO_DATE(SUBSTR((EMP_NO),1,2), 'RR'), 'YYYY' ))
                 FROM EMPLOYEE
                 JOIN JOB USING (JOB_CODE)
                 GROUP BY JOB_NAME)
ORDER BY 나이 DESC;

-- 선생님 풀이와 다른 점 서브쿼리문에서 나이가 겹치는 애들이 다 출력되는 거임
-- 선생님 풀이는 주민등록번호 고유 번호라서 중복 없음
-- 드래그해서 ALT + X 실행해보면 됨