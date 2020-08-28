## 데이터 저장하기
## txt file로 저장 ---
data <- iris
write.table(
      x         = data                  # 저장할 data object
    , file      = "C:/ADP자료/test.txt" # 저장 경로
    , row.names = F  # 행 이름이 있는 경우, T
    , quote     = F  # TRUE인 경우, 행 번호 추가
    , append    = F  # txt file에 붙여넣을 경우,
    , na = c("NA")   # 결측인 경우 해당 문자열로 대체 가능
)

