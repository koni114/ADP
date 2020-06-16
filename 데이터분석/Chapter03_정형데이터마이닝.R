# 정형 데이터 마이닝
########################
##### 로지스틱 회귀#####
########################

data(iris)
# a <- subset(iris, Species = "setosa" | Species == "versicolor")
iris$Species <- factor(iris$Species)

b <- glm(Species ~ Sepal.Length, data = iris, family = binomial)
  ``
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

# 로지스틱 회귀 분석 같은 경우도  step function을 사용하여 변수선택법 적용 가능
# default : backward

#####################################
##### 신경망 모형 - 단층 신경 망#####
#####################################
library(nnet)
nn.iris <- nnet(Species ~., data = iris, size = 2, rang = 0.1, decay = 5e-4, maxit = 200)
summary(nn.iris) # 연결선에 대한 가중치

# nnet plot 생성
install.packages("devtools")
library(devtools)
source_url('https://gist.githubusercontent.com/Peque/41a9e20d6687f2f3108d/raw/85e14f3a292e126f1454864427e3a189c2fe33f3/nnet_plot_update.r')
plot.nnet(nn.iris)

# nnet plot 생성 2번째 방법
library(clusterGeneration)
library(scales)
library(reshape)

plot(nn.iris)

## neuralNet function을 이용한 신경망 모형 생성
# 자연유산과 인공유산 후의 불임에 대한 사례-대조 연구 자료로 8개의 변수와 248개의 관측치 
data(infert, package = "datasets")
str(infert)

library(neuralnet)
net.infert <- neuralnet::neuralnet(case ~ age + parity + induced + spontaneous
                                   , data    = infert
                                   , hidden  = 2
                                   , err.fct = "ce"
                                   , linear.output = F
                                   , likelihood    = T)

net.infert
plot(net.infert)

# 원 자료와 함께 적합 값을 출력하는 방법
out           <- cbind(net.infert$covariate, net.infert$net.result[[1]])
dimnames(out) <- list(NULL, c("age", "parity", "induced", "spontaneous", "nn-output"))

# 가중치의 초기값과 적합값 은 startweights, weights에 제공되며, 적합값의 출력 결과는 위의 그림과 동일함을 확인할 수 있음
net.infert$startweights
net.infert$weights

# generalized.weights 가 제시하는 일반화 가중치는 각 공변량들의 효과를 나타내는 것
# 로지스틱 회귀모형에서의 회귀계수와 유사하게 해석(각 공변량이 로그-오즈에 미치는 기여도를 나타냄)
# 로지스틱회귀와는 달리 일반화가중치는 다른 모든 공변량에 의존하므로 각 자료점에서 국소적인 기여도를 나타냄
# ex) 동일한 변수가 몇몇 관측치에 대해서는 양의 영향을 가지며, 몇몇 관측치에서는 음의 영향을, 어떤 관측치에서는 0을 나타냄

# 모든 자료에 대한 일반화 가중치의 분포는 특정 공변량의 효과가 선형적인지의 여부를 나타냄
# 즉 작은 분산은 선형효과를 제시, 큰 분산은 관측치 공간상에서 변화가 심하다는 것을 나타내므로 비-선형적인 효과가 있음을 나타냄
# ** 모형의 단순화를 위해 분산이 전반적으로 큰 변수를 선택할 수 있음!!!

# compute function은 각 뉴련의 출력값을 계산
# 이를 이용하여 새로운 공변량 조합에 대한 예측값도 구할 수 있음

# ex)  age = 22, parity = 1, induced <= 1, spontaneous <= 1
library(dplyr)
new.output <- neuralnet::compute(net.infert,
                      covariate = matrix(c(22, 1, 0, 0,
                                           22, 1, 1, 0,
                                           22, 1, 0, 1,
                                           22, 1, 1, 1), byrow = T, ncol = 4))

new.output$net.result # 공변량 예측 결과
# 사전 낙태의 수에 따라 예측 확률이 증가함을 보여줌

# 신경망모형에서 가중치들에 대한 신뢰구간 --> confidence.interval() 를 통해 구할 수 있음


#####################################
##### 신경망 모형 - 다층 신경 망#####
#####################################

# threshold 옵션은 오차함수의 편미분에 대한 값으로, 정지 규칙(stopping rule)으로 사용
# hidden = c(10, 8) 2개의 hidden 노드 --> node 수 10, 8개로 setting

########################
##### 의사결정모형 #####
########################
# rpart.plot을 이용하여 의사결정나무 모형을 여러가지방식으로 시각화 가능
library(rpart.plot)
prp(c, type = 4, extra = 2)

# rpart 수행 결과 제공 정보
# cptable : 트리의 크기에 따른 비용-복잡도 모수(cost-complexity parameter) 및 교차타당성오차 제공
# 교차타당성오차는 가지치기와 트리의 최대 크기를 조절하기위한 옵션으로 사용

########################
##### 앙상블 모형 ######
########################
install.packages("adabag")
library(adabag)

data(iris)

# adabag 의 bagging 함수는 베깅을 이용하여 분류 수행
iris.bagging <- bagging(Species ~., data = iris, mfinal = 10)
iris.bagging$importance

# predict 함수를 통해 예측 가능
pred <- predict(iris.bagging, newdata = iris)
table(pred$class, iris[, 5])

# adabag의 boosting 함수 사용 예제
library(adabag)
data(iris)
boo.adabag <- boosting(Species ~., data = iris, boos = T, mfinal = 10)
boo.adabag$importance

# ada 의 ada 함수를 이용하여 아다부스팅을 이용한 분류 수행 예제
# plot()    : 오차와 일치도를 나타내는 카파(Kappa) 계수를 그려줌, 뒤에 두 개의 TRUE 옵션은 훈련용, 검증용 자료 모두에 대해 그림을 그려줌
# varplot() : 변수의 중요도
# pairs()   : 두 예측변수의 조합별로 분류된 결과를 보여줌 maxvar = 옵션을 통해 변수의 수를 지정 가능

########################
##### 랜덤포레스트 #####
########################

# importance(), varImpPlot()로 변수의 중요성을 알 수 있음
# importance : 해당 변수로부터 분할이 일어날 때 불순도의 감소가 얼마나 일어나는지를 나타내는 값
# plot(margin(rf)) : 랜덤포레스트 분류기 가운데 정분류를 수행한 비율에서 다른 클래스로 분류한 비율의 최대치를 뺀 값
# 즉 (+) margin은 정확한 분류를 의미하며, (-)은 그 반대

#####################
##### 군집 분석 #####
#####################
data(USArrests)
str(USArrests)

d   <- dist(USArrests, method = "euclidean")
fit <- hclust(d, method = "ave")

# plot 함수를 통해 dendrogram 시각화
par(mfrow = c(1,2))
plot(fit)
plot(fit, hang = -1)
par(mfrow = c(1,1))

# cutree()는 계층적군집의 결과를 이용하여 tree의 높이(h)나 그룹의 수(k)를 옵션으로 지정하여 
# 원하는 그룹으로 나눌 수 있음
groups <- cutree(fit, k = 6)

# rect.hclust function을 이용하여 각각의 그룹 사각형으로 구분지어 나타낼 수 있음
plot(fit)
rect.hclust(fit, k = 6, border = 'red')
rect.hclust(fit, h = 50,which = c(2, 4), border = 3:4) # 높이와 위치(which)를 이용하여 그룹의 전체 또는 일부를 나타낼 수 있음

# cluster - agnes() : 계층적 군집방법 중 병합적 방법 사용
# daisy function을 이용하여 거리를 계산할 수 있음
# daisy 함수는 수치형 뿐만 아니라 다른 형의 거리도 계산해줌

library(cluster)
agn1 <- agnes(USArrests, metric = "manhattan", stand = T)
agn1
par(mfrow=c(1,2))
plot(agn1)

# k-means
# wsplot 을 이용하여 적절한 군집 수 확인. 그 전에 표준화를 계산해주는 것이 중요.
# Nbclust를 이용하여 최적의 군집 수도 계산 가능
# $Best 확인
library(rattle)
library(NbClust)
data(wine, pakage = "rattle")
head(wine)
df <- scale(wine[-1])
nb <- NbClust(df, min.nc = 2, max.nc = 15, method = "kmeans")
table(nb$Best.nc[1,])

# 군집의 수를 3으로 하여 kmeans 수행
fit.km <- kmeans(df, 3, nstart = 25)
fit.km$size

fit.km$centers

# flexclust 의 kcca 함수는 k-중심군집(k-centroids)을 수행
# cluster의 clusplot 함수는 2차원의 군집 그래프를 그려주는 함수

# k-means clustering 을 수행하는 R 함수에는 kmeans(stats), kcca(flexclust), cclust(flexclust),  cclust(cclust), Kmeans(amap) 등이 있음
# k-centroid clustering은 pam을 통해 수행


# mixture distribution clustering
# mixtools 의 normalmixEM()을 통해 혼합분포군집을 수행한 예제
# Mclust 함수를 통한 군집 분석 수행


# SOM(Self-Orgamizing Maps)
# R에서 SOM 알고리즘을 이용한 군집분석

# som function
# parameter
# data : SOM 분석을 수행하기 위한 입력 데이터
# grid : 결과를 나타내기 위한 그리드
# rlen : 학습 횟수
# alpha : 학습률. default : 0.05. 0.01에서 정지
# radius : 이웃의 초기 반경
# toroidal : T 일 경우, 맵에 엣지가 조인됨
# keep.data : 반환데이터 저장

# Value
# grid : somegrid 클래스의 오브젝트
# changes : 코드벡터로부터 평균편차의 벡터
# codes : 코드 벡터 메트릭스
# classif : 승자 유니트
# toroidal : 맵 사용 여부
#  data : 데이터 매트릭스

# **
# kohonen에서 제공하고 있는 wines 데이터를 활용한 SOM 군집 분석 예제
install.packages("kohonen")
library(kohonen)
data("wines")
head(wines)

# 5 x 4 SOM 군집 분석 수행

wines.sc <- scale(wines)
set.seed(7)
wine.som <- som(  data = wines.sc
                , grid = somgrid(5, 4, "hexagonal")
                , rlen = 100
                , alpha = c(0.05, 0.01)
                , toroidal = F
                , keep.data = T)
plot(wine.som , main = "Wine data")

#####################
##### 연관 분석 #####
#####################
# arules package 에 있는 Adult 데이터 사용
# 연소득이 5만달러 이상인지, 미만인지 예측하기 위한 트랜잭션 형태의 미국 센서스 데이터
# install.packages("arules")

library(arules)
data("Adult")

# as 함수를 사용항 transaction -> data.frame 형태로 변환하여 확인 가능
Adult.df <- as(Adult, "data.frame")
head(Adult.df)

rules <- apriori(Adult)

# inspect 함수 사용시 apriori 함수를 통해 발굴된 규칙을 보여줌
inspect(rules)

# 지지도와 신뢰도 값을 지정하여 좀 더 유의미한 결과가 나올 수 있도록 함
# rhs를 income 변수에 대햇  small인지, large인지 대한 규칙만 나올 수 있도록 하여 income 변수에 대한 연관 규칙만 출력
adult.rules <- apriori(Adult
                 , parameter = list(support = 0.1, confidence = 0.6)
                 , appearance = list(rhs=c('income=small','income=large'), default = 'lhs')
                 , control = list(verbose = F))

adult.rules.sorted <- sort(adult.rules, by = 'lift')     
inspect(head(adult.rules.sorted))

# 연관규칙 시각화
install.packages("arulesViz")
library(arulesViz)

plot(adult.rules.sorted, method = "graph", control = list(type = 'items', alpha = 0.5)) # 연관규칙 관계도..
