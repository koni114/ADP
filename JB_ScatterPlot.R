## 산점도 
library(ggplot2)
colnames(iris)

p <- ggplot(data = iris,
       mapping = aes(x = Sepal.Length, y = Sepal.Width)
       ) + geom_point(colour = c('red', 'green', 'blue')[iris$Species])

# 그룹별(Species) 산점도 각각 그리고 싶을 때,
p <- ggplot(data = iris,
            mapping = aes(x = Sepal.Length, y = Sepal.Width)) + geom_point() + facet_grid(Species ~.)
            




