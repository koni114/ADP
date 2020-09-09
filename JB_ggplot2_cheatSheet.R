
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
# Aesthetics
#' @param : x     : x축, 필수
#' @param : y     : y축, 필수
#' @param : alpha : 투명도
#' @param : colour : 색상
#' @param : group : 선 연결시 그룹핑 해주고자 하는 그룹을 말함
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
# geom_abline(aes(intercept, slope)), geom_hline(aes(yintercept)), geom_vline(aes(xintercept))
# 일차 선분을 그래프 위에 그려주는 함수
# * 앞에 geom_point 을 그리고, geom_abline을 그리려고 한다면? 
ggplot(seals, aes(x = long, y = lat )) + geom_abline(aes(intercept = 0, slope = 1))
ggplot(seals, aes(x = long, y = lat )) + geom_hline(aes(yintercept = lat))
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
# 연속형 데이터의 분포를 점 plot으로 표기해주는 그래프 함수 
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
