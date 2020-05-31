## Chapter01. R기초와 데이터 마트

# 1. R 기초
#####################
## R의 데이터 구조 ##
#####################
# 벡터
# 벡터와 벡터 결합 가능
x <- c(1, 10, 24, 40)
y <- c("사과", "바나나", "오렌지")
xy <- c(x, y) # 문자 데이터로 인식함을 기억하자

# 행렬
mx <- matrix(c(1,2,3,4,5,6), ncol = 2)
my <- matrix(c(1,2,3,4,5,6), ncol = 2, byrow = T) # 행을 우선 채우고 싶을 때, byrow = T

# rbind, cbind를 이용해 벡터를 합칠 수 있음
# 데이터 타입이 같은 경우, 행렬의 형태로 합쳐 줌.
# 데이터 타입이 다른 경우, DF의 형태로 합쳐 줌.
r1 <- c(10, 20)
c1 <- c(10, 20, 30)
rbind(my, r1)
cbind(my, c1)

## 외부 데이터 불러오기
## csv file loading
# 1. read.table
# 경로에 \ 대신에 \\ 사용. 또는 / 사용
data <- read.table("c:\\caret/caret_package.csv", header = T, sep = ",")

# 2. read.csv
# read.table과 유사하고,  sep 명령어 필요 없음

# txt file loading
# read.table function을 이용하여 로딩 가능
# sep 옵션 사용 안하면 txt reading 가능

# 3. xls/xlsx 
# RODBC package 사용
library(RODBCDBI)
new      <- odbcConnectExcel("c:/data/myData") # excel file의 경로 입력. 확장자 생략
yourData <- sqlFetch(new, "Sheet1") # excel file의 워크시트 이름 입력


#####################
## R의 기초   함수 ##
#####################

# 수열 생성
rep(1, 3) # 1,1,1
seq(1, 3) # 1,2,3
1:3
seq(1, 11, by = 2) 
seq(1, 11, length = 6)
seq(1, 11, length = 8)
rep(2:5, 3)

# 기초적인 수치 계산
# 벡터의 사칙연산은 연산되는 벡터들의 길이가 같아야 함
a <- 1:10
a+a
a-a
a*a
a/a

# 행렬 곱 : %*%

a <- 1:3
b <- t(a)

A <- a %*% b

# 행렬의 역행렬 solve()
t <- matrix(c(23, 41, 12, 35, 67, 1, 24, 7, 53), nrow = 3)
inverse.t <- solve(t)

# 두 벡터에 대한 공분산, 상관계수 계산 가능
a <- 1:10
b <- log(a)
cov(a,b) # 공분산
cor(a,b) # 상관계수

######################
## R의 데이터 핸들링##
######################

# 1. 벡터
b <- c("a", "b", "c", "d" ,"e")
b[2]
b[ -4 ]
b[c(2,3)]
b[c(-2, -3)]

# 2. 행렬/데이터 프레임 형태의 변수
income <-   c(100, 200, 150, 300, 900)
car    <-   c('kia', 'hyundai', 'kia', 'toyota', 'lexus')
marriage <- c(F, F, F , T, T)
mydat    <- data.frame(income, car, marriage)

# 데이터 프레임은 행과 열을 모두 지정하여 특정 원소를 제외할 순 없음
mydat[,-2]
mydat[-3, -2] # 3행, 2열 없어짐

######################
## 반복 구문, 조건문 #
######################

# for 반복 구문
a <- c()
for (i in 1:9){
  a[ i ] <- i * i
}

# while 반복 구문
x <- 1
while(x < 5){
  x = x +1 
  print(x)
}

# 사용자 정의 함수

######################
## 기타 유용한 기능들#
######################

# paste, sep 를 이용하여 구분자를 삽입 가능
number = 1:10
alphabet = c("a", "b", "c")
paste(number, alphabet, sep = ",")

# substr : 시작 index가 1부터 ..
substr("BigDataAnalysis", 1, 4)

country <- c("korea", "Japan", "China", "Singapore", "Russia")
substr(country, 1, 4)

######################
## 자료형 데이터 변환#
######################

as.logical(c(0, 1, 9))

######################
## 문자형 -> 날짜형 ##
######################

# as.Date는 기본적으로 문자열이 yyyy-mm-dd 일 것이라 가정
# 그 외의 다른 형식을 처리하려면 format = 를 통해 입력되는 날짜 형식 지정
# ex) mm/dd/yy -> format = "%m/%d/%y" 로 변경 
Sys.Date()
as.Date("2020-04-12")
as.Date("01/13/2015", format = "%m/%d/%y")

######################
## 날짜형 -> 문자형 ##
######################

format(Sys.Date())
as.character(Sys.Date())

# format function을 이용하여 원하는 요일, 날짜 추출하기
format(Sys.Date(), "%a") # 요일 추출
format(Sys.Date(), "%b") # 월 추출
format(Sys.Date(), "%m") # 두자리 숫자 월
format(Sys.Date(), "%d") # 두자리 숫자 일
format(Sys.Date(), "%y") # 두자리 숫자 연도 출력
format(Sys.Date(), "%Y") # 네자리 숫자 된 연도 출력

######################
#### 그래픽 기능 #####
######################

# 1. 산점도 그래프
# pch : 그래프 상에 찍히는 점의 모양 변경
# bg  : iris 데이터의 Species 에 따라 서로 다른 색상
plot(x, y) # plot(y~x)
pairs(iris[1:4], main = "Anderson's Iris Data -- 3 Speices",
pch = 21, bg = c("red", "green3", "blue")[unclass(iris$Species)])

# 2. 히스토그램, 상자그림
StatScore <- c(88, 98, 70, 50, 60, 71)
hist(StatScore, prob = T) # prob를 이용하여 상대 도수 표시
boxplot(StatScore)

#####################
## reshape package ##
#####################

# install.packages("reshape")
library(reshape)
data("airquality")
head(airquality)

# column name을 소문자로 바꿔 속성에 다시 저장
#  "ozone"   "solar.r" "wind"    "temp"    "month"   "day"    
names(airquality) <- tolower(names(airquality))

# melt function : 기준 id : month, day로 지정
# 결측치 제거를 위하여 na.rm = T
aqm <- melt(airquality, id = c("month", "day"), na.rm = T)

# cast function 
# ~ 를 이용해 y ~ x 의 dimension 과 measure에 해당하는 variable 표시
a   <- cast(aqm, day ~ month ~ variable)

# y축은 month, x축은 variable 인데, ',' 로 구분한 다음 mean 함수를 적용
b <- cast(aqm, month ~ variable, mean)

# |를 이용해서 산출물을 분리해 표시
c <- cast(aqm, month ~ . |variable, mean)

# margin option. 행과 열에 대해 소계를 산출
d <- cast(aqm, month ~ variable, mean, margins = c("grand_row", "grand_col"))

# 모든 데이터를 처리하지 않고 특정 변수만 처리하고 하는 경우,
# subset 기능 이용

e <- cast(aqm, day ~ month, mean, subset = variable == 'ozone') 

# range -> min 은 _X1, max 는 _X2 라는 변수명으로 suffix를 붙여줌. 
# 매우 유용한 함수 중 하나
f <- cast(aqm, month ~ variable, range)

#####################
### sqldf package ###
#####################
# 표준 SQL에서 사용되는 문장이 모두 가능
# 데이터 이름에 "."같은 특수문자가 들어간 경우 ''로 묶어주면 테이블처럼 간단히 처리
install.packages("sqldf")
library(sqldf)

data(iris)
sqldf("select * from iris limit 10")

# like 문장 사용시 ''를 이용하면 됨
sqldf("select count(*) from iris where Species like 'se%' ")

# Mac 버전에서는 가끔 sqldf 가 문제가 있지만,
# 윈도우 버전에서는 편하게 사용 가능

#####################
#### plyr package ###
#####################
# apply 함수와 multi-core 사용 함수를 이용하면 for loop를 사용하지 않고 매우 간단하고 빠르게 처리
# plyr은 apply 함수에 기반해 데이터와 출력변수를 동시에 배열로 치환하여 처리하는 패키지
# ply() 함수는 앞 두 개의 문자를 접두사로 가짐.
# 첫 번째 문자는 입력하는 데이터 형태, 두 번째 문자는 출력하는 데이터 형태

# 입력되는 데이터 형태는 데이터 프레임, 리스트, 배열
# * runif(생성할 난수 개수, 최소값, 최대값)
set.seed(1)
d <- data.frame(year = rep(2012:2014, each = 6), count = round(runif(9,0,20)))

#  ddply 를 이용해 변동계수를 구하기
# 입력 변수는 data.frame의 1 row.
library(plyr)
ddply(d, "year", function(x){
  mean.count = mean(x$count)
  sd.count   = sd(x$count)
  cv         = sd.count / mean.count
  data.frame(cv.count = cv)
})

# transform, summarise 사용 예시
# summarise, transform 둘 다 집계 값을 계산해주는데, 
# summarise는 집계 변수만, transform은 기존 변수까지 data.frame에 포함 시켜줌

ddply(d, "year", summarise, mean.count = mean(count))
ddply(d, "year", transform, mean.count = mean(count))

# plotting : d_ply 명령문 사용 가능.
# 여러 개의 변수에 따라 데이터를 나눌 수 있음

###########################
#### data.table package ###
###########################

# data.frame과 유사하지만 빠른 grouping, ordering, 짧은 문장 지원
# 무조건 빠른 것은 아니며, 64bit 환경에서 RAM이 충분히 많을 때는 효율적.
library(data.table)
DT <- data.table(x = c("b", "b", "b", "a", "a"), v = rnorm(5))

# 데이터 프레임 형식의 객체를 데이터 테이블 형식으로 쉽게 변환
CARS <- data.table(cars)

# tables() 기능을 이용해 크기가 어떤지, key는 있는지, 용량은 얼마인지 확인 가능
tables()
sapply(CARS, class)

# data.table에 key 지정
setkey(DT, x)
DT # x에 의해 ordering
DT["b", ]
DT["b", mult = "first"]
DT["b", mult = "last" ]

# 성능 data.frame vs data.table
# 자료 찾기
# data.frame : 데이터를 메모리에서 검색해 빠르게 보여줬지만, 하나하나 모든 자료를 비교해 찾는 벡터 검색 방식
# data.table : index를 이용한 binary search 방식 이용하여 data.frame 보다 100배 성능이 빠름

# 결측값 처리와 이상값 탐색
# 1. 데이터 탐색
summary(iris)

# 2. 결측값 처리
# R에서의 결측값 처리 관련 패키지 : Amelia 2, Mice, mistools 등..
y <- c(1,2,3,NA)
is.na(y)


# '99'를 결측값으로 처리하기
mydata[mydata$v1 == 99, ] <- NA

x <- c(1,2,NA,4)
mean(x) # NA return
mean(x, na.rm = T)

# complete.cases 를 이용해 삭제.
mydata[!complete.cases(mydata),]

# Amelia 사용 예제
# 변수들 간의 관계를 이용해 imputation 계산 
#  m : 몇 개의 imputation 데이터 세트를 만들 것인지 결정하는 값
# ts : 시계열에 대한 정보
# cs : cross-sectional 분석에 포함될 정보

#install.packages("Amelia")
library(Amelia)
data(freetrade)
a.out <- amelia(freetrade, m = 5, ts = "year", cs = "country")
hist(a.out$imputations[[3]]$tariff, col = "grey", border = "white")

# imputation 을 하려면 imputation 값을 데이터세트에 사용


# 3. 이상값처리
install.packages("outliers")
library(outliers)
set.seed(1234)
y = rnorm(100)
outlier(y) # 평균과 가장 차이가 많이 나는 값 출력
outlier(y, opposite = T) # 반대방향으로 가장 차이가 많이 나는 값 출력
