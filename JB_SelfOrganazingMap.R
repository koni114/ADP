########################## 
## Self Organizaing Map ##
##########################
# Self Organizaing Map(SOM) 분석은
# 차원 축소와 군집화를 동시에 수행하는 기법

# 사람이 눈으로 볼 수 있는 저차원 격자에 고차원 데이터들이 대응하도록 인공신경망의 유사한 방식의 학습을 통해 군집을 도출
# 고차원의 데이터 원공간. 유사한 개체 <====> 저차원의 인접한 격자 들과 연결

############################################################
## NBA Player 들의 통계 dataset을 통한 SOM 분석 실습 예제 ##
############################################################
require(kohonen)       #- kohonen package는 R에서 basic SOM을 빠르게 생성하기 위한 package
require(RColorBrewer)

# Dataset
# 2015/16 NBA season의 통계 Data
library(RCurl)
NBA <- read.csv(text = getURL("https://raw.githubusercontent.com/clarkdatalabs/soms/master/NBA_2016_player_stats_cleaned.csv"), 
                sep = ",",
                header = T, 
                check.names = FALSE)

# Basic SOM 생성하기
# SOM 모델을 생성하기 전에 어떤 변수들을 가지고 군집패턴을 생성할 것인지 선택해야 함
colnames(NBA)
head(NBA)

# 슛 시도 관련 변수들을 가지고 간단한 Basic SOM 모델을 생성해보자
# 기본적으로 군집분석도 마찬가지지만 SOM 분석은 데이터를 정규화하는 작업을 우선적으로 수행해준다.  --> scale
NBA.measures1 <- c("FTA", "2PA", "3PA")
NBA[NBA.measures1]
NBA.SOM1 <- som(scale(NBA[NBA.measures1]),
                grid = somgrid(6, 4, "rectangular")) #- grid size 지정.  --> 저차원 격차를 의미

##############
## SOM PLOT ##
##############

# kohonen 에서 제공해주는 plot은 pie chart임.
# pie의 반경은 해당 차원의 크기와 비례
# NBA 플레이어들은 각 유형의 샷 수에 따라 클러스터링 됨
plot(NBA.SOM1)

# HeatMap SOM
# 각각의 cell은 각각의 격자를 대표함
# 더 짙은 빨간색 cell 일수록 더 높은 player 수 임을 알 수 있음
# type = 'count'를 지정함으로써 HeatMap SOM plot 생성
colors <- function(n, alpha = 1){
  rev(heat.colors(n, alpha))
}

plot(
  NBA.SOM1, 
  type         = "counts", 
  palette.name = colors, 
  heatkey      = TRUE)

# Plotting SOM
# 격자 내에 데이터(point)가 포함되어 있는 plot을 생성 가능
# type = 'mapping' 을 지정함으로써 해당 plot 생성 가능
plot(
  NBA.SOM1, 
  type = "mapping", 
  pchs = 20, 
  main = "Mapping Type SOM")

# 플롯 유형의 geometry를 변경하는 방법
# 지금까지는 grid 형태를 rectangular 형태로 가져갔는데, 이러한 경우는 corner에 있는 grid는 
# 상대적으로 적은 neigbor를 가짐
# --> 결과적으로 edge에 있게 되면 더 극단의 값을 가질 확률이 높아짐
# --> 우리가 첫번째 예제에서 SOM 분석을 할 때, 3개의 stat에서 최대값을 가지는 경우는 주로 corner에 포함되게 됨

# toroidal topology
# pac-man rule 기반의 해당 grid 토폴로지는 모서리여도 위 아래, 좌, 우에 인접함
NBA.SOM2 <- kohonen::som(
  scale(NBA[NBA.measures1]), 
  grid = somgrid(6, 6, "hexagonal")
  )

plot(
  NBA.SOM2, 
  type = "mapping", 
  pchs = 20, 
  main = "Mapping Type SOM")

# Mapping Distance
# type = "dist.neighbours" 로 지정시, 
# cell의 색깔은 가장 가까운 이웃끼리의 전체 거리에 따라서 색상의 진함이 표시됨
# 이러한 색상 비유는 지형학적 비유로 생각할 수 있음
# 이웃 cell과 거리가 먼 cell은 산봉우리와 같음
plot(
  NBA.SOM2, 
  type = "dist.neighbours", 
  palette.name = terrain.colors)
  
#####################
## Supervised SOMs ##
#####################
# kohonen package에서는 분류가 가능한 지도학습의 SOM을 제공해줌
# 이번 예제는 여러개의 독립변수(high dimension)을 통한 supervised example을 진행해보자

# 다음과 같은 변수들을 독립변수로 사용
NBA.measures2 <- c("FTA", "FT", "2PA", "2P", "3PA", "3P", "AST", "ORB", "DRB", 
                   "TRB", "STL", "BLK", "TOV")

# The xyf() Function
# 우리는 supervised SOM을 만들기 위하여 xyf function 사용
# 우리는 다양한 독립변수를 통해 player의 count의 position을 분류하는 분류 모델을 만들어 볼 것임

training_indices <- caret::createDataPartition(NBA$Pos, p = 0.7, list = F)       #-  200개의 sample idx 생성
NBA.training     <- scale(NBA[training_indices, NBA.measures2])                  #-  trainData에 대한 독립변수 정규화 진행
NBA.testing      <- scale(NBA[-training_indices, NBA.measures2],                 #-  ** trainData의 mean, sd를 기준으로 testData 정규화 진행
                          center = attr(NBA.training,"scaled:center"), 
                          scale  = attr(NBA.training, "scaled:scale"))
    
NBA.SOM3 <- xyf(NBA.training, 
                classvec2classmat(NBA$Pos[training_indices]), #-  classvec2classmat : one-hot encoding 해주는 function
                grid       = somgrid(13, 13, "hexagonal"),    #-  grid : 13 x 13, hexagonal
                rlen       = 100)                             #-  

pos.prediction <- predict(NBA.SOM3, newdata = NBA.testing,  whatmap = 1)
table(NBA[-training_indices, "Pos"], pos.prediction$prediction[[2]])    

############################################
## Visualizing Predictions : "Codes" SOMs ##
############################################
NBA.SOM4 <- xyf(scale(NBA[, NBA.measures2]),             #- NBA 전체 데이터를 가지고 SOM 모델 생성
                classvec2classmat(NBA[, "Pos"]), 
                grid = somgrid(13, 13, "hexagonal"), 
                rlen = 300)

