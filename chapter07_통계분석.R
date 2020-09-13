################################
## 01. 난수 생성 및 분포 함수 ##
################################

# 난수 발생 함수
# 함수들의 인자는 난수의 개수와 해당 분포들의 파라미터
rbinom # 이항 분포
rf     # F 분포
rgeom  # 기하 분포
rhyper # 음이항 분포
rnorm  # 정규 분포
rpois  # 포아송 분포
rt     # t분포
runif  # 연속 균등 분포

# 표본이 100개인 평균이 1이고 분산이 1인 정규분포 난수 생성
nrom_data <- data.frame(x = rnorm(100, 0, 1))
ggplot(data = nrom_data, aes(x = x)) + geom_density(fill = 'red', alpha = 0.5) 

# 확률 밀도 함수
# 확률 밀도 함수 또는 확률 질량 함수는 앞에 d를 붙임
dnorm(x = 3, mean = 1, sd = 1)

# 분포 함수
# p = F(x) 에서 x 일때의 p 값을 구해줌
pnorm(3, 1, 1)


# 분위수 함수
# p = F(x) 일 때의 x 값을 계산 해줌
qnorm(p = 0.5, 1, 1)
#####################
## 02. 기초 통계량 ##
#####################
## 표본 평균, 표본 분산, 표본 표준 편차
## R에서 기본적으로 계산하는 분산과 표준 편차는 전체 데이터 중 일부를 샘플로 추출한 뒤 이에 대한
## 분산과 표준 편차를 계산하는 "표본 분산" 과 "표본 표준편차" 임
## 즉 분모로 나눠 주는 수가 전체 데이터(n) - 1 이라는 얘기

# 다섯 수치 요약 vs summary
# 1분위수, 3분위수 계산 방법이 다름
# fivenum : 중앙 값 기준으로 좌측 데이터의 중앙이 1분위 수, 우측 데이터의 중앙이 3분위 수
# summary : 다소 복잡한 방법을 이용하여 1분위수와 3분위수를 추정
x <- c(1,2,3,4)
fivenum(x)
summary(x)

# 최빈값
x <-factor(c('a', 'b', 'c', 'c', 'c', 'd','d'))
which.max(table(x))

###################
## 03. 표본 추출 ##
###################
# 단순 임의 추출
sample(
  x,     # 표본을 뽑을 데이터 벡터
  size,  # 표본의 크기
  replace = F, # 복원, 비복원 추출 여부
  prob = NULL  # 데이터가 뽑힐 가중치. ex) prob = c(2, 5, 3) 이면 표본이 뽑힐 확률이 20%, 50%, 30%
               # 일반적으로 size 옵션과 같이 쓰는데, size는 샘플 갯수를 말함
)

sample(1:10, 5)
sample(1:5,  3, replace = T)

# 층화 추출
sampling::strata(
  data,  # data.frame 또는 vector
  stratanames = NULL, # 층화 추출에 사용할 변수들, 다수의 층을 적용할 수 있음
  size, # 각 층의 크기
  # method는 데이터를 추출하는 방법으로, 다음 4가지 중 하나로 지정한다
  # - srswor   : 비복원 단순 임의 추출
  # - srswr    : 복원 단순 임의 추출
  # - poisson  : 포아송 추출
  # - sysmatic : 계통 추출
  pik, # 각 데이터를 표본에 포함할 확률
  description = F # T면 표본의 크기와 모집단의 크기를 출력
)

# 해당 표본 dataFrame을 기준으로 실제 데이터를 sampling 해오는 함수
sampling::getdata(
  data,
  m  # 선택된 유닛에 대한 벡터 또는 표본 데이터 프레임
)

# 계통 추출
# 데이터가 sequential 하게 나열되어 있다면 계통 추출이 더 좋은 효과를 가져올 수 있음
# but 데이터가 주기성을 가지고 있다면 절대로 계통 추출로서는 추출해서는 안됨
doBy::sampleBy(
  formula,
  frac = 0.1,
  replace = F,
  data = parent.frame(), 
  systematic = F
)

x <- data.frame(x = 1:10)
doBy::sampleBy(~1, frac = 0.3, data = x, systematic = T)

################
## 04. 분할표 ##
################
# 분할표는 명목형, 순서형 데이터의 도수를 표 형태로 나타낸 것
# 분할표가 작성되면 카이 제곱 검정으로 변수간의 의존 관계가 있는지를 독립성 검정으로,
# 도수가 특정 분포를 따르는지를 적합도 검정으로 살펴 볼 수 있음

# 분할표 작성
# 1. table
table(c("a", "a", "b", "b", "b", "c"))

xtabs(
  formula, # L1 ~ R1 + R2 + R3 형태의 포뮬러. R1, R2, R3 등은 분할표의 분류를 나타내고
           # L1는 빈도를 나타내는 변수를 나타낼 수 있음
  data 
)

d <- data.frame(x = c('1', '2', '2', '1'),
                y = c('A', 'B', 'A', 'B'),
                num = c(3, 5, 7, 9))

dt <- xtabs(formula = num ~ x + y,
      data = d)

xtabs(~ y, data = d)

# Margin Table
margin.table(
  x, # 배열
  # 색인 번호. 1은 행 방향, 2는 열방향, NULL은 전체 합
  margin = NULL
)

# 분할표의 주변 비율을 구해줌
prop.table(
  x,
  margin = NULL
)

margin.table(dt, 1)
margin.table(dt, 2)
margin.table(dt)

prop.table(dt, 1) # xt의 각 행의 합으로 값을 나눈 값
prop.table(dt, 2) # xt의 각 열의 합으로 값을 나눈 값 
prop.table(dt)    # xt 전체 합에서 각 값을 나눈 값

# 2. 독립성 검정 해보기
# 분할표의 행에 나열된 변수와 열에 나열된 변수가 독립인지 검정
# P(i, j) = P(i) * P(j) 이 성립하는지를 보는 것
# 카이제곱검정을 통해 확인한다
chisq.test(
  x,        # 숫자 백터 또는 행렬, 또는 x와 y가 모두 백터
  y=NULL,   # x가 분할표인 경우는 무시. x가 factor인 경우, y도 factor
  p=rep(1/length(x), length(x)) # x와 같은 길이를 가질 확률. 이 값의 비율이 이 확률과 같은지 테스트
                                # 이 값이 지정되지 않으면 확률이 서로 같은지 테스트
)

library(MASS)
data(survey)
str(survey)

# Sex  : 성별(Male, Female)
# Exer : 운동여부(None, Some, Freq)
head(survey[,c('Sex', 'Exer')])
xt <- xtabs(~ Sex + Exer, data = survey[,c('Sex', 'Exer')])

chisq.test(xt) 

# 결과 해석
# p-value 값이 0.05보다 크므로, 귀무 가설을 채택하여 성별과 운동은 독립이다를 기각함

## 3. 피셔의 정확 검정
# 표본 수가 적을 때 피셔의 정확 검정을 사용하는데,
# 적다는 의미는 애매하지만 일반적으로 전체 셀중 20%가 빈도수가 5 이하일 때를 의미

# R에서 카이제곱 검정을 사용할 때 빈도수가 적으면
# 경고 메세지를 출력해준다. 따라서 그러한 경우에는 피셔의 정확 검정을 사용한다

## * survey data중 손 글씨를 어느 손으로 쓰는지와 박수를 칠 때 어느 손이 위로 가는지 사이의 경우에 대해
#  피셔의 정확 검정을 수행해보자

xt <- xtabs(~ W.Hnd + Clap, data = survey)
chisq.test(xt)  # 정확하지 않을 수도 있다라고 경고 메세지 출력
fisher.test(xt) 
# 결과 해석
# p-value가 매우 작으므로, 둘 사이의 관계가 있다는 대립가설을 채택

## 4. 맥니마의 검정
# 응답자의 성향이 사건 전후로 어떻게 달라지는지를 알아보는 경우 해당 검정 사용
# ex) 벌금을 부과하기 전후 안전벨트 착용자의 수, 선거 유세를 하고 난 뒤 지지율의 변화

# 사건 발생 전 설문 결과 --> Test1
# 사건 발생 후 설문 결과 --> Test2

#              Test 2 양성 , Test 2 음성
# Test 1 양성       a            b        = a + b
# Test 1 음성       c            d        = c + d
#                 a + c        b + d 

# 사건 전후에 변화가 없다면, Test 1 의 양성과 Test 2 의 양성이 변화가 없어야 함
# --> a + c = a + b
# --> c = b 이 성립 해야함
#     즉, b, c의 값이 b + c의 절반씩 되어야 하므로 b는 이항 분포를 따름
# b ~ B(b + c, 1/2)

# 즉 두가지 방법을 사용해 검정이 가능하다.
#  1. mcnemar.test
#  2. binom.test
mcnemar.test(
  x,         # 행렬 형태의 이차원 분할표 또는 백터 
  y=NULL,    # factor, x가 행렬일 경우 무시
  correct=T  # 연속성 수정 적용 여부
)

binom.test(
  x, # 성공의 수
  n, # 시행 횟수
  p=0.5, # 성공 확률에 대한 가설
  alternative=c('two.sided', 'less', 'greater') # 대립 가설의 형태, 기본값은 양측 검정
)

# 맥니마 검정 예시
# 2 x 2 분할표에서 맥니마 검정을 사용하는 예
# 사용된 데이터는 투표권이 있는 나이의 미국인 1,600명에 대해 대통령 지지율을 조사한 것으로
# 1차 조사(1st Survey)와 2차 조사(2nd Survey)는 한 달 간격으로 수행
Performance <- matrix(c(794, 86, 150, 570),
                      nrow = 2,
                      dimnames= list("1st Survey"= c("Approve", "Disapprove"), 
                                     "2nd Survey"= c("Approve", "Disapprove")))

mcnemar.test(Performance)
# 결과 해석
# p-value가 매우 작아, 비율에 차이가 발생했음을 알 수 있음

# 이항 분포 검정으로도 확인 가능하다.
# 즉, Disapprove/Approve <--> Approve/Disapprove 간의 비교를 하면 된다

binom.test(86, 86 + 150, 0.5)
# p-value가 매우 작은 것으로 보아, 절반이라는 귀무 가설을 기각

#####################
## 05. 적합도 검정 ##
#####################
# 적합도 검정은 해당 데이터가 특정 분포를 따르는지를 검정하는 기법을 말함

# 1. 카이제곱 검정
# 독립성 검정과는 달리, 비교하고자 하는 분포로부터 계산
# ex) 글씨를 왼손으로 쓰는 사람과 오른손으로 쓰는 사람의 비율이 30% :70%인지 여부를 분석하는 경우,

xt <- table(survey$W.Hnd)
chisq.test(xt)
# p-value가 0.05보다 작으므로, 글씨를 왼손으로 쓰는 사람과 오른손으로 쓰는 사람의 비가
# 30% : 70% 라는 귀무가설을 기각

# 2. shapiro.wilk 검정
# 정규성을 따르는지 검정
# 이 때 귀무가설은 정규 분포로부터의 표본이라는 것! ( 조심 )
shapiro.test(
  x # 숫자 백터
)

# 3. 콜모고로프 스미르노프 검정
# 데이터의 누적 분포 함수와 비교하고자 하는 분포의 누적 분포 함수간의 최대 거리를 통계량으로 사용하는 가설 검정 방법
ks.test(
  x, # 숫자 벡터
  y, # 숫자 벡터 또는 누적 분포 함수(예를 들어 pnorm)
  ..., # y에 지정한 누적 분포 함수에 넘겨줄 파라미터
  alternative = c("two.sided", "less", "greater") # 대립가설
)

# 예시1. 두 정규분포를 따르는 나누 데이터 간의 분포가 동일한지를 확인
ks.test(rnorm(100), rnorm(100))
# p-value > 0.05 이므로, 두 난수가 같은 분포


# 예시2. 데이터가 평균 0, 분산이 1인 정규 분포로부터 뽑은 표본인지 확인
ks.test(rnorm(100), "pnorm", 0, 1)
# p-value > 0.05 이므로, 평균이 0, 분산이 1인 정규분포로부터 추출

# 4. Q-Q plot
# 데이터가 특정 분포를 따르는지 시각적으로 검토하는 방법
# 여기서 Q는 quantile을 의미
# 즉 Q-Q plot은 비교하고자 하는 분포의 분위수끼리 좌표 평면에 표시하여 그린 그림
# 직선 관계가 보이면, 정규성을 따름
# (X(실제 검증할 데이터), Z(N(0, 1)에서 %에서의 Z 값))

# qqnorm : 주어진 데이터와 정규 확률 분포를 비교하는 Q-Q 도를 그림
qqnorm(x)  

# qqplot : 두 데이터 셋에 대한 Q-Q도를 그림
qqplot(x,y) 

# qqline : 데이터와 분포를 비교해 이론적으로 성립해야 하는 직선 관계를 그림
qqline(
  y,
  distribution = qnorm # 이론적 분포에 대한 quantile 함수
)

###################
## 06. 상관 분석 ##
###################
# 상관 분석은 두 확률 변수 사이의 관련성을 파악하는 방법
# - 피어슨 상관계수
# - 스피어만 상관계수
# - 켄달의 순위 상관 계수
# 등이 존재

# 1. 피어슨 상관계수
# 두 변수간의 선형적 상관관계를 측정

# 1.1 피어슨 상관계수 식
# low(X, Y) = cov(X, Y) / sigma(X) * sigma(Y)

# ** 공분산
# 두 확률 변수가 얼마나 함께 변하는지 측정
# 한 변수가 커질 때, 다른 변수가 함께 커지거나, 
# 한 변수가 작아질 때, 다른 변수가 작아지거나 크기 변화의 방향이 같다면 공분산은 양의 값을 가짐
# 한 변수가 작아질 때 다른변수가 커진다면 공분산은 음의 값을 가짐
# 두 변수가 관계가 없다면 공분산은 0을 가짐

cov(1:5, 2:6)

# 1.2 상관 계수 구하기
cor(
  x,         # 숫자 벡터, 행렬, 데이터 프레임
  y = NULL,  # NULL, 백터, 행렬 또는 dataframe 
  # 계산할 상관 계수의 종류를 지정함. pearson, kendall, spearman을 지정할 수 있으며, 기본값은 피어슨
  method = c('pearson', 'kendall', 'spearman')
)

# ** 숫자를 심볼로 표현
symnum(
  x     # 숫자 또는 논릿값의 벡터, 배열
)
# 반환 값은 숫자를 심볼로 표현한 값. 
# x가 숫자인 경우 0.3, 0.6, 0.8, 0.9, 0.95 기준으로 숫자들을 공백, 마침표(.), 쉼표(,), 더하기(+),
# 별표(*), B(B)로 대체해 보여줌

# 1.3 상관 계수 행렬 시각화
corrgram::corrgram(
  x, # 한 행에 한 관측값들이 저장된 데이터 프레임 또는 상관 계수 행렬
  type = NULL, # x가 데이터일 때 data, 상관 계수일 때 cor를 지정
  # 그러나 대부분의 경우 지정하지 않아도 잘 동작
  # panel에는 각 셀을 표현할 패널, lower.panel, upper.panel은 우측 상단과 좌측 상단에 그릴 패널
  # diag.panel, text.panel에는 대각선에 그릴 패널과 문자열 패널을 지정함
  # 대각선 외에 패널에는 panel.pts, panel.pie, panel.shade, panel.bar, panel.ellipse, panel.conf를 지정 할 있으며,
  # 대각선 방향의 패널에는 panel.txt, panel.minmax, panel.density를 지정할 수 있음
  # 이들 각각은 패널에 어떤 값들을 보여줄지를 의미함
  # 예를 들어 panel.conf는 값의 신뢰구간을 보여줌
  panel = panel.shade,
  lower.panel = panel,
  upper.panel = panel,
  diag.panel =  NULL,
  text.panel = textPanel
)

cor(iris$Sepal.Width, iris$Sepal.Length)

cor(iris[,1:4])

# 숫자가 한눈에 안들어 오는 경우, symnum 사용
symnum(cor(iris[,1:4]))

# 상관계수 시각화
install.packages("corrgram")
library(corrgram)
corrgram(iris,
         upper.panel = panel.conf,
         lower.panel = panel.pts)

# 2. 스피어만 상관 계수
# 상관 계수를 계산할 두 데이터의 실제 값 대신 값의 순위를 사용해 상관 계수를 계산하는 방식
# 피어슨 상관계수와 달리 비선형 관계의 연관성을 파악할 수 있다는 장점이 있음
# 순서 적용만 가능하다면, 이산형,순서형 데이터에 적용이 가능
# 스피어만 상관 계수 계산시와 마찬가지로, cor() 함수 이용

m <- matrix(c(1:10, (1:10)^2), ncol = 2)
cor(m, method = 'spearman')

# 3. 켄달의 순위 상관 계수
# (X, Y) 형태의 순서쌍으로 데이터가 있을 때 xi < xj, yi < yj 또는 xi > xj, yi > yj 가 성립하면 부합,
# xi < xj, yi > yj 또는 xi > xj, yi < yj 일 때 비부합이라고 정의
# 즉 x가 커질 때 y도 커지면 부합, x가 커질 때 y가 작아지면 비부합이라고 봄

# 상관 계수가 1이면 부합 데이터쌍의 비율이 100%, 
# 상관 계수가 -1이면 비부합 데이터쌍의 비율이 100% 를 의미

cor(c(1, 2, 3, 4, 5), c(1, 0, 3, 4, 5), method = 'kendall')

# 4. 상관 계수에 대한 가설 검정
# p-value가 0.05보다 작으면 통계적으로 유의(상관계수가 0이 아님)
cor.test(
  x, # 숫자 벡터
  y, # 숫자 벡터
  alternative = c("two.sided", "less", "grater"), # 대립가설
  method = c('pearson', 'kendall', 'spearman')    #  상관 계수의 종류, 기본값은 피어슨
)

# 5. Tip
# 세가지 상관계수 값은 서로 다른 값이 될 수 있음
# 이런 경우 더 작은 숫자를 사용하는 것이 바람직함
# 또는 세가지 값이 계산하는 것이 무엇인지 알고 데이터의 성격에 비추어 올바른 상관계수를 찾아 사용

######################
## 07. 추정 및 검정 ##
###################### 

################## 
# 1. 일표본 평균 #
# 하나의 모집단으로부터 표본을 추출하고
# 표본으로부터 모집단 평균의 신뢰 구간을 구하는 방법

# 가정
# - 확률 변수는 서로 독립
# - 확률 변수는 정규 분포를 따름

# 일표본 평균의 구간 추정 및 가설 검정에는 t-test() 를 사용
# t 검정 수행. 귀무가설은 '모평균이 Mu와 같다'임

t.test(
  # 일표본 검정인 경우에는 x, 이표본 t 검정의 경우 x,y 모두에 숫자 벡터 지정
  x,
  y = NULL,
  alternative = c("two.sided", "less", "greater"),
  mu = 0,        # 모집단의 평균
  paired    = F, # paired 여부
  var.equal = F, # 이표본 검정에서 두 집단의 분산이 같은지 여부
  conf.level = 0.95 # 신뢰 구간
)

t.test(
  formula, # lhs ~ rhs 형태로 쓰며, lhs : 검정에 사용할 값,rhs 두 개의 그룹을 뜻하는 팩터
  data    
)

x <- rnorm(30)
t.test(x)

x <- rnorm(30, mean = 10)
t.test(x, mu = 10)
#######################
# 2. 독립 이표본 평균 #
# 두 모집단에서 각각 표본을 추출한 뒤, 표본으로부터 두 모집단의 평균이 같은지 알아보는 내용을 다룸

# sleep data 
# extra : 수면 시간 증가량
# group : 사용한 약물의 종류
# ID    : 환자 식별 번호

sleep2 <- sleep[, -3]

# 수면제별 수면 시간 증가량 평균 계산
library(dplyr)
sleep2 %>% group_by(group) %>% summarise_all(list(mean = ~ mean(., na.rm = T)))

# 등분산 검정
var.test(extra ~ group, sleep2)
# p-value > 0.05 이므로, 두 그룹별 데이터의 등분산 비가 1 임을 채택함

# 등분산일 때, t.test 검정
t.test(extra ~ group, data = sleep2, paired = F, val.equal = T)
# p-value > 0.05 이므로 차이가 없음

#########################
# 3. 짝지은 이표본 평균 #
t.test(extra ~ group, data = sleep2, paired = T, val.equal = T)

##################
# 4. 이표본 분산 #
##################
var.test(
  x,
  y,
  ratio = 1, # 분산 비에 대한 가설
  alternative = c("two.sided", "less", "greater")
)

var.test(
  formula,
  data
)

##################
# 5. 일표본 비율 #
##################
# 모집단에서 표본을 추출하여 그 표본에서 계산한 비로부터 모집단의 비를 추정 및 가설 검정하는 내용
# ex) 국민 투표로 찬반 투표 실시할 때, 찬성과 반대의 비율 추정

# - 이항 분포의 정규 분포 근사를 사용할 경우,
prop.test()

# - 이항 분포 그대로 사용할 경우,
binom.test()

##################
# 6. 이표본 비율 #
##################
prop.test(c(45, 55), c(100, 90))



