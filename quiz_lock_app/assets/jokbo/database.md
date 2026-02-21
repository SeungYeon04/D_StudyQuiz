# 데이터베이스구축

SQL: DB에서 조회, 삽입, 수정, 삭제 등을 위한 표준언어  
  
#### 기본 명령어 

| 명령어 | 내용 |
|------|------|
| SELECT | 테이블에서 DB 조회 |
| INSERT | 새 데이터 행 추가 |
| DELETE | 특정 행 삭제 | 
| SELECT | 절의 실행 순서 | 
| LEFT JOIN | 왼쪽 테이블 기준, 매칭 안 되는 오른쪽 값은 NULL로 채움 | 
| RIGHT JOIN | 오른쪽 테이블 기준, 왼쪽에 없는 값은 NULL | 
| HAVING | 그룹핑 되어있는 데이터에 조건 걸 때 사용 (WHERE은 그룹핑 전에 씀) | 
| VIEW | 가상 테이블, 실제 데이터 미저장, 쿼리 단순화·보안 목적 사용 | 
| INDEX | 빠른 테이블 검색용 자료구조. 책의 색인처럼 작동 | 
| PROCEDURE(프로시저) | 자주 쓰는 SQL 명령 프로그램 단위로 묶어 저장. 이름 호출로 반복 실행 가능 | 

  
```
절의 실행 순서 
SELECT ➡️ FROM ➡️ WHERE ➡️ GROUP BY ➡️ HAVING ➡️ ORDER BY 
```
  
#### SQL 문법 종류 역할 구분 

| SQL | 역할 |
|------|------|
| DDL (데이터 정의어) | 1. DB 구조(테이블, 뷰 등)를 생성•변경•삭제 할 때 사용(CREATE, ALTER, DROP)<br>2. 실행 즉시 DB 반영 COMMIT 되며 ROLLBACK 불가 |
| DML(데이터 조작어) | 1. 테이블에 저장된 데이터를 다룰 때 사용(SELECT, INSERT, UPDATE, DELETE)<br>2. 변경 내용은 커밋 전까지 임시 저장 상태 |
| DCL (데이터 제어어) | 사용자 권한 부여 또는 회수할 때 사용(GRANT, REVOKE)<br>2. 자동 커밋 발생할 가능성 있음 |
| TCL (트랜잭션 제어어) | 트랜잭션 단위로 작업 처리 관리하고, 명령어는 COMMIT, ROLLBACK, CHECKPOINT |
| COMMIT | 변경사항을 DB에 영구 저장 |  
| ROLLBACK | 작업 도중 오류 시 이전 상태로 되돌림 | 
| CHECKPOINT | 복구용 기준 시점 저장 | 



