## 데이터 분할

## 1. split function
## split('분리할 데이터', ' 기준이 되는 컬럼 혹은 factor')
## return Data type은 list
iris_split <- split(x = iris, iris$Species)

## 두가지 컬럼을 기준으로 split 하는 경우,
## list로 지정해 주어야 함. 이때 column1Value.column2value 형식으로 naming
split(infert, list(infert$education, infert$case))

## 2. 문자열 분할
## nchar(), substr(), paste0(), strsplit(), sub(), gsub()

## 2.1 nchar : 스칼라 각각의 문자열 길이 return, 
##     이 때 공백 포함
x <- c("Seoul", "New York", "London", "1234")
nchar(x)

## 2.2 substr(x, start, stop)
substr(x, 1, 3)

## 2.3 strsplit : 문자형 벡터 x를 기준으로 나누기
##                return value는 list
name       <- c("Chulsu, Kim", "Younghei, Lee", "Dongho, Choi")
split_name <- strsplit(name, split = ',')


## 2.4 sub, gsub 를 이용하면 문자 대체 가능
## sub  : 최초 한번만,
## gsub : 변경 가능한 문자 전부 대체

## 3. dataframe에서 문자열 기호를 기준으로 컬럼을 나누는 방법
test <- data.frame(ID = c(1:3), name = c("Chulsu/Kim", "Younghei/Lee", "Dongho/Choi"))
cbind_test <- do.call('rbind', strsplit(as.character(test$name), '/')
                      ) %>% data.frame

## 4. 문자열 벡터에서 특정 부분 문자열 패턴 찾기
## grep     : 해당 패턴이 있는지 확인 
## regexpr  : 해당 규칙이 있는 최초 index 위치 return
## gregexpr : text 내에서 패턴이 나오는 모든 위치를 찾기 
grep("1010", c('1010101', '1001010', '10010101'))
regexpr("1010", c('1010101', '1001010', '10010101'))
gregexpr("NY", "I love NY and I'm from NY")

## 5. stringr::str_split
## strsplit function과 동일한 역할 수행
## str_split 같은 경우, 내가 나누고자 하는 개수를 지정할 수 있음
fruits <- c(
  "apples and oranges and pears and bananas",
  "pineapples and mangos and guavas"
)

stringr::str_split(fruits, pattern = "and ", n = 2)

## dplyr package에서 컬럼 분할하는 방법?


