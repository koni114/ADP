# 분류알고리즘_2
# 1. 주성분 분석(PCA)
# 2. 변수 선택
#   - 0에 가까운 분산
#   - 상관 계수가 높으면 변수를 제거
#   - 카이 제곱 검정(Chi-Squared Test)
# 3. 분류 평가
#   - 평가 매트릭(Confusion Matrix)
#   - ROC Curve

#########################
## 1. 주성분 분석(PCA) ##
#########################
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

## 모델 평가 방법

#######################
##### 3. 분류 평가 ####
#######################

# 1. 평가 매트릭(Confusion Matrix)

#'           Y                 N 
#'  Y True Positive(TP)  False Positive(FP)
#'  N False Negative(FN) True Negative(TN)
#'  
#'  True, False        : 예측이 맞으면 True, 틀렸으면 False
#'  Positive, Negative : Y로 예측했으면, Positive, N으로 예측했으면 Negative

# 1. Precision
# TP / TP + FP
# Y로 예측한 것들 중, 실제로 Y인 것들의 비율

# 2. Accuracy
# TP + TN / ALL 
# 전체 예측에서 옳은 예측

# 3. Recall(= Sensitivity, TP Rate, Hit Rate)
# TP / TP + FN 
# 실제 Y인 것들 중, 예측이 Y로 된 경우의 비율

# 4. Specificity
# TN / FP + TN
# 실제 N인 것들 중, 예측이 N으로 된 경우의 비율 

# 5. FP Rate
# Y가 아닌데, Y로 예측된 비율
# FP / FP + TN 
# Y가 아닌데, Y로 예측된 비율. 1 - Specificity

# 6. F1 점수
# 2*(1 / (1/precision + 1/recall))
# Precision 과 recall의 조화 평균

# 7. Kappa
# 두 평가자의 평가가 얼마나 일치하는지 평가하는 값
# 0 ~ 1 사이의 값 가짐
# P(e)는 두 평가자의 평가가 우연히 일치할 확률
# 코헨의 카파는 두 평가자의 평가가 우연히 일치할 확률을 제외한 확률

# 1. caret::confusionMatrix
# No Information Rate : 가장 많은 값이 발견된 분류의 비율
#                       가장 많이 발견된 값으로만 예측했을때의 비율이므로, 반드시 이 값을 넘겨야 좋은 것임
library(caret)
caret::confusionMatrix(
  data,      # 예측값 또는 분할표
  reference  # 실제값
)

predicted <- c(1, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1)
actual    <- c(1, 0, 0, 1, 1, 0, 1, 1, 0, 1, 1, 1)

cm <- caret::confusionMatrix(  data        = as.factor(predicted)
                               , reference = as.factor(actual))

# ROC Curve
# x축은 FP Rate, Y축은 TP Rate

# 1. ROCR::prediction function
ROCR::prediction(
  predictions,  # 예측 값
  label         # 실제 값
)

# 2. ROCR::performance function
ROCR::performance(
  prediction.obj, # prediction 객체
  # 성능 평가 매트릭, acc(Accuracy), fpr(FP Rate) tpr(TP Rate), rec(recall) 등을 지정할 수 있음
  # 전체 목록은 도움말(performance) 참고하기 바람
  measure, 
  # 두 번째 성능평가 매트릭. x.measure를 지정하면 X축은 x.measure, Y축은 measure에 대한
  # 매트릭으로 그래프를 그림. x.measure를 지정하지 않으면 기본값 cutoff 사용
  x.measure = "cutoff"
)


set.seed(127)
probs  <- runif(100) # 분류 알고리즘이 예측한 점수
labels <- as.factor(ifelse(probs > 0.5 & runif(100) < 0.4, "A", "B"))
install.packages("ROCR")
library(ROCR)
pred <- prediction(probs, labels)     # ROCR를 사용하기 위해 prediction 객체 생성
plot(performance(pred, "tpr", "fpr")) # tpr, fpr 지정해서 ROC Curve 생성
auc  <- performance(pred, "auc")      # AUC 값 추출을 위한 "auc" 옵션 입력
auc@y.values                          # y.values

####################
##### 예측 평가 ####
####################



####################
##### 교차 검증 ####
####################

# 1. cvTools::cvFolds function
library(cvTools)
cvTools::cvFolds(
  n,        # 데이터의 크기
  K = 5,    # K겹 교차 검증
  R = 1,    # R회 반복
  type = c('random', 'consecutive', 'interleaved')
)

cvFolds(10, 5, type = 'random')       # 검증데이터 random
cvFolds(10, 5, type = 'consecutive')  # 검증데이터 순차적으로
cvFolds(10, 5, type = 'interleaved')  # 검증데이터 순차적으로 하는데 계통 추출 비슷하게 함

set.seed(2020)

# 결과 해석
# 1행 1열의 92는, k = 1, R = 1 일때 아이리스의 92번째 데이터를 사용하라는 의미
cv <- cvFolds(NROW(iris), K = 10, R = 3)
cv$which   # Fold에 해당하는 부분
cv$subsets # 실제 선택할 행을 저장한 부분

# 첫 번째 반복의 K = 1에서 거증 데이터로 사용해야 할 행의 번호 구하기
library(dplyr)
validation_idx <- data.frame(cv$subsets) %>% filter(cv$which == 1) %>% select(1) %>% unlist %>% as.numeric

# K겹 교차 검증을 반복하는 전체 코드
library(foreach)
set.seed(719)
R = 3
K = 10
cv <- cvFolds(NROW(iris), K = K, R = R)
foreach(r=1:R) %do% {
  # combine = c 로 설정시, vector로 setting
  foreach(k=1:K, .combine=c) %do% {
    
    validation_idx <- cd$subsets[which(cv$which == k), r]
    train          <- iris[-validation_idx, ]
    validation     <- iris[validation_idx, ]
    
    # 데이터 전처리
    # 모델 훈련
    # 예측
    # 성능 평가
    # return(성능 값)
  }
}

# 2. caret::createDataPartition function
# Y값을 고려한 훈련 데이터와 테스트 데이터의 분리 지원
# 데이터를 훈련 데이터와 테스트 데이터로 분할

caret::createDataPartition(
  y,          # 분류 또는 레이블
  times=1,    # 생성할 분할의 수
  p=0.5,      # 훈련 데이터에서 사용할 데이터의 비율
  list=TRUE,  # 결과를 리스트로 반환할 지 여부
)

parts <- caret::createDataPartition(iris$Species, p=0.8)
table(iris[parts$Resample1, "Species"]) # 결과 확인 -> 40, 40, 40으로 동일하게 partitioning 됨

# 3. caret::createFolds
# K겹 교차 검증 지원
# iris Data 10중 교차 검증
caret::createFolds(iris$Species, k = 10)


# 4. caret::createMultiFolds function
# K겹 교차 검증의 times 회 반복을 지원
caret::createMultiFolds(iris$Species, k = 10, times = 3)