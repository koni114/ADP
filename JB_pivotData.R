#################
## 데이터 피벗 ##
#################
# 열 -> 행 변환 : melt function
# 행 -> 열 변환 : cast function


## data pivoting
library(reshape)
library(MASS)
library(dplyr)
## 1. reshape melt(data, id.vars, measure.vars), dcast function ----
str(Cars93)
head(Cars93)

# 차종(Type) 중에서 개수가 적은 "Compact"와 "Van" 만 선별해서 예제로 사용
Cars93_v1   <- Cars93 %>% dplyr::select(Type, Origin, MPG.city, MPG.highway) %>% filter(Type %in% c('Compact', 'Van'))
Cars93_melt <- melt(  Cars93_v1
                    , id.vars      = c('Type', 'Origin')
                    , measure.vars = c('MPG.city', 'MPG.highway'))

head(Cars93_melt)
cast(Cars93_melt, Type ~ variable, fun = mean) # 세로 : Y, 가로 : X축에 온다고 생각하면 됨
cast(Cars93_melt, Type + Origin ~ variable, mean)
## 2. reshape::acast function
## dcast와 비슷한 역할 수행. 
library(gcookbook)
data(cabbage_exp)


#######################
## dcast, acast 예제 ##
#######################

reshape2::acast(data = cabbage_exp, 
                formula = Cultivar ~ Date,
                value.var = 'Weight')


# ** warning!!
# 행 -> 열 변환시, keyVar가 중복발생 하는 경우, error가 발생할 수 있음
# 따라서 key group별 sequence를 추가해 중복 데이터에 대해서도 열 변환이 되도록 적용 
test <- Cars93_melt %>% group_by(variable) %>% mutate(id = row_number()) %>%  data.frame()
reshape2::dcast(data = test, 
                formula = Type + Origin + id ~ variable,
                value.var = 'value')

