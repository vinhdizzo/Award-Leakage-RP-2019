setwd('//ivcud/research/CTE/Completion Audit Using SQL 201805')

library(readxl)
library(readr)
library(dplyr)
library(odbc)
library(tidyr)
library(stringr)
library(openxlsx)
library(glue)

# Parameters
CoR <- 'I'
## # June 2018
## Cur_TermCode <- 20181
## App_TermCode <- 20182
## # September 2018
## Cur_TermCode <- 20183 # Can be currently enrolled
## App_TermCode <- 20183
# January 2019
Cur_TermCode <- 20191 # Can be currently enrolled
App_TermCode <- 20191

Near_Completion_Threshold <- 2

# DB
con <- dbConnect(odbc(), dsn='Sandbox', uid=Sys.getenv('uid'), pwd=Sys.getenv('pwd'))
rs <- dbConnect(odbc(), dsn='Sandbox_ResearchStaging', uid=Sys.getenv('uid'), pwd=Sys.getenv('pwd'))


# Ingest Data
#d1 <- read_excel('Input/CTE SP18 Certificate Requirements.xlsx')
d1 <- read_excel('Input/IVC Award Requirements.xlsx') %>%
  filter(!is.na(Course_List_01)) %>%
  mutate_at(.vars=vars(starts_with('N_')), .funs=as.numeric)

dim(d1)
head(d1) %>% as.data.frame

# Missings
d2 <- d1 %>%
  mutate_at(.vars=vars(starts_with('Course_List')), .funs=function(col) ifelse(is.na(col), 'BLANK', col)) %>%
  mutate_at(.vars=vars(starts_with('N_')), .funs=function(col) ifelse(is.na(col), 0, col)) %>%
  mutate_at(.vars=vars(starts_with('Group_')), .funs=function(col) ifelse(is.na(col), 'BLANK', col)) %>% 
  ## Remove: Paralegal Studies (need AA degree)
  filter(Certificate != 'Paralegal Studies')
d2 %>% head %>% as.data.frame

# Check certificate name
## Old
# dCert <- dbGetQuery(con, statement="select dam.AwardMajorDesc, count(1) as n from DimAwardMajor as dam where BK_CollegeCode='I' and BK_AwardCategoryCode='Certificate' group by dam.AwardMajorDesc order by dam.AwardMajorDesc ;")
## unique_cert <- d2 %>% select(Certificate) %>% unlist
## ## problematic certificate names
## setdiff(unique_cert, trimws(dCert$AwardMajorDesc)) ## CHECK HERE: should be empty

dAward <- dbGetQuery(con, statement="select dam.AwardMajorDesc, dam.BK_AwardTypeCode, count(1) as n from DimAwardMajor as dam where BK_CollegeCode='I' group by dam.AwardMajorDesc, dam.BK_AwardTypeCode order by dam.AwardMajorDesc, dam.BK_AwardTypeCode ;")
dim(dAward)
dAward %>% head

d2 %>%
  select(Certificate, Type, Type2) %>%
  anti_join(dAward, by=c('Certificate'='AwardMajorDesc', 'Type'='BK_AwardTypeCode')) %>%
  arrange(Certificate, Type) %>% 
  as.data.frame
## RESULTS should be empty
## Business Information Worker: not yet in Data Warehouse


# Check distinct courses
dCourses <- dbGetQuery(con, statement="select CourseID, count(1) as n from DimCourse group by CourseID order by CourseID ;")

unique_courses <- d2 %>%
  select(starts_with('Course_List_')) %>% 
  unlist %>%
  strsplit(split=', ') %>%
  unlist %>%
  unique %>%
  setdiff('BLANK')

## problematic courses
setdiff(unique_courses, trimws(dCourses$CourseID))
# SHOULD BE EMPTY




# Read in query template
query_template <- read_file('Code/04_Award_Query_Template.sql')

# Get candidate list
format_course_list <- function(x) {
  x %>% str_split(', ') %>% unlist %>% paste(collapse="', '", sep='') %>% paste("'", ., "'", sep='')
}
get_candidate_list <- function(i, data=d2, query=query_template, Current_TermCode=Cur_TermCode, Near_Completion=FALSE, export_sql_code=TRUE) {
  run_query <- query %>%
    str_replace_all('#CoR', CoR) %>%
  str_replace_all('#Current_TermCode', Current_TermCode %>% as.character) %>%
  str_replace_all('#Near_Completion_Threshold', Near_Completion_Threshold %>% as.character) %>% 
  str_replace_all('#Award_Name', data$Certificate[i]) %>%
  str_replace_all('#Award_Type', data$Type[i]) %>%
  str_replace_all('#Course_List_01', data$Course_List_01[i] %>% format_course_list) %>%
  str_replace_all('#Course_List_02', data$Course_List_02[i] %>% format_course_list) %>%
  str_replace_all('#Course_List_03', data$Course_List_03[i] %>% format_course_list) %>%
  str_replace_all('#Course_List_04', data$Course_List_04[i] %>% format_course_list) %>%
  str_replace_all('#Course_List_05', data$Course_List_05[i] %>% format_course_list) %>%
  str_replace_all('#Course_List_06', data$Course_List_06[i] %>% format_course_list) %>%
  str_replace_all('#Course_List_07', data$Course_List_07[i] %>% format_course_list) %>%
  str_replace_all('#Course_List_08', data$Course_List_08[i] %>% format_course_list) %>%
  str_replace_all('#Course_List_09', data$Course_List_09[i] %>% format_course_list) %>%
  str_replace_all('#Course_List_10', data$Course_List_10[i] %>% format_course_list) %>%
  str_replace_all('#N_Course_01', data$N_Course_01[i] %>% as.character) %>%
  str_replace_all('#N_Course_02', data$N_Course_02[i] %>% as.character) %>%
  str_replace_all('#N_Course_03', data$N_Course_03[i] %>% as.character) %>%
  str_replace_all('#N_Course_04', data$N_Course_04[i] %>% as.character) %>%
  str_replace_all('#N_Course_05', data$N_Course_05[i] %>% as.character) %>% 
  str_replace_all('#N_Course_06', data$N_Course_06[i] %>% as.character) %>% 
  str_replace_all('#N_Course_07', data$N_Course_07[i] %>% as.character) %>% 
  str_replace_all('#N_Course_08', data$N_Course_08[i] %>% as.character) %>% 
  str_replace_all('#N_Course_09', data$N_Course_09[i] %>% as.character) %>% 
  str_replace_all('#N_Course_10', data$N_Course_10[i] %>% as.character) %>%
  str_replace_all('#Group_01', data$Group_01[i] %>% format_course_list) %>%
  str_replace_all('#Group_02', data$Group_02[i] %>% format_course_list) %>%
  str_replace_all('#Group_03', data$Group_03[i] %>% format_course_list) %>%
  str_replace_all('#Group_04', data$Group_04[i] %>% format_course_list) %>%
  str_replace_all('#Group_05', data$Group_05[i] %>% format_course_list) %>% 
  str_replace_all('#Group_06', data$Group_06[i] %>% format_course_list) %>% 
  str_replace_all('#Group_07', data$Group_07[i] %>% format_course_list) %>% 
  str_replace_all('#Group_08', data$Group_08[i] %>% format_course_list) %>% 
  str_replace_all('#Group_09', data$Group_09[i] %>% format_course_list) %>% 
  str_replace_all('#Group_10', data$Group_10[i] %>% format_course_list) %>%
  str_replace_all('#Group_11', data$Group_11[i] %>% format_course_list) %>% 
  str_replace_all('#Group_12', data$Group_12[i] %>% format_course_list) %>% 
  str_replace_all('#N_Groups', data$N_Groups[i] %>% as.character)
  if (Near_Completion) {
    run_query <- run_query %>%
      str_replace_all(fixed('-- /* -- Uncomment this for near completions'), '/* -- Uncomment this for near completions') %>%
      str_replace_all(fixed('-- */ -- Uncomment this for near completions'), '*/ -- Uncomment this for near completions') %>%
      str_replace_all(fixed('/* -- Remove this line for near completions'), '-- /* -- Remove this line for near completions') %>%
      str_replace_all(fixed('*/ -- Remove this line for near completions'), '-- */ -- Remove this line for near completions')
  }
  run_query

  # Write query out
  if (export_sql_code) {
    fileConn <- file(paste0('Code/Generated Code/', str_pad(i, width=3, side='left', pad='0'), ' - ', data$Certificate[i] %>% str_replace_all('/', '+') %>% str_replace_all(':', ''), ' - ', data$Type[i], ' - ', Current_TermCode, '.sql'))
    writeLines(run_query, fileConn)
    close(fileConn)
  }

  # Execute query
  #dbGetQuery(con, statement=run_query)
}
## foo <- get_candidate_list(i=1)
## dim(foo)
## foo <- get_candidate_list(i=67) # AS/AA
## dim(foo)
## foo <- get_candidate_list(i=132)
## dim(foo)
## foo <- get_candidate_list(i=147)
## dim(foo)
## foo <- get_candidate_list(i=147, Near_Completion=TRUE)


## dResultsL <- lapply(1:nrow(d2), get_candidate_list)
## dResults <- dResultsL %>%
##   plyr::rbind.fill(.)
dResults <- lapply(1:nrow(d2), get_candidate_list) %>%
  plyr::rbind.fill(.)

# Check
nrow(dResults)

dResults %>%
  group_by(Award_Name, Award_Type) %>%
  tally %>%
  arrange(desc(n)) %>%
  as.data.frame

dResults %>%
  summarize(N=n(), N_students=length(unique(BK_StudentID)))

dResults %>%
  group_by(BK_StudentID) %>%
  mutate(N=n()) %>%
  ungroup %>%
  filter(N>1) %>%
  arrange(desc(N), BK_StudentID, Award_Name, Award_Type) %>%
  select(BK_StudentID, Award_Name, Award_Type, N) %>%
  as.data.frame

# Append award type that students would recognize
dResults <- dResults %>%
  left_join(d2 %>% select(Certificate, Type, Type2), by=c('Award_Name'='Certificate', 'Award_Type'='Type')) %>%
  mutate(Award_Type=Type2) %>%
  select(-Type2)

# Export data
write.xlsx(dResults, file=paste0('Data/Award Candidates - ', Cur_TermCode, ' - ', Sys.Date(), '.xlsx'))