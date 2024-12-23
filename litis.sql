CREATE TABLE "ORGANIZATION" (
	"ORG_NO"	NUMBER		NOT NULL, -- 고유 번호
	"ORG_NAME"	VARCHAR2(200)		NOT NULL, -- 조직 이름
	"PARENT_ORG_NO"	NUMBER		NULL, -- 부모키
	"ORG_NO_DEL_FL" CHAR(1) DEFAULT 'N' NOT NULL -- 삭제 여부
);

COMMENT ON COLUMN "ORGANIZATION"."ORG_NO" IS '조직 기본키';

COMMENT ON COLUMN "ORGANIZATION"."ORG_NAME" IS '조직 이름';

COMMENT ON COLUMN "ORGANIZATION"."PARENT_ORG_NO" IS '조직 부모키';

ALTER TABLE "ORGANIZATION" ADD CONSTRAINT "PK_ORGANIZATION" PRIMARY KEY (
	"ORG_NO"
);

CREATE SEQUENCE SEQ_ORG_NO NOCACHE;

SELECT * FROM "ORGANIZATION";

INSERT INTO "ORGANIZATION" VALUES (SEQ_ORG_NO.NEXTVAL, '대표이사', NULL);
INSERT INTO "ORGANIZATION" VALUES (SEQ_ORG_NO.NEXTVAL, '경영관리', 1);
INSERT INTO "ORGANIZATION" VALUES (SEQ_ORG_NO.NEXTVAL, '영업본부', 1);
INSERT INTO "ORGANIZATION" VALUES (SEQ_ORG_NO.NEXTVAL, '솔루션사업부', 1);
INSERT INTO "ORGANIZATION" VALUES (SEQ_ORG_NO.NEXTVAL, '연구소', 1);

SELECT * FROM "ORGANIZATION";

INSERT INTO "ORGANIZATION" VALUES (SEQ_ORG_NO.NEXTVAL, '영업 1팀', 3);
INSERT INTO "ORGANIZATION" VALUES (SEQ_ORG_NO.NEXTVAL, '영업 2팀', 3);

INSERT INTO "ORGANIZATION" VALUES (SEQ_ORG_NO.NEXTVAL, '프로젝트 수행 팀', 4);

INSERT INTO "ORGANIZATION" VALUES (SEQ_ORG_NO.NEXTVAL, '연구소 1', 5);
INSERT INTO "ORGANIZATION" VALUES (SEQ_ORG_NO.NEXTVAL, '연구소 2', 5);

SELECT * FROM "ORGANIZATION";

INSERT INTO "ORGANIZATION" VALUES (SEQ_ORG_NO.NEXTVAL, '엔진 개발', 9);

INSERT INTO "ORGANIZATION" VALUES (SEQ_ORG_NO.NEXTVAL, '솔루션 개발', 10);
INSERT INTO "ORGANIZATION" VALUES (SEQ_ORG_NO.NEXTVAL, '시스템 개발', 10);

SELECT LEVEL, ORG_NAME
FROM ORGANIZATION
WHERE ORG_NO_DEL_FL = 'N'
START WITH PARENT_ORG_NO IS NULL
CONNECT BY PRIOR ORG_NO = PARENT_ORG_NO
ORDER SIBLINGS BY ORG_NO;

-- 넣은 순서대로 출력이 아닌 순서를 새로 부여해서 출력
SELECT 
    ORG_NAME, LEVEL
FROM 
    ORGANIZATION
WHERE 
    ORG_NO_DEL_FL = 'N'
START WITH 
    PARENT_ORG_NO IS NULL
CONNECT BY 
    PRIOR ORG_NO = PARENT_ORG_NO
ORDER SIBLINGS BY 
    CASE ORG_NAME
        WHEN '대표이사' THEN 1
        WHEN '경영관리' THEN 2
        WHEN '영업본부' THEN 3
        WHEN '영업 1팀' THEN 4
        WHEN '영업 2팀' THEN 5
        WHEN '솔루션사업부' THEN 6
        WHEN '프로젝트 수행 팀' THEN 7
        WHEN '연구소' THEN 8
        WHEN '연구소 1' THEN 9
        WHEN '엔진 개발' THEN 10
        WHEN '연구소 2' THEN 11
        WHEN '솔루션 개발' THEN 12
        WHEN '시스템 개발' THEN 13
        ELSE 999
    END;