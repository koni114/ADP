## 모델 평가 방법

####################
##### 분류 평가 ####
####################

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

cm <- caret::confusionMatrix(  data      = as.factor(predicted)
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
# ME(Mean of Errors)
# 예측오차의 산술평균을 의미

# RMSE(Root Mean of Squared Errors)
# 잔차를 제곱하여 n으로 나눈 값이 평균 제곱오차(MSE)를 다시 제곱근 시킨 지표

# MAE(Mean of Absolute Errors)
# 오차의 절대값을 씌우고 데이터 수로 나눈 것

# MPE(Mean of Percentage Errors)
# 상대적인 의미의 예측오차가 필요할 경우

# MAPE(Mean of Absolute Percentage Errors)
# MPE에서 예측오차에 절대값을 씌어서 계산

# MASE(Mean of Absolute Scaled Errors)
# MAE에서 데이터를 척도화(scaling) 하여 계산

# forecast::accuracy function
forecast::accuracy(
  f,  # 모델 객체. (Arima, ets, lm model)
  x,  # 모델의 예측 지표를 평가할 데이터
  test, # 모델의 예측 지표를 평가할 데이터 중 test 데이터 
  d,    # MASE 평가지표를 구할 때, lag 설정
)

data(swiss)
lm1 <- lm(Fertility ~ . , data = swiss)
lm2 <- lm(Fertility ~ Agriculture, data = swiss)

library(forecast)
accuracy(lm1)
accuracy(lm2)


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