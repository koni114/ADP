#######################
## Chapter03 다변량 분석

#####################################
# 1. 상관분석(Correlation Analysis) #
#####################################
# 데이터 안에 두 변수 간의 관계를 알아보기 위해 함
# 피어슨   상관계수 : 등간척도 이상으로 측정되는 두 변수 간의 상관관계를 측정하는 데 쓰임
# 스피어만 상관계수 : 서열척도인 두 변수들의 상관관계를 측정하는 데 사용

# ** 피어슨 상관계수
# -1 <= law <= 1, X와 Y가 독립이면, 0 값을 가짐(모집단)

# 상관계수 예시
install.packages("Hmisc")
library(Hmisc)
data(mtcars)
head(mtcars)

# Hmisc package 내 rcorr 함수 사용
# 두 번째 P 행렬은 각 상관계수의 유의학률을 포함
Hmisc::rcorr(as.matrix(mtcars), type = "pearson")

# 공분산 구하기
cor(mtcars)

# ** 스피어만 상관계수
# 피어슨의 상관계수는 두 변수 간의 선형 관계의 크기를 측정하는 값으로,
# 비선형적인 상관관계는 나타내지 못함

# 스피어만 상관계수는 두 변수 간의 비선형적인 관계도 나타낼 수 있는 값
# 한 변수를 단조 증가 함수로 변환하여 다른 변수를 나타낼 수 있는 정도를 나타냄

# 두 변수를 모두 순위로 변환 시킨 후, 두 순위 사이의 피어슨 상관계수로 정의가 됨

rcorr(as.matrix(mtcars), type="spearman")

####################
# ** 다차원 척도법 #
####################
# 여러 대상 간의 거리가 주어져 있을 때, 대상들을 동일한 상대적 거리를 가진
# 실수공간의 점들로 배치시키는 방법

# 주어진 거리는 추상적인 대상들간의 거리가 될 수도 있고, 실수공간에서의 거리가 될 수도 있음

data(eurodist)
eurodist       # 도시 사이의 거리를 매핑

# cmdscale : 각 도시의 상대적 위치를 도식화 할 수 있는 X,Y좌표를 계산

loc <- cmdscale(eurodist) 
x   <- loc[, 1]
y   <- loc[, 2]
plot(x,y,type = "n", main = "eurodist")
text(x,y,rownames(loc), cex = 0.8)
abline(v=0,h=0)

##################
# ** 주성분 분석 #
##################
# 상관관계가 있는 고차원 자료를 자료의 변동을 최대한 보존하는 저차원 자료로 변환시키는 방법
# 자료의 차원을 축약시키는데 주로 사용

library(datasets)
data(USArrests)
fit <- princomp(USArrests, cor = T) # 주성분 분석시, 공분산 행렬이 아닌 상관계수 행렬 사용
summary(fit)  # 주성분의 표준편차, 분산의 비율 등을 보여줌
loadings(fit) # 주성분들의 로딩 벡터를 보여줌

# Y1 = 0.536 * Murder + 0.583 * Assault + 0.278 * UrbanPop + 0.543 * Rape
# Y2 = 0.418 * Murder + ...

plot(fit) # Scree plot 이라고 부름. 함수는 각 주성분의 분산의 크기를 그림으로 보여줌
# 총 분산의 비율이 70% ~ 90% 사이가 되는 주성분의 개수를 선택하는 방법 사용

fit$scores  # 각 관측치를 주성분들로 표현한 값 
biplot(fit) # 관측치들을 첫 번째와 두 번째 주성분의 좌표에 그린 그림

###############
# 시계열 예측 #
###############
Nile
ldeaths

plot(Nile)    # 비계절성을 띔 -> 평균이 변화하는 비정상성 데이터
plot(ldeaths) # 계절성을 띔

class(Nile)
class(ldeaths)

ldeaths.decompose <- decompose(ldeaths)
ldeaths.decompose$seasonal
plot(ldeaths.decompose)

# 계절성을 띄는 시계열 자료는 계절요인을 추정해 그 값을 원 시계열자료에서 빼면 적절하게 조정할 수 있음

# ARIMA 모형
# 1. 차분하기
# 나일강 연간 유입량 데이터는 시간에 따라 평균이 일정하지 않은 비정상 시계열 자료
# --> 2번 차분하여 평균을 동일하게 맞춰준다
Nile.diff2 <- diff(Nile, defferences = 2)
plot(Nile.diff2)

# 2. ARIMA 모델 적합 및 결정
# 자기상관함수 살펴보기.
# lag 개수를 너무 많이 설정하면, 자기상관함수 그래프를 보고 모형식별을 위한 판단이 힘들기 때문에 적절한 값을 선택
# 해당 결과 자기상관함수가 lag = 1, 8을 제외하고 신뢰구간 안에 있는 것을 확인 가능
acf(Nile.diff2, lag.max = 20)

# 부분자기상관함수
# lag = 9 에서 양수로 가면서 절단된 것을 볼 수 있음
pacf(Nile.diff2, lag.max = 20)

# 자기상관함수와 부분자기상관함수의 그래프를 종합해보면 다음과 같은 ARMA 모형이 존재
# ARMA(8, 0) : 부분자기상관함수 그래프에서 lag = 9에서 절단
# ARMA(0, 1) : 자기상관함수 그래프에서 lag = 2에서 절단
# ARMA(p, q) : AR 모형과 MA 모형을 혼합하여 모형을 식별하고 결정해야 함

# 모수가 커지면 설명력은 높아지지만  , 복잡해지고 
# 모수가 작아지면 설명력은 낮아지지만, 단순해진다

# forecast package에 있는 auto.arima 함수를 사용하여 ARIMA 모형 결정하기
install.packages("forecast")
library(forecast)
auto.arima(Nile)
Nile.arima <- arima(Nile, order = c(1,1,1))
Nile.forecast <-  forecast(Nile.arima, h=10)  # forecast function을 통해 미래 수치 값 예측
plot(Nile.forecast)
