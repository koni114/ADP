# time trend
library(reshape)
iris_seq  <- cbind("seq" = 1:nrow(iris), iris)
iris_seq  <- iris_seq[,c('seq', 'Sepal.Length', 'Petal.Length', 'Species')]
melt_data <- reshape::melt(data    = iris_seq, 
                           id.vars = c('Species', 'seq'))

ggplot(data    = melt_data,
       mapping = aes(x = seq, y = value, colour = variable)) + geom_line() + scale_color_discrete(  name  = '범례제목'
                                                                                                  , label = c('a', 'b'))







