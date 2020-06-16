# 정형 데이터 마이닝
######################
##### 로지스틱 회귀###
######################

data(iris)
a <- subset(iris, Species = "setosa" | Species == "versicolor")
a$Species <- factor(a$Species)

b <- glm(Species ~ Sepal.Length, data = a, family = binomial)

summary(b)

# 해석 방법
# Sepal.Length 가 한 단위 증가 할때마다, Versicolor 일 오즈가 exp(5.140) = 170배 증가
# Null deviance는 절편만 포함하는 모형의 완전모형으로부터의 이탈도(deviance)를 나타냄
# 이는 p-값= P(chi^2(99) > 138.629) =. 0.005 으로 통계적으로 유의하므로 적합결여를 나타냄

# Residual deviance는 예측변수 Sepal.Length가 추가된 적합 모형의 이탈도를 나타냄
# Null deviance에 비해 자유도 1 기준에 이탈도의 감소가 74.4 정도의 큰 감소를 보이며,
# p-값 = P(chi^2(98) > 64.211) =~ 0.997 이므로 귀무가설이 기각되지 않으며 적합값이 관측된 자료를 잘 적합하고 있다고 말할 수 있음

coef(b)
exp(coef(b)["Sepal.Length"])

# 회귀 계수 beta와 오즈의 증가량 exp(beta)에 대한 신뢰구간은 다음과 같음
confint(b, parm = "Sepal.Length")
exp(confint(b, parm = "Sepal.Length"))

# fitted 함수를 통해 적합 결과를 확인할 수 있음 
fitted(b)

# predict 함수를 이용하여 새로운 자료에 대한 예측 수행
# 편의상 모형 구축에 사용된 자료를 다시 사용
predict(b, newdata = a[c(1, 50, 51, 100),], type = 'response')

# 로지스틱 회귀의 탐색적 분석 
cdplot(Species ~ Sepal.Length, data = a)

# 적합된 로지스틱회귀모형의 그래프는 다음과 같음
plot(a$Sepal.Length, a$Species, xlab = "Sepal.Length")
x = seq(min(a$Sepal.Length), max(a$Sepal.Length), 0.1)
lines(x, 1+(1/(1+(exp(-27.831 + 5.140*x)))), type = "l", col = "red")



