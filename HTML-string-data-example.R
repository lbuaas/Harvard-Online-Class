library(rvest)
library(tidyverse)
library(stringr)
url <- "https://en.wikipedia.org/w/index.php?title=Opinion_polling_for_the_United_Kingdom_European_Union_membership_referendum&oldid=896735054"
tab <- read_html(url) %>% html_nodes("table")
polls <- tab[[6]] %>% html_table(fill = TRUE)

col_names <- c("dates", "remain", "leave", "undecided", 
               "lead", "samplesize", "pollster", "poll_type", "notes")

#Sets name column names for polls
colnames(polls) <- col_names

#Removes first row w/ text data
polls <- polls[-1,]

#filters out data without % sign
polls %>% filter(grepl('%', remain))

#Set remain and leave coloumns to proprotion between 0 & 1
polls %>% mutate(remain = as.numeric(str_replace(polls$remain, "%", ""))/100,
                 leave = as.numeric(str_replace(polls$leave, "%", ""))/100)

#Set NAs to 0 in undecided 
polls %>% mutate(undecided = str_replace(polls$undecided, "N/A", "0"))

                 