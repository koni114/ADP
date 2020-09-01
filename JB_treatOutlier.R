## 이상치 처리
library(dplyr)
setwd("C:/ADP자료/")
titanic <- data.table::fread("titanic.csv"
) %>% data.frame()

# 이상치 처리 Rule

## IQR
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

titanic %>% select(Pclass, Age, SibSp, Parch, Fare) %>% summarise_all(funs(IQR_Treat_lower, IQR_Treat_upper))

## 백분위 수
PCT10 <- function(x) quantile(x, 0.1, na.rm = T)
PCT90 <- function(x) quantile(x, 0.9, na.rm = T)
titanic_PCT <- titanic %>% select(Pclass, Age, SibSp
                                  , Parch, Fare) %>% summarise_all(funs(PCT10, PCT90)) %>% select(contains("Age")
                                                                                                  ) %>%  as.vector


# 이상치 대체 값
## NA
titanic %>% mutate(Age = ifelse(Age < as.numeric(titanic_PCT[1]) | Age > as.numeric(titanic_PCT[2]), NA, Age)) 

## min/max



## 제거