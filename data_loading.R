## data loading
setwd("C:/r")

### 0. encoding check
library(readr)
enco <- readr::guess_encoding("Boston_Housing.csv")[1,1] %>% as.character()
print(paste0("enco: ", enco))

### 1. csv loading. fread 함수를 통한 data loading
library(data.table)
bh <- data.table::fread(  file   = "Boston_Housing.csv"
                        , header = T
                        , stringsAsFactors = F
                        , data.table = F
                        , na.strings = c("NA", "NaN", "NULL", "\\N"))

# 2. excel loading.
# read_xls function이 xls loading중에 가장 빠르다고 알려져 있음
library(readxl)
rxls <- readxl::read_xls(  path  = "file_example_XLS_5000.xls" 
                 , sheet = NULL
                 , col_names = TRUE
                 , col_types = NULL
                 , na = c("NA", "NaN", "NULL", "\\N")
                 )

### excel loading시, ecoding 문제 해결 방법.
## readr::read_csv function 이용. 
library(readr)
library(dplyr)
rxls <- readr::read_csv(  file      = "Boston_Housing.csv"
                        , col_names = T
                        , locale    = locale("ko", encoding = enco)) %>% data.frame


strptime(202008, format= '%Y%m')

### 3. tab

