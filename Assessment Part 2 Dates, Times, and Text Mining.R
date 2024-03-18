library(tidyverse)
library(gutenbergr)
library(tidytext)
options(digits = 3)

data <- gutenberg_metadata

#Use str_detect() to find the ID of the novel Pride and Prejudice.
data[str_detect(data$title, "Pride and Prejudice"),] %>% group_by(gutenberg_id) %>%
  summarize(n=n())

#What is the correct ID number?
gutenberg_works(title == "Pride and Prejudice")$gutenberg_id

#How many words are present in the book?
book <- gutenberg_download(1342, mirror="http://mirror.csclub.uwaterloo.ca/gutenberg/")
words <- book %>% unnest_tokens(word, text)
  
#Remove stop words from the words object. 
words <- words %>% anti_join(stop_words)

#After removing stop words, detect and then filter out any token that contains a digit from words
words <- words %>%
  filter(!str_detect(word, "\\d"))

#How many words appear more than 100 times in the book?
words %>% group_by(word) %>%
  summarize(count = n()) %>% 
  filter(count >= 100) %>% arrange(count)

#Define the afinn lexicon:
afinn <- get_sentiments("afinn")

#Use this afinn lexicon to assign sentiment values to words. Keep only words that are 
#present in both words and the afinn lexicon. Save this data frame as afinn_sentiments.
afinn_sentiments <- inner_join(afinn, words)

#How many elements of words have sentiments in the afinn lexicon?
have_sentiment <- afinn_sentiments %>% filter(value == !is.na(value))

#What proportion of words in afinn_sentiments have a positive value?
mean(afinn_sentiments$value > 0)

sum(afinn_sentiments$value == 4)
