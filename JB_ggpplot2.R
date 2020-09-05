## ggplot2 기본 기능

## ggplot2 설치 
install.packages("ggplot2")
library(ggplot2)

## (1) 필수 메인 함수 ggplot ----
# data = 데이터
# mapping = aes(x = x축변수, y = y축변수)

ggplot(data    = iris,
       mapping = aes(x = Sepal.Length, y = Sepal.Width))

## (2) 그래프 그리기 함수 - geom_그래프 계열 ---- 
#  산점도/산포도 geom_point()
#  선그래프      geom_line()
#  박스플롯      geom_boxplot()
#  히스토그램    geom_histogram()
#  막대그래프    geom_bar()

ggplot(data    = iris,
       mapping = aes(x = Sepal.Length,
                     y = Sepal.Width)) + geom_point()

## (3) 그래프에 대한 색상, 모양, 크기, 넓이 지정하기 ---- 
# size 크기, pch 모양(0 ~ 127), colour 색상
ggplot(data    = iris,
       mapping = aes(x = Sepal.Length, y = Sepal.Width)) + geom_point(  colour = "red"
                                                                      , pch    = 2
                                                                      , size   = 2)

## (4) 그룹별 옵션 지정 ----
#  단 색상 지정 순서는 levels(iris$Species) 순서로 지정됨
ggplot(data    = iris,
       mapping = aes(x = Sepal.Length, y = Sepal.Width)) + geom_point(  colour = c('red', 'green', 'blue')[iris$Species]
                                                                      , pch    = c(0, 2, 20)[iris$Species]
                                                                      , size   = c(1, 1.5, 2)[iris$Species])


## (5) 그래프에 도형 그리기 ----
#      그래프를 그리고서 도형으로 사각형으로 특정 구역을 표시하거나 선으로 임계치를 표시하고 싶을 때 사용

# 5.1 geom_도형 계열 사용
# 선      geom_abline()
# 평행선  geom_hline()
# 수직선  geom_vline()
# 사각형  geom_rect()
# 텍스트  geom_text()

# 5.2 annotate() 함수 사용
p1 <- ggplot(data    = iris,
            mapping = aes(x = Sepal.Length, y = Sepal.Width)) + geom_point(  colour = c('red', 'green', 'blue')[iris$Species]
                                                                             , pch    = c(0, 2, 20)[iris$Species]
                                                                             , size   = c(1, 1.5, 2)[iris$Species])

# Species가 모두 겹치는 부분을 사각형으로 표기하기
# 1. Species 별 Sepal.Length, Sepal.Width의 최소값과 최대값을 tmp에 할당
# geom   = "도형종류" 
# xmin   = 왼쪽 아래 x좌표 
# xmax   = 오른쪽 위 x좌표 
# ymin   = 왼쪽 아래 y좌표 
# ymax   = 오른쪽 위 y좌표 
# fill   = "채우기 색" 
# alpha  = 투명도 
# colour = "선색" 
# lty    = 선종류

library(dplyr)
colnames(iris)
iris_summary <- iris %>% select(Sepal.Length, Sepal.Width, Species) %>%  group_by(Species) %>% summarise_all(list(  min = ~ min(., na.rm = T)
                                                                                                  , max = ~ max(., na.rm = T)))
start_x <- max(iris_summary$Sepal.Length_min)
end_x   <- min(iris_summary$Sepal.Length_max) 
start_y <- max(iris_summary$Sepal.Width_min)
end_y   <- min(iris_summary$Sepal.Width_max) 

p <- p1 + annotate(  geom = "rect"
                  , xmin = start_x
                  , xmax = end_x
                  , ymin = start_y
                  , ymax = end_y
                  , fill = "red"
                  , alpha = 0.2
                  , colour = "black"
                  , lty    = 2)


# annotate function은 geom 옵션으로 어떤 도형을 그릴 것인지 결정하고,
# 그에 따라서 세부옵션이 따라 붙음

# 점선 긋기
p <- p1 + annotate(  geom = "segment"
             , x    = c(start_x, end_x, -Inf, -Inf)
             , xend = c(start_x, end_x, Inf, Inf)
             , y    = c(-Inf, -Inf, end_y, start_y)
             , yend = c(Inf, Inf, end_y, start_y)
             , colour = "black", alpha = 0.5, lty = 2, size = 1)

# 행 번호로 label 붙이기
# geom   = "도형종류" 
# x      = x좌표 
# y      = y좌표 
# colour = "글씨색" 
# alpha  = 투명도 
# size   = 글씨크기 
# hjust  = x축 영점 조절 
# vjust  = y축 영점 조절

p <- p1 + annotate( geom    = "text"
             , x      = iris$Sepal.Length
             , y      = iris$Sepal.Width
             , label  = rownames(iris)
             , colour = "brown"
             , alpha  = 0.7
             , size   = 3
             , hjust  = 0.5
             , vjust  = -1)


# 외부 옵션 함수 - coord 계열, labs 등
# 축이나 그래프 외부 공간에 옵션을 추가하는 경우 사용

# x,y축 스왑 : coord_flip()
p <- p1 + coord_flip()

# 축 범위    : coord_cartesian()
p <- p1 + coord_cartesian(  xlim = c(start_x, end_x)
                          , ylim = c(start_y, end_y ))


# 라벨링     : labs()
# title    : 제목
# subtitle : 부제목
# caption  : 주석
# x        : x축 이름
# y        : y축 이름

p1 + labs(  title    = "제목"
          , subtitle = "부제목"
          , caption  = "주석"
          , x        = "x축이름"
          , y        = "y축이름")


# (5) 시계열 그래프

# 1. iris data에 seq 붙이기
data        <- dplyr::bind_cols(data.frame("seq" = 1:nrow(iris)), iris)
cols        <- topo.colors(4, alpha = 0.5)
names(cols) <- names(data)[2:5] 

# 2. 그래프를 위한 데이터 변환
library(reshape2)
melt_data <- melt(data, id.vars = c("seq", "Species"))

# 3. 그룹별 시계열 그래프 생성
library(ggplot2)
head(melt_data)
g1 <- ggplot(melt_data) + geom_line(aes(x = seq, y = value, colour = variable), cex = 0.8, show.legend = T)

# 4. 선 색상, 라벨링 수행
g <- g1 + scale_color_manual( name   = "변수명"
                            , values = cols[melt_data$variable]
                            , labels = c('꽃받침 길이', "꽃받침 너비", "꽃잎 길이", "꽃잎 너비"))

## * 알아둘 것
## ggplot2는 for문에서 정상적으로 작동하지 않음



ㄴ












