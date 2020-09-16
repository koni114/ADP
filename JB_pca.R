#########################
## 1. 주성분 분석(PCA) ##
#########################
# 차원 감소 기법 중 하나
# 선형적인 상관관계가 없는 다른 변수들로 재표현
# 주성분들은 원 데이터의 분산을 최대한 보존하는 방법으로 구함

# 1. princomp function
# 결과 중 scores는 주성분 점수를 의미
princomp(
  x,      # 행렬 또는 데이터 프레임
  cor = F # cor=F이면 공분산 행렬, T면 상관 행렬을 사용한 주성분 분석을 함
)

x    <- 1:10
y    <- x + runif(10, min = -.5, max = .5)
z    <- x + y + runif(10, min = -.10, max = .10)
data <- data.frame(x, y, z)
pr   <- princomp(data)

# 결과 해석
# Proportion of Variance : 원 데이터의 분산 중 얼마만큼의 설명해주는 지 확인
# Cumulative Proportion  : 데이터 분산의 누적 비율 
summary(pr)

# 두 주성분상의 좌표
# 1주성분, 2주성분을 사용하고 싶을 때
pr$scores[,c(1,2)]

# 2. prcomp function
# 위의 princomp function 과 동일한 기능을 수행
pc <- prcomp(iris[,-5], scale = T)

var       <- pc$sdev^2 #  주성분 분산
fitted.pc <- pc$x      # 주성분 값

pc.s <- summary(pc)

# 결과 해석
# 주성분 분산 표
# Proportion of Variance : 원 데이터의 분산 중 얼마만큼의 설명해주는 지 확인
# Cumulative Proportion  : 데이터 분산의 누적 비율 
pc.s$importance 

# 주성분 계수
# 해당 계수 값을 기반으로 주성분 변수로 값을 변환함
pc.s$rotation

# scree plot 
df_vars <- data.frame(x = 1:length(var), y = var)
p <- ggplot(df_vars, aes(x, y)) + geom_line(size = 0.1) + geom_point(size = 2) 
p <- p + geom_vline(xintercept = 2, linetype = 2, color = 'darkgrey') + scale_x_continuous(breaks = seq(from = min(df_vars$x), to = max(df_vars$x), by = 1))
p <- p + ggtitle('PCA Scree plot') + xlab('주성분') + ylab("분산")
p

# 주성분 분석 예측
predict(pc, newdata = iris[,-5])