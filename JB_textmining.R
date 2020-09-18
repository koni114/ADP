#####################
### 텍스트 마이닝 ###
#####################

# 텍스트 마이닝은 문서와 단어를 가공하여 다음과 같은 분석 수행 가능
# - 단어의 빈도 분석 -> 워드 클라우드
# - 문서/단어의 군집 분석
# - 문서별 감성 분석
# - 단어의 연관 분석

###—————————————————————————–
### Corpus 생성

library(tm)
lines <- readLines("review.txt")
lines <- head(lines, 100)
doc   <- tm::Corpus(VectorSource(lines))

lines <- c("You're awe some and I love you", 
           "I hate and hate and hate. So angry. Die!",
           "Impressed and amazed: you are peer less in your achievement of unparalleled mediocrity.", 
           "I love you")
doc   <- tm::Corpus(VectorSource(lines))

#— Vector에 저장된 Text 읽기
lines <- c("This   is a text", "This another one.", "My name is Eric", 
           "Fuzzy Analysis Clustering", "Computes a fuzzy clustering of the data into k clusters.")
doc   <- tm::Corpus(VectorSource(lines))

#— Text 파일 읽기
folder <- system.file("texts", "txt", package = "tm")
doc    <- tm::Corpus(DirSource(folder), readerControl = list(language = "lat"))

#— XML 파일 읽기
folder <- system.file("texts", "crude", package = "tm")
doc    <- tm::Corpus(DirSource(folder), readerControl = list(reader = readReut21578XML))

###—————————————————————————–
### Corpus 조회
summary(doc)
doc[[1]]                                #— 첫번째 문서 조회
inspect(doc[1])                         #— 첫번째 문서 조회

#writeCorpus(doc)                        #— Corpus 저장
#writeCorpus(doc[1], filenames="01.txt") #— 첫번째 Corpus 저장


###—————————————————————————–
### Corpus 변환
(doc <- tm_map(doc, as.PlainTextDocument))[[1]]                #— XML 문서를 Text로 변환
(doc <- tm_map(doc, stripWhitespace))[[1]]                     #— 두개 이상의 공백을 하나의 공백으로 치환
(doc <- tm_map(doc, tolower))[[1]]                             #— 소문자로 변환
(doc <- tm_map(doc, removePunctuation))[[1]]                   #— 구두점 삭제
(doc <- tm_map(doc, removeWords, stopwords("english")))[[1]]   #— Stopword (조사, 띄어쓰기, 시제 등)를 제거하고 표준화
(doc <- tm_map(doc, stripWhitespace))[[1]]                     #— 두개 이상의 공백을 하나의 공백으로 치환
(doc <- tm_map(doc, stemDocument))[[1]]                        #— 어근만 추출
# (doc1 <- tm_map(doc, removeNumbers))[[1]]                       #— 숫자 삭제
#removeURL <- function(x) gsub("http[[:alnum:]]*", "", x)
#(doc <- tm_map(doc, removeURL))[[1]]                           #— URL 삭제
#rm(removeURL)
#(doc <- tm_map(doc, gsub, pattern = "diamond", replacement = "aaa"))[[1]]   #— 문자열 치환
#(doc <- tm_map(doc, stemCompletion, dictionary = doc))[[1]]                 #— 어근으로 원래 단어 유추
test <- inspect(doc)

###—————————————————————————–
### DocumentTermMatrix / TermDocumentMatrix
#— Non-/sparse entries : 단어가 있는 entry / 단어가 없는 entry
(m <- DocumentTermMatrix(doc))          #— DocumentTermMatrix 생성

dic <- c("prices", "crude", "oil")      #— 여기 기술된 단어를 포함하는 모델 생성
(m <- DocumentTermMatrix(doc, list(dictionary = dic)))

(m <- TermDocumentMatrix(doc))          #— TermDocumentMatrix 생성
(m <- t(m))                             #— DocumentTermMatrix로 변환
(data <- as.matrix(m))                  #— DocumentTermMatrix를 matrix로 변환

m$nrow                                  #— 문서 (document) 개수 / 단어 (term) 개수
m$ncol                                  #— 단어 (term) 개수 / 문서 (document) 개수
m$dimnames                              #— 문서 (document)와 단어 (term) 목록
m$dimnames$Docs
m$dimnames$Terms
m$i                                     #— 문서 (document) 인덱스 / 단어 (term) 인덱스
m$j                                     #— 단어 (term) 인덱스 / 문서 (document) 인덱스
m$v                                     #— m$i[0] 문서에서 m$j[0] 단어의 발생 빈도
inspect(m)                              #— 단어의 분포를 확인
inspect(m[1:2, 3:5])                    #— 처음 2개 문서의 3번째에서 5번째 단어의 분포를 확인

findFreqTerms(m, 3)                     #— 3회 이상 사용된 단어 표시
findFreqTerms(m, 10, 15)                #— 10회 이상, 15회 이하 사용된 단어 표시
findAssocs(m, "oil", 0.65)              #— "oil" 단어와 연관성(같이 사용될 확률)이 65% 이상이 단어를 표시
rm(dic)

(frequency <- colSums(data))            #— 단어별 발생 건수 계산
(frequency <- subset(frequency, frequency >= 5))   #— 3건 이상 발생한 단어 추출

# library(gdata)
frequency <- as.data.frame(available.packages())   #— 패키지 목록 추출
frequency <- gdata::trim(unlist(strsplit(as.character(frequency$Depends), ',')))
frequency <- gsub('[ \(].*|\n', '', frequency) #— 다양한 문자 부호 제거
frequency <- table(frequency)                  #— 단어의 빈도수 테이블

library(ggplot2)
barplot(frequency, las = 2)

library(wordcloud) #— 워드 클라우드
wordcloud(names(frequency), as.numeric(frequency), colors = c("green", "red"))
wordcloud(names(frequency), log(as.numeric(frequency)), colors = c("green", "red"))

###—————————————————————————–
### 문서의 군집 분석
## k-means를 통한 군집 분석
fit <- hclust(dist(scale(data)), method = "ward.D2")
plot(fit)
rect.hclust(fit, k = 3)                 #— 5개의 그룹으로 구분
(groups <- cutree(fit, k = 3))          #— 문서별로 그룹 지정
rm(fit, groups)

(kmeansResult <- kmeans(m, k))          #— k-평균 군집 모형
for (i in 1:k) {
  cat(paste("cluster", i, ": ", sep = ""))
  s <- sort(kmeansResult$centers[i,], decreasing = T)
  cat(names(s), "n")
}

# PAM 군집 분석
library(fpc)
(pamResult <- pamk(m, metric = "manhatttan"))
(k <- pamResult$nc)

(pamResult <- pamResult$pamobject)
for (i in 1:k) {
  cat(paste("cluster", i, ": "))
  cat(colnames(pamResult$medoids)[which(pamResult$medoids[i, ] == 1)], "n")
}

###—————————————————————————–
### 감성 분석
###—————————————————————————–
#— 문장을 입력받아 문장과 점수를 반환
#— 점수 = 긍정 점수 – 부정 점수
#—     긍정 점수 : 긍정 단어 (pos.words)가 포함된 개수
#—     부정 점수 : 부정 단어 (neg.words)가 포함된 개수
(pos.word <- scan("data/ADV_4_5_positiveWords.txt", what = "character", comment.char = ";"))   #— 긍정 단어
(pos.words <- c(pos.word, "upgade"))
(neg.word <- scan("data/ADV_4_5_negativeWords.txt", what = "character", comment.char = ";"))   #— 부정 단어
(neg.words <- c(neg.word, "wait", "waiting"))

scores <- function(sentences, pos.words, neg.words, .progress='none') { #— 점수와 문장을 반환
  require(plyr)
  require(stringr) 
  scores = laply(
    sentences, 
    function(sentence, pos.words, neg.words) {
      sentence = gsub('[[:punct:]]', '', sentence)   #— 구두점 삭제
      sentence = gsub('[[:cntrl:]]', '', sentence)   #— 특수기호 삭제
      sentence = gsub('\d+', '', sentence)             #— 숫자 삭제
      sentence = tolower(sentence)                   #— 소문자로 변환
      
      word.list = str_split(sentence, '\s+')        #— 하나 이상의 공백으로 단어 추출
      words = unlist(word.list)                      #— list를 벡터로 변환
      
      pos.matches = match(words, pos.words)          #— 긍정의 점수 계산 (긍정 단어와 매핑되는 개수 산정)
      pos.matches = !is.na(pos.matches)
      neg.matches = match(words, neg.words)          #— 부정의 점수 계산 (부정 단어와 매핑되는 개수 산정)
      neg.matches = !is.na(neg.matches)     
      score = sum(pos.matches) - sum(neg.matches)
      return (score)
    }, 
    pos.words, neg.words, .progress=.progress
  )
  scores.df = data.frame(score=scores, text=sentences)
  return(scores.df)
}

(result <- scores(lines, pos.words, neg.words))
library(ggplot2)
qplot(result$score)
hist(result$score)

###—————————————————————————–
### 연관 분석
###—————————————————————————–
library(KoNLP)
extractNoun("연습을 해보고자 한다. 명사가 잘 추출되는지 보자. 빨간색으로 글씨를 쓴다.")
system.time(nouns <- sapply(head(lines, 1000), extractNoun, USE.NAMES = FALSE))

(data <- Map(extractNoun, lines))       #— 각 문장에서 명사 추출 (문장 -> 문자열 목록)
(data <- unique(data))[[1]]             #— 라인별 데이터를 unique하게
(data <- sapply(data, unique))[[1]]     #— 각 라인내 데이터를 unique하게
(data <- sapply(data, function(x) {     #— 2자 이상 4자 이하의 한글 단어 추출
  Filter(function(y) {
    nchar(y) <= 4 && nchar(y) > 1 && is.hangul(y)
  },
  x)
}))

(names(data) <- paste("Tr", 1:length(data), sep = ""))   #— 데이터에 행 이름 지정
data

library(arules)
(data <- as(data, "transactions"))
dataTab <- crossTable(data)

#— 빈도수 5%, 같이 있을 확률이 10%인 단어 목록 추출
#—     최소지지도 5% 이상, 최소신뢰도 10% 이상인 연관 규칙 탐색
(m <- apriori(data, parameter = list(supp = 0.05, conf = 0.1))) 
inspect(m)

