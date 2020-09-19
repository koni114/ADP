#################
## 시계열 분석 ##
#################

# 1. 시계열 자료
# 시간의 흐름에 따라서 관찰된 데이터

# 2. 정상성
# 대부분의 시계열 자료는 다루기 어려운 비정상성 시계열 자료
# 분석하기 쉬운 정상성 시계열 자료로 변환해야함
# 정상성 조건
# - 평균이 일정해야 함
#   평균이 일정하지 않은 시계열은 차분(difference)을 통해 정상화

# - 분산이 시점에 의존하지 않음
#   분산이 일정하지 않은 시계열은 변환(transformation)을 통해 정상화
# - 공분산도 시차에만 의존할 뿐, 특정 시점에는 의존하지 않음

# 3. 시계열 모형

# 3.1 자기회귀 모형(Autogressive model, AR)
# P 시점 이전의 자료가 현재 자료에 영향을 줌
# 오차항 = 백색잡음과정(white noise process)
# 자기상관함수(Autocorrelation Function, ACF) : k 기간 떨어진 값들의 상관계수
# 부분자기상관함수(partial ACF) : 서로 다른 두 시점의 중간에 있는 값들의 영향을 제외시킨 상관계수
# ACF 빠르게 감소, PACF는 어느 시점에서 절단점을 가짐
# PACF가 2시점에서 절단점을 가지면 AR(1) 모형

# 3.2 이동평균 모형(Moving average model, MA)
# 유한한 개수의 백색잡음 결합이므로 항상 정상성 만족
# ACF가 절단점을 갖고, PACF는 빠르게 감소

# 자기회귀누적이동평균 모형 (Autoregressive integrated moving average model, ARIMA)
# 비정상 시계열 모형
# 차분이나 변환을 통해 AR, MA, 또는 이 둘을 합한 ARMA 모형으로 정상화
# ARIMA(p, d, q) - d : 차분 차수 / p : AR 모형 차수 / q : MA 모형 차수

# 분해 시계열
# 시계열에 영향을 주는 일반적인 요인을 시계열에서 분리해 분석하는 방법
# 계절 요인(seasonal factor), 순환 요인(cyclical), 추세 요인(trend), 불규칙 요인(random)

# 1) 소스 데이터를 시계열 데이터로 변환
ts(data, frequency = n, start = c(시작년도, 월))

# 2) 시계열 데이터를 x, trend, seasonal, random 값으로 분해
decompose(data)

# 3) 시계열 데이터를 이동평균한 값 생성
SMA(data, n = 이동평균수)

# 4) 시계열 데이터를 차분
diff(data, differences = 차분횟수)

# 5) ACF 값과 그래프를 통해 래그 절단값을 확인
acf(data, lag.max = 래그수)

# 6) PACF 값과 그래프를 통해 래그 절단값을 확인
pacf(data, lag.max = 래그수)

# 7) 데이터를 활용하여 최적의 ARIMA 모형을 선택
auto.arima(data)

# 8) 선정된 ARIMA 모형으로 데이터를 보정(fitting)
arima(data, order = c(p, d, q))

# 9) ARIMA 모형에 의해 보정된 데이터를 통해 미래값을 예측
forecast.Arima(fittedData, h = 미래예측수)

# 10) 시계열 데이터를 그래프로 표현
plot.ts(시계열데이터)

# 11) 예측된 시계열 데이터를 그래프로 표현
plot.forecast(예측된시계열데이터)


##########################################
## 시계열 실습 - 영국왕들의 사망시 나이 ##
##########################################
library(TTR)
library(forecast)

# 영국왕들의 사망시 나이
kings <- scan("http://robjhyndman.com/tsdldata/misc/kings.dat", skip = 3)
kings

kings_ts <- ts(kings)
kings_ts

plot.ts(kings_ts)

# 이동평균
kings_sma3 <- SMA(kings_ts, n = 3)
kings_sma8 <- SMA(kings_ts, n = 8)
kings_sma12 <- SMA(kings_ts, n = 12)
par(mfrow = c(2,2))
plot.ts(kings_ts)
plot.ts(kings_sma3)
plot.ts(kings_sma8)
plot.ts(kings_sma12)

# 차분을 통해 데이터 정상화
kings_diff1 <- diff(kings_ts, differences = 1)
kings_diff2 <- diff(kings_ts, differences = 2)
kings_diff3 <- diff(kings_ts, differences = 3)

plot.ts(kings_ts)
plot.ts(kings_diff1)    # 1차 차분만 해도 어느정도 정상화 패턴을 보임
plot.ts(kings_diff2)
plot.ts(kings_diff3)

par(mfrow = c(1,1))
mean(kings_diff1); sd(kings_diff1)

# 1차 차분한 데이터로 ARIMA 모형 확인
acf(kings_diff1, lag.max = 20)       # lag 2부터 점선 안에 존재. lag 절단값 = 2. --> MA(1)
pacf(kings_diff1, lag.max = 20)      # lag 4에서 절단값 --> AR(3)
# --> ARIMA(3,1,1) --> AR(3), I(1), MA(1) : (3,1,1)

# 자동으로 ARIMA 모형 확인
auto.arima(kings)   # --> ARIMA(0,1,1)

# 예측
kings_arima <- arima(kings_ts, order = c(3,1,1))   # 차분통해 확인한 값 적용
kings_arima

# 미래 5개의 예측값 사용
kings_fcast <- forecast(kings_arima, h = 5)
kings_fcast

plot(kings_fcast)

kings_arima1 <- arima(kings_ts, order = c(0,1,1))   # auto.arima 추천값 적용
kings_arima1

kings_fcast1 <- forecast(kings_arima1, h = 5)
kings_fcast1

plot(kings_fcast)
plot(kings_fcast1)

############################################
## 시계열 실습 - 리조트 기념품매장 매출액 ##
############################################
data <- scan("http://robjhyndman.com/tsdldata/data/fancy.dat")
fancy <- ts(data, frequency = 12, start = c(1987, 1))
fancy
plot.ts(fancy) # 분산이 증가하는 경향 --> log 변환으로 분산 조정  

fancy_log <- log(fancy)
plot.ts(fancy_log)

fancy_diff <- diff(fancy_log, differences = 1)
plot.ts(fancy_diff)   

# 평균은 어느정도 일정하지만 특정 시기에 분산이 크다 
# --> ARIMA 보다는 다른 모형 적용 추천
acf(fancy_diff, lag.max = 100)
pacf(fancy_diff, lag.max = 100)
auto.arima(fancy)   # ARIMA(1,1,1)(0,1,1)[12]
fancy_arima <- arima(fancy, order = c(1,1,1), seasonal = list(order = c(0,1,1), period = 12))
fancy_fcast <- forecast.Arima(fancy_arima)
plot(fancy_fcast)

