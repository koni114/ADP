################
## ANOVA 분석 ##
################

# 2. ANOVA -> aov 내장 함수 이용
f <- paste0(sYvar, " ~ ", sXvar)
AOV <- aov(eval(parse(text = f)), data = df)

SUM.AOV <- summary(AOV)[[1]]
rowNames.AOV <- rownames(SUM.AOV)
rowNames.AOV <- rownames(SUM.AOV)[-grep('Residuals', rowNames.AOV)]

AOV.PVALUE <- SUM.AOV$`Pr(>F)`
AOV.PVALUE <- subset(AOV.PVALUE, !is.na(AOV.PVALUE))

P_VALUE.Mark <- ifelse(AOV.PVALUE < 0.01,"***"
                       ,ifelse(AOV.PVALUE < 0.03,"**"
                               ,ifelse(AOV.PVALUE < 0.05,"*","")))


cutOff_check <- ifelse(AOV.PVALUE <= cutOff,"YES", "") # cutoff check

DF.P_VALUE <- data.frame(
    "요인"     = rowNames.AOV
  , "변수명"   = Yvar
  , "P_Value"  = AOV.PVALUE
  , "유의수준" = P_VALUE.Mark
  , "영향인자" = cutOff_check
)


# 이분산 모수 검정 -> 이표본 이분산 검정일 때 사용
# 1. Welch's ANOVA
# 사용 조건
# - 자료는 모두 동일 간격을 가진 연속형 수치치어야만 한다
# - 두 집단은 서로 독립적 이어야 한다
# - 자료의 수치는 정규성을 가져야 한다
# - 두 집단 각각에서 추정된 분산이 다르다
# - 우리가 사용하는 흔히 사용하는 Tukey, Duncan, Scheffe 의 사후분석은 등분산을 만족하는 경우에 쓰일 수 있는 방법
# -> 등분산을 가정하지 않는 경우에도 사후 분석이 가능한데, 보편적으로 Games-Howell 이 많이 사용된다.

install.packages("onewaytests")
library(onewaytests)

welchTest <- welch.test(Sepal.Length ~ Species, data = iris)
welch.pValue <- welchTest$p.value

# 2. Brown Forsythe test
bfTest <- bf.test(Sepal.Length ~ Species, data = df, alpha = 0.5, na.rm = T)
bfTest$formula
bfTest.pValue <- bfTest$p.value

# 일표본 Z검정, 일표본 T검정 -> 1표본 Wilcoxon검정
# 2표본 t검정                -> Mann-Whitney 검정
# 분산 분석 검정             -> Kruskal-Wallis 검정, Mood의 중위수 검정, Friedman 검정

# 비모수 검정
# 1. 일표본 Wilcoxon 검정(Wilcoxon signed-rank test)
# 자료의 순서를 이용하여 자료의 중위수가 0인지를 검정
# +, -의 부호를 무시하고 절대값으로 순위를 구한 후, 그 다음 절차는 순위에 "+" 와 "-" 를 부여
# 각 자료의 쌍은 부호화된 순위를 갖게 됨
# 이런 의미에서 Wilcoxon 검정은 Wilcoxon 부호 순위검정이라고 불리기도 함

# T-Test vs Wilcoxon Signed-Rank Test 
# 평균이 0인지를 검정하는 T-Test와는 달리, 순서를 사용하여 자료의 중위수가 0인지를 검정
# 양수("+")인 데이터의 수와 음수("-")인 데이터의 수가 같다면 중위수가 0이다

wilcoxTest <- wilcox.test(iris[,sYvar]
                          ,alternative = c("two.sided") 
                          ,mu = MU
                          ,conf.level = 0.95
)

wilcoxTest$p.value
names(wilcoxTest)

# 2. Wilcoxon rank sum test
# -> 두 집단 사이의 비모수 검정
wilcox.test(x, y
            , alternative = c("two.sided")
            , mu = 0
            , conf.int = F
            , conf.level = 0.95
)


# 3. Kruskal-Walis(클러스칼-왈리스)
# 독립된 세 군 이상의 크기를 비교하는 비모수적 방법
# 일종의 순위합 검정
# 자료들을 한데 모아 크기순으로 정렬한다음, 가장 작은 값부터 순위를 매겨 군 별로 순위합을 구함
# 크기가 차이가 없는 집단들이라면 순위합도 비슷할 것임. 본래 자료의 고유 값들은 순위만 남고 모두 상실되어
# 통계분석에 작용하지 않으므로, 두 군의 평균과 표준편차는 가설 검정에서 의미를 갖지 않음
# 분산분석의 기본 가정이 잘 만족할 Kruskal-Wallis test는 일원배치 분산분석에 비해 검정력이 다소 낮음
# 해당 그림 참조 : https://dermabae.tistory.com/168

kruskalTest <- kruskal.test(Sepal.Length ~ Species, data = iris) 
kruskalTest$p.value

# R package로 따로 사후분석은 제공 X



# 4. mood의 중위수 검정
# Kruskal-Walis 검정과 같이 일원배치 분산분석의 비모수적 방법
# 둘 이상의 모집단에서 얻은 중위수와 동일성을 검정하는데 사용
# 각 모집단으로부터 데이터가 독립적 랜덤표본이고 모집단의 분포 형태가 동일하다고 가정
# 특이치 및 오차에 대해 Robust하며 분석의 예비 단계에서 특히 적절
moodTest <- mood.test(iris[,c("Sepal.Width")] , iris[,c("Species")])



# eval - parse combo
# 문자형으로 이루어진 수식을 맥이고 싶을 때,
# ex) ANOVA 분석에서 문자형 수식을 넣어 돌리고 싶을 때,
f   <- paste0(Yvar, " ~ ", Fvar)
AOV <- aov(eval(parse(text = f)), data = df)
