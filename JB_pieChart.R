# Pie Chart 그리기
# 기본적으로 geom_bar를 가지고 pie chart를 그릴 수 있는데,
# coord_polar("y") option을 주면 pie chart를 그릴 수 있음

library(ggplot2)
library(dplyr)
test <- iris %>% group_by(Species) %>% summarise_all(list(count = ~ n()))

ggplot(data    = test,
       mapping = aes(x = "", y = Sepal.Length_count, fill = as.factor(Species))
       ) + geom_bar(width = 1, stat = 'identity') +  coord_polar("y") +
  geom_text(aes(label = paste0(Sepal.Length_count)),
            position = position_stack(vjust = 0.5)
            ) + scale_fill_discrete(name= 'Species 별 count 수')
                                                                        


            

