## Chapter_01 데이터 처리 프로세스
-----
### ETL(Extraction, Transaction and Load) 개요
> 데이터 이동과 변환 절차와 관련된 업계 표준 용어
> 데이터 웨어하우스(DW), 운영 데이터 스토어(ODS), 데이터 마트(DM)에 대한 데이터 적재 작업의 핵심 구성 요소
> 데이터 통합, 데이터 이동, 마스터 데이터 관리에 걸쳐 폭넓게 활용

> * ETL은 데이터 이동과 변환을 주 목적으로 하며, 3가지 기능으로 구성
> <b> ① Extraction(추출) </b>  
> 하나 또는 그 이상의 데이터 원천(Source)들로부터 데이터 획득
> <b> ② Transformation(변환) </b>
> 데이터 클랜징, 형식 변환, 표준화, 통합 또는 다수 애플리케이션에 내장된 비즈니스 룰 적용 등
> <b> ③ Loading(적재) </b>
> 위 변형 단계 처리가 완료된 데이터를 특정 목표 시스템에 적재

> * ETL 작업 단계에는 MPP(Massive Parallel Processing)를 지원
> 또한 다수 시스템들간 대용량, 복잡도가 높은 비즈니스 룰 적용이 필요한 데이터 교환에 활용

> * ETL 구현을 위한 여러 상용 S/W들이 있으며,
> <b>일괄(Batch) ETL</b>과 <b>실시간(Real Time) ETL</b>로 구분

### * ODC와 데이터 웨어하우스 개념도
> ![img](C://데이터분석자료/ADP준비자료/ODC.jpg)

> * Step 0 interface : 다양한 이기종 DBMS 및 스프레드시트 등 데이터 원천(Source)으로부터 데이터를 획득하기 위한 인터페이스 매커니즘 구현

> * Step 1 Staging ETL : 수립된 일정에 따라 데이터 원천(Source)으로부터 트렌젝션 데이터 획득 작업 수행 후, 획득된 데이터를 스테이징 테이블에 저장
> * Step 2 Profiling ETL : 스테이징 테이블에서 데이터 특성을 식별하고 품질을 측정
> * Step 3 Cleansing ETL : 다양한 규칙들을 활용해 프로파일링된 데이터 보정 작업
> * Step 4 Integration ETL : (이름, 값, 구조) 데이터 충돌을 해소하고, 클렌징된 데이터를 통합
> * Step 5 Denormalizing ETL : 운영 보고서 생성, 데이터 웨어 하우스 또는 데이터 마트 데이터 적재를 위해 데이터 비정규화 수행

### ODS(Operational Data Store) 구성
> * 데이터 추가 작업을 위해 다양한 데이터 원천(Source)들로부터의 데이터 추출, 통합한 DB
> * 향후 비즈니스 지원을 위해 타 정보 시스템으로 이관, 다양한 보고서 생성을 위해 DW로 이관
> *다양한 원천 소스 데이터가 통합되기 때문에 데이터 클랜징, 중복 제거, 데이터 무결성 점검 등의 작업을 포함

> ![img](C://데이터분석자료/ADP준비자료/layeredODC.jpg)

> ① interface Layer
> * 다양한 데이터 원천들로부터 데이터를 획득하는 단계
> * 데이터를 획득하기 위한 프로토콜로는 OLEDB, ODBC, FTP 등과 더불어 DW의 Real Time, Near Real Time OLAP
> * 질의를 지원하기 위해 실시간 데이터 복제 인터페이스 기술들이 함께 활용됨

> ②Staging Layer
> * 작업 일정이 통제되는 프로세스들에 의해 데이터 원천들로부터 트랜잭션 데이터들이 추출
> * 하나 또는 그 이상의 스테이징 테이블들에 저장
> * 정규화 배제
> * 테이블 스키마는 데이터 원천의 구조에 의존적
> * 데이터 매핑은 1:1, 1: N 구조를 가짐
> * 데이터가 스테이징 테이블에 적재되는 시점에 control 정보도 동시에 저장
> * Batch 작업 형태와 Real Time 형태의 데이터 획득 방식을 혼용해 구성할 수 있음

> ③ profiling Layer
> * 범위, 도메인, 유일성 확보 등의 규칙을 기준으로 데이터 품질 점검 실시
> Step1 : 데이터 프로파일링 수행
> Step2 : 데이터 프로파일링 결과 통계 처리
> Step3 : 데이터 품질 보고서 생성 및 공유

> ④ cleansing Layer
> * 클렌징 ETL process 들로 앞데이터 프로파일링 단계에서 식별된 오류 데이터를 수정
> Step 1 : cleansing Stored Procedure
> Step 2 : Cleasing ETL Functions

> ⑤ data Integration Layer
> * 앞서 수정 완료한 데이터를 ODS 내에 단일 통합 테이블에 적재
> * 선행자료 및 조건 : 데이터 클랜징 테이블, 데이터 충돌 판단 요건
> Step 1 : Integration Stored Procedure 실행
> Step 2 : Integration ETL Functions 실행

> ⑥ Export Layer
> * export rule 과 security rule을 반영한 익스포트 ETL 기능을 수행해 Export 테이블을 생성
> * DBMS 클라이언트, Data Mart, DW에 적재
> * OLAP에 활용될 수 있음

### 데이터 웨어하우스(Data Warehouse)
> * DW의 특징
> ① 주제 중심(Subject Oriented)
> 특정 이벤트나 업무 항목을 기준으로 구조화
> ②영속성(Non Volatile)
> 최초 저장 이후에는 읽기 전용 속성을 가지며, 삭제되지 않음
> ③통합성(Integrated)
> DW 데이터는 기관, 조직이 보유한 대부분의 운영 시스템들에 의해 생성된 데이터 통합본
> ④시계열성(Time Variant)

> * DW Table들은 <b>Star Schema</b>  또는 <b> Snow Flake Schema </b> 로 모델링 됨
> ① Star Schema
> 조인 스키마라고도 함. DW 스키마 중 가장 단순. 사실 테이블을 중심으로, 차원 테이블로 구성
> 전통적인 관계형 DB를 통해 다차원 DB 기능 구현 가능
> 이해하기 쉽고, join table 개수가 적고, 쿼리 작성이 용이
> 비정규화에 따른 데이터 중복으로 테이블 적재 시 오래걸리는 단점 존재

> ② Snow Flake Schema
> 스타 스키마의 차원 테이블을 제3정규형으로 정규화한 형태
> 데이터의 중복이 제거돼 데이터 적재시 시간 단축
> Join Table의 증가로 쿼리 작성 난이도 상승

### CDC(Change Data Capture) 개요
> * DB 내 데이터의 변경을 식별해 필요한 후속 처리를 자동화하는 기술 또는 설계 기법이자 구조
> * 실시간 또는 근접 실시간 데이터 통합을 기반으로 하는 DW 및 저장소 구축에 폭 넓게 사용

> * CDC 구현 기법
> ① Time Stamp on Rows
> 테이블 내 마지막 변경 시점을 기록하는 TimeStamp 컬럼을 두고, 마지막 변경 TimeStamp 값 보다 더 최신 컬럼을
> 변경된 레코드로 식별
> ② Version Numbers on Rows
> 레코드의 버전을 기록하는 컬럼을 두고, 기 식별된 레코드의 버전보다 더 높은 레코드를 변경 된 것으로 식별
> 레코드들의 최신 버전을 기록 관리하는 참조 테이블을 함께 운용하는 것이 일반적
> ③ Status on Rows
> Time Stamp 및 Version Rows 의 보완 용도로 사용.
> 변경 여부를 True/False boolean 값으로 저장하는 컬럼의 상태 값을 기반으로 변경 여부 결정
> 시간이나 버전에 따른 식별 여부에 추가적으로 사람이 판단한 업무 규칙을 추가할 수 있음

> ④Time/Version/Status on Rows
> TimeStamp, version, Status 모두 활용하는 기법.
> 정교한 쿼리를 이용해 개발 유연성 제공

> ⑤ Triggers on Tables
> DB 트리거를 활용해 사전에 등록된 다수 대상 시스템에 변경 데이터를 베포하는 형태로 CDC를 구현
> DB 트리거는 시스템 관리 복잡도를 증가하고 유지보수성을 저하시키는 특성이 있어 사용 주의

> ⑥ Event Programming
> 데이터 변경 식별 기능을 Application에 구현
> Application 개발 부담과 복잡도를 증가시키나, 다양한 조건에 의한 CDC 매커니즘을 구현할 수 있는 기법

> ⑦ Log Scanner on Database
> DB 데이터에 대한 변경 여부와 변경 값 시간 등을 transaction 로그를 기록 관리하는 기능 제공
> 트랜잭션 로그에 대한 스캐닝 및 변경 내역에 대한 해석을 통해 CDC 매커니즘 수행
> DBMS 종류에 따라 작업 규모가 증가할 수 있음

> DB 영향도 최소화
> DB 사용 Application에 대한 영향도 최소화
> 변경 식별 지연시간 최소화
> 트랜잭션 무결성에 대한 영향도 최소화
> DB 스키마 변경 불필요

> * CDC 구현 방식
> CDC 구현 시, 데이터 원천에서 변경을 식별하고 대상 시스템에 변경 데이터를 적재해 주는 'Push' 방식과
> 대상 시스템에서 데이터 원천을 정기적으로 살펴보아 필요 시 데이터를 다운로드 하는 'Pull' 방식으로 구분

### EAI(Enterprise Application Integration)
> * EAI 개요
> 기업 정보 시스템들의 데이터를 연계. 통합하는 SW 정보 시스템 아키텍처 프레임워크
> 이질적 정보 시스템들의 데이터를 연계함으로써 상호 융화 내지 동기화돼 동작
> 프론트 오피스 시스템, 기존의 레거시 시스템, 패키지 어플리케이션 등의 형태로 산재된 정보 시스템들을 프로세스 및 메세지 차원에서 통합,관리 할 수 있게 함

> * 포인트 투 포인트 방식
> 기존 단위 업무 위주의 정보 시스템 개발 시, 데이터 연계의 복잡성 발생
> 정보 시스템간 데이터 통합과 연계 확보를 어렵게 하고, 마스터 데이터의 통합과 표준화를 불가능하게 함
> 이는 유지보수성을 저하 시킴
> -> 이를 해결하기 위해 <b>Hub and spoke </b> 방식의 EAI 기반 구조를 적용할 수 있음

> * EAI 구성 요소
> 정보 시스템과 EAI 허브(Engine) 간 연결성을 확보하기 위한 Adapter 들이 존재
> BUS: Adapter들을 매개로 각 정보 시스템들 간의 데이터 연동 경로
> Broker: 데이터 연동 규칙 통제
> Transformer : 데이터 형식 변환 등을 담당

> * EAI 구현 유형
> ① Meditation(intra-communication)
> EAI 엔진이 중개자(Broker)로 동작
> 특정 정보 시스템 내 유의미한 이벤트 발생을 식별해, 사전 약속된 정보 시스템들에게 그 내용을 전달
> ② Federation(inter-communication)
> EAI 엔진이 외부 정보 시스템으로부터의 데이터 요청들을 일괄적으로 수령해 필요한 데이터 전달

> ** intra VS inter
> intra : 어떤 것의 내부를 지칭, 어떤 scope가 핵심이 됨
> inter : 어떤 것과 다른 것의 상호 관계





### 용어 정리
> * 트랜잭션(transaction)
> 데이터베이스의 상태를 변화 시키기 위한 수행 작업 단위

> * 스태이징(staging)
> 소스시스템으로부터 제공 받은 데이터를 아무런 변화 없이 그대로 로딩하는 저장 공간
> Temporary 성 공간

> * OLE(Object Linkng and Embedding)
> 애플리케이션 사이에서 데이터를 공유하는 기술

> * ODBC(open DataBase Connectivity)
> 데이터베이스 표준 규격, 데이터베이스의 차이는 ODBC 드라이버에 흡수되기 때문에 사용자는
> ODBC에 정해진 순서에 따라서 프로그램을 쓰면 접속처의 DB 종류 상관없이 접근 가능

> * data profiling
> 프로파일링이란 데이터 품질 측정 대상 데이터베이스의 데이터를 읽어 컬럼, 테이블의 데이터 현황정보를 통계적으로 분석하는 것을 의미

> * OLAP(Online Analytics Processing)
> 대용량 업무 DB를 구성하고, BI를 지원하기 위해 사용되는 기술
> DW나 Data Mart와 같은 대규모 데이터에 대해 <b>최종 사용자가 정보에 직접 접근하여 정보를 분석</b>하고 의사결정에 활용할 수 있는 실시간 분석 처리
> 최종 사용자들이 전산 부서를 거치지 않고 자신이 직접 분석 데이터에 접근
