# 주성분 분석(PCA)
# 차원 감소 기법 중 하나
# 선형적인 상곤관계가 없는 다른 변수들로 재표현
# 주성분들은 원 데이터의 분산을 최대한 보존하는 방법으로 구함

# 결과 중 scores는 주성분 점수를 의미
princomp(
  x,      # 행렬 또는 데이터 프레임
  cor = F # cor=F이면 공분산 행렬, T면 상관 행렬을 사용한 주성분 분석을 함
)

x    <- 1:10
y    <- x + runif(10, min = -.5, max = .5)
z    <- x + y + runif(10, min = -.10, max = .10)
data <- data.frame(x, y, z)
pr   <- princomp(data)
summary(pr)

#################
# 2. 변수 선택 ##
#################

# 1. 0에 가까운 분산
# 일반적으로 변수의 분산이 0에 가까우면 해당 변수를 제거할 수 있음
# ** 결과 해석 
# nsv 컬럼은 Near Zero Variance를 뜻하므로, nsv 컬럼에 TRUE로 표시된 변수들을 제거
# caret::nearZeroVar function
library(caret)
caret::nearZeroVar(
  x,      # 숫자를 저장한 행렬 또는 매트릭스. 또는 숫자만 저장한 데이터 프레임
  # 변수에서 가장 많이 관찰되는 값의 개수와 두 번째로 많이 관찰되는 값의 개수의 비에 대한 컷오프
  # 해당 비보다 차이가 많이나면 제거
  freqCut     = 95/5,
  # 전체 데이터 개수와 서로 다른 값의 개수의 비에 대한 컷오프
  uniqueCut   = 10,
  # False면 위치 반환 
  # True면  데이터 프레임 반환
  saveMetrics = F
)

library(caret)
library(mlbench)
data(Soybean)
nearZeroVar(Soybean, saveMetrics = T)

# 2. 독립변수들 간의 상관 계수가 높으면 변수를 제거
# - 상관 관계가 높은 변수들이 있다면 주성분 분석을 이용하여 차원 축소를 시도하거나,
# - 상관 계수가 큰 변수를 제거

# caret::findCorrelation function
# 상관 계수가 높은 변수들을 찾음
# 반환 값은 상관 계수가 너무 높아 제거해야 하는 변수들의 색인
# 수치형 데이터만 적용해야 함
# 동작 방식
# (1) 상관 계수 행렬을 입력으로 받아 상관 계수가 cutoff를 넘는 쌍 (A, B)를 찾는다
# (2) A와 B 둘을 제외한 다른 변수와의 상관 계수가 큰 변수 하나 삭제
# (3) 1~2를 계속 반복하면서 상관 계수가 높은 변수들을 제거

caret::findCorrelation(
  x,      # 상관계수 행렬
  cutoff  # 상관계수에 대한 cutoff
)

library(mlbench)
library(caret)
data(Vehicle)
rj        <- findCorrelation(cor(subset(Vehicle, select = -c(Class))))
myVehicle <- Vehicle[,-rj]


# FSelector::linear.correlation 
# 피어슨 상관 계수를 고려한 변수의 가중치를 계산
# 예측하고자 하는 대상 값과 예측 변수 간 피어슨 상관 계수를 고려했을 때 각 예측 변수를 얼마나
# 비중 있게 다루어야 하는지를 알려주는 가중치
# 이 값은 피어슨 상관계수의 절대 값

# FSelector::rank.correlation 
# 스피어만 상관 계수를 고려한 변수의 가중치 계산
FSelector::rank.correlation(
  formula,
  data 
)

# FSelector::curoff.k
FSelector::cutoff.k(
  # 순위를 첫번째 컬럼, 변수명을 행 이름(rowname)에 저장한 데이터 프레임
  # linear.correlation() 함수나 rank.correlation() 함수의 반환 값으로 지정하면 됨
  attrs,
  k
)
# 반환 값은 선택된 속성명을 저장한 문자열 백터. 
# k번째 까지의 속성을 보여줌
FSelector::cutoff.k.percent(
  attrs,
  k
)

# 3. 카이 제곱 검정(Chi-Squared Test)
# 변수와 분류 간의 독립성을 검정해 볼 수 있음
# 둘 간의 관계가 독립이라면 모델링에 적합하지 않다고 판단 가능

# FSelector::chi.squared function
# attr_importance : 변수의 중요도를 평가
FSelector::chi.squared(
  formula,
  data 
)

library(FSelector)
library(mlbench)
data(Vehicle)
cs <- chi.squared(Class ~., data = Vehicle)
cutoff.k(cs , 3) # 그 중 3개의 변수를 선택


# 4. 모델을 사용한 변수 중요도 평가
# 이 함수가 변수의 중요도를 평가하는 자세한 방법은 인자에 주어진 모델에 따라 다름
caret::varImp(
  object # 회귀 또는 분류 모델
)

library(mlbench)
library(rpart)
library(caret)
data(BreastCancer)
m <- rpart(Class ~., data = BreastCancer)
varImp(m)

######################
# 3. 모델 평가 방법 ##
######################

# confusion Matrix





