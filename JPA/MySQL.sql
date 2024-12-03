# MySQL 기본 쿼리 실습
show databases;

# 데이터베이스 생성
create database member;

show databases;

# 데이터베이스 삭제
drop database member;

# member 데이터베이스 사용
use member;

# member 안에 table 확인
show tables;

# member 안에서 MEMBER 테이블 생성
CREATE TABLE member (
	num int NOT NULL auto_increment,
	name varchar(32) NOT NULL,
	id varchar(12) DEFAULT 'guest',
	phone varchar(12) NOT NULL,
	PRIMARY KEY (num)
) engine=InnoDB charset=utf8mb4;

show tables;

# table 세부사항 확인
desc member;

# member 테이블에 내용 insert num은 자동으로 증가하기 때문에 안 적어줘도 됨
insert into member (name, id, phone) values ('홍길동', 'mr.hong', '010-111-2222');

select * from member;

insert into member (name, id, phone) values ('이순신', 'mr.lee', '010-222-2222');

# 컬럼명 생략도 가능
insert into member values ('3', '김유신', 'mr.kim', '010-333-2222');

insert into member (name, id, phone) values
('', '', ''),
('', '', ''),
('', '', ''),
('', '', '');

# 안에 들어있는 값 다 지우기
delete from member;

insert into member (name, id, phone) values
('홍길동', 'mr.hong', '010-111-1111'),
('이순신', 'mr.lee', '010-222-2222'),
('김유신', 'mr.kim', '010-333-3333');

select * from member;

insert into member (name, phone) values ('을지문덕', '010-444-4444');
insert into member (name, phone) values ('신사임당', '010-555-5555');

show databases;

use member;

show tables;

desc member;

select * from member;

insert into member values ('13', '강감찬', 'mr.kang', '010-666-6666');
insert into member values (default, '강감순', 'mr.soon', '010-777-7777');

# 현재 내가 어떤 데이터베이스를 사용하고 있는지 확인할 때
select database();

# 버전 확인
select version();

# 현재 사용자 확인
select user();

# root 비밀번호 변경
show databases;

use mysql;

show tables;

select host, user, authentication_string from user;

ALTER user 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '12345678';

# 기본 쿼리문
use member;

select * from member;

# update
update member set id='mr.shin' where num=12;

# delete
delete from member where num=11;

# 자동으로 증가하는 num 값 초기화 (1번부터 시작) DELETE 한다고 초기화 되는 것 아님
# truncate : 길이를 줄이다, 짧게하다 -> 전체 데이터 모두 삭제되고 num 값도 초기화 됨 (완전 초기화)
truncate table member;

insert into member (name, id, phone) values ('홍길동', 'mr.hong', '010-111-1111');

create table user (
	num int not null auto_increment,
	name varchar(32) not null,
	primary key(num)
)engine=InnoDB charset=utf8mb4;

show tables;

drop table user;

# 테이블명 변경 (member -> tbl_member) rename
rename table member to tbl_member;

select * from tbl_member;

rename table tbl_member to member;

select * from member;

# database 명 변경 (move)
show databases;

# 새로운 데이터 베이스를 만들어두고 기존 데이터베이스 안에 테이블들을 옮겨줘야함
# 기존 데이터베이스는 따로 삭제해주면 됨
create database member3;

use member2;

# 기본형
# member2 테이블을 member3로 옮겨줌 데이터베이스명.원본테이블 use member2 면 테이블명만 작성해주면 됨
rename table member2.member to member3.member;
rename table member to member3.member;
# member3에 테이블을 만든 적 없어도 member라는 테이블 생성되면서 이동됨 (member2의 member테이블은 없어짐)

use member3;
show tables;

show databases;

# member2에는 내용 없으니 삭제
drop database member2;

# 테이블 속성 변경
# type, 길이, null 허용 등등 변경하기
-- 기본형 Alter table [테이블명] modify [필드명] [타입] not null;
# 뒤에 not null 안 붙이면 null 허용

SELECT user();
use member;

desc member;

alter table member modify id varchar(12) not null;

# not null 적지 않으면 null 허용
alter table member modify id varchar(12) default 'guest';

alter table member modify phone varchar(13) not null;

# 필드 추가
-- 기본형 alter table [테이블명] add [필드명][타입];

# content 필드 추가 (not null 안 적으면 null 허용)
alter table member add content text not null;

# null 허용으로 변경
alter table member modify content text;

# 필드 삭제
-- 기본형 alter table [테이블명] drop [필드명];

# content 필드 삭제
alter table member drop content;

use member;

desc member;

select * from member;