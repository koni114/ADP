###################
## 데이터 윈도우 ##
###################
## 이동평균과 같은 개념

## 1. zoo package의 rollapply function을 이용한 이동 평균 계산

a <- 1:10
b <- 11:20
c <- data.frame(cbind(a, b))

library(zoo)
c_window <- zoo::rollapply( 
  data   = c,
  FUN    = mean,
  align  = 'left',  # left   : 기준값 + 이후값들
                    # right  : 기준값 + 이전값들
                    # center : 이전값들 + 기준값 + 이후값들
  width  = 3,       # 간격
  fill   = NA
  )     

c <- cbind(c, c_window)


## 2. zoo package의 rollmean function을 이용한 이동 평균 값 계산
## 위의 rollapply function과 동일
zoo::rollmean(
  x     = c,
  k     = 3,
  fill  = NA,
  align = 'left')

###############
## 누적 계산 ##
###############
# - 누적 합 (cumulative sums) : cumsum()
# - 누적 곱 (cumulative products) : cumprod()
# - 누적 최소값 (cumulative minima) : cummin()
# - 누적 최대값 (cumulative maxima) : cummax()


## 3. dplyr::cummean function
# 행을 하나씩 이동해 가면서 누적으로 평균 반환
library(dplyr)
c <- data.frame(a = c('A', 'A', 'A', 'B', 'B'), b = c(1,2,3,4,5))
c %>% group_by(a) %>% mutate(cummean.b = cummean(b))

##########
## 기타 ##
##########
# 01. 그룹별로 평균 값(mean)보다 큰 행(rows)만 선별
iris %>%  group_by(Species) %>% filter(Sepal.Length > mean(Sepal.Length))

# 02. dplyr CASE WHEN 사용하기
mtcars %>% dplyr::select(mpg, cyl, hp) %>% mutate(
    type = dplyr::case_when(
      cyl >= 8 | hp >= 180 ~ "big",          # or
      cyl >= 4 & hp >= 120 ~ "medium",      # and
      TRUE ~ "small"
    )
  )