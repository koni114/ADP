## 변수 타입 설정 script
library(dplyr)
library(parsedate)


# 1. dplyr package를 활용한 변수 타입 설정

# 1.1 mutate_if function 활용
colnames(mtcars)
head(mtcars)

mtcars1 <- mtcars  %>% mutate_if(is.factor, as.character) # 모든 타입을 다른 타입으로 바꾸고 싶은 경우,
mtcars2 <- mtcars  %>% mutate_at("mpg", as.character)     # 특정 변수를 다른 변수형으로 바꾸고 싶은 경우,
mtcars3 <- mtcars  %>% mutate_at(vars(matches("ge")),  as.character)     # 특정 변수명을 포함하는 값들을 변환 하고 싶은 경우,

# 2. 날짜형 변환
# 왜 날짜형으로 변환해야 할까? 
# - 날짜형으로 변환시, 날짜형에 대한 사칙연산이 기본적으로 가능해짐.
# - 

# 2.1 오늘 날짜 반환 ----
Sys.Date()  # 오늘 날짜 반환 
date( )     # 현재 날짜와 시간 반환

# 2.2. 기호(symbol) ----
# 기본적으로 날짜형은 format 함수와 함께 날짜를 출력 할 수 있음
# %d : 날짜 ex) 01 ~ 31
# %a : 요일 축약형, ex) Mon
# %A : 요일 완성형, ex) Monday ~ Saturday.. Sunday
# %m : month(00-12) ex) 00-12
# %b : 월 축약형    ex) Jan, Feb
# %B : 월 완성형    ex) January
# %y : 2-digit year ex) 20, 07
# %Y : 4-digit year ex) 2020, 1992

# 2.3 as.Date, strptime ----
# help 함수를 통해 변환 타입 확인 가능
help(as.Date)

# 2.4 seq function을 통한 날짜 데이터 생성 ----
seq(as.Date("2020-08-01"), as.Date("2020-08-31"), 1)

# 3. lubridate package
# 날짜 연산을 위해 많이 사용되는 패키지
library(lubridate)
date <- now()

year(date)
month(date)
day(date)
wday(date, label = T)
wday(date)

# 날짜형 계산이 편하게 가능
# 주의! 날짜형 계산시 함수 뒤에 s를 붙여주어야 함
date + years(1)
date + months(1)
date + days(1)
date + minutes(1)
date + seconds(1)


# 3.1 lubridate::ymd
# 어떤 날짜형태든 날짜형으로 변환해줌, 단 %y-%m-%d 는 지켜야함
lubridate::ymd(20200830)
lubridate::ymd("2020-08-30")
lubridate::ymd("2020-11-30")

# 3.2 interval function + as.period function
# 시작과 끝 사이의 날짜 계산에 도움을 줌

interval("2020-01-30", today()) %>% as.period()

# 3.3 as.duration function
# 초 단위의 차이 값을 계산해줌
interval("2020-01-30", today()) %>% as.duration()

# 3.4  leap_year function
# 어떤 해가 윤년인지 아닌지 알아볼 수 있음
leap_year(2019) # 윤년이 아님
leap_year(2020) # 윤년이 맞음

# 3.5 lubridate::ymd_hm function
# 년월일 + 시분까지 표기해줌

# 3.6 am, pm function
# 오전인지, 오후인지 알려주는 function

# 3.7 round_date, ceiling_date, floor_date
# 날짜, 시간 계산에도 반올림이 필요할 수 있음

# 4. 기타 tip ----
# R에서 날짜는 1970-01-01 년 이후의 날짜 수로 표시되며, 이전 날짜는 음수로 표시됨

