setwd("C:/ADP자료/")
library(readr)
library(dplyr)
encoding_type <- readr::guess_encoding(file = "housing.csv")[1,1] %>%  as.character

## 데이터 로딩 방법 3가지
### 1. data.table::fread
housing <- data.table::fread(  file       = 'housing.csv'
                  , data.table = F
                  , header = F
                  , stringsAsFactors = F
                  , na.strings = c("NA", "NaN", "\\n"))

head(housing)

### 2. readr::read_csv(encoding 문제가 있는 경우,)
housing <- readr::read_csv(file = 'housing.csv',
                col_names       = F,
                locale          = locale('ko', encoding = encoding_type), 
                na              = c("NA", "NaN", "\\n")
                ) %>%  data.frame


### 3. excel loading
library(readxl)
example <- readxl::read_xls(path = "example.xls",
                 col_names = T
                 ) %>% data.frame()

example <- example[,-1]

test <- read.table(file = 'test.txt',
           sep = " ",
           header = T)













