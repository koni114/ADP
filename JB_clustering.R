####################
## 군집 분석 이론 ##
####################

## 군집 분석을 하라고 한다면, 다음과 같은 프로세스로 진행하여 반영하면 됨
# - 01. 어떤 군집 분석 기법을 선택할 것인가?
# - 02. 알맞은 속성 선택
# - 03. 데이터 표준화 및 encoding 수행 
# - 04. 이상치 선별(Screen for outliers)
# - 05. 거리의 계산 (Calcuate distance)
# - 06. 군집 알고리즘 선택
# - 07. 하나 이상의 군집분석 결과 얻음
# - 08. 군집의 갯수 결정
# - 09. 최종결과 획득
# - 10. 분석 결과의 시각화
# - 11. 군집 분석 결과의 해석

##############################################
## 01. 어떤 군집 분석 기법을 선택할 것인가? ##
##############################################

# 1). 계층적 군집 분석
# 2). 비계층적 군집 분석 ex) k-means

##########################
## 02. 알맞은 속성 선택 ##
##########################

# 데이터를 군집화 하는데 중요하다고 생각되는 속성들을 선택
# 예를 들어, 우울증에 대한 연구라면 다음과 같은 속성들을 선택할 수 있음
# --> 신과적 증상, 이학적증상, 발병나이, 우울증의 횟수, 지속기간, 빈도, 입원 횟수, 기능적 상태, 사회력 및 직업력, 현재 나이, 성별, 인종
#     사회경제적 상태, 결혼상태, 가족력, 과거 치료에 대한 반응 등.

########################################
## 03. 데이터 표준화 및 encoding 수행 ##
########################################

# 평균 0, 표준편차 1로 변경하는 정규화 수행
df1 <- apply(mydata, 2, function (x) {(scale(x))})
df1 <- apply(mydata, 2, function (x) {(x - mean(x))/sd(x)})

##########################################
## 04. 이상치 선별(Screen for outliers) ##
##########################################
# 많은 군집분석 기법 같은 경우, 이상치에 민감하기 때문에 이상치 처리를 필수적이게 해주어야 할 필요성이 있음
# 단변량 이상치의 경우, outlier   package 이용
# 다변량 이상치의 경우, mvoutlier package 이용
# 일반적으로 PAM 군집분석 방법을 사용하면 어느정도 강건한 군집모형 생성 가능

##########################################
## (5). 거리의 계산 (Calcuate distance) ##
##########################################
# default 거리의 계산은 유클리드 거리를 이용해서 계산함
#  “euclidean”, “maximum”, “manhattan”, “canberra”, “binary” 또는 “minkowski” 방법을 사용할 수가 있다. 

#############################
## (6). 군집 알고리즘 선택 ##
#############################
# 계층적군집(Hierarchical agglomerative clustering)은 150 관찰치 이하의 적은 데이타에 적합
# 분할군집은 보다 많은 데이타를 다룰 수 있으나 군집의 갯수를 정해주어야 한다.

# (7). 하나 이상의 군집분석 결과 얻음

# (8). 군집의 갯수 결정
# NbClust패키지의 NbClust()힘수를 사용

# (9). 최종결과 획득

# (10). 분석 결과의 시각화
# 계층적 분석은 dendrogram으로 나타내고 분할군집은 이변량 cluster plot으로 시각화

# (11). 군집 분석 결과의 해석

###############
## 거리 계산 ##
###############
data(nutrient,package="flexclust")
head(nutrient, 4)

# 거리 계산
d = dist(nutrient)
as.matrix(d)[1:4,1:4]

######################
## 계층적 군집 방법 ##
######################

# 1. 모든 관찰치를 군집으로 정의
# 2. 모든 군집에 대하여 다른 모든 군집과의 거리를 계산
# 3. 가장 작은 거리를 갖는 두 군집을 합해 하나의 군집으로 만든다. 따라서 군집의 갯수가 하나 감소
# 4. 2, 3번 반복하여 모든 관찰치가 하나의 군집으로 합쳐질 때 까지 반복

# 거리 계산 방법
# - single linkage   : 한 군집의 점과 다른 군집의 점 사이의 가장 짧은 거리
#                      긴 시가모양의 군집이 만들어지는 경향이 있으며 이러한 현상을 chaining이라고 함

# - complete linkage : 한 군집의 점과 다른 군집의 점 사이의 가장 긴 거리
#                      거의 비슷한 직경을 갖는 compact cluster를 만드는 경향이 있으며 이상치에 민감한 것으로 알려져 있다

# - average linkage	 : 한 군집의 점과 다른 군집의 점 사이의 평균 거리
#                      두 가지 방법의 타협점. 분산이 적은 군집을 만드는 경향

# - centroid         : 두 군집의 centroids(변수 평균의 벡터) 사이의 거리.관측치가 하나인 경우 centroid는 변수의 값이 된다
#                      단순하고 이해하기 쉬운 거리의 정의를 갖는 매력적인 방법으로 다른 방법들에 비해 이상치에 덜 민감하지만
#                      average linkage나 Ward방법에 비해 수행능력이 떨어진다.

# - Ward             : 모든 변수들에 대하여 두 군집의 ANOVA sum of square를 더한 값
#                      적은 관찰치를 갖는 군집을 만드는 경향

data(nutrient,package = "flexclust")
rownames(nutrient) = tolower(rownames(nutrient))
nutrient.scaled    = scale(nutrient)
d                  = dist(nutrient.scaled)
fit.average        = hclust(d, method="average")
plot(fit.average,hang=-1,cex=.8,main="Average Linkage Clustering")

library(NbClust)
library(dplyr)
devAskNewPage( ask = TRUE)
nc = NbClust(nutrient.scaled,
             distance = "euclidean",
             min.nc   = 2,
             max.nc   = 15,
             method   = "average")
           
table(nc$Best.n[1,])
par(mfrow=c(1,1))
barplot(table(nc$Best.n[1,]),
        xlab="Number of Clusters",
        ylab="Number of Criteria",
        main="Number of Clusters Chosen by 26 criteria")

clusters <- cutree(fit.average,k=5)
table(clusters)
nutrient_cls <- inner_join(nutrient, "clusters" = clusters)
nutrient_cls %>% group_by(clusters) %>% summarise_all(list(mean  = ~ median(.)))
plot(fit.average,hang=-1,cex=.8,
     main="Average Linkage Clustering\n5 Cluster Solution")
rect.hclust(fit.average, k = 5)

########################
## 비계층적 군집 방법 ##
########################
# 군집의 개수 k개를 구한 후, 데이터를 무작위로 K개의 군으로 배정한 후 다시 계산하여 군집으로 나눔
# - K-means
# - PAM

##############
# 1. K-means #
##############
# K개의 centroids를 선택(k개의 행의 무작위로 선택)
# 각 데이타를 가장 가까운 centroid에 할당
# 각 군집에 속한 모든 데이타의 평균으로 centroid를 다시 계산
# 각 데이타를 가장 가까운 centroid에 할당
# 모든 관측치의 재할당이 일어나지 않거나 최대반복횟수(R에서의 dafault값은 10회)에 도달할 때까지 3과 4를 반복

# k-means의 장단점
# - 장점
# 계층적 군집분석에 비해 큰 데이터에 사용 가능
# 관측치가 영구히 한 그룹에 영속되는 것이 아니라 최종결과를 개선시키는 방향으로 감
# - 단점
# 평균을 사용하기 때문에 연속형 변수에만 사용 가능
# 이상치에 심하게 영향을 받음
# non-convex 형태의 군집이 존재하는 경우 잘 찾지 못함

library(NbClust)
library(flexclust)
set.seed(123)
data(wine, package = 'rattle')
head(wine)

df <- scale(wine[-1])
nc <- NbClust(df, min.nc = 2, max.nc = 15, method = 'kmeans')
table(nc$Best.n[1,])
par(mfrow=c(1,1))
barplot(table(nc$Best.n[1,]),xlab="Number of Clusters",ylab="Number of Criteria",
        main="Number of Clusters Chosen by 26 criteria")
wssplot = function(data, nc = 15, seed = 1234, plot = TRUE){
  wss <- (nrow(data)-1)*sum(apply(data,2,var))
  for( i in 2:nc){
    set.seed(seed)
    wss[i]<-sum(kmeans(data,centers=i)$withinss)
  }
  if(plot) plot(1:nc,wss,type="b",xlab="Number pf Clusters",ylab="Within group sum of squares")
  wss
}
# 그래프에서 적절한 bend가 있는 곳에서 군집을 생성해야 함을 시사해줌
wssplot(df)

fit.km <- kmeans(df, 3, nstart = 25)
fit.km$cluster
fit.km$size
fit.km$centers
aggregate(wine[-1],by=list(clusters=fit.km$cluster),mean)

ct.km <- table(wine$Type, fit.km$cluster)
ct.km

randIndex(ct.km)

############
## 2. PAM ##
############
# k-means 알고리즘은 평균을 이용하기 때문에 이상치에 민감한데, 이를 보완한 방법
# k-means에서 유클리드 거리를 사용하는 것과 달리 다른 거리 측정법도 사용할 수 있기 때문에 연속형들 뿐만 아니라,
# mixed data type 에도 적합시킬 수 있음

# 1. K개의 관찰치(medoid)를 무작위로 선택
# 2. 모든 관찰치에서 각 군집의 대표 관찰치(medoid)까지의 거리를 계산
# 3. 각 관찰치를 가장 가까운 medoid에 할당
# 4. 각 관찰치와 해당하는 medoid사이의 거리의 총합(총비용,total cost)을 계산
# 5. medoid가 아닌 점 하나를 선택하여 그 점에 할당된 medoid와 바꾼다.
# 6. 모든 관찰치들을 가장 가까운 medoid에 할당한다.
# 7. 총비용을 다시 계산한다.
# 8. 다시계산한 총비용이 더 작다면 새 점들을 medoid로 유지
# 9. medoid가 바뀌지 않을 때까지 5-8단계를 반복

# cluster::pam function
pam(
  x,                    # 데이터 행렬 또는 데이터 프레임 
  k,                    # 군집의 개수
  metric="eucladean",   # 거리측정방법
  stand=FALSE           # 거리 측정 전 변수 표준화 여부
  )

library(cluster)
set.seed(1234)
fit.pam <- pam(wine[-1],k=3,stand=TRUE)

fit.pam$medoids # 3개의 군집을 대표하는 대표 관측치 3개

# Bivariate plot
# 관측치들을 두 개의 주성분을 좌표로 하여 산점도로 나타낸 것
# 각 군집은 각 군집에 속한 모든 관측치를 포함하는 가장 작은 타원으로 표시
# 이 경우 PAM의 수행능력은 k-means에 비해 떨어진다.
clusplot(fit.pam, main="Bivariate Cluster Plot")


ct.pam=table(wine$Type, fit.pam$clustering)

# adjusted Rand index : clutser의 군집을 알 때 사용하는 군집 성능 지표
randIndex(ct.pam)



