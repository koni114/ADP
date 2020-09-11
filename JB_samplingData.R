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

# 1.3 sampling::strata function
sampling::strata(
  data,  # data.frame 또는 vector
  stratanames = NULL, # 층화 추출에 사용할 변수들, 다수의 층을 적용할 수 있음
  size, # 각 층의 크기
  # method는 데이터를 추출하는 방법으로, 다음 4가지 중 하나로 지정한다
  # - srswor   : 비복원 단순 임의 추출
  # - srswr    : 복원 단순 임의 추출
  # - poisson  : 포아송 추출
  # - sysmatic : 계통 추출
  pik, # 각 데이터를 표본에 포함할 확률
  description = F # T면 표본의 크기와 모집단의 크기를 출력
)

# 해당 표본 dataFrame을 기준으로 실제 데이터를 sampling 해오는 함수
sampling::getdata(
  data,
  m  # 선택된 유닛에 대한 벡터 또는 표본 데이터 프레임
)

library(sampling)
x <- sampling::strata(c("Species")
                      , size   = c(3,3,3) # 종별로 3개씩 추출, 값을 다르게 주면 다르게 추출 가능
                      , method = 'srswor', data = iris)
sampling::getdata(iris, x)


## 3. 계통추출 ----
## +3, +3, +3...
library(doBy)

doBy::sampleBy(
  formula,
  frac = 0.1, # 계통 추출 시 반복할 비율 : 데이터의 개수  * frac 만큼 반복을 돌려 index 추출
  replace = F,
  data = parent.frame(), 
  systematic = F
)

x <- data.frame(x = 1:10)
doBy::sampleBy(~1, frac = 0.3, data = x, systematic = T)




## 4. 시계열추출 ----
## 시계열 기준으로 order by 되었을 때, 뒷부분, 앞부분으로 sampling 진행하고 싶은 경우,
mid   <- nrow(iris) * 0.7
train <- iris[seq(from = 0, to = mid),] 
test  <- iris[seq(from = mid+1, to = nrow(iris)), ]

