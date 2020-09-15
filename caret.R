###################
## caret package ##
###################





# 1. 모델 훈련
# caret::train function
caret::train(
  form,   # 모델 포뮬러
  data,   # 분석 데이터
  ...,    # 분류 또는 회귀에 전달할 파라미터
  weights # 데이터의 가중치
)

caret::train(
  x, y, # 예측 변수를 저장한 데이터 프레임 x와 분류 y
  # 사용할 기계학습 모델.
  # 기본 값은 rf(randomForest)
  # names(getModelInfo())로 지원되는 전체 모델 목록을 볼 수 있음
  method = 'rf',
  # 수행할 데이터 전처리
  # center(평균이 0이 되게 함), scale(분산이 1이 되게 함), pca(주성분 분석)등을 지정할 수 있음
  preProcess = NULL,
  weights    = NULL,          # 데이터의 가중치
  # 평가 매트릭. 
  # 분류 문제의 경우 정확도(accuracy), 회귀 문제일 경우 RMSE로 자동 지정
  metric,
  trControl = trainControl(), # 훈련 파라미터
  ...                         # 분류 또는 회귀에 전달할 파라미터
)

# caret::trainControl 
caret::trainControl(
  # 데이터 샘플링 종류 선택 가능
  # boot       : 부트스트래핑
  # boot632    : 부트스트래핑 개선된 버전
  # cv         : 교차 검증
  # repeatedcv : 교차 검증의 반복
  # LOOCV      : Leave One Out  Cross validation(한개의 데이터로만 테스트하고, 나머지 데이터를 훈련 데이터로 하는 방법)
  method = 'boot',
  # 교차 검증을 몇 겹으로 할 것인가? 부트스트래핑을 몇 번 수행 할 것인가?
  # ex) k-fold에서 k의 수
  number, 
  repeats, # 데이터 샘플링 반복 횟수
  p = 0.75
)

library(caret)
set.seed(123)
train.idx <- caret::createDataPartition(iris[,5], p = 0.8)[[1]]
data.train <- iris[train.idx,  ]
data.test  <- iris[-train.idx, ]
m <- train(Species ~ .
           , data        = data.train
           , preProcess  = 'pca'
           , method      = 'rf'
           , ntree       = 1000
           , trControl   = trainControl(method = 'cv', number = 10, repeats = 3 ))

caret::confusionMatrix(
  predict(m, data.test, type = 'raw'),
  data.test$Species
)


#########################
## 기타. bootstrapping ##
#########################
# 부트스래핑을 통해 표본 추출을 통한 신뢰구간 하위 2.5%, 상위 97.5%를 구하기

x <- rnorm(1000, mean = 30, sd = 3)
t.test(x)

library(foreach)
bootmean <- foreach(i=1:10000, .combine= c) %do% {
  return(mean(x[sample(1:NROW(x), replace = T)]))
}
bootmean[c(10000 *0.025, 10000 * 0.975)]


