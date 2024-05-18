CREATE TABLE TODO (
TODO_PK NUMBER CONSTRAINT "TODO_PK" PRIMARY KEY, -- 기본키 NUMBER
TODO_NO NUMBER NOT NULL, -- 할일 목록 만들기 키를 누를 때 생성되는 시퀀스로 번호를 만들어서 묶어둠 요청 받은 사람들이 여러 명일 때 어떤 할 일에 관한 건지 알기 위해(한 명의 요청자가 여러 요청을 할 수 있기 때문에 구분할 수 있는 키가 필요함 )
TODO_CONTENT NVARCHAR2(300), -- 내용 CLOB 이든지 NVARCHAR2
TODO_REQUEST_MEMBER_NO NUMBER NOT NULL, -- 요청한 놈 MEMBER테이블 기본키로서 이 컬럼은 외래키로 설정함. 1번 페이지 나눌 때 사용
TODO_WHO_DO NUMBER NOT NULL, -- 요청받은 놈 MEMBER 테이블 기본키로서 2번페이지 나눌 때 사용
COMPLETE_CONDITION NUMBER NOT NULL, -- 완료조건 한명만 해도되면 1, 모두 다 해야 완료되는 조건이면 2, 1인 경우 한명이 완료 누르면 완료된 걸로 넘어가게
FILE_PATH VARCHAR2(500), -- 파일 하나 올릴 수 있게함.
ORIGINAL_NAME VARCHAR2(300),
FILE_RENAME VARCHAR2(100),
TODO_DATE, -- 요청한 날짜를 기록함. 조회조건 중 등록순을 위함.
GIHAN, -- 기한을 나타냄 DATE
STATUS, -- 완료여부. 3가지 경우가 있음. 1 2 3 으로 구분. 1은 기본값으로서 아직 기한이 안지났고, 미완료인 상태. 2는 기한이 안지났고 완료인 상태, 3은 기한이 지났고 미완료인 상태(실패)
TODO_COMPLETE -- 요청 받은 사람이 완료하기를 눌렀을 때 상태 변화를 나타내 줌 3번 페이지 나눌 때 사용
);