##########################
## 앙상블 기법 이해하기 ##
##########################

#######################
## 01. 배깅(bagging) ##
#######################

# 샘플링으로 복원 추출로 해온 여러개의 데이터셋으로부터 각각 모델을 만듬
# 그 모델들에서 나온 결과들을 투표(Voting) 또는 평균하여 결과 도출

# 좋은 배깅 앙상블 모형을 만들기 위해 확인해야 할 사항
# - 데이터에 대해 어떤 머신러닝 모델을 구현할 것인가? (회귀인지, 의사결정 트리인지 등)
# - 해당 모델에 대해서 파라미터 튜닝을 어떻게 할 것인가? (샘플 갯수를 몇개로 할 것인지 등)
# - 최고의 후보를 찾기 위해 모델 평가하는데 어떤 기준을 사용할 것인가? (투표인지, 평균인지)

# ipred를 활용한 bagging
## bagging 연습 - ipred
install.packages("ipred")
library(ipred)
set.seed(300)

# 의사결정트리 - 25개를 통한 bagging 수행
mybag     <- bagging(Species ~ . , data = iris, nbagg = 25)
iris_pred <- predict(mybag, iris)
table(iris_pred, iris$Species)
prop.table(table(iris_pred == iris$Species))

##########################
## 02. 스태킹(stacking) ##
##########################
# 원본 데이터의 train, test가 존재
# 원본 training Data가 n개의 머신러닝 모델이 학습
# 각 모델마다 X_test를 넣어서 예측 후 predict을 뽑아냄
# n개의 predict을 다시 train Dataset으로 뽑아 학습 데이터로 사용
# 최종 model을 하나 선정해 학습
# 최종 평가



##########################
## 03. 부스팅(boosting) ##
##########################










