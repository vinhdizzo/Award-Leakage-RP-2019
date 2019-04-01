dGe1 <- read_excel('Input/GE Patterns 2018-2019.xlsx', sheet='IGETC')
dGe2 <- read_excel('Input/GE Patterns 2018-2019.xlsx', sheet='CSU_GE')
dGe3 <- read_excel('Input/GE Patterns 2018-2019.xlsx', sheet='IVC_GE')

dGe <- bind_rows(dGe1 %>% mutate(GE='IGETC')
               , dGe2 %>% mutate(GE='CSU')
               , dGe3 %>% mutate(GE='IVC')
                 )
ge_courses <- dGe$Courses %>%
  strsplit(x=., split=', ') %>%
  unlist %>%
  unique
#ge_courses

# Get official list of courses
dCourses <- dbGetQuery(con, statement="select CourseID, count(1) as n from DimCourse group by CourseID order by CourseID ;")

# Check if GE courses are valid
setdiff(ge_courses, trimws(dCourses$CourseID)) ## should be empty
#cat(setdiff(ge_courses, trimws(dCourses$CourseID)), sep='\n')

# GE calcs to be added to SQL
ge_var_calcs <- dGe %>%
  mutate(
    ge_var_name=paste0(GE, '_', Area)
    , ge_course_list=strsplit(Courses, split=', ') %>% sapply(., FUN=function(x) paste0("'", x, "'", collapse=", "))
    , ge_var_code=glue(', sum(case when dc.CourseID in ({ge_course_list}) and (dg.SuccessFlag=1 or (dt.BK_TermCode=@Current_TermCode and fe.DropCount=0)) then 1 else 0 end) as {ge_var_name}')) %>%
  # select(ge_var_code) %>% as.data.frame
  select(ge_var_code) %>%
  unlist %>%
  paste(collapse='\n')
#cat(ge_var_calcs, '\n')

# GE Base Query
ge_query_base <- read_file('Code/01_GE_Base_Query_Template.sql')
ge_query <- glue(ge_query_base)
#cat(ge_query, '\n')
fileConn <- file('Code/Generated Code/000 - General Education.sql')
writeLines(ge_query, fileConn)
close(fileConn)

dGeStudents <- dbGetQuery(conn=con, statement=ge_query)
dim(dGeStudents)
dGeStudents %>% filter(GE_IGETC >= 1) %>% nrow
dGeStudents %>% filter(GE_CSU >= 1) %>% nrow
dGeStudents %>% filter(GE_IVC >= 1) %>% nrow
dGeStudents %>% filter(GE_IGETC >= 1 | GE_CSU >= 1 | GE_IVC >= 1) %>% nrow

dGeStudents %>%
  select(starts_with('IGETC'), starts_with('CSU'), starts_with('IVC'), starts_with('GE_')) %>%
  summarize_all(.funs=function(x) mean(x > 0)) %>%
  as.data.frame

# Iterate across terms
dTerms <- data_frame(TermCode=c(20122, 20123, 20131, 20132, 20133, 20141, 20142, 20143, 20151, 20152, 20153, 20161, 20162, 20163, 20171, 20172, 20173, 20181, 20182, 20183, 20191)
                     , Year=rep(2012:2018, each=3)
                     , School_Year=paste(Year, Year+1, sep='-')
                     )
dTerms %>% as.data.frame

dGeHist <- lapply(dTerms$TermCode
            , function(Cur_TermCode) {
              ge_query <- glue(ge_query_base)
              dGeStudents <- dbGetQuery(conn=con, statement=ge_query)
              dGeStudents
            }
            ) %>%
  plyr::rbind.fill(.)

dim(dGeHist)
table(dGeHist$BK_TermCode)
dGeHist %>%
  select(BK_TermCode, starts_with('IGETC'), starts_with('CSU'), starts_with('IVC'), starts_with('GE_')) %>%
  group_by(BK_TermCode) %>%
  summarize_all(.funs=function(x) mean(x > 0)) %>%
  as.data.frame

# Write
dbRemoveTable(conn=rs, name='Leakage_GE_Hist')
dbWriteTable(conn=rs, name='Leakage_GE_Hist', value=dGeHist)
