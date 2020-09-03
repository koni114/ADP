## 데이터 샘플링
library(sampling)

## 1. 단순임의추출 ----
trainIdx <- sample(1:nrow(iris), nrow(iris) * 0.7)
train <- iris[trainIdx , ]
test  <- iris[-trainIdx, ]

## 2. 층화임의추출 ----
## 2.1. createDataPartition function : 자동으로 종속변수의 level 비율에 따라 sampling 수행
trainIdx <- caret::createDataPartition(iris[,"Species"], p = 0.7, list = F)
train <- iris[trainIdx,  ]
test  <- iris[trainIdx,  ]

## 2.2. srswor_sampling
## 성별, 연령대 계층별 층화 임의 추출 수행 방법
n   <- 1000
d.t <- data.table( gender     = rbinom(n, 1 , .5)                # 0, 1
                  ,   age     = sample(1:5, n, replace=TRUE)     # 계층별, 1, 2, 3, 4, 5
                  ,  rebuy_yn = rbinom(n, 1, 0.2))               # ?

setkey(d.t, gender, age)
d.t[ , .N, keyby = list(gender, age)] # 총 10개의 그룹.
set.seed(2)
samp <- data.table(sampling::strata(
                           c('gender', 'age')
                          , size = rep(20, 10)
                          , method = "srswor"
                          , data = d.t)
                   )


## 3. 계통추출 ----
## +3, +3, +3...
library(doBy)
doBy::sampleBy(~1, frac = .3, data = iris, systematic = T)


## 4. 시계열추출 ----
## 시계열 기준으로 order by 되었을 때, 뒷부분, 앞부분으로 sampling 진행하고 싶은 경우,
mid   <- nrow(iris) * 0.7
train <- iris[seq(from = 0, to = mid),] 
test  <- iris[seq(from = mid+1, to = nrow(iris)), ]

