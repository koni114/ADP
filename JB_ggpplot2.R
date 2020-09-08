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

###########################
#### (5) 시계열 그래프 ####
###########################

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



############################
#### (6) 범례 수정하기 #####
############################

## theme() function

#  범례 아래로 이동하기
#  legend.position = 'bottom'

#  범례 표시하지 않기    
#  guides(fill="none")

#  범례의 제목 및 항목명 변경하기
#  scale_color_manual : 점, 선 그래프
#  scale_fill_manual  : 막대 그래프
ggplot(data=mtcars) +
  geom_bar(mapping = aes(x = cyl, fill = as.factor(am)), position = "dodge") + 
  theme(legend.position = "bottom") + 
  scale_fill_manual(values = c("red","green"),
                    name   = ("범례제목"),
                    breaks = c(0,1),
                    labels = c("값1","값2"))      


# scale_fill_discrete : 간단한 범례 제목, label 변경시 사용
ggplot(data=mtcars) +
  geom_bar(mapping = aes(x = cyl, fill = as.factor(am)), position = "dodge") + 
  theme(legend.position = "bottom") + scale_fill_discrete(name= '범례제목', labels = c('값1', '값2'))

# 레이블 표시하기
# geom_text function 사용
# check_overlap = T 로 설정하면 겹치는 text에 대해서 안보이게 설정 가능

ggplot(data=mtcars, mapping = aes(x=hp, y=mpg)) + 
  geom_point(aes(color=as.factor(am))) +
  geom_text(aes(label=rownames(mtcars)), check_overlap = T)

# args function
# args function을 이용하면, 해당 함수의 pararmeter 정보를 확인 가능

args(geom_histogram)

############################
#### (7) ggplot2 - STAT ####
############################
# Statistical Transformations(줄여서 STAT)
# 다음과 같은 경우 명시적으로 STAT을 별도로 지정해 주어야 함

# 1) default STAT 대신에 다른 것을 쓰고 싶을 때
# 예를들어 히스토그램에서 빈도수 대신에 밀도를 보여주고 싶다면, default ..count.. 대신 ..density.. 사용
ggplot(data = mtcars, mapping = aes(x=cyl)) + 
  geom_histogram(mapping = aes(y=..density..), binwidth=1)

# 2) 계산된 통계값인 STAT이 아닌, 데이터셋에 있는 변수로 그래프를 직접 그리고자 할 때
# 예를들어 geom_bar()은 기본 y축 STAT이 count 임
# 그런데, 데이터에 있는 다른 지표로 그래프를 그리고자 할때 사용

name  <- c('a', 'b', 'c')
value <- c(80, 90, 100) 
dd    <- data.frame(name, value)

# stat="identity" 는 geom_bar의 STAT 값을 원데이터셋에 있는 값으로 쓰겠다는 것을 설정하는 의미
# stat_count에서 계산된 변수가 아니므로 앞 뒤로 .. 을 붙이지 않음
ggplot(data = dd, mapping = aes(x = name, y = value)) + geom_bar(stat="identity")

################################
#### (8) ggplot2 - POSITION ####
################################

# position : 그래프를 그릴 때 요소들의 위치에 대한 수정을 의미
#            엑셀에서 막대 그래프를 그릴 때 누적 그래프 여부, 그래프 겹치게 할 것인지의 여부 등..

# ggplot2  : POSITION --> dodge, fill, identity, fitter, stack 5개의 종류로 구성

# 1). stack : 누적 막대 그래프를 그려줌
ggplot(data = mtcars) + geom_bar(mapping  = aes(x=cyl, fill = as.factor(am)),
                                 position = 'stack')
 

# 2). dodge : 옆으로 겹치지 않게 그래프 그림
ggplot(data = mtcars) + geom_bar(mapping  = aes(x=cyl, fill = as.factor(am)),
                                 position = 'dodge')

# 3). fill  : 100% 기준 누적 막대 그래프를 그림. 세로 축의 count 값 1을 기준으로 그래프가 그려져 있음
ggplot(data = mtcars) + geom_bar(mapping  = aes(x=cyl, fill = as.factor(am)),
                                 position = 'fill')

# 4). identity : 위치 조정을 적용하지 않고, 그래프를 겹쳐서 막대 그래프를 그림
ggplot(data=mtcars) + geom_bar(mapping = aes(x=cyl, fill=as.factor(am))
                               , position = "identity")

# 5). jitter : 값들이 겹치지 않도록 값을 조금씩 움직이는 것을 말함
#               범주형 자료가 아닌 연속형에서 주로 쓰이며 아래에서 보듯이 막대 그래프 X

# jitter를 적용하지 않으면, 범주형 변수가 x일때 그래프가 겹쳐져 있음을 알 수 있음
ggplot(data=mtcars) +
  geom_point(mapping = aes(x=as.factor(cyl), y=mpg))

# jitter 를 적용하면 조금씩 겹쳐지지 않게 그래프를 그려줌을 알 수 있음
ggplot(data=mtcars) +
  geom_point(mapping = aes(x=as.factor(cyl), y=mpg), position = "jitter")

##################################
#### (9) ggplot2 - COORDINATE ####
##################################

# COORDINATE : x축과 y축을 바꾸거나, 축의 값을 log 등으로 변환

# 1) coord_flip()  : x축 <--> y축
ggplot(data=mtcars) +
  geom_bar(mapping = aes(x=cyl, fill=factor(am)), position="dodge") + coord_flip()

# 2) coord_polar() : 극좌표계 이용
#  막대 그래프를 나이팅게일 차트(coxcomb chart)로 변환할 수 있음
ggplot(data=mtcars) +
  geom_bar(mapping = aes(x=cyl, fill=as.factor(cyl)), position="dodge") + 
  coord_polar()

# 3) coord_trans() : 변수 변환(log 등)
#    ggplot2에서는 coord_trans() 함수를 통해서 변수의 직접 변환 없이 변환된 그래프를 그릴 수 있음
x   = c(-10:10)
aa  = c(-10:10)
bb  = aa^2
ccc = data.frame(aa,bb)

# bb 변수를 sqrt() 함수로 직접 제곱근 처리 하였다면
# 다음과 같은 결과를 얻을 수 있음
ggplot(data = ccc, mapping = aes(x = aa, y = bb)) + geom_point() + coord_trans(y="sqrt")

##################################
###### (10) ggplot2 - FACET ######
##################################

# FACET - 범주형 자료 분석시 아주 편리하게 이용
# 범주형 변수 별로, 각기 다른 위치에 그래프를 그려줌

# facet_wrap(), facet(grid) 함수가 주로 쓰임
# 두 함수 모두 첫번째 인수는 ~(물결무늬)가 포함된 형식

# 1) facet_wrap 함수
# ~ 오른쪽에 기재되는 변수별 level 별로 그래프를 각각 그려줌
ggplot(data=mtcars, mapping = aes(x=hp, y=mpg)) + 
   geom_point() + 
   facet_wrap(~cyl)

# cyl + am 별 그래프 각각 그려줌

ggplot(data=mtcars, mapping = aes(x=hp, y=mpg)) + 
  geom_point() + 
  facet_wrap(~cyl+am, labeller = label_both)

# nrow parameter 를 적용하여 grid 배치를 조정할 수 있음


# 2) facet_grid() 함수
#  함수 안의 ~ 좌/우 변수를 각각 행/열로 나누어 2차원으로 sub그래프
ggplot(data=mtcars, mapping = aes(x=hp, y=mpg)) + 
  geom_point() + 
  facet_grid(am~cyl)

##################################
###### (11) ggplot2 - SCALE ######
##################################

# SCALE : 데이터 값들을 미적요소의 시각화 요소들로 매핑하는 것을 말함
# 그래프의 축, 색, 범례 등에 해당하는 부분

# SCALE 함수는 다음과 같은 형식을 따름
# scale + _ + aesthetic 객체명(x,y, fill, shape 등) + _ + scale명(discrete, continuous, date, gradient 등) 이 붙음

# 1) 축 눈금 변경 : scale_x_continuous() 함수의 breaks 옵션 및 labels 옵션
ggplot(data=mtcars, mapping = aes(x=hp, y=mpg)) + 
  geom_point(aes(color=as.factor(am))) + scale_x_continuous(breaks = seq(0, 350, by = 50))

# breaks = NULL 이라고 설정하면, 눈금이 아예 보이지 않음
ggplot(data=mtcars, mapping = aes(x=hp, y=mpg)) + 
  geom_point(aes(color=as.factor(am)))+ scale_x_continuous(breaks=NULL) + scale_y_continuous(breaks=NULL)

# labels = NULL 이라고 설정하면, x,y축 눈금을 지울 수 있음
ggplot(data=mtcars, mapping = aes(x=hp, y=mpg)) + 
  geom_point(aes(color=as.factor(am))) + scale_x_continuous(labels = NULL) + scale_y_continuous(labels=NULL)

# labels, breaks 옵션을 활용하면 x,y축 적용 가능
ggplot(data=mtcars, mapping = aes(x=hp, y=mpg)) + 
  geom_point(aes(color=as.factor(am))) + scale_y_continuous(labels = c('a', 'b', 'c'),
                                                            breaks = c(10, 20, 30)) + scale_x_continuous(labels = c('1st', '2nd', '3rd'),
                                                                                                            breaks = c(100, 200, 300))
# dollar($), percent(%) 적용
ggplot(data=mtcars, mapping = aes(x=hp, y=mpg)) + 
  geom_point(aes(color=as.factor(am))) + scale_y_continuous(labels = scales::dollar) + scale_x_continuous(labels = scales::percent)


# 2) 데이터 변환 : scale_x_sqrt() 등
# sqrt, log10, reverse 등 변환 함수 사용 가능

# 3) 자동 색상 변경 : scale_color_brewer() --> 산점도, 선그래프
#                     scale_fill_brewer()  --> default로 제시되는 그래프의 색상을 변경할 수 있음

# Rcolorbrewer에서 제공되는 색상 확인 가능
RColorBrewer::display.brewer.all()

# scale_color_brewer 내 parette parameter 이용
# 일반적으로 level이 4 ~ 5개 이상인 경우 유용
ggplot(data=mtcars, mapping = aes(x=hp, y=mpg)) + 
  geom_point(aes(color=as.factor(am))) + scale_color_brewer(palette = "Accent")


# 4) 수동 색상 변경 : scale_color_manual()
#                   : scale_fill_manual()
ggplot(data=mtcars, mapping = aes(x=hp, y=mpg)) + 
  geom_point(aes(color=as.factor(am))) + scale_color_manual(values = c('blue', 'green'))

# 5) 범례의 명칭, 순서 및 항목명 변경
# names : 범례 이름, labels : 범례의 항목명 변경
ggplot(data=mtcars, mapping = aes(x=hp, y=mpg)) + 
  geom_point(aes(color=as.factor(am))) +
  scale_color_manual(values = c("Green","Red"), 
                     name = "Transmission",
                     labels = c("Auto","Manual"))


# ** 범례의 표시 순서를 바꾸고 싶은 경우, breaks parameter 사용
ggplot(data=mtcars, mapping = aes(x=hp, y=mpg)) + 
  geom_point(aes(color=as.factor(am))) +
  scale_color_manual(values = c("Green","Red"), 
                     name = "Transmission",
                     breaks = c(1, 0),
                     labels = c("Manual","Auto"))

# 6) 표식의 형태 및 크기 변경
#    표식의 형태 : scale_shape_manual()
#    표식의 크기 : scale_size_manual()

ggplot(data=mtcars, mapping = aes(x=hp, y=mpg)) + 
  geom_point(aes(shape=as.factor(am))) + 
  scale_shape_manual(values=c(15, 17))

ggplot(data=mtcars, mapping = aes(x=hp, y=mpg)) + 
  geom_point(aes(shape=as.factor(am), size=as.factor(am), color=as.factor(am))) + 
  scale_shape_manual(values = c(15, 17)) + 
  scale_size_manual(values = c(4,5))


