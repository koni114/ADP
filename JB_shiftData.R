###################
## 데이터 시프트 ##
###################

## 1. 컬럼 1개만을 기준으로 shifting --> lead lag function

iwinsize = 3
lead(iris[,"Sepal.Length"], iwinsize) # 후행이동 : 윈도우 크기만큼 벡터 앞쪽으로 이동
lag(iris[,"Sepal.Length"] , iwinsize) # 선행이동 : 윈도우 크기만큼 벡터 뒷쪽으로 이동

## 2. 여러 개의 컬럼을 기준으로 shifting 하는 경우,
lapply(iris, function(x){
  lead(x, iwinsize)
}) %>%  data.frame


lapply(iris, function(x){
  lag(x, iwinsize)
}) %>% data.frame


