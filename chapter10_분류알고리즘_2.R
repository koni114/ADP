####################
# 분류알고리즘 - 2 #
####################
# 1. 로지스틱 회귀 모델
# 2. 다항 로지스틱 회귀 모델
# 3. 의사 결정 나무
# 4. 랜덤 포레스트
# 5. 신경망
# 6. SVM
# 7. class 불균형(upsampling, oversampling, SMOTE)

############################
## 01. 로지스틱 회귀 모델 ## 
############################

# glm function
glm(
  formula,  # 모델 포뮬러
  data,     # 포뮬러를 적용할 데이터
  family    # 오차 분포와 링크(Link) 함수.로지스틱 회귀 모델의 경우 "binomial" 를 지정
)


# predict.glm
# 일반화 선형 모델을 사용한 예측 수행
predict.glm(
  object,   # glm 객체
  newdata   # 예측을 수행할 대상 데이터
  # 예측 결과의 유형을 지정. 기본값은 "link" 
  # - link : 선형 독립 변수의 연산 결과의 크기로 값을 반환. 이 값은 로지스틱 회귀 모델의 경우 로그 오즈 log(p/(1-p)) 임
  # - response : 반응 변수의 크기로 값을 반환하며, 로지스틱 회귀 모델의 경우 p가 이에 해당 됨
  # - terms : 행렬에 모델 포뮬러의 각 변수에 대한 적합된 값을 선형 예측 변수의 크기로 반환
)

d <- subset(iris, Species == "virginica" | Species == 'versicolor')
d$Species <- droplevels(d$Species)
m         <- glm(Species ~ ., data = d, family = 'binomial')

# fitted를 통해 모델이 예측한 값을 알 수 있음
f <- fitted(m)
ifelse(f > 0.5, 1, 0) == as.numeric(d$Species) - 1


# 새로운 데이터에 대한 예측
predict(m, newdata = d[c(1, 10, 55),], type = 'response')

#################################
## 02. 다항 로지스틱 회귀 모델 ## 
#################################

# 1. nnet::multinom
# 다항 로지스틱 회귀 모델 생성
# 반환값은 nnet 객체
nnet::multinom(
  formula, # 모델 포뮬러
  data     # 데이터
)

# 2. fitted
# 모델에 의해 훈련 데이터가 어떻게 적합되었는지 보임
fitted(
  object # 모델
)

# 3. predict.multinom
# 다항 로지스틱 회귀 모델을 사용한 예측 수행
predict.multinom(
  object,                        # multinom 함수로 생성한 nnet 객체
  newdata,                       # 예측을 수행할 데이터
  type = c("class", "probs")     # class : 분류, probs : 확률, default는 class
)

library(nnet)
m <- multinom(Species ~., data = iris)
# 각 행의 데이터가 각 분류에 속할 확률
# 가장 큰 확률 값이 해당 class로 분류되었다는 의미
head(fitted(m))

# 새로운 관측값에 대한 예측 수행시 predict 함수 사용
predict(m, newdata = iris[c(1, 51, 101), ], type = 'class')
predict(m, newdata = iris[c(1, 51, 101), ], type = 'prob')


#######################
## 03.의사 결정 나무 ## 
#######################
# 최상단에 위치한 노드 : root node 
# 최하단에 위치한 노드 : leaf node
# 데이터가 얼마나 잘 분리되었는지는 불순도(impurity) 라는 기준으로 평가
# 가장 좋은 질문을 한 노드의 데이터를 두 개의 자식 노드로 분리했을 때 
# 자식 노드들의 불순도가 가장 낮아지는 질문

# 1. rpart
# 분류와 회귀 나무(CART : Classification and regression Tree)의 아이디어 구현한 패키지
# rpart(재귀적 분할 및 회귀 나무)
# 1.1 rpart function
rpart::rpart(
  formula,
  data
)
# 1.2 rpart::predict.part
rpart::predict.part(
  object,
  newdata,
  type = c('vector', 'prob', 'class', 'matrix') # prob, class정도가 유용
)

# rpart::plot.rpart 
# rpart를 그래프로 그림
rpart::plot.rpart(
  x,   # rpart 객체
  # 노드 간격.
  # uniform = T 간격 일정, F : 노드마다 에러에 비례한 간격이 주어짐
  uniform  = F,
  # 가지 모양을 정하는 숫자.
  # 0 ~ 1 값. 1은 사각형, 0은 V자 모양
  branch   = 1, 
  compress = F, # True면 나무를 좀 더 빽빽하게 그림
  nspace,       # 노드와 자식 노드 간의 간격
  margin = 1    # 의사결정나무를 그렸을 때 그림의 주변부에 위치한 잎사귀 노드에 추가로 부여할 여백  
)

# rpart.plot::prp
# rpart를 그래프로 그림.
rpart.plot::prp(
  x,           # rpart 객체
  type  = 0,   # 그림의 유형
  extra = 0,   # 노드에 표시할 추가 정보의 유형
  digits = 2   # 표시할 숫자의 유효 자리
)

library(rpart)

# 결과 해석
# 들여쓰기는 가지가 갈라지는 모양
# *는 잎사귀 모드
# 트리의 최상단인 뿌리 노드는 1) 로 표시
# 각 노드에서 괄호 안에 표시된 세 숫자는 아이리스의 Specie 별 비율

# 2), 3) 노드는 왼쪽 노드
# 이 기준을 만족하는 노드는 setosa 뿐, 노드에는 총 50개의 데이터가 속함
m <- rpart(Species ~ ., data = iris)

plot(m, compress = T, margin = .2)
text(m, cex = 1.5)

# install.packages("rpart.plot")
library(rpart.plot)
# root node 해석
# 총 150개 데이터 중, setosa가 50개라는 의미
prp(  m
    , type   = 4
    , extra  = 2
    , digits = 3)

# 2. 조건부 추론 나무(ctree)
# CART같은 의사 결정 나무의 두 가지 문제를 해결
# - 통계적 유의성에 대한 판단 없이 노드를 분할하는데 오는 과적합
#   조건부 분포에 따라 변수와 반응값 사이의 연관 관계를 측정하여 노드 분할에 사용할 변수를 선택

# - 다양한 값으로 분할 가능한 변수가 다른 변수에 비해 선호됨
#   노드를 반복하여 분할하면서 발생하는 문제인 다중 가설 검정을 고려한 절차를 적용하여 적절한 시점에
#   분할을 중단
# - rpart가 과적합 등의 이유로 성능이 잘 나오지 않을 때
#   조건부 추론 나무를 사용해 효과를 볼 수 있음

# 2.1 party::ctree function
party::ctree(
  formula,  # 모델 포뮬러
  data      # 포뮬러를 적용할 데이터
)

# 2.2 party::predict.BinaryTree function
party::predict.BinaryTree(
  obj,
  newdata,
  # 예측 결과의 유형
  # - response : 분류
  # - node     : 잎사귀 노드의 ID
  # - prob     : 각 분류에 대한 확률
  type = c('response', 'node', 'prob')
)

library(party)
m <- ctree(Species ~.,  data = iris)

# 결과 해석
# 결과를 통해 어느 노드에서 분류가 잘 되지 않았는지 확인 가능
# 안보이는 종이 있는데, levels 함수의 순서가 그래프 x축의 순서
plot(m)

#######################
## 04. randomForest  ## 
#######################
# 데이터를 복원 추출로 꺼내서 subsample을 생성
# 자식 노드를 나눌 때 전체 변수가 아니라 일부 변수만 대상으로 하여 기준을 찾음
library(randomForest)

# 4.1 randomForest::randomForest
randomForest::randomForest(
  formula,
  data,
  ntree = 500,     # 나무의 개수
  mtry,            # 노드를 나눌 때 고려할 변수의 수
  importance = F   # 중요도 평가 여부
)

# 4.2 randomForest::predict.randomForest
# 반환 값은 예측 결과임
randomForest::predict.randomForest(
  object,  # randomForest 객체
  newdata, # 예측을 수행할 데이터
  # response : 예측값
  # prob     : 예측 확률의 행렬
  # vote     : 투표 결과 행렬
  type = c('response', 'prob', 'vote') 
)

# 4.3 randomForest::importance
randomForest::importance(
  x,            # randomForest model
  # 출력한 변수 중요도 유형으로 1은 정확도(Accuracy), 2는 노드 불순도로 변수 중요도를 표시함
  # type이 지정되지 않으면 정확도, 불순도 모두에 대한 중요도가 출력됨
  type = NULL  
)

# 4.4 randomForest::varImpPlot 
# 변수 중요도에 대한 plot을 그려줌
randomForest::varImpPlot(
  x,
  type = NULL
)

library(randomForest)
m <- randomForest(Species ~., data = iris)
head(predict(m, newdata = iris))

# 일반적으로 formula로 지정시 많은 메모리를 필요로 하고, 속도가 더 느리다고 알려져 있음
randomForest(x = iris[,1:4], y = iris[,5])

# 4.5 randomForest 변수 중요도
# 변수의 정확도와 노드 불순도 개선에 얼마만큼 기여하는지로 측정
# 변수 선택 중 필터 방법
# 이렇게 나온 변수 중요도를 통해 다른 모델링 시 적용할 수 있음
# 해당 지표에 기여하는 평균값을 계산. 따라서 클수록 좋음
# 해당 결과는 order by 되어 있지 않음
# -  MeanDecreaseGini     : 노드 불순도 개선
# -  MeanDecreaseAccuracy : 정확도 
m <- randomForest(Species ~., data = iris, importance = T)
importance(m)
varImpPlot(m)

# 정규화 랜덤 포레스트(RRF)
# 랜덤 포레스트를 개선한 변수 선택 방법
# 부모 노드에서 가지를 나눌 때 사용한 변수와 유사한 변수로 자식 노드에서 가지를 나눌 경우 
# 해당 변수에 패널티 부과

# 4.6 파라미터 튜닝
# ntree, mtry 등 파라미터 존재
# expand.grid function
expand.grid(
  ... # 벡터, Factor 또는 이들을 저장한 리스트
)

grid <- expand.grid(ntree = c(10, 100, 200), mtry = c(3, 4))

## 파라미터 튜닝을 통한 모델 성능 평가(3번 반복)
library(cvTools)
library(foreach)
library(randomForest)
set.seed(100)
K = 10
R = 3
cv   = cvFolds(NROW(iris), K = K, R = R)
grid = expand.grid(ntree = c(10, 100, 200), mtry = c(3, 4)) 

result <- foreach(g = 1:NROW(grid), .combine = rbind) %do% {
  foreach(r=1:R, .combine = rbind) %do% {
    foreach(k=1:K, .combine=rbind)  %do% {
      validation_idx <- cv$subsets[which(cv$which == k), r]
      train          <- iris[-validation_idx, ]
      validation     <- iris[validation_idx , ]
      
      m <- randomForest(Species ~ .
                        , data =train
                        , ntree = grid[g, "ntree"]
                        , mtry  = grid[g, "mtry"])
      
      # 예측
      predicted <- predict(m, newdata = validation)
      precision <- sum(predicted == validation$Species) / NROW(predicted)
      return(data.frame(g = g, precision = precision))
      
    } 
  }
}

# g 값마다 묶어 평균 구하기
library(dplyr)
result %>% group_by(g) %>% summarise_all(list(mean = ~ mean(., na.rm = T)))


#################
## 05. 신경망  ## 
#################
# 입력층, 은닉층, 출력층으로 구분되어 나열되어 있음
# 입력노드(i)에서 은닉노드(j)로 전달될 때
#   이와 같은 계산식을 "합성 함수(comination function)"
#   노드 j로 전달되는 값을 "넷 활성화" 
#   노드 j로 전달될 때 통과하는 함수를 "활성화 함수"
#      - ex) sigmoid, relu function ..

# 가중치 감소 : weight decay. --> 가중치를 교정할 때 마다 0과 1사이의 값을 가지는
#                                 값을 가중치에 곱해줌

# 출력을 수정 : softmax 함수사용

# nnet::nnet function
# 신경망 모델 생성
# 신경망의 파라미터는 엔트로피 또는 SSE를 고려해 최적화함
# 출력 결과는 소프트맥스를 사용해 확률과 같은 형태로 변환 가능
# 과적합을 피하기 위한 방법으로 weight decay를 제공
nnet::nnet(
  formula,  # 모델 포뮬러   
  data,     # 표뮬러를 적용할 데이터
  weights,  # 데이터에 대한 가중치 
)

# data를 formula로 지정하는 경우
# - linout의 기본값이 FALSE이므로 출력층에서 선형 함수가 아니라 시그모이드 함수가 사용됨
# - 예측 대상이 되는 분류(즉 Y의 레벨)의 수가 2개라면 엔트로피를 사용해 파라미터가 추정
#   분류의 개수가 3개 이상이면 SSE가 추정되며 소프트맥스가 적용됨


nnet::nnet(
  x, y,     # 데이터
  weights,  # 데이터에 대한 가중치
  size,     # 은닉층 노드의 수
  Wts,      # 초기 가중치 값. 생략할 경우 임의의 값이 가중치로 할당
  mask,     # 최적화할 파라미터. 가본값은 모든 파라미터의 최적화
  # TRUE면 활성 함수로 y = ax+b 같은 유형의 선형 출력(linear output)이 사용
  # FALSE면 로지스틱 함수(즉, 시그모이드 함수)가 활성함수로 사용
  linout  = F,
  # 모델 학습 시 모델의 출력과 원하는 값을 비교할 때 사용할 함수. TRUE면 엔트로피 F면 SSE 사용
  entropy = F,
  # 출력에서 소프트멕스 사용 여부
  softmax = F,
  # 가중치의 최대 개수로 기본값은 1000, 모델이 복잡해 가중치의 수가 많다면 이 값을 증가시켜야 함
  MaxNWts = 1000
)

# nnet:predict.nnet function
nnet:predict.nnet(
  object,
  newdata,
  type = c('raw', 'class')
)

# formula로 지정하는 경우
library(nnet)
m <- nnet(Species ~., data = iris, size = 3)
predict(m, newdata = iris)
predict(m, newdata = iris, type = 'class')

# X,Y 직접 지정하는 경우
# ** Y를 지시행렬로 변환해야 함
# nnet::class.ind
# 반환 값은 각 행에 관측값을 놓고 각 열에 분류를 놓은 다음. 해당 분류에 속할 경우 1을 아니라면 0을 저장한 행렬
nnet::class.ind(
  cl # factor또는 분류의 백터
)
nnet::class.ind(iris[,5])
m2 <- nnet(
  x       = iris[,c(1:4)],
  y       = nnet::class.ind(iris[,c(5)]),
  size    = 3,
  softmax = T
)
predict(m2, newdata = iris[,1:4], type = 'class')

##############
## 06. SVM  ## 
##############
# SVM은 서로 다른 분류에 속한 데이터 간에 간격이 최대가 되는 선을 찾아
# 이를 기준으로 데이터를 분류하는 모델
# - cost: 과적합을 막는 정도를 지정하는 파라미터
#         데이터를 잘못 분류하는 선을 긋게 될 경우 얼마만큼의 비용을 지불할 것인지를 지정
#         결과적으로 해당 비용과 데이터를 한 가운데로 얼마나 잘 나누는지의 비용의 총합으로 계산

# SVM 생성 함수
# kernlab::ksvm function
kernlab::ksvm(
  x,         # 모델 포뮬러
  data=NULL  # 포뮬러를 적용할 데이터
)

kernlab::ksvm(
  x, y = NULL, # 데이터
  # 데이터를 정규화 할지 여부. 기본값인 TRUE는 평균 0, 분산 1이 되도록 데이터 변환
  scaled = T,
  # 사용할 커널. 기본값은 rbfdot으로, Radial Basis Function이다
  # kernel에 지정할 수 있는 함수 목록은 help(kernlab::dots)에서 볼 수 있음
  kernel = "rbfdot",
  # 커널 파라미터를 리스트로 지정. kernel이 rbfdot인 경우 kpar를 automatic으로
  # 지정하면 데이터로부터 휴리스틱으로 적절한 파라미터를 찾음
  kpar   = "automatic"
)

# ksvm::predict.ksvm
# ksvm을 사용한 예측을 수행. 반환 값은 예측 결과
kernlab::predict.ksvm(
  object,  # ksvm 객체
  newdata, # 예측을 수행할 데이터
  # 예측 결과의 유형. response는 예측값, probabilities는 확률을 반환
  type = 'response'
)

e1071::svm(
  formula,   # 모델 포뮬러
  data=NULL, # 데이터
)

e1071::svm(
  x, y = NULL, # 데이터
  scale = T,   # 변수를 정규화 해야하는지의 여부
  # 분류, 회귀 등의 모델 중 만들 모델. y 값이 펙터인지 여부에 따라
  # 분류 또는 회귀 모델이 자동으로 지정되지만 type에 모델을 지정해 특정 모델을 강제할 수 있음
  type = NULL,
  kernel = 'radial',                         # 커널 함수
  gamma = if(is.vector(x)) 1 else 1/ncol(x), # 커널 파라미터 gamma
  cost  =  1                                 # 커널 파라미터 cost
)

# 그리드 탐색을 사용한 파라미터 수행
# 반환값은 tune
e1071::tune(
  method,  # 최적화할 함수
  train.x, # 포뮬러 또는 독립 변수의 행렬을 지정
  train,y, # 예측할 분류, 만약 train.x가 포뮬러면 무시  
  data,    
) 

library(kernlab)
svm_model <- kernlab::ksvm(Species ~., data = iris)
svm_model <- kernlab::ksvm(Species ~., data = iris, kernel = 'vanilladot')
svm_model <- kernlab::ksvm(Species ~., data = iris, kernel = 'polydot', kpar = list(degree = 3))
head(predict(m, newdata = iris))

svm    <- e1071::svm(Species ~., data = iris)
result <- tune(method = "svm", Species ~., data = iris, gamma = 2^(-1:1), cost = 2^(2:4))

#######################
## 07. class 불균형  ##
#######################
# class 불균형을 해결하는 방법
# - 데이터 적은 쪽에 더 큰 가중치를 주는 방법(ex) param, loss, cost)
# - 훈련 데이터를 조정하는 방법 ex) 업 샘플링, 다운 샘플링, SMOTE가 있음

# 1. caret::upSample function
caret::upSample(
  x, y
)

# caret::downSample function
caret::downSample(
  x, y
)
library(mlbench)
data(BreastCancer)
BreastCancer
x <- caret::upSample(subset(BreastCancer, select = -Class), BreastCancer$Class)
table(x$Class)

# 3. SMOTE
# 비율이 낮은 분류의 데이터를 만들어내는 방법
# SMOTE 수행 방법
# 1. 먼저 분류 개수가 적은 쪽의 데이터의 샘플을 취함 
# 2. 샘플의 k 최근접 이웃을 찾음
# 3. 현재 샘플과 이웃간의 차이를 계산
# 4. 이 차이에 0 ~ 1 사이의 임의의 값을 곱하여 원래 샘플에 더함

DMwR::SMOTE(
  form,    # 모델 포뮬러 
  data,    # 포뮬러를 적용할 데이터
  perc.over = 200, # 적은 쪽의 데이터를 얼마나 추가로 샘플링해야 하는지
  k = 5,           # 고려할 최근접 이웃의 수
  # 적은 쪽의 데이터를 추가로 샘플링할 때 각 샘플에 대응해서 많은 쪽의 데이터를
  # 얼마나 샘플링 할지 지정
)


newData <- SMOTE(Species ~.
                 , data       = iris
                 , perc.over  = 600
                 , perc.under = 100)
table(newData$Species)