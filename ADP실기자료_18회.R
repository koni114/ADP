###########################
# ADP 18회 문제 시험 복기 #
###########################

# 01. 백화점 고객 transaction 데이터(Sales.csv)
# id         : 고객 Id(unique한 데이터)
# grade      : 고객 등급(1 ~ 5)
# duration   : 최종 구입일로부터 경과 시간
# count      : 구매품 총 수
# amount     : 구매 총 금액   

# 데이터의 특징.
# id       : 고객은 unique한 데이터로 구성
# grade    : grade는 1 ~ 5등급까지 구성되어 있으며, 1등급이 가장 고객 수가 적고, 5등급이 고객 수가 가장 많음
# duration : 최종 구입일로부터 경과 시간으로, 날짜형이 아닌 단순 정수로 구성됨
# count    : 고객이 구입한 총 물품. 고객 ID가 중복 발생하지 않는 것으로 보아, 한 고객이 지금까지 총 구매한 구매 물품 수를 말하는 것 같음
# amount   : 고객이 구입한 총 금액. 마찬가지로 지금까지 구매한 총 금액을 의미하는 듯함

# 분석 할 데이터 생성
# 구글링으로 데이터 찾기가 어려워 직접 데이터를 생성해서 테스트 하는 형식으로 진행해 보도록 하겠다.
# 실제 데이터는 다음과 같은 특징이 있었던 것으로 기억한다.
# 0. 등급이 높아질수록 고객의 수는 많아짐
# 1. 등급이 높아질수록 count 값은 커짐
# 2. 등급이 높아질수록 amount 값은 커짐
# 3. 등급이 높아질수록 duration 값도 커짐
# 각 등급별로 2000개의 row data 를 생성하여 임의의 데이터를 만들어 보겠다.

library(foreach)
grade    <- c(1, 2, 3, 4, 5)
amountOfCsm <- c(1000, 2000, 3000, 4000, 5000)
amount   <- c(150000, 120000, 90000, 50000, 30000)
duration <- c(8,  6, 5, 4, 2)
count    <- c(12, 9, 7, 5, 3)
df <- foreach(i = 1:5, .combine='rbind') %do% {
  grade1 <- data.frame(  
    grade    = rep(grade[i], amountOfCsm[i]),
    duration = round(rnorm(amountOfCsm[i], duration[i], 1), 0),   
    count    = round(rnorm(amountOfCsm[i], count[i],    2), 0),
    amount   = round(rnorm(amountOfCsm[i], amount[i],   2), 0)
  )
  grade1
}

# 1.1 



