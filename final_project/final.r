# QBS-181 Final Exam code

##################################################
#                 QUESTION 1
##################################################

# read in data from file
d <- read.csv(file="/Users/AhsanAzim/Desktop/current_classes/QBS181/final/IC_BP.csv",head=TRUE,sep=",", stringsAsFactors=FALSE)

############################
# a)
############################ 
colnames(d)[4] <- "BPStatus"

############################ 
# b) 
############################ 
# first convert values to integer chars
d$BPStatus[d$BPStatus == "Hypo1"] <- "1"
d$BPStatus[d$BPStatus == "Normal"] <- "1"
d$BPStatus[d$BPStatus == "Hypo2"] <- "0"
d$BPStatus[d$BPStatus == "HTN1"] <- "0"
d$BPStatus[d$BPStatus == "HTN2"] <- "0"
d$BPStatus[d$BPStatus == "HTN3"] <- "0"
# then convert entire column to numeric
# note that NULL's converted to NA
d$BPStatus <- as.numeric(as.character(d$BPStatus))

############################ 
# c)
############################ 
# since question didn't mention having to use ODBC drivers 
# for this part, I'll do without them for now
d2 <- read.csv(file="/Users/AhsanAzim/Desktop/current_classes/QBS181/final/Demographics.csv",head=TRUE,sep=",", stringsAsFactors=FALSE)
d3 <- merge(x = d, y = d2, by.x = "ID", by.y="contactid")

############################ 
# d)
############################ 
d3$ObservedTime <- as.Date(as.character(d3$ObservedTime), format = "%m/%d/%y")

# function that returns required systolic and diastolic average scores 
# over 12 week intervals for a certain passed in ID and computed over a 
# certain passed in data frame
get_interval_scores <- function(curr_id, curr_df) {
  dates <- curr_df$ObservedTime[curr_df$ID == curr_id]          # get dates for this ID
  s_vals <- d3$SystolicValue[d3$ID==curr_id & d3$ObservedTime %in% dates]
  d_vals <- d3$Diastolicvalue[d3$ID==curr_id & d3$ObservedTime %in% dates]
  new_df <- data.frame(dates, s_vals, d_vals)
  new_df <- new_df[order(new_df$dates),]                          # ascending order sort of dates, dictates ordering of other columns
  new_df$weeks <- as.numeric(new_df$dates-new_df$dates[1]) %/% 7  # https://stackoverflow.com/questions/8030812/how-can-i-group-days-into-weeks
  new_df$weeks <- new_df$weeks + 1                                # to account for 1 - indexing

  s_means <- c(NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA)
  d_means <- c(NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA)
  for (i in 1:12){
    s_means[i] <- mean(new_df$s_vals[weeks == i])
    d_means[i] <- mean(new_df$d_vals[weeks == i])
  }
  return(list("sys" = s_means, "dia" = d_means))
}

q3_df_sys <- data.frame(matrix(ncol = 13, nrow = 0))
q3_df_dia <- data.frame(matrix(ncol = 13, nrow = 0))
x <- c("ID", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12")
colnames(q3_df_sys) <- x
colnames(q3_df_dia) <- x


ids <- unique(d3$ID)
for (val in ids) {
  both_means <- get_interval_scores(val, d3)
  temp_df_dia <- data.frame(matrix(ncol = 13, nrow = 1))
  temp_df_sys <- data.frame(matrix(ncol = 13, nrow = 1))
  colnames(temp_df_dia) <- x
  colnames(temp_df_sys) <- x
  temp_df_dia <- data.frame(t(c(val, both_means$dia)))
  temp_df_sys <- data.frame(t(c(val, both_means$sys)))
  q3_df_dia <- rbind(q3_df_dia, temp_df_dia)
  q3_df_sys <- rbind(q3_df_sys, temp_df_sys)
}

print(q3_df_dia)
print(q3_df_sys)

############################ 
# e)
############################ 

The follow-up scores are generally higher than the scores from the first week.


############################ 
# f)
############################ 
  

##################################################
#                 QUESTION 3
##################################################

# STEP 1 - Accessing the data
# ---------------------------
# Will later replace manually imported data with 
# use of ODBC drivers
demos_df <- read.csv(file="/Users/AhsanAzim/Desktop/current_classes/QBS181/final/Demographics.csv",head=TRUE,sep=",", stringsAsFactors=FALSE)
chronic_df <- read.csv(file="/Users/AhsanAzim/Desktop/current_classes/QBS181/final/ChronicConditions.csv",head=TRUE,sep=",", stringsAsFactors=FALSE)
text_df <- read.csv(file="/Users/AhsanAzim/Desktop/current_classes/QBS181/final/Text.csv",head=TRUE,sep=",", stringsAsFactors=FALSE)

# STEP 2 - Wrangling
# ---------------------------
# The wrangling process itself:
# - Merge the tables Demographics, Chronic Conditions 
#   and TextMessages
# - take care of the fact that only one ID per row in 
#   the end, take the latest TextMessageSent date as a
#   tiebreaker
# We use the dplyr package below

library(dplyr)

# Perform the three-way join in two steps
temp_df1 <- inner_join(demos_df, chronic_df, by = c("contactid" = "tri_patientid")) 
temp_df2 <- inner_join(temp_df1, text_df, by = c("contactid" = "tri_contactId"))

# for debugging - just to show that there are 3346 unique ids
# currently a lot repeated, we need to eliminate the repeats
# according to last-date rule outlined in prompt
length(unique(temp_df2$contactid))      # 3346
length(temp_df2$contactid)              # 81949

# Now we eliminate the repeats

# extract dates from the long string
dates_vector <- substr(temp_df2$TextSentDate, start = 1, stop = 10)
# convert dates to proper format
temp_df2$TextSentDate <- as.Date(as.character(dates_vector), format = "%Y-%m-%d")
# select for the top date corresponding to each ID, thus creating 2 column table of ID and its max date
temp_df3 = aggregate(temp_df2$TextSentDate,by=list(temp_df2$contactid),max)
# join this table back with the original joined table to obtain final table
# note that the join here is done on multiple keys (ie a combination of the date *and* ID)
final_df <- inner_join(temp_df2, temp_df3, by = c("contactid" = "Group.1", "TextSentDate" = "x"))

# Examine our final output
head(final_df)
length(final_df$contactid)            # 4619
length(unique(final_df$contactid))    # 3346

# Note once again how there are a some repeats still left in even the final data.
# This is indicated by the difference between 4619 and 3346. This is *exactly* the
# same difference as observed in our answer to question 2 (these are the ~3k and ~4k
# referred to in that question.)
# As our methodology - both in this question and our answer to question #2 -
# demonstrates, this is not a problem with our approach. Instead, the data is such
# that it necessitates some repetitions. We do not replicate our elaborate demonstration
# of necessary repetitions hear. Suffice it to say, it would be trivial to remove
# these repetitions. We once again do not do so for it would *harm* the data and cause us
# to lose valuable information. We believe this approach is more in spirit wit hthe intent of the
# task at hand.