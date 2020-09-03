## 데이터 윈도우
## 이동평균과 같은 개념의 컴포넌트

## 1. zoo package의 rollapply function을 이용한 이동 평균 계산

a <- 1:10
b <- 11:20
c <- data.frame(cbind(a, b))

library(zoo)
c_window <- zoo::rollapply( data = c
               , FUN = mean
               , align = 'left' # left   : 기준값 + 이후값들
                                # right  : 기준값 + 이전값들
                                # center : 이전값들 + 기준값 + 이후값들
               ,width = 3
               ,fill  = NA)      # 간격

c <- cbind(c, c_window)


## 2. zoo package의 rollmean function을 이용한 이동 평균 값 계산
## 위의 rollapply function과 동일
zoo::rollmean(x =  c,
              k = 3,
              fill = NA,
              align = 'left')

