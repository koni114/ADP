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

## 2. reshape::acast function
## dcast와 비슷한 역할 수행. 
library(gcookbook)
data(cabbage_exp)

head(cabbage_exp)

reshape2::acast(data = cabbage_exp, 
                formula = Cultivar ~ Date,
                value.var = 'Weight',
                fun.aggregate = mean)



                             

