#################
# 데이터 인코딩 #
#################

library(MASS)
library(dplyr)

#####################
# 1. label encoding #
#####################

# 1.1 CatEncoders::LabelEncoder.fit function 이용 ----
library(CatEncoders)
Cars93_fac <- Cars93 %>% select_if(is.factor)
test       <- Cars93_fac[c(5,6)]

for(i in colnames(test)){
  encode   <- CatEncoders::LabelEncoder.fit(test[,i])
  test[,i] <- CatEncoders::transform(encode, test[,i])
}


# 1.2 revalue function 이용 ----
library(plyr)
Cars93_fac <- Cars93 %>% select_if(is.factor)
test       <- Cars93_fac[c(5,6)]

levels(test[,1])
DriveTrain_encoder <- c('4WD'   = 1,
                        'Front' = 2,
                        'Rear'  = 3)

test[,1] <- plyr::revalue(test[,1], DriveTrain_encoder)

#######################
# 2. one-hot encoding #
#######################

# 2.1 caret::dummyVar function 이용 ----
library(caret)
Cars93_fac <- Cars93 %>% select_if(is.factor)
dmy        <- caret::dummyVars("~ .", data = Cars93_fac[,c(5,6)])
trsf       <- data.frame(predict(dmy, Cars93_fac[,c(5,6)]))


# 2.2  model.matrix function 이용 ----
Cars93_fac <- Cars93 %>% select_if(is.factor)
colnames(Cars93_fac)
DriveTrain_encoder <- model.matrix( ~ DriveTrain, data = Cars93_fac)[,-1]
oneHotencoder      <- model.matrix( ~ DriveTrain + Cylinders, data = Cars93_fac)[,-1]
Cars93_fac         <- cbind(Cars93_fac, DriveTrain_encoder)



