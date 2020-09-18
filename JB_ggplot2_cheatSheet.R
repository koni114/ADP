# ggplot2 - cheatSheet 
# ggplot2 라이브러리를 이용하여 graph를 그리고 싶다면,
# 다음과 같은 template을 완성 시켜야 함

# ggplot(data = <DATA>) +
# <GEOM FUNCTION>(mapping  = aes(<MAPPINGS>),   --> * geom       : 기하학적
#                 stat     = <STAT>,
#                 position = <POSITION>) + 
# <COORDINATE_FUNCTION> +                       --> * coordinate : 위도와 경도
# <FACET_FUNCTION> +                            --> * facet      : 면
# <SCALE FUNCTION> +                            --> * scale      : 
# <THEME FUNCTION>                              --> * theme      : 주제..

############
## BASICS ##
############
# 그래프를 그릴 때 가장 기본이 되는 틀이라고 생각하면됨

# 1. ggplot function
# 가장 모태가 되는 함수.
# 일반적으로 data, aes 정도를 parameter로 받아 사용 가능
library(ggplot2)
library(MASS)
head(Cars93)

ggplot(     data      = Cars93
            , mapping = aes(x = Price, y= MPG.city))

# 2. qplot function
# data, geom, mapping parameter를 추가하여 하나의 그래프를 완성 시키는 함수
qplot(x = Price, y = MPG.city, data = Cars93, geom = 'point')

# 3. last_plot function 
# memory 상에서 가장 마지막에 생성했던 그래프를 복원시켜 주는 함수
last_plot()

# 4. ggsave function
# ggplot 그래프를 저장시켜 주는 함수.
#' @param : filename, 파일명
#' @param : width, 이미지  세로 폭
#' @param : height, 이미지 가로 폭
ggsave(filename   =  "plot.png",
       width      = 5,
       height     = 5)

#############
### GEOMS ###
#############

########################################
# 1. graphical primitives(그래픽 원형) #
########################################

a <- ggplot(economics, aes(date, unemploy))
b <- ggplot(seals, aes(x = long, y = lat ))

# 1.1 geom_blank function
# 경계 확장을 위해서 유용함. 아무 그래프도 그리진 않고 x축, y축에 대한 경계 확인용..
a + geom_blank()

# 1.2 geom_curve function
# 곡선 형태의 화살표를 그릴 수 있는 함수
#' @param : x     : 시작 x 좌표
#' @param : y     : 시작 y 좌표
#' @param : xend  : 끝나는 x 좌표
#' @param : yend  : 끝나는 y 좌표
#' @param : color : 색깔 지정  
#' @param : curvature : 곡률, 숫자가 커질수록, 왼쪽에서 오른쪽으로 휨 정도가 커짐. 1하면 반원 모양을 가지며 휨
#' @param : angle : 화살표 각도, 90보다 작은 값은 시작점을 향해 곡선을 구부리고, 90보다 큰 값은 끝점을 향해 곡선을 구부림
#' @param : arrow : 화살 특징, 반드시 arrow(length = unit(0.25,"cm")) 와 같은 형식으로 사용
ggplot(data = head(Cars93)) + geom_curve(aes(x    = rep(0, 6),
                                             y    = rep(0, 6),
                                             xend = Price,
                                             yend = MPG.city,
                                             color = as.factor(Origin)),
                                         curvature = 0.5,
                                         angle     = 40,
                                         arrow     = arrow(length = unit(0.25,"cm")))

# 1.2 geom_path function
# 관찰 값들을 연결시켜 주는 함수
# 즉, x축은 각 컬럼의 데이터 group, y축은 해당 컬럼의 값으로 구성되어 있고, 각 객체들의 값을 선으로 이어 보여주는 함수
# --> 평행 좌표
# Aesthetics
#' @param : x     : x축, 필수
#' @param : y     : y축, 필수
#' @param : alpha : 투명도
#' @param : colour : 색상
#' @param : group : 선 연결시 그룹핑 해주고자 하는 그룹을 말함(색깔 구분 group이 아님)
#' @param : linetype : 선 타입
#' @param : size : 선 크기(?)
#' @param : lineend  : Line end style (round, butt, square).
#' @param : linejoin : Line join style (round, mitre, bevel).
#' @param : arrow : 화살 특징, 반드시 arrow(length = unit(0.25,"cm")) 와 같은 형식으로 사용
#' @param : show.legend : 범례 표시 여부
library(reshape2)
args(geom_path)
iris_data         <- iris
iris_data$row_num <- 1:nrow(iris)
melt_data <- melt(data    = iris_data,
                  id.vars = c('row_num','Species'))

ggplot(melt_data) +
geom_path(aes(x= variable, y = value, group = row_num, size = 10, color = Species, alpha = 0.5), 
lineend = 'round', linejoin = 'round', show.legend = F)

# 1.3 geom_polygon function
# 관찰 값들을 선으로 연결하고, 그 내부를 색을 칠하여 표기해주는 함수
# geom_path 함수와 동일하게 사용하되, fill 함수를 이용해서 내부 색상 지정 가능

ggplot(melt_data) +
  geom_polygon(aes(x= variable, y = value, group = row_num, size = 10, color = Species, alpha = 0.5), 
            lineend = 'round', linejoin = 'round', show.legend = F, fill = 'white') # 내부가 흰색으로 보이는 것을 확인

# 1.4 geom_rect function
# 네개의 관찰값을 연결하여 사각형을 그려주는 함수
#' @param : xmin, x 최소값
#' @param : ymin, y 최소값
#' @param : xmax, x 최대값
#' @param : ymax, y 최대값
ggplot(data = iris, aes(  x = Sepal.Length
                        , y = Sepal.Width)) + geom_point() + geom_rect(aes(  xmin = 5
                                                                           , xmax = 7
                                                                           , ymin = 3
                                                                           , ymax = 5),  fill = 'white')
# 1.5 geom_ribbon function
# geom_path 에서 그려지는 직선에서, 위 아래 마진을 줘서 영역을 표기하는 그래프 함수
# 마찬가지로, ymin, ymax, xmin, xmax parameter를 통해 마진 영역 표기 가능
ggplot(economics, aes(date, unemploy)) + geom_ribbon(aes(ymin = unemploy - 900, ymax = unemploy + 900))

################################
# 2. Line segment(선분 그리기) #
################################
# 공통 aesthetics : x, y, alpha, color, linetype, size
# geom_abline(aes(intercept, slope)) 일차 함수 직선
# geom_hline(aes(yintercept))        수평선
# geom_vline(aes(xintercept))        수직선
# 일차 선분을 그래프 위에 그려주는 함수
# * 앞에 geom_point 을 그리고, geom_abline을 그리려고 한다면? 
ggplot(seals, aes(x = long, y = lat )) + geom_abline(aes(intercept = 0, slope = 1))
ggplot(seals, aes(x = long, y = lat )) + geom_hline(aes(yintercept = lat))            #- 하나의 직선이 아니라, 여러개 가능
ggplot(seals, aes(x = long, y = lat )) + geom_vline(aes(xintercept = long))

################################
## 3. One variable continuous ##
################################
# 연속형 데이터의 변수가 x 하나 일때의 그래프 종류 
# common parameter
#' @param bins     : 구획의 갯수
#' @param binwidth : 한 구획의 길이점
#' @param breaks   : 구획의 시작점과 끝점
head(mpg)
c <- ggplot(mpg, aes(hwy))
# 3.1 geom_area function
# 연속형 데이터의 실제 값 분포를 area로 표기해주는 그래프 함수
# 실제로는 geom_line에서 영역에 대한 색을 입힌 그래프 함수가 정석.
#' @param x, * sequential한 또는 semi-discrete 데이터가 와야 함
#' @param y, 연속형 데이터
#' @param alpha,
#' @param color,
#' @param fill,
#' @param linetype,
#' @param size 
ggplot(data = economics) + geom_area(aes(x = date, y = unemploy), alpha = 0.4)
ggplot(mpg, aes(hwy)) + geom_area(stat = 'bin') # hwy도 약간 discrete 하면서 count 성의 컬럼 값

# 3.2 geom_density function
# 확률 값을 y축, sequential한 또는 semi-discrete한 데이터가 x축에 오는 확률밀도함수
#' @param x
#' @param y
#' @param alpha
#' @param color
#' @param fill
#' @param group, 그룹별 변수
#' @param linetype, 
#' @param size,
#' @param weight
#' @param adjust, 대역폭 조정이라고 나오는데, adjust 값이 작아질수록 실제 값에 더 가까워(?) 짐
ggplot(mpg, aes(hwy)) + geom_density(kernel = 'gaussian')

# 3.3 geom_dotplot function
# 연속형 데이터의 분포 '구간'를 점 plot으로 표기해주는 그래프 함수 
# 바둑돌들이 그래프 위에 올라와 있는 형태
#' @param x
#' @param y
#' @param alpha
#' @param color
#' @param fill
ggplot(mpg, aes(hwy)) + geom_dotplot(binwidth = 1)
ggplot(mpg, aes(hwy)) + geom_dotplot()

# 3.4 geom_freqpoly function
# frequency polygons 그래프를 그려주는 함수
ggplot(mpg, aes(hwy)) + geom_freqpoly(bins = 50)
ggplot(mpg, aes(hwy)) + geom_freqpoly()

# 3.5 geom_histogram  function
# x축은 간격, y축은 빈도를 나타내는 그래프를 histogram이라고 함
ggplot(mpg, aes(hwy)) + geom_histogram(binwidth = 5) # y 축은 count, x축은 데이터의 간격을 나타냄
ggplot(mpg, aes(hwy)) + geom_histogram()

# 3.6 geom_qq function
# t 분포의 qq-plot을 생성
#' @param x
#' @param y
#' @param alpha
#' @param color
#' @param fill
#' @param linetype, 
#' @param size,
#' @param weight
ggplot(mpg) + geom_qq(aes(sample = hwy))

################################
### 4. One variable discrete ###
################################
# 4.1 geom_bar function
#' @param x
#' @param y
#' @param alpha
#' @param color
#' @param fill
#' @param linetype, 
#' @param size,
#' @param weight
# 막대 그래프을 그려주는 함수
# x축에 이산형 데이터가 오는 것이 일반적이다라고 생각하자.
# geom_bar(stat = ''identity) 와 geom_col은 동일한 그래프를 만듬!
ggplot(mpg, aes(fl)) + geom_bar()
ggplot(data = Cars93) + geom_bar(aes(x = Man.trans.avail,
                               fill   = as.factor(Origin))) 


###################################################
### 5. Two variables continuous x, continuous y ###
###################################################
# 5.1 geom_label function
# 점 그래프 등에서 해당 점마다 label을 표기하고 싶을 때 사용하는 그래프 함수
# ** 실제 label 함수는 반드시 x,y가 연속형일 필요는 없다!
#' @param nudge_x, label의 x 축 조절
#' @param nudge_y, label의 y 축 조절
#' @param check_overlap, False인 경우, 라벨이 겹치는 경우 제거함
#' @param x
#' @param y
#' @param label, label로 적용하고자 하는 컬럼
#' @param label.r, Radius of rounded corners
#' @param label.size, label size
#' @param alpha
#' @param angle
#' @param color
#' @param family, 폰트 설정
#' @param fontface, 글씨체
#' @param hjust, 수평 정렬을 제어, 0이면 왼쪽 정렬, 1이면 오른쪽 정렬, 0과 1 사이에서만 정의
#' @param vjust, 수직 정렬을 제어, 0이면 왼쪽 정렬, 1이면 오른쪽 정렬, 0과 1 사이에서만 정의
#' @param lineheight, 선 높이
#' @param size
library(dplyr)
ggplot(mpg, aes(cty, hwy)) + geom_label(aes(label = cty), nudge_x = 10, nudge_y = 10)

# Species 그룹별 평균 막대 그래프에 label을 표시하고 싶을 때, 
ggplot(data = (iris %>%  group_by(Species) %>%  summarise_all(list(~ mean(., na.rm = T)))),
       aes(x = Species, y = Sepal.Length, fill = Species)
       ) + geom_bar(stat =  'identity') + geom_label(mapping = aes(label = Sepal.Length), nudge_x = 0, nudge_y = -0.3, fill = 'white')
                                               
# 5.2 geom_jitter function     
# 두 연속형 데이터의 값들을 무작위로 수평 분산 시켜줌   
#' @param height, 수직 폭을 얼마나 흩트릴 것 인지
#' @param width,  수평 폭을 얼마나 흩트릴 것 인지
ggplot(mpg, aes(cty, hwy)) + geom_point()                        # 점들이 겹쳐서 정확하게 안보임
ggplot(mpg, aes(cty, hwy)) + geom_jitter(height = 2, width = 2)  # 점을 조금씩 수평 분산하여 데이터를 더 잘 보이게 해줌

# 5.3 geom_point function
# 두 연속형 데이터의 값을 점으로 표현하는 그래프 함수
ggplot(mpg, aes(cty, hwy)) + geom_point()  
  
# 5.4 geom_quantile function
# 분위 회귀 분석 직선 3개를 그려줌
# 분위회귀분석 --> ex) 분위수 별  
ggplot(mpg, aes(cty, hwy)) + geom_quantile()  

# 5.5 geom_rug function
# 2차원 데이터를 1차원 x,y 축에 선을 그어 내려주는 그래프 함수
ggplot(mpg, aes(cty, hwy)) + geom_point()  + geom_rug(sides = 'bl')  

# 5.6 geom_smooth
# 부드러운 곡선을 추가하는 그래프 함수
# 일반적으로 stat_smooth 를 추가하여 사용한다
ggplot(mpg, aes(cty, hwy)) + geom_point() + geom_smooth(method = lm)

# 5.7 geom_text
# 점, 막대 등에 text를 표기하는 그래프 함수(**중요) 
# geom_label과 비슷한 역할 수행
#' @param nudge_x, label의 x 축 조절
#' @param nudge_y, label의 y 축 조절
#' @param check_overlap, False인 경우, 라벨이 겹치는 경우 제거함
#' @param x
#' @param y
#' @param label, label로 적용하고자 하는 컬럼
#' @param label.r, Radius of rounded corners
#' @param label.size, label size
#' @param alpha
#' @param angle
#' @param color
#' @param family, 폰트 설정
#' @param fontface, 글씨체
#' @param hjust, 수평 정렬을 제어, 0이면 왼쪽 정렬, 1이면 오른쪽 정렬, 0과 1 사이에서만 정의
#' @param vjust, 수직 정렬을 제어, 0이면 왼쪽 정렬, 1이면 오른쪽 정렬, 0과 1 사이에서만 정의
#' @param lineheight, 선 높이
ggplot(mpg, aes(cty, hwy)) + geom_text(aes(label = cty))

#################################################
### 5. Two variables discrete x, continuous y ###
#################################################
# 5.1 geom_col
# x축이 이산형 데이터인 막대 그래프. x축은 연속형 실제 데이터가 들어감
ggplot(mpg, aes(class, hwy)) + geom_col()

# 5.2 geom_boxplot
# boxplot graph 생성해 주는 그래프 함수
# stat_boxplot를 통해 기본 통계 값 수정 가능
#' @param x,
#' @param y, 
#' @param lower, q1
#' @param upper, q3
#' @param ymax,  y의 최대 값
#' @param ymin,  y의 최소 값
#' @param alpha, 
#' @param color, 
#' @param fill,
#' @param group,
#' @param linetype,
#' @param shape,
#' @param size,
#' @param weight,
#' @param outlier.colour, NULL
#' @param outlier.color,  NULL
#' @param outlier.fill, NULL
#' @param outlier.shape,
#' @param outlier.size ,
#' @param outlier.stroke,
#' @param outlier.alpha,
ggplot(mpg, aes(class, hwy,colour = class, fill = class)) + geom_boxplot( outlier.colour = 'black'
                                                                         , outlier.alpha = 0.5)

# 5.3 geom_dotplot
# 기본적으로 dotplot은 x축이 연속형 일때만 주로 사용하는 함수이지만
# binaxis parameter = 'y' 명령어를 통해 응용하여 사용 가능하다
ggplot(mpg, aes(class, hwy)) + geom_dotplot(binaxis = 'y', stackdir = "center")

# 5.4 geom_violin
# violin plot이라고 불리는 그래프를 생성하기 위한 함수
# 해당 함수의 장점은 y축의 데이터의 밀도를 바이올린의 두께로 확인이 가능하다는 점이다.
# stat_ydensity 함수와 결합해서 사용됨
ggplot(mpg, aes(class, hwy, fill = class)) + geom_violin(alpha = 0.5)

###############################################
### 6. Two variables discrete x, discrete y ###
###############################################
# 6.1 geom_count
# x,y가 전부 이산형일 때의 개수를 점의 크기 등으로 나타내주는 함수
ggplot(diamonds) + geom_count(aes(x = cut, y = color, color = cut))

############################################
### 7. continuous bivariate distribution ###
############################################
# 랜덤 변수 두 개(X, Y)에 대한 결합 확률 그래프

# 7.1 geom_bin2d function
# x,y 연속형 변수에 대한 밀도 확률 그래프를 그려주는 함수
# stat_bin_2d와 결합하여 사용
#' @param binwidth, tile 간격을 의미, c(x,y)
ggplot(diamonds, aes(carat, price)) + geom_point()
ggplot(diamonds, aes(carat, price)) + geom_bin2d(binwidth = c(0.25, 500), alpha = 0.5)

# 7.2 geom_density2d function
ggplot(diamonds, aes(carat, price)) + geom_density2d()

# 7.3 geom_hex function
ggplot(diamonds, aes(carat, price)) + geom_hex(bins = 50)

##############################
### 7. continuous function ###
##############################
# x축 분포에 따른 y 축 값에 대한 그래프를 그려줌 

# 7.1 geom_area function
ggplot(economics, aes(date, unemploy)) + geom_area()

# 7.2 geom_line function
# 시계열 그래프를 그려주는 함수
library(reshape)
ggplot(economics, aes(date, unemploy)) + geom_line()

# 7.3 geom_step function
# 값을 직선이 아닌 계단 형식으로 그려주는 그래프 함수
ggplot(economics, aes(date, unemploy)) + geom_step(direction = 'hv')

#############################
### 8. visualizaing error ###
#############################
df <- data.frame(  grp = c("A", "B")
                 , fit = 4:5
                 , se  = 1:2)
j  <- ggplot(df , aes( x     = grp
                      ,y     =  fit
                      ,ymin  = fit-se
                      , ymax = fit + se))

# 8.1 geom_crossbar function
# 데이터의 편차를 계산해 실제 값과 해당 에러를 그래프로 표기해주는 그래프 함수
#' @param fatten, crossbar 가운데 선분의 굵기를 지정, 값이 커질수록 굵어짐
#' @param width,  crossbar 폭
#' @param x,
#' @param y, 
#' @param ymax, y 실측치 최대값 = 실측치 + error
#' @param ymin, y 실측치 최소값 = 실측치 - error
#' @param alpha, 
#' @param color, 
#' @param fill,
#' @param group
#' @param linetype,
#' @param size
j + geom_crossbar(fatten = 10)

# 8.2 geom_errorbar function
# 데이터의 편차를 계산해 실제 값과 해당 에러를 그래프로 표기해주는 그래프 함수
#' @param fatten, crossbar 가운데 선분의 굵기를 지정, 값이 커질수록 굵어짐
#' @param x,
#' @param y, 
#' @param ymax, y 실측치 최대값 = 실측치 + error
#' @param ymin, y 실측치 최소값 = 실측치 - error
#' @param alpha, 
#' @param color, 
#' @param fill,
#' @param group
#' @param linetype,
#' @param size
#' @param width,
j + geom_errorbar(width = 0.1)

# iris data 중, group별 mean, sd 를 구하여 errorbar로 표기해보기
iris_SL_summary <- iris %>% group_by(Species) %>% summarise_all(list(mean = ~ mean(., na.rm = T),
                                                  std  = ~ sd(.,   na.rm =T))) %>% select(Species, Sepal.Length_mean, Sepal.Length_std)
ggplot(data =iris_SL_summary, aes(  x = Species
                                  , y =  Sepal.Length_mean
                                  , ymax =  Sepal.Length_mean + Sepal.Length_std
                                  , ymin =  Sepal.Length_mean - Sepal.Length_std
                                  , color = Species)) + geom_errorbar(width = 0.1)


# 8.3 geom_linerange function
# 데이터의 편차를 고려해 line으로 그려주는 함수
#' @param x,
#' @param y, 
#' @param ymax, y 실측치 최대값 = 실측치 + error
#' @param ymin, y 실측치 최소값 = 실측치 - error
#' @param alpha, 
#' @param color, 
#' @param fill,
#' @param group
#' @param linetype,
#' @param size
j + geom_linerange()

iris_SL_summary <- iris %>% group_by(Species) %>% summarise_all(list(mean = ~ mean(., na.rm = T),
                                                                     std  = ~ sd(.,   na.rm =T))) %>% select(Species, Sepal.Length_mean, Sepal.Length_std)

ggplot(data =iris_SL_summary, aes(  x = Species
                                    , y =  Sepal.Length_mean
                                    , ymax =  Sepal.Length_mean + Sepal.Length_std
                                    , ymin =  Sepal.Length_mean - Sepal.Length_std
                                    , color = Species)) + geom_linerange()

# 8.4 geom_pointrange function
#' @param x,
#' @param y, 
#' @param ymax, y 실측치 최대값 = 실측치 + error
#' @param ymin, y 실측치 최소값 = 실측치 - error
#' @param alpha, 
#' @param color, 
#' @param fill,
#' @param group
#' @param linetype,
#' @param shape,
#' @param size,
j + geom_pointrange(shape = 1, size = 1.2)

###############
### 9. MAPS ###
###############
data  <- data.frame(murder = USArrests$Murder)
state <- tolower(rownames(USArrests))
map   <- map_data("state")
k     <- ggplot(data = data, aes(fill = murder)) 

# 9.1 geom_map function
#' @param map_id, map_data object 생성시 id
#' @param map, map_data object
# 지도위에 표기 해주는 그래프 함수
k + geom_map(aes(map_id = state), map = map) + expand_limits(x = map$long, y = map$lat)

## ** 아시아 지도 표기
asia <- map_data("world", region = c("China","Japan","North Korea","South Korea", "India"))
ggplot(asia, aes(x=long, y=lat, group=group, fill=region)) + geom_polygon(colour="black") + scale_fill_brewer(palette="Set1")

###########################
### 10. THREE Variables ###
###########################
# 10.1 geoum_contour function
# 등고선 그래프를 그려주는 그래프 함수
seals$z <- with(seals, sqrt(delta_long^2 + delta_lat^2)); l <- ggplot(seals, aes(long, lat))
l + geom_contour(aes(z = z))

# 10.2 geom_raster function 
# 히트맵 함수를 그려주는 그래프 함수
l + geom_raster( aes(fill = z)
                , hjust = 0.5
                , vjust = 0.5,
                interpolate = FALSE)

# 10.3 geom_tile
l + geom_tile(aes(fill = z))

#############
### STATS ###
#############
# STATS 함수는 plot을 위한 새로운 변수를 변환하고 생성함(ex) count, prop)
# data -> stat + geom + coordinate system -> plot

# 기본적으로 stat 의 값을 추가하는 방법은,
#   - geom_function 에서 stat 옵션을 지정하는 방식과,
#   - stat_function 에서 geom 옵션을 지정하는 방식으로 나뉜다.

# aesthetics에서는  ..name.. syntax 를 사용하여 적용 

#####################
### 1. continuous ###
#####################

# 1.1 stat_bin function
#' @param ..count.., bin의 개수 count
#' @param ..ncount..,bin의 개수를 count하여 0 - 1 사이로 scale
#' @param ..density.., bin의 밀도
#' @param ..ndensity.., bin의 밀도를 scale
c <- ggplot(mpg, aes(hwy))
c + stat_bin(binwidth = 1, origin = 10, geom = 'histogram')

# 1.2 stat_count
# ..count.., ..prop..
c + stat_count(width = 1)

# 1.3 stat_density
# ..count.., ..density.., ..scaled..
c + stat_density(adjust = 1, kernel = "gaussian")

####################################
### 2. x continuous, y continous ###
####################################
# 2.1 stat_bin_2d 
# x,y가 연속형 데이터에서, count를 추가한 그래프
# x, y, fill --> ..count.., ..density..
ggplot(mpg, aes(cty, hwy,fill = ..density..)) + stat_bin_2d(bins = 30, drop = T)
ggplot(mpg, aes(cty, hwy,fill = ..count..)) + stat_bin_2d(bins = 30, drop = T)

# 2.2 stat_bin_hex
# x, y, fill -->  ..count.., ..density..
ggplot(mpg, aes(cty, hwy,fill = ..density..)) + stat_bin_hex(bins=30)

# 2.3 stat_density_2d
# x, y, color, size | ..level..
ggplot(mpg, aes(cty, hwy)) + stat_density_2d(contour = TRUE, n = 100)

# 2.4 stat_ellipse
ggplot(mpg, aes(cty, hwy)) + stat_ellipse(level = 0.95, segments = 51, type = "t")

# 2.5 stat_ecdf
# x, y -> ..x.., ..y..
ggplot(mpg, aes(cty, hwy)) + stat_ecdf(n = 40)

# 2.6 stat_quantile
# x, y -> ..quantile..
ggplot(mpg, aes(cty, hwy))  + stat_quantile(quantiles = c(0.1, 0.9), formula = y ~  log(x), method = "rq")

# 2.7 stat_smooth
# x, y | ..se.., ..x.., ..y.., ..ymin.., ..ymax..
ggplot(mpg, aes(cty, hwy)) + stat_smooth(method = "lm", formula = y ~ x, se=T, level=0.95)
               
# 2.8 stat_function
# 연속확률분포 곡선
ggplot(data.frame(x=c(-3,3)), aes(x=x)) + stat_function(fun = dnorm, args = list(sd = 0.5))
                      
# 2.9 stat_identity
ggplot(mpg, aes(cty, hwy)) + stat_identity(na.rm = TRUE)
  
# 2.10 stat_sum
# x, y, size -> ..n.., ..prop..
ggplot(mpg, aes(cty, hwy))  + stat_sum()

# 2.11 stat_summary
ggplot(mpg, aes(cty, hwy))  + stat_summary(fun.data = "mean_cl_boot")

# 2.12 stat_summary_bin
ggplot(diamonds, aes(carat, price)) + stat_summary_bin(fun = "mean", geom = "bar")

# 2.13 stat_unique
ggplot(mpg, aes(cty, hwy)) + stat_unique() + 


##########################
### 3. Three Variables ###
##########################
seals$z <- with(seals, sqrt(delta_long^2 + delta_lat^2)); l <- ggplot(seals, aes(long, lat))


# 3.1 stat_contour
# x, y, z, order -> ..level..
l + stat_contour(aes(z = z))

# 3.2 stat_summary_hex
# x, y, z, fill -> ..value..
l + stat_summary_hex(aes(z = z), bins = 30, fun = max)

# 3.3 stat_summary_2d
# x, y, z, fill -> ..value..
l + stat_summary_2d(aes(z = z), bins = 30, fun = mean)

###################################
### 4. x discrete, y continuous ###
###################################
f <- ggplot(mpg, aes(class, hwy))

# 3.4 stat_boxplot
# x, y | ..lower.., ..middle.., ..upper.., ..width.. , ..ymin.., ..ymax..
ggplot(mpg, aes(class, hwy)) + stat_boxplot(coef = 1.5)
?stat_boxplot

# 3.5 stat_ydensity
# x, y | ..density.., ..scaled.., ..count.., ..n.., ..violinwidth.., ..width..
ggplot(mpg, aes(class, hwy)) + stat_ydensity(kernel = "gaussian", scale = "area")

#############
### SCALE ###
#############
# Scale function은 데이터 값을 심미적으로 조정하는 역할 수행

n <- ggplot(mpg, aes(fl)) + geom_bar(aes(fill = fl))

# Format : A_B_C
# A : 서두에 scale은 공통 
# B ; alpha/color/colour/continuous/discrete/linetype/shape.. 등 심미적으로 조절하고자 하는 객체명 입력
# C : manual, date, datetime..등   scale 하고자하는 동사(?) 입력

# 1. scale_fill_manual function
# fill 객체(막대, 면적 등..) 의 manual 을 수정하고자 하는 함수
#' @param values
#' @param limits
#' @param breaks
#' @param name
#' @param labels
n +  scale_fill_manual(
  values = c("skyblue", "royalblue", "blue", "navy"),
  limits = c("d", "e", "p", "r"), 
  breaks = c("d", "e", "p", "r"),
  name = "fuel", 
  labels = c("D", "E", "P", "R"))

##############################
### General Purpose Scales ###
##############################
# 1. scale_*_continuous()
# 연속형 값을 시각적으로 mapping 해주는 함수
#' @param name, label의 명
#' @param breaks, 축 간격
#' @param labels, break 간격에 줄 label 명
#' @param na.value, na 인 경우 처리하고자 하는 값
#' @param limits, 축 min, max 
#' @param trans, 함수를 적용해서 x 축 값을 변환할 수 있음. ex)  log2_trans()
ggplot(mpg, aes(cty, hwy)) + geom_point()  + scale_x_continuous(name   = 'hello',
                                                breaks = c(10, 15, 20, 25, 30),
                                                labels = c('A', 'B', 'C' ,'D', 'E'),
                                                limit = c(10, 30))
                                               

# 2. scale_*_discrete()
# 이산형 값을 시각적으로 mapping 해주는 함수
# 일반적으로 범주형 변수들의 순서를 limit 옵션을 통해 바꿔줌
#' @param name, label의 명
#' @param limits, 범주형 x 축의 순서 변경 
ggplot(mpg, aes(fl)) + geom_bar() + scale_x_discrete(limit = c('d', 'e', 'p', 'r', 'c'))

# 3. scale_*_identity()
# scaling을 진행하지 않고, 있는 값 그대로 보여주고 싶을 때,
ggplot(mtcars, aes(mpg, wt)) + geom_point(aes(size = cyl)) # 원의 size가 scaled 되서 적절한 사이즈로 변환
ggplot(mtcars, aes(mpg, wt)) + geom_point(aes(size = cyl)) + scale_fill_identity() # 원의 size가 cyl 값 그대로 적용

# 4. scale_*_manual()
# scale_*_manual(values = c())
# scale_fill_manual : 기존의 색상 위에 다른 색상을 입혀주는 함수 .
# 따라서 기본적으로 색상이 입혀져 있어야 작동
ggplot(mpg, aes(fl)) + geom_bar(aes(fill = fl)) + scale_fill_manual(values = c('red', 'blue', 'white', 'black', 'green'))

# 5. scale_*_date(date_labels = "%m/%d")
# 날짜형 데이터를 format에 따라 변환해주는 함수

# 6. scale_*_datetime()
# scale_*_date 함수와 동일한 역할을 하는 함수 

##############################
### X & Y Location Scales ####
##############################
# x,y 축 scale 변환 함수
# 1. scale_x_log10 function
# 밑이 10인 로그 변환
ggplot(data = iris) + geom_point(aes(x = Sepal.Length, y = Petal.Length)) + scale_x_log10()

# 2. scale_x_reverse function
# 축 자체가 좌우 반전이 일어나게끔 해주는 함수
ggplot(data = iris) + geom_point(aes(x = Sepal.Length, y = Petal.Length)) + scale_x_reverse()

# 3. cale_x_sqrt function
# 제곱근 변환 함수
ggplot(data = iris) + geom_point(aes(x = Sepal.Length, y = Petal.Length)) + scale_x_sqrt()

#########################################
### COLOR AND FILL SCALES (DISCRETE) ####
#########################################
# color와 fill scale 변환 함수들
# ** 중요한 것은 기존에 색깔이 있는 상태에서 추가하는 개념이므로,
# default 색깔이 없는 상태에서는 적용 불가능
o <- ggplot(mpg, aes(hwy)) + geom_dotplot(aes(fill = ..x.., color = ..x..))

# 1. scale_fill_distiller 
o + scale_fill_distiller(palette = "Blues")

# 2. scale_fill_gradient
o + scale_fill_gradient(low="red", high="yellow")

# 3. scale_fill_gradient2
o + scale_fill_gradient2(low="red", high="blue" ,mid = "white", midpoint = 25)

# 4. scale_fill_gradientn
o + scale_fill_gradientn(colours=topo.colors(2))

##########################
### Coordinate Systems ###
##########################
# 좌표 변환 함수들!
# 1. coord_cartesian
# x축, y축 범위 지정 함수 
# 범주형인 경우에는 xlim(c(0, 5)) 면 6개의 공간으로 표현됨
#' @param xlim, 
#' @param ylim, 
ggplot(mpg, aes(fl)) + geom_bar() + coord_cartesian(xlim = c(0, 5))

# 2. coord_fixed
# x, y축 비율 조정. 
# 크게 좋진 않다.. 그래프 자체 크기가 조정되기 때문
ggplot(mpg, aes(cty, hwy)) + geom_point() + coord_fixed(ratio = 0.5)
ggplot(mpg, aes(cty, hwy)) + geom_point() + coord_fixed(ratio = 1)

# 3. coord_flip
# x축과 y축을 swap
# 막대그래프 방향을 변경 시킬 수 있음
ggplot(mpg, aes(cty, hwy)) + geom_point() + coord_flip()
ggplot(mpg, aes(fl)) + geom_bar() + coord_flip()

# 4. coord_polar
# 원형 그래프 처럼 그려주는 함수
ggplot(mpg, aes(fl)) + geom_bar() + coord_polar(theta = "x", direction=1)

# 5. coord_trans
# 값 자체가 변환 되는 것이 아니라, 그래프 축의 비율이 변화되는 것
# scale transformation 함수랑은 다름!
#' @param x, x축 변환 
#' @param y, y축 변환
#' @param xlim, x축 범위 
#' @param ylim, y축 범위
ggplot(mpg, aes(fl)) + geom_bar() + coord_trans(y = "sqrt")

###########################
### position adjustment ###
###########################
# 1. dodge 겹치지 않게 표현
ggplot(mpg, aes(fl, fill = drv)) + geom_bar(position = "dodge") 

# 2. fill 비율로 겹쳐서 그래프를 표현
ggplot(mpg, aes(fl, fill = drv)) + geom_bar(position = "fill") 

# 3. jitter 값을 조금씩 분산되서 표현하여 전부 보이도록 함
ggplot(mpg, aes(cty, hwy)) + geom_point(position = 'jitter')

# 4. nudge label이 값에서 조금 벗어날 수 있도록 함
ggplot(mpg, aes(cty, hwy)) + geom_label(aes(label = drv), position = "nudge")

# 5. stack, 쌓아서 그래프를 표현
ggplot(mpg, aes(fl, fill = drv)) + geom_bar(position = "stack") 

###########################
### position adjustment ###
###########################


##############
### Themes ###
##############
# 1. + theme_bw() : 흰색 바탕
ggplot(mpg, aes(fl)) + geom_bar() + theme_bw()

# 2. + theme_gray() : 회색 바탕
ggplot(mpg, aes(fl)) + geom_bar() + theme_gray()

# 3. + theme_dark() : 검은색 바탕
ggplot(mpg, aes(fl)) + geom_bar() + theme_dark()

# 4. 기타
ggplot(mpg, aes(fl)) + geom_bar() + theme_classic()
ggplot(mpg, aes(fl)) + geom_bar() + theme_light()
ggplot(mpg, aes(fl)) + geom_bar() + theme_linedraw()
ggplot(mpg, aes(fl)) + geom_bar() + theme_minimal()
ggplot(mpg, aes(fl)) + geom_bar() + theme_void()

################
### Faceting ###
################
# 1. facet_grid
#' @param free, x축, y축 모두 데이터 크기에 따라 자동 scale 조정
ggplot(mpg, aes(cty, hwy)) + geom_point() + facet_grid(rows = vars(year), cols = vars(fl))

# 2. facet_wrap
ggplot(mpg, aes(cty, hwy)) + geom_point() + facet_wrap(vars(fl))

  ggplot(mpg, aes(cty, hwy)) + geom_point() + facet_grid(cols = vars(fl), labeller = label_both)

# 1. geom 함수를 여러 개 사용하고 싶은 경우, ggplot main function에 aes 를 적용해야 함
# 막대 그래프 경우
ggplot(data = (iris %>%  group_by(Species) %>%  summarise_all(list(~ mean(., na.rm = T)))),
       aes(x = Species, y = Sepal.Length, fill = Species)
) + geom_col(alpha = 0.7) + geom_label(mapping = aes(label = Sepal.Length), fill = 'white')

