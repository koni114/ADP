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

# 등분산 검정
# levene / Bartlett / F Test
# H0 : 등분산 만족
# H1 : 등분산 만족 X
# -> T-test와 다르므로, 주의!

# 1. levene's test(레빈)
# 등분산 가정을 검정하는 Test중 하나.
# 통계량 값이 F값인데, 혼동하지 말아야 할 것 중에 하나는
# p-value(유의확률)이 0.05보다 큰 경우 등분산이 가정됨
# t-test 같은 경우 0.05 보다 작아야 가설이 채택되는 것이랑 다르다!

# ** levene test 는 normal 분포에 덜 민감. 따라서 정규 분포를 따르는 경우에는 Bartlett test를 진

library(car)
data(iris)
levenTest    <- leveneTest(iris[,"Sepal.Length"], iris[,"Species"],  center = mean)
pValue       <- levenTest$`Pr(>F)`
levenePValue <- pValue[!is.na(pValue)]
cat("pValue :", levenePValue)         # 0.05 보다 훨씬 작으므로, 이분산


# 2. Bartlett’s test(바틀렛)
# ** 집단이 3개 이상인 경우 사용
# levene 검정과의 차이로는 정규성 가정이 만족한 집단들에 대한 등분산 검정으로, 
# 반드시 정규성 검정을 진행한 다음에 적용.
# but levene test는 정규성 가정 없이도 사용 가능

require(graphics)
plot(count ~ spray, data = InsectSprays)
bartlett.test(InsectSprays$count, InsectSprays$spray)

# 3. F-test
# 집단에 대한 F검정을 실시한다.
# 2-(1) 귀무가설이 기각되면 등분산 가정을 만족하지 못한다.
# 2-(2) 귀무가설이 기각되지 않으면 등분산 가정을 만족한다


a <- c(47.2,49.0,51.2,50.0,50.2,47.1,58.3,49.9,52.6)  # a 집단 설정
b <- c(51.2,49.4,52.1,54.0,52.6,53.2,52.2,47.2)       # b 집단 설정

varTest <- var.test(a,b,conf.level = 0.95)                       # 유의수준 5%에서 a,b 집단에 대한 F 검정
varTest$p.value

