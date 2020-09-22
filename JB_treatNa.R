#################
## 결측치 처리 ##
#################

library(dplyr)
setwd("C:/ADP자료/")
titanic <- data.table::fread("titanic.csv"
) %>% data.frame()

##############
# 1. 행 제거 #
##############

# 1.1 is.na function
titanic_removeRow <- titanic[rowSums(is.na(titanic)) == 0,]

# 1.2 complete.cases function
titanic_removeRow <- titanic[complete.cases(titanic),]

# 1.3 dplyr package를 활용한 행제거
titanic_removeRow <- titanic %>% filter(is.na(.))
titanic_removeRow <- titanic %>% filter_all(~ !is.na(.))
titanic_removeRow <- titanic %>% filter_all(all_vars(!is.na(.)))

##############
# 2. 열 제거 #
##############

# 2.1 is.na function
titanic[colSums(is.na(titanic)) == 0]

# 2.2  dplyr package를 활용한 열제거
titanic_removeCol <- titanic %>%  dplyr::select_if(~ !any(is.na(.)))

##################
# 3. 결측치 대체 #
##################

# 3.1 평균 값
titanic_treatMean <- titanic %>% mutate_all(~ifelse(is.na(.x), mean(.x, na.rm = T), .x))

# 3.2 이전 값
x <- c(NA, 1, 4, 5, 6, NA, 1)
L <- !is.na(x)
x <- unlist(list(x[L][1], x[L]))[cumsum(L) + 1]

# 3.3 임의 값
titanic_treatMean <- titanic %>% mutate_all(~ifelse(is.na(.x), 10, .x))

# 3.4 중앙 값
titanic_treatMean <- titanic %>% mutate_all(~ifelse(is.na(.x), median(.x, na.rm = T), .x))

#########################################
# 04. library 함수를 사용한 결측치 제거 #
#########################################

# 4.1 DMwR::centralImputation
# NA를 가운데 값으로 대체
# 숫자의 경우 중앙값, 팩터의 경우 최빈값
library(DMwR)
DMwR::centralImputation(
  data, # 데이터 프레임
)

# 4.2 DMwR::knnImputation
# NA를 k 최근 이웃 분류 알고리즘을 사용해 대체
# 데이터 정규화는 자동으로 수행
DMwR::knnImputation(
  data, # 데이터 프레임
  k,    # 몇개의 이웃을 볼 것인가 확인
)

# 4.3 mice
library(mice)
miceMod <- mice(titanic, method="rf")  # perform mice imputation, based on random forests.
miceOutput <- complete(miceMod)                                                   # generate the completed data.
anyNA(miceOutput)




