#################
## 데이터 통합 ##
#################
# 01. 열결합 : dplyr::left_join(), dplyr::right_join(), dplyr::inner_join, dplyr::outer_join
# 02. 행결합 : dplyr::bind_rows()

test1 <- data.frame( class = c(1, 2, 3, 4, 5)
                    ,type1  = c(90, 80, 85, 40, 30))

test2 <- data.frame(class = c(1,2,3,4,6),
                    type2 = c(100, 200, 300, 400, 500))


# 1. dplyr::left_join(), dplyr::right_join(), dplyr::inner_join, dplyr::outer_join
dplyr::left_join(test1 ,test2)
dplyr::right_join(test1 ,test2)

# 2. dplyr::bind_rows()
dplyr::bind_rows(test1, test2) # 컬럼명이 같은 것들만 rbind 수행

# 3. rbind, cbind 
# binding 처리시, 컬럼명이 맞지 않는 경우, error 발생
rbind(test1, test2) # error

# 4. merge function
# inner join 하고 싶은 경우,       --> by parameter 만 사용
# left Outer join 하고 싶은 경우,  --> by, all.x
# right Outer join 하고 싶은 경우, --> by, all.y
# Outer join 하고 싶은 경우,       --> by, all

merge(test1, test2 , by = c('class'))             # inner join
merge(test1, test2 , by = c('class'), all.x =  T) # left Outer join
merge(test1, test2 , by = c('class'), all.y =  T) # right Outer join
merge(test1, test2 , by = c('class'), all   =  T) # full outer join
