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
