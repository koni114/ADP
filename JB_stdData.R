## 데이터 표준화
## https://adnoctum.tistory.com/184

test <- sample(100)
unlist()
## 1. scale 변환 = 정규화변환
## x - mean(x) / sd(x) 
iris_std <- lapply(iris, function(x){
  if(is.numeric(x)){
    as.numeric(scale(x))
  }else{
    x
  }
}) %>% data.frame

## 2. 01 변환


## x - min(x) / max(x) - min(x)
iris_01 <- lapply(iris, function(x){
  if(is.numeric(x)){
    round(as.numeric(x - min(x, na.rm = T) / (max(x, na.rm = T) - min(x, na.rm = T))), 1)
  }else{
    x
  }
}) %>% data.frame


