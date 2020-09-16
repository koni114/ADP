###########################
## chapter 08. 선형 회귀 ##
###########################
# 선형회귀
# 01. 단순선형회귀
# - 모델확인
# - 회귀 계수 coef(m)
# - 적합된 값 fitted(m)
# - 잔차 residual(m)
# - 회귀 계수의 신뢰 구간  confint(m)
# - 잔차 제곱 합 deviance(m)
# - 예측과 신뢰 구간 predict 
# - 모델평가 : summary(m)
# - 결정계수 R 
# - 조정결정계수
# - 설명변수평가
# - F통계량
# - ANOVA를 통한 모델 간 비교 : anova(m)

# 02. 모델 진단 그래프 
# - Residual vs Fitted
# - Normal Q-Q
# - Scale - Location
# - Residuals vs Leverage
# - Cook's distance
# - Cook's dist vs Leverage h(ij) / (1 - h(ij)) 
# - 회귀 직선의 시각화
 
# 03. 중 선형회귀
# - 모델 생성 및 평가
# - 중선형 회귀 모델의 시각화
# - 표현식을 위한 I()의 사용
# - 변수의 변환
# - 상호 작용(interaction)
# - 상호 작용 시각화 함수

# 04. 이상치
# - 외면 스튜던트화 잔차 : rstudent(model)
# - 본페로니 이상값 검정 

# 05. 변수선택
# - 변수선택법(전진선택법, 변수소거법, 단계적방법)
# - 모든경우탐색 : leaps::regsubsets function

# 06. 다중공선성 진단
# - car::vif(model)

############################ 
# 1. 선형 회귀의 기본 가정 #
# - 종속 변수, 독립 변수 간 선형성 성립
# - 독립 변수 Xij는 정확히 측정된 값으로 확률적으로 변하는 값이 아닌 고정된 값
# - 오차의 평균이 0, 분산은 sigma^2 인 정규 분포를 따르며, 모든 i에 대해 평균과 분산이 일정
# - 다른 i,j에 대해 error(i), error(j)는 독립
# - 독립 변수 간에는 다중 공선성이 적어야 함

##################### 
# 2. 단순 선형 회귀 # 
#####################
# 종속 변수 Yi를 하나의 독립 변수 Xi로 설명

# 선형 회귀 함수
lm(
  formula,
  data
)

# 1. 모형 생성
# lm function 
m <- lm(dist ~ speed, data = cars)

# 선형 회귀 결과 추출
# - 회귀 식 : y(dist) = -17.579 + 3.932 * x

# 2. 회귀 계수
# coef(model) function
coef(m) # 절편 : -17.57.. , 계수 : 3.932409

# 3. 적합된 값
# fitted(model) function
# speed 값에 대해 모델에 의해 예측된 dist 값
fitted(m)[1:4]

# 4. 잔차: residual(model)
# Y - YHat 의 값 
# 잔차 : 선형 회귀 모델을 작성한 다음 다음 모델로부터의 구한 예측값과 실제 값 사이의 차이
residuals(m)
fitted(m)[1:4] + residuals(m)[1:4] == cars$dist[1:4]

# 5. 회귀 계수의 신뢰 구간: confint(model)
# 단순 선형 회귀에서 절편과 speed의 기울기는 정규 분포를 따름
# 따라서 t 분포를 사용한 신뢰구간을 confint(model)을 이용해 구할 수 있음
confint(m)

# 6. 잔차 제곱 합 
deviance(m)

# 7. 예측과 신뢰 구간 
predict.lm(
  object,  # 선형 모델
  newdata, # 예측을 수행할 새로운 데이터
  # 구간의 종류. 기본값은 none이며, 이 경우 신뢰 구간이 계산되지 않음
  # interval이 confidence로 주어진 경우 회귀 계수에 대한 신뢰 구간을 고려하여 종속 변수의 신뢰 구간을 찾음
  # interval이 prediction인 경우, 회귀 계수의 신뢰 구간과 오차항을 고려한 종속 변수의 예측 구간(prediction interval)을 찾음
  interval = c('none', 'confidence', 'prediction')
)

predict(m, newdata = data.frame(speed = 3))

# 제동 거리의 평균 신뢰 구간을 구할 수 있음
# 평균적인 차량에대한 추정
predict(m, newdata = data.frame(spped = 3), type = 'confidence')

# 특정 속도를 가진 차량 한대가 주어졌을 때 해당 차량에 대해 제동 거리를 생각
# --> 이 때는 오차를 무시할 수 없음
predict(m, newdata = data.frame(speed = c(3)), interval = 'prediction')

# 8. 모델 평가
# 모델 평가 기준
# - 결정 계수(R sqaured)
# - 조정 결정 계수
# - 설명 변수 평가
# - F 통계량

summary(m)

# coefficient 부분
# - Estimate 열 : 절편과 계수의 추정치
# - Pr(>|t|)    : t-분포를 사용하여 각 변수가 얼마나 유의한지를 판단할 수 있는 p-value를 알려줌
#                 이 때 사용하는 귀무가설은 H0 : 계수가 0, H1: 계수가 0이 아님

# F 통계량
# F 통계량은 H0: B1 = 0, H1:B1 != 0 에 대한 가설 검정 결과
# dist = B0 + error 의 축소 모델(reduced model) 과 dist = B0 + B1xspeed + error 의 완전 모델 간의
# 잔차 제곱 합이 얼마나 유의하게 다른지를 보는 방식과 같음

# 9.분산 분석 및 모델 간의 비교
# 선형 회귀에서 분산 분석은 모델을 평가하거나 모델 간의 비교를 위해 사용

anova(
  object, # 모델 피팅 함수(예를 들먄, lm) 의 반환 값
  ...,    # 비교할 또 다른 객체들
)

# summary가 보여주는 F 통계량은 anova 함수를 통해서도 확인가능
anova(m)

# anova 모델을 이용해 완전 모형과 축소 모형을 직접 비교해 볼 수도 있음
full    <- lm(dist ~ speed, data = cars)
reduced <- lm(dist ~  1,    data = cars) 
anova(full, reduced)
# F 통계량은 89.567 이며, p-value 값이 매우 작게 나타났으므로, 
# 두 모델 간의 차이는 유의하다라고 볼 수 있음

# 10. 모델 진단 그래프
plot(
  x,                # 선형 모델
  which = c(1:3, 5) # 그릴 그래프의 종류. 1~6의 총 6가지 그래프가 있음 
)

plot(full)
# 결과적으로 4개의 plot이 나옴
# - Residual vs Fitted
#   x축: 선형 회귀로 예측된 예측값
#   y축: 잔차
#   따라서 평균이 0이고 분산은 일정한 그래프가 나와야 함

# - Normal Q-Q
# 정규분포를 따르는지 확인하기 위한 Q-Q plot

# - Scale-Location
#   X축 : 선형 회귀로 예측된 Y값
#   Y축 : 표준화 잔차(잔차 / 잔차의 표준편차)
#   기울기가 0인 직선이 이상적이며, 특정 위치에 0에서 멀리 벗어난 값이 보인다면
#   해당 점에 대해서 표준화 잔차가 큼

# - Residuals vs Leverage
#   X축 : Leverage(설명 변수가 얼마나 극단에 치우쳐 있는지를 뜻함)
#   Y축 : 표준 잔차
#   cook's distance --> 회귀 직선의 모양에 영향을 많이 끼치는 점들을 찾는 방법
#   표준잔차와 leverage 가 클수록 cook's distance가 커짐

# 추가적인 그래프 2개가 더 있음
plot(m, c(4, 6))

# - Cook's distance
#   관측값의 순서별 쿡의 거리

# - Cook's dist vs Leverage hij / (1 - hij)
#   레버리지와 쿡의 거리

# 11. 회귀 직선의 시각화
# - 기본 회귀 직선 + 산점도
plot(cars$speed, cars$dist)
abline(coef(m))

# - 그래프에 추정값의 신뢰구간 추가하기
summary(cars$speed)
ys <- predict(m,
        newdata  = data.frame(speed = seq(4, 25, 0.2)),
        interval = c('confidence'))

speed <- seq(min(cars$speed), max(cars$speed), .1)
ys <- predict(m,
              newdata  = data.frame(speed = speed),
              interval = c('confidence'))
matplot(speed, ys ,type = 'n')
matlines(speed, ys, lty=c(1, 2, 2), col = 1) # lty 1은 직선, 2는 점선

##################### 
## 2. 중 선형 회귀 ## 
#####################
# 하나 이상의 독립변수가 사용된 선형회귀
# 1. 모델 생성 및 평가
m <- lm(Sepal.Length ~ Sepal.Width + Petal.Length + Petal.Width, data = iris)
summary(m)

# 해석
# 단순 선형 회귀와 거의 동일한데, F 통계량의 가설이 조금 다름
# 귀무가설 : 모든 회귀 계수에 대해서 0이다 
# 대립가설 : 모든 회귀 계수에 대해서 0이아님

# 범주형 추가해서 계산하기
# 범주형 변수는 dummy variable를 사용해 표현
m <- lm(Sepal.Length ~ ., data = iris) 

# 데이터가 어떻게 코딩되는지를 확인하고 싶으면, model.matrix 사용
model.matrix(
  # 객체. formula 또는 terms 객체. lm을 인자로 주면 model.matrix.lm() 이 호출되고,
  # 이 함수가 적절한 인자를 model.matrix()에 넘겨줌
  object,
  data = enviroment(object) # 데이터 프레임
)
# 1, 51, 101번째 데이터 확인
model.matrix(m)[c(1, 51, 101), ]

# anova를 통한 분산 분석 결과 확인
# summary(m) 과는 달리 Species가 하나의 설명변수로 묶여서 표시됨
anova(m)

# 2. 중선형 회귀 모델의 시각화
with(iris, plot(Sepal.Width, Sepal.Length,
                cex = .7,
                pch = as.numeric(Species)))
m <- lm(Sepal.Length ~ Sepal.Width + Species, data = iris)
coef(m)
abline(2.25, 0.80, lty = 1)
abline(2.25 + 1.45, 0.80, lty = 1)
abline(2.25 + 1.94, 0.80, lty = 1)
legend("topright", levels(iris$Species), pch = 1:3, bg='white')

# 3. 표현식을 위한 I()의 사용
# 경우에 따라서 종속 변수가 독립 변수의 2차 이상에 비례하는 경우가 있을 수 있음
# 이러한 경우에는 I() 안에 원하는 수식 표현
# 객체의 해석과 변환을 방지
I(
  x # 객체 
)
x <- 1:1000
y <- x^2 + 3 * x + 5 + rnorm(1000)
lm(y ~ I(x^2) + x)

# I(X^2) 대신 X^2 쓰면 전혀 다른 결과를 생성
# 그 이유는 lm에 formula 인자로 주어진 x^2는 X x X 이기 때문
# X x X 는 x + x + x:x와 같은 의미로, x변수, x와 x의 상호작용을 의미

x1 <- 1:1000
x2 <- 3 * x1
y  <- 3 * (x1 + x2) + rnorm(1000) 
lm(y ~ I(x1 + x2))
lm(y ~ x1 + x2)    # 위의 모델과는 다른 의미임을 기억하자

# 4. 변수의 변환
# 종속 변수에 log를 취하거나 설명 변숭 제곱근을 취하는 방식
lm(log(y) ~ x)
lm(y ~ log(x))

# 5. 상호 작용(interaction)
# 독립 변수 간의 상호 작용이 종속 변수에 영향을 주는 경우를 말함
# 영향을 주는 방법이 합이 아니라 곱의 형태일 때를 말함

# ex) 기존 주행 속도, 제동 거리의 순서쌍 데이터로 구성되어 있고
#     여기에 자동차의 크기라는 범주형 변수가 추가된다면 자동차의 크기를 설명 변수에 추가해야 함

# 추가시 3가지 유형으로 설명 가능
# -  차량의 크기를 고려할 필요 없음
# -  dist ~ speed
# -  차량의 크기는 상수항에만 영향을 미칠 뿐 주행 속도에 따른 제동 거리의 기울기는 영향을 미치지 않음
# -  dist ~ speed + size

# -  차량의 크기가 상수항과 주행 속도의 기울기 모두에 영향을 미침
# -  dist ~ speed + size + speed:size
# -       ~ speed * size

# 최대 2개까지 상호 작용 하는 경우, (A + B + C) ^ 2 = A + B + C + A:B + A:C + B:C
# 최대 3개까지 상호 작용 하는 경우, (A + B + C) ^ 3

data(Orange)
head(Orange) #오렌지 나무 별 나이와 둘레를 저장한 데이터
with(Orange, plot(Tree, circumference, xlab = 'Tree', ylab = 'circumference'))

# 상호 작용 시각화 함수
interaction.plot(
  x.factor,       # X축에 그릴 펙터
  trace.factor,   # 자취를 그릴 레벨을 저장한 펙터
  response        # 반응값을 저장한 숫자 벡터
)

# 나무의 나이와, 종류가 둘레에 어떤 영향을 주는지 알아보자
# 어떤 나무인가에 따라 나이와 둘레의 관계가 변함을 확인!
with(Orange, interaction.plot(age, Tree, circumference))

Orange[,'fTree'] <- factor(Orange[,"Tree"], ordered = F)
m                <- lm(circumference ~ (fTree*age), data = Orange)

anova(m)     

###############
## 3. 이상치 ## 
###############
# 이상치(Outlier)는 주어진 회귀 모델에 의해 잘 설명되지 않는 데이터 점들을 뜻함
# 이상치 검출에서는 잔차, 외면 스튜던트화 잔차(Externally Studentized Residual)를 사용
# ** 스튜던트화 잔차
# 잔차를 잔차의 표준 편차로 나눈 값
# 일반적으로 표준 편차는 데이터 전체에 대해서 구함
# 그런데 i번째 데이터가 이상치인지 아닌지를 확인하면서 i번째 데이터를 포함하여 표준 편차를 구하는 건
# 적절치 않음. 따라서 외면 스튜던트화 잔차는 i번째 스튜던트화 잔차를 구할 때 i를 제외하여 표준 편차를 구함

# 외면 스튜던트화 잔차
rstudent(
  model  # lm 또는 glm 함수가 반환한 모델 객체
)
# 본페로니 이상값 검정
# 여러 가설 검정을 수행할 때 
# 발생하는 다중 비교(Multiple Comparison) 문제를 해결한 p 값
# 여러개의 가설 검정을 동시에 수행하면 귀무가설을 기각할 확률이 높아짐
# 이를 다중 비교 문제라고 하는데, 본페로니 교정은 이를 해결한 p 값을 구함

# t-test를 이용해 rstudent 값이 너무 크거나 작은 점을 찾으면 됨
# -> 이를 간단하게 해주는 함수 outlierTest
car::outlierTest(
  model # lm 또는 glm 객체 
) 

# Orange 데이터에 이상치를 직접 추가하고,
# circumference ~ age + I(age^2)의 포뮬러로 선형 회귀를 수행한 다음 
# outlierTest를 호출해 이상치 찾기
data(Orange)
Orange <- rbind(Orange,
                data.frame(Tree = as.factor(c(6, 6, 6)),
                           age  = c(118, 484, 664),
                           circumference = c(177, 50, 30)))

tail(Orange)
m <- lm(circumference ~ age + I(age^2), data = Orange)
car::outlierTest(m) # 36번째 데이터에서 p가 0.05보다 작은 값이 나와 이상치로 검출됨

#################
## 4. 변수선택 ## 
#################

# 변수 선택법
# 설명 변수를 선택하는 방법 중 한가지는
# 특정 기준(F 통계량, AIC)를 사용해 변수를 하나씩 택하거나 제거하는 것

# - 전진 선택법: 절편만 있는 모델에서 기준 통계치를 가장 많이 개선시키는 변수를 차례로 추가
# - 변수 소거법: 모든 변수가 포함된 모델에서 기준 통계치에 가장 도움이 되지 않는 변수 제거
# - 단계적 방법: 위의 두 단계를 복합적으로 조합한 방법

# 1. step function
# 위의 3가지 방법을 적용 가능
step(
  object, 
  # 탐색할 모델의 범위 지정
  # 범위는 단일 포뮬러, 또는 하한 상한을 lower, upper로 저장한 리스트로 지정
  scope,
  # forward, backward, both
  direction = c('both', 'forward', 'backward')
)

library(mlbench)
data(BostonHousing)
m  <- lm(medv ~ ., data = BostonHousing)

# step 해석
# AIC(아카이케 정보 기준)으로 모델의 품질을 평가하는 척도
# AIC이 작을수록 좋은 모델
# 결과화면에서 AIC가 작은 순서대로 정렬되어 있음. 즉 가장 상단에 위치하는 변수를 빼거나 더하면 가장 좋아짐 
# 

m2 <- step(m, direction = "both")
formula(m2)                        # formula 함수를 통해 변수선택법 적용 후의 포뮬라 추출 가능
predict(m2, newdata = ...)         # m2 object를 predict 함수를 통해 수행

# AIC는 작을수록 더 좋은 모형!


# 2. 모든 경우에 대한 비교
# N개의 설명 변수가 있을 때, 각 변수를 추가하거나 뺀 총 2N개의 회귀 모델을 만들고 이를 모두 비교
# leaps::regsubsets function
leaps::regsubsets(
  x,    # 디자인 행렬 또는 모델 포뮬러
  data, 
  # 어떻게 모델을 탐색할 것인가 setting
  # exhaustive : 모든 가능한 모델 탐색
  # forward    : 변수 추가
  # backward   : 변수 삭제
  # seqrep     : 삭제 반복
  method = c("exhaustive", "forward", "backward", "seqrep"),
  # 각 변수 개수당 최선의 모델 구하는 수
  nbest = 1
)

data("BostonHousing")
m <- leaps::regsubsets(medv ~., data = BostonHousing)
# row num은 변수 포함 개수를 말하고,
# *는 해당 변수 포함 개수에서 최적의 모델일 때 포함해야할 변수를 뜻함
summary(m)
summary(m)$bic    # BIC가 작을 수록 좋은 모델
summary(m)$adjr2  # AIC가 클수록 좋은 모델

# plot을 사용하면, 수정 결정 계수를 그려보면 각 변수가 선택되었을 때 수정 결정 계수를 좀 더 
# 쉽게 알 수 있음
plot(m, scale = "adjr2")

########################
## 6. 다중공선성 진단 ## 
########################
# 계수가 통계적으로 유의미하지 않다면 대처
# 계수가 통계적으로 유의미하다면 VIF가 크더라도 특별히 대처할 필요없음
# 변수들을 더하거나 빼서 새로운 변수를 만든다
# (개념적으로나 이론적으로) 두 예측변수를 더하거나 빼더라도 문제가 없는 경우
#    예) 남편의 수입과 아내의 수입이 서로 상관이 높다면, 두 개를 더해 가족 수입이라는 하나의 변수로 투입한다
# 더하거나 빼기 어려운 경우는 변수를 모형에서 제거한다
# 단, 변수를 제거하는 것은 자료의 다양성을 해치고, 분석하려던 가설이나 이론에 영향을 미칠 수 있기 때문에 가급적 자제
car::vif(m)


