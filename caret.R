###################
## caret package ##
###################

########################
# 2. 모델 옵션 setting #
########################
# caret::trainControl function
# 해당 함수에서 설정할 수 있는 항목은 다음과 같음 
#- 샘플링 종류        --> none, boost632, cv, repeatedcv, LOOCV
#- 파라미터 튜닝 방법 --> random, grid(none인 경우는 튜닝 안함)

## Performance Metrics
#- 어떻게 모델을 요약할 것인지 선택
# summaryFunction = <R function>
# classProbs      = <logical>
# 개인이 만든 함수를 적용할수도 있고, caret에서 제공하는 default summary function 사용 가능
# - defaultSummary (accuracy, RMSE, etc)
# - twoClassSummary(for ROC curve)
# - prSummary(information retrieval)
#  --> 해당 두 함수는 classProbs = True로 설정

# Subsampling
# imblanced data 인 경우, subsampling 옵션으로 적용 가능
# - up, down, smote, rose 

caret::trainControl(
  # 데이터 샘플링 종류 선택 가능
  # none       : 데이터 샘플링 안함  # boot       : 부트스트래핑
  # boot632    : 부트스트래핑 개선된 버전
  # cv         : 교차 검증
  # repeatedcv : 교차 검증의 반복
  # LOOCV      : Leave One Out Cross validation(한개의 데이터로만 테스트하고, 나머지 데이터를 훈련 데이터로 하는 방법)
  # LGOCV      : Leave group out(number, p option)
  # LOO        : Leave one out  
  # oob        : out-of-bags
  # timeslice  : time-series data 
  method = 'boot',
  # random, grid 방식 중 하나 선택. method = 'none' 경우는 제외
  search,
  # 교차 검증을 몇 겹으로 할 것인가? 부트스트래핑을 몇 번 수행 할 것인가?
  # ex) k-fold에서 k의 수
  number, 
  repeats,     # 데이터 샘플링 반복 횟수
  verboseIter, #  training log를 print
  classProbs,  #  이진 분류 시, ROC 넓이 값 등 계산 필요시 True 지정
  p = 0.75,     #  LGOCV에서 training Dataset의 percentag를 말함
  summaryFunction, # defaultSummary, twoClassSummary, prSummary
  classProbs,      # twoClassSummary, prSummary 사용할 경우, TRUE 를 설정
  sampling,        # 
)


# expand.grid function
# hyper parameter setting 시 사용하는 함수.
# 조합이 형성된 data.frame 생성
expand.grid(
  
)

################
# 3. 모델 훈련 #
################
# caret::train function
# 해당 함수에서 설정할 수 있는 사항은 다음과 같음
#- method     : 모델 알고리즘
#- preProcess : 전처리 방식
#- weights    : 데이터의 가중치
#- metric     : 모델 평가 방식
#- trControl  : trainControl function return 객체
#- tuneGrid   : Grid search, 샘플링 작업 하지 않을 때 사용
#- tuneLength : random search 횟수

# train 함수에서 모델을 생성할 수 있는 방식은 크게 3가지 
# - formula 방식
# - x/y 방식
# - object 방식

# -  train formula 방식 사용시 항상 dummy variable 생성
# -  x/y train 방식은 dummary variable을 생성하지 않습니다.(단 모델 자체에서 dummay variable을 만들어 낼 수도 있습니다.)

# 기억하세요!
#- data에는 column name이 존재해 함
#- 분류 결과를 위해서는 factor 형을 사용해야 함 
#- class 수준에 유효한 R name이 있어야 함
#- train 함수 호출 전 set.seed를 지정시 resample이 고정돼서 사용
#- 결측값도 같이 처리하고 싶으면, na.option = na.pass를 사용하면 됩니다. 
#- 일반적으로 test Data에도 NA가 포함되어 있을 경우에 사용함
#- caret에서 tuning parameter에서 지원하지 않은 hyper parameter 값을 지정하는 경우, train 함수에 parameter로 지정하면 됨

# preprocess
# preprocess 옵션 값에 전처리 방법을 지정하면 모델 훈련시 자동으로 전처리를 수행해줍니다.
# - 정규화 옵션       : center, scale, range(0과 1사이로 변환)
# - 데이터 변환 옵션  : BoxCox, YeoJohnson, expoTrans 
# - 결측값 대체       : knnImpute, bagImpute(baggingTree 방식을 이용하여 결측값을 tree 모델로 예측하여 처리), medianImpute
# - 필터링            : corr, nzv, zv
# - 차원 축소, 그룹변환 : pca, ica(독립 성분 분석), spatialSign
# 전처리 작동 순서는 입력 순서와는 상관없이 train function 내부적으로 작동 순서를 결정 함
# recipe package에서 더 다양한 list 확인 가능 


caret::train(
  form,   # 모델 포뮬러
  data,   # 분석 데이터
  ...,    # 분류 또는 회귀에 전달할 파라미터
  weights # 데이터의 가중치
)

modelResult <- caret::train(
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
  # 회귀 : RMSE, Rsquared, MAE 등
  # 분류 : Accuracy, Kappa, ROC,  
  metric,
  # na 처리 여부 선택, na 제거 할 경우 = na.omit 할당
  na.action = na.omit,
  trControl = trainControl(), # 훈련 파라미터
  # grid search 시 특정 개수만큼 random하게 값을 setting : tuneLength
  # grid search 시 직접 값을 셋팅 : tuneGrid. expand.grid function 사용
  tuneGrid  = expand.grid(),  # grid search 사용시 설정하는 파라미터
  tuneLength = 5,             # 
  ...                         # 분류 또는 회귀에 전달할 파라미터
)

#####################
# 4. 모델 결과 확인 #
#####################

modelResult$results  # 튜닝별 모델링 결과
modelResult$bestTune # 최적 파라미터 결과
Y    <- modelResult$trainingData$.outcome # Y value
Yhat <- predict.train(
  object = model, # caret model 객체
  newdata = data, # 예측하고자 하는 data
  type = c('raw') # 예측 타입
)

# - 분류 모델일 경우,
cm <- caret::confusionMatrix(
  Yhat,
  Y
)

# - 예측 모델일 경우,


#######################
# 5. 모델 결과 시각화 #
#######################
# 수치 예측 PLOT
plot2 <- data.frame('Y'     = Y,
                    'YHat'  = Yhat,
                    'resid' = NA,
                    'index' = 1:nrow(modelResult$trainingData))

plot2 <- reshape2::melt(plot2[c(1,2,4)], id.var = 'index')
names(plot2)[2] <- '구분'
ggplot(data = plot2, aes(  x = index
                           , y = value 
                           , colour = 구분)) + geom_line(linetype = 1
                                                       , size = 0.5
                                                       , alpha = 0.6) + scale_colour_manual(values = c('blue', 'red')) + labs(title = 'title',
                                                                                                                              x     = 'xlab',
                                                                                                                              y     = 'ylab')

# 변수 중요도 PLOT
varImp.data <- caret::varImp(modelResult, scale = T)
df.plot     <- varImp.data$importance
var         <- c('Overall')
title       <- c('randomForest 예측 변수 중요도')

p <- ggplot(df.plot, aes(x = reorder(rownames(df.plot), - df.plot[, var]),
                         y = round(df.plot[, var], 3), group = 1))

p <- p + geom_point(size = 2, colour = 'blue') + geom_line(linetype = 2, size = 0.2) + guides(fill = F)
p <- p + ggtitle(title) + theme(plot.title = element_text(hjust = 0.5))
p <- p + theme(  axis.text.x  = element_text(size = 14, angle = 30, vjust = 1, hjust = 1)
                 , axis.title.y = element_text(size = 14, angle = 30, vjust = 1, hjust = 1)
                 , panel.grid.major = element_line(colour = "darkgrey", linetype = 'dashed', size = 0.3))
p <- p + xlab("Variables") + ylab("Importance")
print(p)

############
# 6. 예시 ##
############
library(caret)
colnames(iris)
set.seed(123)
train.idx  <- caret::createDataPartition(iris[,4], p = 0.8)[[1]]
data.train <- iris[train.idx , ]
data.test  <- iris[-train.idx, ]
modelResult <- train(Petal.Width ~ Sepal.Length + Sepal.Width + Petal.Length
                     , data        = data.train
                     , preProcess  = NULL
                     , method      = 'rf'
                     , ntree       = 1000
                     , trControl   = trainControl(method = 'cv', number = 10, repeats = 3))

# 결과 비교
modelResult$results  # 튜닝별 모델링 결과
modelResult$bestTune # 최적 파라미터 결과
Y    <- modelResult$trainingData$.outcome # Y value
Yhat <- predict.train(
  object = modelResult,
  newdata = data.train, 
  type = c('raw')   
)

# 분류일 경우,
cm <- caret::confusionMatrix(
  Yhat,
  Y
)


############################
# 7. 모델별 parameter 정리 #
############################
# 1. XGBoost
# - nrounds   : 최대 반복 부스팅 횟수
#   기본값    : 100
#   0 < nrounds
# - gamma     : 이 값이 커지면 트리 깊이가 줄어들어 보수적인 모델이 됨
#   0 <= gamma
# - max depth : 트리 최대 깊이
#   0 < max depth
# - min child weight : 특정 순도에 도달하면 가지치기를 종료
#   0 <= min child weight
# - eta :  learning rate, boosting step 마다 weight를 주어 부스팅 과정에서 과적합이 일어나지 않도록 함
#   0 <= eta <= 1
# - subsample : 각 트리마다의 train data sampling 비율, 너무 적게 주면 under_fitting 발생
#   0 <= subsample <= 1 
# - colsample_bytree : : 각 트리마다의 feature 샘플링 비율 
#   0 <= colsample_bytree <= 1

# 2. RandomForest
# - mtry : Split 마다 random 하게 샘플링될 변수 개수

# 3. Ridge, Lasso, elasticNet
# algo = elasticNet 입력
# Ridge      : alpha = 0,   lambda
# Lasso      : alpha = 1,   fraction
# elasticNet : alpha = 0.5, lambda, fraction

# svm
# kernel 종류
# - svmLinear
# - svmRadial
# - svmPoly

# parameter 종류
# - cost   : 얼마나 많은 데이터 샘플이 다른 클래스에 놓이는 것을 허용하는지를 결정, 작을수록 많이 허용. Cost가 작을수록 underfitting 가능성 커짐
# - sigma  : 하나의 데이터 샘플이 얼마나 많은 영향력을 끼치는지 결정. 클수록 overfitting 커짐
# - degree : 다항 커널이 사용될 경우의 모수. 
# - scale  : 스케일링 매개 변수


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
