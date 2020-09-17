#################
## 연관성 분석 ##
#################
# 지지도(SUPPORT)
# 전체 거래에서 특정 물품 A와 B가 동시에 거래되는 비중
# 해당 규칙이 얼마나 의미가 있는 규칙인지를 보여줌

# 신뢰도(CONFIDENCE)
# A를 포함하는 거래 중 A와 B가 동시에 거래되는 비중
# A라는 사건이 발생했을 때 B가 발생할 확률이 얼마나 높은지를 말해줌

# 향상도(LIFT)
# A와 B가 동시에 거래된 비중을 A와B가 서로 독립된 사건일때 동시에 거래된 비중으로 나눈 값
# A와 B사이에 아무런 관계가 상호 관계가 없다면 향상도는 1이 됨
#  향상도가 1보다 높아질 수록 이 규칙은 우연히 일어나지 않았다는 강한 표시가 될 수 있음

######################
## 연관성 분석 예제 ##
######################

read.transactions(
  file,                         # file : file name 
  # format : data set의 형식 지정(basket 또는 single) 
  # -> single : 데이터 구성(2개 칼럼) -> transaction ID에 의해서 상품(item)이 대응된 경우 
  # -> basket : 데이터 셋이 여러개의 상품으로 구성 -> transaction ID 없이 여러 상품(item) 구성 
  format=c("basket", "single"), 
  sep  = NULL,                  # sep : 상품 구분자 
  cols = NULL,                  # cols : single인 경우 읽을 컬럼 수 지정, basket은 생략(transaction ID가 없는 경우) 
  rm.duplicates = FALSE,        # rm.duplicates : 중복 트랜잭션 항목 제거 
  encoding = "unknown"          # encoding : 인코딩 지정 
  )

## 연관성 규칙 분석을 위한 패키지 
install.packages("arules") # association Rule 
# read.transactions(),  apriori(), Adult 데이터셋 제공 
library(arules) #read.transactions()함수 제공 

tran <- arules::read.transactions("tran.txt", format="basket", sep=",") 
inspect(tran) 

rule <- apriori(tran, parameter = list(supp=0.3, conf=0.1)) # 16 rule 
rule <- apriori(tran, parameter = list(supp=0.1, conf=0.1)) # 35 rule  
inspect(rule) # 규칙 보기 

rule <- apriori(tran)  
