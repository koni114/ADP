## 산점도 
library(ggplot2)
colnames(iris)

## 산점도 그리기 
# 1. geom_point function
# color         -> box의 테두색 색상 지정 가능
# outlier.color -> NULL로 지정하면 outlier.color없 없어짐. 따로 지정도 가능

p <- ggplot(data    = iris,
            mapping = aes(x = Sepal.Length, y = Sepal.Width)
       ) + geom_point(colour = c('red', 'green', 'sblue')[iris$Species])


# 그룹별(Species) 산점도 각각 그리고 싶을 때,
p <- ggplot(data = iris,
            mapping = aes(x = Sepal.Length, y = Sepal.Width)) + geom_point() + facet_grid(Species ~.)
            

# 3. 산점도에 추세선 그리기
#  stat_smooth(method = 'lm')
p1 <- p + stat_smooth(method ='lm', se = F, color = 'black ')

# 4. 산점도에 text 추가하기
p2 <- p1 + geom_text(x = 45, y = 450
                     , label = 'y=6.452x-18.142') +  geom_text(x = 85, y = 405, label="R²=0.8917")
    

# 5. 조건별 산점도 색깔을 변경하고 싶을 때,
# --> Sepal.Length 가 5보다 작으면 red, 크거나 같으면 blue로 setting
ggplot(data    = iris,
       mapping = aes(x = Sepal.Length, y = Sepal.Width)
       ) + geom_point(aes(color = ifelse(Sepal.Length < 5, 'a', 'b'))
                      ) +   scale_color_manual(values = c('red', 'blue'),
                                               name   = c("범례제목"),
                                               labels = c('label1', 'label2')
                                               ) 
ggplot(data    = iris,(x = Sepal.Length, y = Sepal.Width)
       mapping = aes
) + geom_point(aes(color = ifelse(Sepal.Length < 5, 'a', 'b'))) +  guides(fill="none")


