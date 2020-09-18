#################
## 이상치 처리 ##
#################

library(dplyr)
setwd("C:/ADP자료/")
titanic <- data.table::fread("titanic.csv"
) %>% data.frame()

####################
# 이상치 처리 Rule #
####################

## 01. IQR
## InterQuantile Range
IQR_Treat_lower <- function(x){
  IQR_Value  <- IQR(x, na.rm = T)
  medi_value <- median(x, na.rm = T)
  c(medi_value - 1.5*IQR_Value)
}

IQR_Treat_upper <- function(x){
  IQR_Value  <- IQR(x, na.rm = T)
  medi_value <- median(x, na.rm = T)
  c(medi_value + 1.5*IQR_Value)
}

titanic %>% dplyr::select(Pclass, Age, SibSp, Parch, Fare) %>% summarise_all(list("IQR_lower" = IQR_Treat_lower,
                                                                                  "IQR_upper" =  IQR_Treat_upper))



## 02. 백분위 수
PCT10 <- function(x) quantile(x, 0.1, na.rm = T)
PCT90 <- function(x) quantile(x, 0.9, na.rm = T)
titanic_PCT <- titanic %>% select(Pclass, Age, SibSp
                                  , Parch, Fare) %>% summarise_all(funs(PCT10, PCT90)) %>% select(contains("Age")
                                                                                                  ) %>%  as.vector


# 이상치 대체 값
## NA
titanic %>% mutate(Age = ifelse(Age < as.numeric(titanic_PCT[1]) | Age > as.numeric(titanic_PCT[2]), NA, Age)) 

################################
# library를 이용한 이상치 처리 #
################################
# 01. boxplot.stats function
titanic_treat <- data.frame(apply(titanic, 2, function(x){
  if(is.numeric(x)){
    x.stats <- boxplot.stats(x)$out
    x[x %in% x.stats] <- NA
    as.numeric(x)
  }else{
    x
  }
}))

# 02. outliers package
# outlier function
# outlier라고 판단되는 값을 추출
install.packages("outliers")
library(outliers)
outlier(
  x,         # 데이터 백터
  opposite,  # T : 반대 방향 outlier 추출
)

outlier(titanic$Age)
outlier(titanic$Age,opposite=TRUE)

# 03. score function
# t-분포, z-분포 기반으로 신뢰구간 기준 밖으로 벗어난 점을 True로 return
x = rnorm(10)
scores(x, type="z", prob=0.95) 
scores(x, type="t", prob=0.95) 
