## ADP 실기 대비 - R programming 준비

### Data preprocessing
- 데이터 불러오기          : JB_LoadingData.R
  - excel
  - csv
  - tab
  - txt
- 데이터 저장하기          : JB_SavingData.R
- 변수 타입 설정           : JB_chgColType.R
  - dplyr을 이용한 변수 타입 변환
  - 날짜형 변환 --> timestamp 변환
  - 범주형 변환
  - 수치형 변환
  - 문자형 변환

- 데이터 통합              : JB_itgrtData.R
- 데이터 pivoting          : JB_pivotData.R

- 데이터 분할              : JB_splitData.R
- 정규표현식 정리           
  - 특수문자 제거 방법
- 결측치 처리              : JB_treatNa.R
  - 행 제거
  - 열 제거
  - 결측치 대체
    - 평균 값
    - 이전 값
    - 임의 값
    - 중앙 값


- 이상치 처리               : JB_treatOutlier.R
  이상치 Rule
  - IQR
  - 백분위수
   
  이상치 대체 값
  - NA
  - min/max
  - 제거


- 데이터 정렬                : JB_orderByData.R
- 데이터 윈도우              : JB_windowData.R
- 데이터 시프트              : JB_shiftData.R
- 데이터 샘플링              : JB_samplingData.R
- 데이터 표준화              : JB_stdData.R
  - 01 변환
  - scale 변환
- 데이터 인코딩              : JB_encodingData.R
### EDA + Visualiztion
- 자료 요약(통계)            : JB_summary.R 
  - 수치형
  - 문자형
  - 날짜형
  - 범주형
- ggplot2 기본 기능 익히기   : JB_ggpplot2.R
- 산점도                     : JB_ScatterPlot.R
- 산점도 행렬                  
- Time Trend                 : JB_timeTrend.R
- 파이차트                   : JB_pieChart.R
- 밀도함수
- 막대그래프
- 산점도
- headMap

- 히스토그램
- boxplot
- 히트맵

### Statistics 
- 정규성 검정
- 상관분석
- 분산분석
- 평균 유의차 분석

- 영향인자탐지(수치형, 범주형)
- 등분산검정
- 교호작용 인자탐지
- 범주형 유의차 분석(카이제곱검정, 독립성검정)

### modeling

#### unsupervised Model
- 주성분분석
- 군집분석
  - 계층적 군집분석
  - k-평균 군집분석


#### assemble Model
- bagging
- boosting
- random Forest
- xgboost


#### prediction Model
- 회귀분석
  - Linear 회귀분석
  - Ridge 회귀분석
  - Lasso 회귀분석
  - elastic 회귀분석
- 의사결정나무 모형
- 시계열 예측
- 신경망 모형
- SVM

#### Classification Model
- 로지스틱 회귀모형
- 신경망 모형
- 의사결정나무 모형
- SVM

### evaluation
- confusion matrix
- ROC Curve
- 이익도표와 향상도 곡선
- RMSE