library(tidyverse)
library(pdftools)
options(digits = 3)    # report 3 significant digits

fn <- system.file("extdata", "RD-Mortality-Report_2015-18-180531.pdf", package="dslabs")
system("cmd.exe", input = paste("start", fn))

#Use the pdftools package to read in fn using the pdf_text() function. 
txt <- pdf_text(fn)
txt

#Extract the ninth page of the PDF file from the object txt
x <- str_split(txt[9],"\n")
class(x)
length(x)

#Define s to be the first entry of the x object.
s <- x[[1]]
class(s)
length(s)

#After trimming, what single character is the last character of element 1 of s
s <- str_trim(s)
s[1]

#Use the str_which() function to find the row with the header
header_index <- str_which(s, pattern = "2015")[1]
header_index

header <- str_split(s[header_index], "\\s+", simplify = TRUE)
month <- header[1]
header <- header[-1]

#What is the value of tail_index?
tail_index <- str_which(s, "Total")
tail_index

#Use the str_count() function to create an object n with the count of numbers in each row.
n <- str_count(s, pattern = "\\d+")
sum(n == 1)

#How many entries remain in s after removing above?
out <- c(1:header_index, which(n==1), tail_index:length(s))
s <- s[-out]

s <- str_remove_all(s, "[^\\d\\s]")
s <- str_split_fixed(s, "\\s+", n = 6)[,1:5]
s <- as.data.frame(s)
s <- s %>% set_names("day", header) %>%
  mutate_all(as.numeric)

mean(s$"2015")
mean(s$"2016")
mean(s$"2017"[1:19])
mean(s$"2017"[20:30])

tab <- s %>% gather(year, deaths, -day) %>%
  mutate(deaths = as.numeric(deaths))
tab

#create a graph of TAB
tab %>% filter(year == c("2015","2016","2017")) %>%
  ggplot(aes(x=day, y= deaths, color = year)) +
  geom_line() +
  geom_vline(xintercept = 20)
