## 데이터 정렬 
library(dplyr)

## 1. dplyr package arrange 함수를 이용한 정렬 수행

## 1.1 단일 컬럼에 대해서 데이터 정렬 수행 ----
iris %>% dplyr::arrange(Sepal.Length)               # 오름차순
iris %>% dplyr::arrange(-Sepal.Length)              # 내림차순 : - 를 붙임

## 1.2 여러 컬럼에 대한 데이터 정렬 수행 ----
iris %>% dplyr::arrange(Sepal.Length, Petal.Length) 
iris %>% dplyr::arrange(-Sepal.Length, Sepal.Width) # 내림차순과 오름차순 동시에,

## 2.  etc : order, sort, rank function ----
## 2.1 order function
test <- c(1,2,3,4,5,10,7,4,3,4,5,7)

test[order(test)]                 # 오름차순
test[order(test, decreasing = T)] # 내림차순

## 2.2 sort function
sort(test)                 # 오름차순
sort(test, decreasing = T) # 내림차순

## 2.3 rank function
## ties.method = c("average", "first", "last", "random", "max", "min")
test <- c(1,2,3,4,5,10,7,4,3,4,5,7)
rank(test, ties.method = 'first')



