## 자료 요약
library(dplyr)
library(timeDate)

## 1. 수치형
#  평균, 중앙값, 표준편차, 최소, 최대, 1분위수, 3분위수, 백분위(95%, 90%, 10%, 5%), 왜도, 첨도
iris %>% select_if(is.numeric) %>% summarise_all(list(  ~ n()
                                                      , ~ mean(., na.rm   = T)  
                                                      , ~ median(., na.rm = T)
                                                      , ~ sd(.,  na.rm = T)
                                                      , ~ min(., na.rm = T)
                                                      , ~ max(., na.rm = T)
                                                      , Q1  = ~ quantile(., 0.25, na.rm = T)
                                                      , Q3  = ~ quantile(., 0.75, na.rm = T)
                                                      , PCT05 = ~ quantile(., 0.05, na.rm = T)
                                                      , PCT10 = ~ quantile(., 0.1, na.rm = T)
                                                      , PCT90 = ~ quantile(., 0.9, na.rm = T)
                                                      , PCT95 = ~ quantile(., 0.95, na.rm = T)
                                                      , skew  = ~ timeDate::skewness(.)
                                                      , krto  = ~ timeDate::kurtosis(.)
                                                       ))

## 2. 문자형, 범주형
iris %>% group_by(Species) %>% tally()


