-- 4. FOREIGN KEY(외래키/외부키) 제약조건

-- 참조(REFERENCES)된 다른 테이블의 컬럼이 제공하는 값만 사용할 수 있음
-- FOREIGN KEY 제약조건에 의해서 테이블 간의 관계가 형성됨
-- 제공되는 값 외에는 NULL 값을 사용할 수 있음.

-- 컬럼 레벨일 경우
-- 컬럼명 자료형(크기) [CONSTRAINT 이름] REFERENCES 참조할테이블명 [(참조할컬럼)] [삭제룰]

-- 테이블 레벨일 경우
-- [CONSTRAINT 이름] FOREIGN KEY (적용할컬럼명) REFERENCES 참조할테이블명 [(참조할컬럼)] [삭제룰]

-- * 참조될 수 있는 컬럼은 PRIMARY KEY 컬럼과, UNIQUE 지정된 컬럼만 외래키로 사용할 수 있음.
-- 참조할 테이블의 참조할 컬럼명이 생략되면, PRIMARY KEY로 설정된 컬럼이 자동 참조할 컬럼이 됨.

-- 부모테이블 / 참조할 테이블(대상이 되는 테이블)

CREATE TABLE USER_GRADE(
		GRADE_CODE NUMBER PRIMARY KEY, -- 등급 번호
		GRADE_NAME VARCHAR2(30) NOT NULL -- 등급명
);

INSERT INTO USER_GRADE VALUES(10, '일반회원');
INSERT INTO USER_GRADE VALUES(20, '우수회원');
INSERT INTO USER_GRADE VALUES(30, '특별회원');

SELECT * FROM USER_GRADE;

-- 자식 테이블 (USER_GRADE을 사용할 테이블)
CREATE TABLE USER_USED_FK(
		USER_NO NUMBER PRIMARY KEY,
		USER_ID VARCHAR2(20) UNIQUE,
		USER_PWD VARCHAR2(30) NOT NULL,
		USER_NAME VARCHAR2(30),
		GENDER VARCHAR2(10),
		PHONE VARCHAR2(30),
		EMAIL VARCHAR2(50),
		-- 컬럼 레벨
		GRADE_CODE NUMBER CONSTRAINT GRADE_CODE_FK REFERENCES USER_GRADE /*(GRADE_CODE)*/
		-- 컬럼명 미작성 시 USER_GRADE 테이블의 PK를 자동 참조 (GRADE_CODE 생략 가능)

		-- 테이블 레벨
		-- , CONSTRAINT GRADE_CODE_FK FOREIGN KEY(GRADE CODE) REFERENCES USER_GRADE
		--> FOREIGN KEY 라는 단어는 테이블 레벨에서만 사용		
);

COMMIT;

INSERT INTO USER_USED_FK
VALUES(1, 'USER01', 'PASS01', '홍길동', '남', '010-1234-5678', 'hong123@kh.or.kr', 10);

INSERT INTO USER_USED_FK
VALUES(2, 'USER02', 'PASS02', '이순신', '남', '010-5678-9012', 'lee123@kh.or.kr', 10);

INSERT INTO USER_USED_FK
VALUES(3, 'USER03', 'PASS03', '유관순', '여', '010-9999-3131', 'yoo123@kh.or.kr', 30);

INSERT INTO USER_USED_FK
VALUES(4, 'USER04', 'PASS04', '안중근', '남', '010-2222-1111', 'ahn123@kh.or.kr', NULL);
--> NULL 사용 가능
-- USER_GRADE 테이블에 GRADE_CODE 가 PRIMARY KEY라서 그 테이블에 INSERT INPO 값으로는
-- NULL과 중복값이 사용 안되지만 REFERENCES로 참조한 컬럼에는 부모 테이블에서 제공하는
-- 값 외에는 NULL 값 사용 가능

INSERT INTO USER_USED_FK
VALUES(5, 'USER05', 'PASS05', '윤봉길', '남', '010-6666-1234', 'yoon123@kh.or.kr', 50);
-- ORA-02291: 무결성 제약조건(SONGJY.GRADE_CODE_FK)이 위배되었습니다- 부모 키가 없습니다
--> 50이라는 값은 USER_GRADE 테이블 GRADE_CODE 컬럼에서 제공하는 값이 아니므로
-- 외래키 제약조건에 위배되어 오류 발생.

SELECT * FROM USER_USED_FK;

COMMIT;

----------------------------------------------------------------------------------------

-- * FOREIGN KEY 삭제 옵션
-- 부모 테이블의 데이터 삭제 시 자식 테이블의 데이터를
-- 어떤 식으로 처리할 지에 대한 내용을 설정할 수 있다.

-- 1) ON DELETE RESTRICTED(삭제 제한)로 기본 지정되어 있음
-- FOREIGN KEY로 지정된 컬럼에서 사용되고 있는 값일 경우
-- 제공하는 컬럼의 값은 삭제하지 못함

DELETE FROM USER_GRADE WHERE GRADE_CODE = 30; -- 30은 자식테이블에서 사용되고 있는 값
-- ORA-02292: 무결성 제약조건(SONGJY.GRADE_CODE_FK)이 위배되었습니다- 자식 레코드가 발견되었습니다

-- GRADE_CODE 중 20은 외래키로 참조되고 있지 않으므로 삭제가 가능함.
DELETE FROM USER_GRADE WHERE GRADE_CODE = 20;
SELECT * FROM USER_GRADE; -- 20 삭제됨
ROLLBACK;

-- 2) ON DELETE SET NULL : 부모키 삭제 시 자식키를 NULL로 변경하는 옵션
CREATE TABLE USER_GRADE2(
		GRADE_CODE NUMBER PRIMARY KEY, -- 등급 번호
		GRADE_NAME VARCHAR2(30) NOT NULL -- 등급명
);

INSERT INTO USER_GRADE2 VALUES(10, '일반회원');
INSERT INTO USER_GRADE2 VALUES(20, '우수회원');
INSERT INTO USER_GRADE2 VALUES(30, '특별회원');

SELECT * FROM USER_GRADE2;

-- ON DELETE SET NULL 삭제 옵션이 적용된 테이블 생성
CREATE TABLE USER_USED_FK2(
		USER_NO NUMBER PRIMARY KEY,
		USER_ID VARCHAR2(20) UNIQUE,
		USER_PWD VARCHAR2(30) NOT NULL,
		USER_NAME VARCHAR2(30),
		GENDER VARCHAR2(10),
		PHONE VARCHAR2(30),
		EMAIL VARCHAR2(50),
		-- 컬럼 레벨
		GRADE_CODE NUMBER CONSTRAINT GRADE_CODE_FK2 REFERENCES USER_GRADE2 ON DELETE SET NULL
		                                                                    /* 삭제 옵션 */
);

INSERT INTO USER_USED_FK2
VALUES(1, 'USER01', 'PASS01', '홍길동', '남', '010-1234-5678', 'hong123@kh.or.kr', 10);

INSERT INTO USER_USED_FK2
VALUES(2, 'USER02', 'PASS02', '이순신', '남', '010-5678-9012', 'lee123@kh.or.kr', 10);

INSERT INTO USER_USED_FK2
VALUES(3, 'USER03', 'PASS03', '유관순', '여', '010-9999-3131', 'yoo123@kh.or.kr', 30);

INSERT INTO USER_USED_FK2
VALUES(4, 'USER04', 'PASS04', '안중근', '남', '010-2222-1111', 'ahn123@kh.or.kr', NULL);
--> NULL 사용 가능

COMMIT;

SELECT * FROM USER_GRADE2;
SELECT * FROM USER_USED_FK2;

-- 부모 테이블인 USER_GRADE2에서 GRADE_CODE = 10 삭제
--> ON DELETE SET NULL 옵션이 설정되어 있어 오류 없이 삭제됨
DELETE FROM USER_GRADE2
WHERE GRADE_CODE = 10;

SELECT * FROM USER_GRADE2;
SELECT * FROM USER_USED_FK2; -- 10을 가졌던 자식 테이블 값이 NULL이 됨을 확인.

-- 3) ON DELETE CASCADE : 부모키 삭제시 자식키도 함께 삭제됨
-- 부모키 삭제시 값을 사용하는 자식 테이블의 컬럼에 해당하는 행이 삭제됨
CREATE TABLE USER_GRADE3(
		GRADE_CODE NUMBER PRIMARY KEY, -- 등급 번호
		GRADE_NAME VARCHAR2(30) NOT NULL -- 등급명
);

INSERT INTO USER_GRADE3 VALUES(10, '일반회원');
INSERT INTO USER_GRADE3 VALUES(20, '우수회원');
INSERT INTO USER_GRADE3 VALUES(30, '특별회원');

SELECT * FROM USER_GRADE3;

-- ON DELETE CASCADE 삭제 옵션이 적용된 테이블 생성
CREATE TABLE USER_USED_FK3(
		USER_NO NUMBER PRIMARY KEY,
		USER_ID VARCHAR2(20) UNIQUE,
		USER_PWD VARCHAR2(30) NOT NULL,
		USER_NAME VARCHAR2(30),
		GENDER VARCHAR2(10),
		PHONE VARCHAR2(30),
		EMAIL VARCHAR2(50),
		GRADE_CODE NUMBER,
		CONSTRAINT GRADE_CODE_FK3 FOREIGN KEY(GRADE_CODE)
		REFERENCES USER_GRADE3(GRADE_CODE) ON DELETE CASCADE
);

INSERT INTO USER_USED_FK3
VALUES(1, 'USER01', 'PASS01', '홍길동', '남', '010-1234-5678', 'hong123@kh.or.kr', 10);

INSERT INTO USER_USED_FK3
VALUES(2, 'USER02', 'PASS02', '이순신', '남', '010-5678-9012', 'lee123@kh.or.kr', 10);

INSERT INTO USER_USED_FK3
VALUES(3, 'USER03', 'PASS03', '유관순', '여', '010-9999-3131', 'yoo123@kh.or.kr', 30);

INSERT INTO USER_USED_FK3
VALUES(4, 'USER04', 'PASS04', '안중근', '남', '010-2222-1111', 'ahn123@kh.or.kr', NULL);
--> NULL 사용 가능

COMMIT;

SELECT * FROM USER_GRADE3;
SELECT * FROM USER_USED_FK3;

-- 부모 테이블인 USER_GRADE3에서 GRADE_CODE = 10 삭제
--> ON DELETE CASCADE 옵션이 설정되어 있어서 오류 없이 삭제됨.
DELETE FROM USER_GRADE3
WHERE GRADE_CODE = 10;

-- ON DELETE CASCADE 옵션으로 인해 참조키를 사용한 행이 삭제됨을 확인
SELECT * FROM USER_GRADE3;
SELECT * FROM USER_USED_FK3;