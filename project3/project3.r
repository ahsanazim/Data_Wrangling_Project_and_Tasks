#####################################################
#                 QUESTION 1
#####################################################

# misc commands to acquainte myself with the dataset
library(tidyr)
library(dplyr)
table1
table2
table3
table4a
table4b

#################### part (a) ####################

# cases per country per year

# table 2
table2_cases_by_country_and_yr <- filter(table2, type == "cases")

# table 4
# table 4a already gives cases per country per year
table4_cases_by_country_and_yr <- table4a

#################### part (b) ####################

# population per country per year

# table 2
table2_pop_by_country_and_yr <- filter(table2, type == "population")

# table 4
# table 4b already gives population per country per year
table4_pop_by_country_and_yr <- table4b

#################### part (c) ####################

# divide cases by population, * by 10000

# table 2 - we create a new table
table2_part_c <- left_join(table2_cases_by_country_and_yr,table2_pop_by_country_and_yr, by =c("country"="country", "year"="year"))
table2_part_c <- table2_part_c[, -3]
table2_part_c <- table2_part_c[, -4]
colnames(table2_part_c)[3] <- "cases"
colnames(table2_part_c)[4] <- "population"
table2_part_c <- table2_part_c %>%
  mutate(cases_per_ten_k=((cases/population)*10000))

# table 4a, 4b - we create a new table
table4_part_c <- left_join(table4a,table4b, by ="country")
table4_part_c <- table4_part_c %>%
  mutate(`1999_cases_per_ten_k`=((`1999.x`/`1999.y`)*10000))
table4_part_c <- table4_part_c %>%
  mutate(`2000_cases_per_ten_k`=((`2000.x`/`2000.y`)*10000))
table4_part_c <- table4_part_c[, -2]
table4_part_c <- table4_part_c[, -2]
table4_part_c <- table4_part_c[, -2]
table4_part_c <- table4_part_c[, -2]

#################### part (d) ####################

# store back

# table 2 - properly format table 2 and then bind
table2_part_c <- table2_part_c[, -3]
table2_part_c <- table2_part_c[, -3]
colnames(table2_part_c)[3] <- "count"
table2_part_c <- table2_part_c %>%
  mutate(type="cases_per_ten_k")
bind_rows(table2, table2_part_c)

# table 4a, 4b
# For table 4 it doesn't make sense to "store" the 
# data back in to the original tables, as the tables
# themselves are specific to case and population - hence
# why there are separate tables - 4a and 4b. Therefore
# our current arrangement is best; for convenience one 
# may rename the table and columns to match formatting
# of the table 4's in general:
colnames(table4_part_c)[2] <- "1999"
colnames(table4_part_c)[3] <- "2000"
table4c <- table4_part_c


#####################################################
#                 QUESTION 2
#####################################################

#   The code does not work because you need to put
# backticks around the dates 1999 and 2000. This is 
# because of the numerical nature of the column names.
# More here:
# https://stackoverflow.com/questions/36220823/what-do-backticks-do-in-r


#####################################################
#                 QUESTION 3
#####################################################

# misc commands to acquainte myself with the dataset
library(nycflights13)
flights
# need for date parsing
library(lubridate)
# https://moderndive.com/2-getting-started.html

#################### part (a) ####################
# There does not seem to be much difference 
# throughout the year. Taking means of each of the
# times and comparing accross the year should show
# as much.

#################### part (b) ####################

# Scheduled departure time (sched_dep_time) needs 
# to be the sum of dep_time and dep_delay. If this
# is true, then the findings are consistent.
# We check this with code below:
flights_df <- flights
flights_df %>%
  mutate(exp_dep_time = sched_dep_time + (dep_delay*60)) %>%
  filter(exp_dep_time != dep_time)
# If your run the code you will notice that there
# are indeed inconsistencies. There do exist rows
# for which our expected dep_time != sched_dep + delay
# Specifically, the number of such rows is many.

#################### part (c) ####################
# create the binary variable
flights_df <- flights_df %>%
  mutate(left_early = dep_delay < 0)
# access all in ranges 20-30 then 50-60 and count how many early and not
nrow(subset(flights_df, minute >= 20 & minute <= 30 & left_early == TRUE))
nrow(subset(flights_df, minute >= 20 & minute <= 30 & left_early == FALSE))
nrow(subset(flights_df, minute >= 50 & minute <= 60 & left_early == TRUE))
nrow(subset(flights_df, minute >= 50 & minute <= 60 & left_early == FALSE))
# The numbers come out to be the following:
# 43526 vs 36903 for 20 to 30 mins
# 29764 vs 25927 for 50 to 60 mins
# Whether that is a significant difference is up to the reader. 
# Once can, tentatively, say that the effect is not 
# strong enough for the hypothesis to be true


#####################################################
#                 QUESTION 4
#####################################################

# url = https://geiselmed.dartmouth.edu/qbs/
# NOTE: all the commands listed below have been 
# tested to work. The 'useful information' in question
# is outputted side by side with the code

# start up by loading library and scraping the html
library(rvest)
geisel_html <-  read_html("https://geiselmed.dartmouth.edu/qbs/")
geisel_html

# Now we parse the obtained html for useful information

# HEADINGS
h1_text <- geisel_html %>% html_nodes("h1") %>%html_text()
h1_text
h2_text <- geisel_html %>% html_nodes("h2") %>%html_text()
length(h2_text)
h2_text
h3_text <- geisel_html %>% html_nodes("h3") %>%html_text()
h3_text
h4_text <- geisel_html %>% html_nodes("h4") %>%html_text()
h4_text

# PARAGRAPHS
p_nodes <- geisel_html %>%html_nodes("p")
p_nodes[1:6]
p_text <- geisel_html %>% html_nodes("p") %>%html_text()
length(p_text)

# LISTS
ul_text <- geisel_html %>% html_nodes("ul") %>%html_text()
length(ul_text)
ul_text

# TOP LEVEL DIVS
# this is also equivalent to extracting all the text
divs <- geisel_html %>%
  html_nodes("div") %>% 
  html_text()
divs

# Scraping a specific heading
geisel_html %>%
  html_nodes(".missing-url") %>% 
  html_text()

# Scraping a specific paragraph
# This is not easy for our given webpage,
# as there is only one paragraph tag that has an actual
# id attached. All the other parapgraphs are absent id 
# or class identifier.

# Scraping a specific list
geisel_html %>%
  html_nodes("#menu-menu-1") %>% 
  html_text()

# Scraping a specific reference list item
geisel_html %>%
  html_nodes("#menu-item-338") %>% 
  html_text()
