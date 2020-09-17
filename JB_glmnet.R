######################
## 정규화 선형 회귀 ##
######################
# 정규화 선형 회귀 방법은 선형 회귀 계수에 대한 제약 조건 추가
# 모델이 과도하게 최적화 되는 현상, 과최적화를 막는 방법
# 정규화 방법에서 제약 조건은 일반적으로 계수의 크기를 제한하는 방법

# - Ridge 회귀 모형
# - LASSO 회귀 모형
# - Elastic Net 회귀 모형

#####################
## Ridge 회귀 모형 ##
#####################
# 가중치들의 제곱합(squared sum of weights)을 최소화하는 것을 추가적인 제약 조건으로 함
# lambda : 기존의 잔차 제곱합과 추가적인 제약 조건의 비중을 조절하기 위한 하이퍼 모수
#          해당 값이 커지면 정규화 정도가 커지고, 가중치의 값들이 작아짐
#          해당 값이 작아지면 정규화 정도가 작아지고, 0이되면 기존 선형 회귀 모형이 됨

#####################
## Lasso 회귀 모형 ##
#####################
# 가중치의 절대값을 최소화하는 것을 추가적인 제약 조건으로 함

###########################
## Elastic Net 회귀 모형 ##
###########################
# 가중치의 절대값의 합과 제곱합을 동시에 제약 조건으로 가지는 모형
# lambda1, lambda2 두 개의 하이퍼 모수를 가짐

#######################
## elasticnet 패키지 ##
#######################
# R의 elasticnet package는 정규화 선형 회귀를 위한 enet 명령을 제공
# lambda = 0 : Lasso
# lambda = 1 : Ridge
# lambda = 0.5 : elasticnet
library(elasticnet)
elasticnet::enet(
  x,        # 예측변수 dataFrame 
  y,        # 종속변수 vector
  lambda    # 가중치 제곱합에 대한 λ2를 의미, lambda가 0이면 순수 lasso 모형
            # λ1은 최적화 하이퍼 파라미터로 남기기 위해 모형에서 정하지 않고 prediction에서 s 파라미터로 설정
)

predict(
  enetmodel, 
  newx, 
  s,         # 최적화 하이퍼 파라미터. mode 설정에 따라 의미가 달라진다.
  type,      # "fit" : 예측값 출력, "coefficients" : 계수 출력
  mode       # "penalty"  :  λ1, 
             # "fraction" : 최적화 하이퍼 파라미터를 변화시켜서 나오는 계수의 절대값의 합 중 최대값과 현재 계수의 절대값의 합의 비율.  
  )


library(elasticnet)

set.seed(0)
n_samples <- 30
x <- runif(n_samples)
x <- x[order(x)]
y <- cos(1.5 * pi * x) + rnorm(n_samples) * 0.1
X <- poly(x, 9, raw=T)
df <- data.frame(x, y)

plot.regression <- function(model, s) {
  xnew = seq(0, 1, length=1000)
  Xnew = poly(xnew, 9, raw=T)
  plot(df)
  pred.fit <- predict(model, Xnew, type=c("fit"), s=s, mode="penalty")   
  pred.coef <- predict(model, Xnew, type=c("coefficients"), s=s, mode="penalty")   
  lines(xnew, pred.fit$fit, type="l")
  return(pred.coef$coefficients)
}




