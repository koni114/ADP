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

df <- df %>% mutate(grade = as.factor(grade))

# 1.1 탐색적 데이터 분석(EDA), 결측치 처리 등 수행하고 시각화를 통해 데이터를 파악하시오(10점)
# 1.1.1 amount, duration, count는 모두 수치형 데이터 이므로, 각 컬럼별 평균, 중앙값, 분위수, 첨도 왜도를 구해보자
library(dplyr);library(timeDate)
summary <- df %>% summarise_all(list(mean   = ~ mean(., na.rm = T),
                                     median = ~ median(., na.rm = T),
                 Q1 = ~ quantile(., 0.25, na.rm = T),
                 Q3 = ~ quantile(., 0.75, na.rm = T),
                 skewness = ~ timeDate::skewness(.),
                 kurtosis = ~ timeDate::kurtosis(.)))

summary %>% select((matches("mean")))
summary %>% select((matches("median")))
summary %>% select((matches("Q1")))
summary %>% select((matches("Q3")))
summary %>% select((matches("skewness")))
summary %>% select((matches("kurtosis")))

# 1.1.2. 결측치 처리
#- 결측치 확인(실제 데이터는 결측치를 포함하고 있었음)
colSums(is.na(df))

#- DMwR::centrallnputation function을 이용해 수치형 데이터 평균치로 대체
#- 원래는 각 등급별 평균치로 대체할 수도 있으나, 그렇게 되면 결측치들이 
# - 그룹에 편향된 결과를 보일 수 있으므로, 단순 평균치로 대체한다
library(DMwR)
df <- DMwR::centralImputation(df)

# 1.1.3. 시각화 확인
# 3.1 등급별 고객이 구입한 총 물품의 평균치 확인 - 막대그래프
# 등급별로 총 물품의 평균치가 확실히 차이가 나는 것으로 보아 고객의 등급을 판정하는 모델을 생성할 때, 해당 독립변수를 추가한다면
# 좋은 모델을 생성할 수 있을 것이라 판단된다.
library(ggplot2)
df_ctByGrd <- df %>% group_by(grade) %>% summarise(meanCount = mean(count, na.rm = T ))
ggplot(data = df_ctByGrd, aes(x = grade, y = meanCount, fill = grade)) + geom_col() + geom_label(aes(label = round(meanCount, 4)),
                                                                                                 nudge_x = 0, nudge_y = 0, fill = 'white')


# 추가적으로, amount, duration 컬럼에 대해서도 등급별 평균 값 그래프를 그려 확인한다.

# 2. 3개의 파생변수를 생성하고, 해당 파생변수를 설명하시오(10점)
# 2.1 durationGrd   : 최종 경과일로 부터 기간(duration)을 통해, 핵심 고객, 충성 고객, 잠재 고객, 이탈 고객으로 크게 4등급으로 구분 짓는 파생변수 생성
# 2.2 amtPerCnt     : 물품 당 평균 금액(amount / count) 파생변수 생성
# 2.3 customerGrd   : 물품 당 평균 금액을 기준으로,  고가 구매 고객/중가 구매 고객/저가 구매 고객 3등급으로 구분 짓는 파생변수 생성

df_deriv <- df %>% mutate(
  durationGrd = case_when(
  duration <= quantile(duration, 0.25) ~ "1",
  duration > quantile(duration, 0.25) & duration <= quantile(duration, 0.5)  ~ "2",
  duration > quantile(duration, 0.5) & duration  <= quantile(duration, 0.75) ~ "3",
  TRUE  ~ "4"
  ),
  amtPerCnt   = amount / count
) %>% mutate(customerGrd = case_when(amtPerCnt >= quantile(amtPerCnt, 0.7) ~ "1" , 
                                     amtPerCnt <= quantile(amtPerCnt, 0.3) ~ "3", 
                                     TRUE ~ "2"))

# 3. 전체 데이터를 70% : 30%로 분류하여 train Data / test Data 로 구분하고,
# clustering SOM을 train Data를 사용하여 군집 모델을 생성 및 test Data를 통해 결과를 confusion Matrix 생성(10점)

# 3.1 train Data / test Data 생성
# 등급별 데이터의 수가 불균형 하므로(1등급의 고객 수는 적고, 5등급의 고객 수는 많음), 등급별 층별 샘플링을 통해 비율을 맞춤
set.seed(123)
train_idx <- caret::createDataPartition(df_deriv[, "grade"], p = 0.7, list = F)
trainData <-df_deriv[train_idx, ]
testData <-df_deriv[-train_idx, ]

# 3.2 SOM 분석 수행




