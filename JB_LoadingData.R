#####################
## 데이터 불러오기 ##
#####################
# 01. csv 불러오기      : data.table::fread
# 02. excel 불러오기    : read_excel
#                         readxl::read_xls(encoding 문제 있을 경우 사용)
# 03. tab, txt 불러오기 : read.table

setwd("C:/ADP자료")

### 0. encoding check
library(readr)
library(dplyr)
enco <- readr::guess_encoding("Boston_Housing.csv")[1,1] %>% as.character()
print(paste0("enco: ", enco))

### 1. csv loading. fread 함수를 통한 data loading ----
library(data.table)
bh <- data.table::fread(  file   = "Boston_Housing.csv"
                        , header = T
                        , stringsAsFactors = F
                        , data.table = F
                        , na.strings = c("NA", "NaN", "NULL", "\\N")
                        )

# 2. excel loading. ----
# cust_profile <- read_excel("C:/Users/Administrator/Documents/cust_profile.xlsx", # path
#                             sheet = "cust_profile", # 읽어올 sheet 명
#                             range = "B3:E8",        # cell 범위
#                             col_names = TRUE,       # 
#                             col_types = "guess",    # guess the types of columns
#                             na = "NA")              # Character vector of strings to use for missing values

# read_xls function이 xls loading중에 가장 빠르다고 알려져 있음
library(readxl)
rxls <- readxl::read_xls(  
  path  = "file_example_XLS_5000.xls"  
, sheet = NULL
, col_names = TRUE
, col_types = NULL
, na = c("NA", "NaN", "NULL", "\\N")
)

## 3. encoding 문제 있을 경우, 적용 ----
# readr::read_*(
#     file      = ""                  # file 경로
#     col_names =                     # T : header 있음, F : header 없음
#     col_types = NULL                # 각 컬럼마다 type을 지정할 수 있음. 
#                                     # c : 문자, i : 정수, n : 숫자, d : double 형, 
#                                     # I : 논리, D : 날짜, T :날짜 시간, t : 시간, ? = 추측, _ 또는 - : 건너띄기
#     locale    = default_locale()    # 위치에 따른 기본값 제어. 한국은 ko
#     na        = c("NA", "NULL")     # 지정하는 문자열을 NA 값으로 변경
#     comment   = ""                  # 해당 문자열 뒤에 오는 문자들은 주석 처리
#     trim_ws   =  T                  # 파싱전 앞뒤 공백 제거 여부
#     skip      =                     # 데이터를 읽을 때 제거하고자 하는 row index 입력 
#     n_max     = Inf                 # 데이터 로딩시 최대 몇줄까지 읽을 것인가 ?
#     guess_max = Inf                 # 열의 데이터 형을 정할 때 최대 몇번째 행까지 검토할 것인지?
#     progress  = interactive()       # 진행 바 표시 여부
# )

library(readr)
library(dplyr)
housing <- readr::read_csv("housing.csv"
                           , col_names = F
                           , col_types = NULL
                           , comment   = ""
                           , na        = c("NA", "NULL")
                           , locale    = locale("ko", encoding = data_encoding)
) %>%  data.frame



### 4. tab, txt 파일 인 경우, ----
abc <- read.table(  file   = "abc.txt"
                  , sep    = "\t"
                  , header = T 
) %>% data.frame()

### 5. 일정한 간격의 데이터를 쪼개서 가져오고 싶을 때, ----
#      --> read.fwf function
read.fwf(  file   = "data_fwf.txt"
         , widths = c(6,6,6)
         , col.names = c("Var_1", "Var_2", "Var_3"))


