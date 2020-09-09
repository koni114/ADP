#################
### 13회 실기 ###
#################
# 1. 고객 세분화 문제

# 데이터 형태 : transaction 데이터

transaction <- data.frame("일시"     = seq(from = as.Date("2014-06-28"), to = as.Date("2014-07-31"), 1),
                          "제목"     = paste0("book", seq(1, 34)),
                          "카테고리" = rep(c("판타지", "소설", "수필", "시"), length = 34),
                          "저자"     = paste0("<저자", seq(1, 34), ">"),
                          "출판사"   = rep(c("출판사1", "출판사2", "출판사3", "출판사4"), length = 34),
                          "수량"     = sample(1:10,34, replace = T),
                          "시간"     = sample(1:15,34, replace = T),
                          "디바이스" = c('모바일', 'PC', '없음')[sample(1:3, size =  34, replace =  T)],
                          "상태"     = c('주문', '취소')[sample(1:2, size = 34, replace = T)]
                          )

# 1.1 EDA, 상관계수 등 분석을 통하여 데이터를 시각화 하여라
# 디바이스 별 책 개수 : 파이 그래프
library(ggplot2)
library(dplyr)
tranByDevice <- transaction %>% group_by(디바이스) %>% tally() %>% data.frame()
pieGraph     <- ggplot(data    = tranByDevice,
       mapping = aes(x = '', y = n, fill = as.factor(디바이스))
       ) + geom_bar(width = 1, stat = 'identity') +  coord_polar("y") + geom_text(aes(label = paste0(n)), position = position_stack(vjust = 0.5)
       ) + scale_fill_discrete(name= '디바이스 별 count 수') + labs(x = NULL, y = NULL)

# 카테고리 별 수량 평균 : histogram
tranByMean <- transaction %>% group_by(카테고리) %>% summarise_all(list(평균 = ~ mean(., na.rm = T))) %>% select_if(~ !any(is.na(.)))
barGraph   <- ggplot(data    = tranByMean,
                     mapping = aes(x = 카테고리, y = 수량_평균)) + geom_bar(stat="identity")

# 1.2 고객 세분화를 시켜라. 소스코드도 제출
#     군집 분석을 통한 고객 세분화 필요

# 다음과 같은 분석 process로 군집 분석을 진행하고, 고객 세분화는 해석에 의해 적용
library(cluster)
library(fastcluster)

# 다음은 데이터가 확실하지 않아, 다음의 블로그와 예시 데이터를 참조하였습니다. : https://rpubs.com/cardiomoon/249084
# 예시 데이터 nutrient Data : 모두 수치형. 만약 데이터 중에 문자형 및 범주형 데이터가 존재한다면, encoding 고려 필요
library(flexclust)
data(nutrient,package="flexclust")
nutrient.rownames = tolower(rownames(nutrient))

# (1). 어떤 군집 분석 기법을 선택할 것인가?
#     - 계층적 군집 분석        : 데이터가 150개 이하일 때 일반적으로 사용
#     - partitioning clustering : 150개 이상일 때 사용.
#    --> 계층적 군집 분석 사용 결정

# (2). 알맞은 속성 선택
#      --> 현재는 컬럼이 몇개 없으므로, 모든 컬럼 전부 사용
# (3). 이상치 선별(Screen for outliers)
IQR_Treat_lower <- function(x){
  IQR_Value  <- IQR(x, na.rm = T)
  medi_value <- median(x, na.rm = T)
  c(medi_value - 1.5*IQR_Value)
}

IQR_Treat_upper <- function(x){
  IQR_Value  <- IQR(x, na.rm = T)
  medi_value <- median(x, na.rm = T)
  c(medi_value + 1.5*IQR_Value)
}

nutrient.IQR <- data.frame(nutrient)  %>% summarise_all(funs(IQR_Treat_lower, IQR_Treat_upper))

nutrient <- data.frame(nutrient) %>% mutate(energy = ifelse(energy < as.numeric(nutrient.IQR["energy_IQR_Treat_lower"]) | energy > as.numeric(nutrient.IQR["energy_IQR_Treat_upper"]), NA, energy)) 
nutrient <- data.frame(nutrient) %>% mutate(protein = ifelse(protein < as.numeric(nutrient.IQR["protein_IQR_Treat_lower"]) | protein > as.numeric(nutrient.IQR["protein_IQR_Treat_upper"]), NA, protein)) 
nutrient <- data.frame(nutrient) %>% mutate(fat = ifelse(fat < as.numeric(nutrient.IQR["fat_IQR_Treat_lower"]) | fat > as.numeric(nutrient.IQR["fat_IQR_Treat_upper"]), NA, fat)) 
nutrient <- data.frame(nutrient) %>% mutate(calcium = ifelse(calcium < as.numeric(nutrient.IQR["calcium_IQR_Treat_lower"]) | calcium > as.numeric(nutrient.IQR["calcium_IQR_Treat_upper"]), NA, calcium)) 
nutrient <- data.frame(nutrient) %>% mutate(iron = ifelse(iron < as.numeric(nutrient.IQR["iron_IQR_Treat_lower"]) | iron > as.numeric(nutrient.IQR["iron_IQR_Treat_upper"]), NA, iron)) 
rownames(nutrient) = nutrient.rownames

# 이상치 제거
library(tibble)
nutrient <- nutrient %>% rownames_to_column('rownames') %>%  filter_all(~ !is.na(.))
rownames(nutrient) <- nutrient[,'rownames']
nutrient <- nutrient[-1]

# (4). 데이터 표준화 및 encoding 수행 
nutrient.scaled = scale(nutrient)

# (5). 거리의 계산 (Calcuate distance)
d = dist(nutrient.scaled)

# (6). 군집 알고리즘 선택
#  --> 평균거리계산법을 이용한 계층적 군집 분석 수행
fit.average = hclust(d, method="average")

# (7). 하나 이상의 군집분석 결과 얻음
plot(fit.average, hang=-1,cex=.8,main="Average Linkage Clustering")

# (8). 군집의 갯수 결정
library(NbClust)
devAskNewPage(ask=TRUE)
nc = NbClust(nutrient.scaled, distance="euclidean", min.nc=2, max.nc = 10,
           method="average")

table(nc$Best.n[1,]) # 최종 군집 개수를 3개로 가지고 가야함.

# (9). 최종결과 획득
clusters<-cutree(fit.average,k = 3)
table(clusters)

# (10). 분석 결과의 시각화
aggregate(nutrient,by=list(cluster = clusters), median)
aggregate(as.data.frame(nutrient.scaled),by=list(cluster=clusters),median)

# (11). 군집 분석 결과의 해석
plot(fit.average,hang=-1,cex=.8,
     main="Average Linkage Clustering\n5 Cluster Solution")
rect.hclust(fit.average,k=5)

# 1.3 특성 분석 / 고객 세분화 후 세분화에 따른 Label를 지으시오. 마케팅 관점에서의 인사이트 도출
# data loading 시 encoding 문제 존재
# 특수문자 제거 필요. ex) >, <
#   한글과 특수문자가 섞여있는 데이터를 불러 올 때 인코딩 방식 확인 및 전처리하는 방법 숙지

# eocoding 참조
#' - 인코딩은 정상적인가? EUC-KR, UTF-8 인지 확인 필요.
#'     --> 문제 있는 경우, readr::read_csv function을 통해 locale parameter 이용
enco <- readr::guess_encoding("Boston_Housing.csv")[1,1] %>% as.character()
print(paste0("enco: ", enco))

housing <- readr::read_csv("housing.csv"
                           , col_names = F
                           , col_types = NULL
                           , comment   = ""
                           , na        = c("NA", "NULL")
                           , locale    = locale("ko", encoding = data_encoding)
) %>%  data.frame


# 2. Classification 문제

# 2.1 부정거래, 정상거래 막대 그래프 표현. + %표시도 같이 표현하시오
library(ggplot2)
library(MASS)    # 예제 데이터를 위한 Dataset
library(plyr) 

Cars93_count <- Cars93 %>% group_by(Origin, Man.trans.avail) %>%  tally() %>%  data.frame
barGraph     <- ggplot(data = Cars93_count,
                       mapping  = aes(x = Origin, y = n, fill = Man.trans.avail, label = n)) + geom_bar(stat = 'identity') + scale_fill_discrete(name= '범례제목', labels = c('값1', '값2')  ) + geom_text(size = 3, position = position_stack(vjust = 0.5))
                                                    
                                                                                       
# 2.2 거래 금액, 거래 시간의 분포를 보이시오
ggplot(Cars93, aes(x = RPM, fill = Man.trans.avail, col = Man.trans.avail)) +
  geom_rug(alpha = 0.6) + 
  geom_density(alpha = 0.6)

ggplot(Cars93, aes(x = RPM, fill = Origin, col = Origin)) +
  geom_rug(alpha = 0.6) + 
  geom_density(alpha = 0.6)

# 2.3 상관관계행렬 plot으로 보이시오
# 다수의 변수간 상관관계를 파악하려고 할 때, 회귀분석에서 종속변수와 독립변수간 선형관계를 파악하고자 할 때,
# 사용하는 분석 기법이 상관계수 행렬이며, 시각화 방법이 산점도 행렬과 상관계수 행렬 Plot (correlation matrix plot)
# corrplot

library(corrplot)
nutrient_cor <- cor(nutrient)
corrplot(nutrient_cor, method="circle")

corrplot(nutrient_cor,
         method="shade", # 색 입힌 사각형
         addshade="all", # 상관관계 방향선 제시
         # shade.col=NA, # 상관관계 방향선 미제시
         tl.col="red", # 라벨 색 지정
         tl.srt=30, # 위쪽 라벨 회전 각도
         diag=FALSE, # 대각선 값 미제시
         addCoef.col="black", # 상관계수 숫자 색
         order="FPC" # "FPC": First Principle Component
         # "hclust" : hierarchical clustering
         # "AOE" : Angular Order of Eigenvectors
)


# 2.4 종속변수가 편중된 dataset이다. sub sampling을 설명하시오
# over sampling과 under sampling 설명인 것으로 파악됨.. 확실치는 않습니다. 
# over sampling  : imbalanced 한 데이터에서 비교적 적은 class Data를 부풀려 sampling 하는 경우를 말함
# under sampling : imbalanced 한 데이터에서 비교적 많은 class Data를 적게 sampling 하는 경우를 말함

# 2.5 Random Under Sampling을 활용한 데이터 셋과 class를 보여주고 TrainSet의 Header를 표기하시오(코드 작성 필수)

# 무작위로 데이터를 없애는 단순 샘플링은 정보의 손실을 가져올 수 있음

# 2.6 SMOTE sampling 을 수행하고, class 별 Header를 표기하시요(코드 작성 필수)
# https://thebook.io/006723/ch10/06/02/ 참고
DMwR::SMOTE(
  form,             # 모델 포뮬러
  data,             # 포뮬러를 적용할 데이터
  perc.over = 200,  # 적은 쪽의 데이터를 얼마나 추가로 샘플링해야 하는지?
                    # 적은 쪽의 데이터 한 개당 perc.over/100개의 추가 데이터가 생성되어 샘플링됨
  k=5,              # 고려할 최근접 이웃의 수
                    # 적은 쪽의 데이터를 추가로 샘플링할 때 각 샘플에 대응해서 많은 쪽의 데이터를
                    # 얼마나 샘플링할지 지정
  perc.under = 100
)

# 2.8 TP/TN/FP/FN/Accuracy/Precision/Recall/민감도/특이도 Score를 모두 구하고, 그 의미를 적으시오
# http://blog.naver.com/PostView.nhn?blogId=woosa7&logNo=220840338896&beginTime=0&jumpingVid=&from=search&redirect=Log&widgetTypeCall=true 블로그 참조

# 2.9 이러한 dataset에서는 어떤 score가 중요하고, 그 이유는 무엇인가?
# 기본적으로 imblanced 한 데이터에서는 F1-Score를 계산하여 확인하는 것이 중요

