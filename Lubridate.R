library(dslabs)
library(lubridate)
options(digits = 3)    # 3 significant digits

data<- data(brexit_polls)

brexit_polls %>% filter(startdate >= "2016-04-01",
                        startdate <= "2016-04-30")

sum(round_date(brexit_polls$enddate, unit = "week") == "2016-06-12")

brexit_polls %>% mutate(weekday = weekdays(enddate)) %>% group_by(weekday) %>%
  summarize(n = n())

data(movielens)
movielens <- movielens %>% mutate(timestamp = as_datetime(timestamp))

movielens %>% mutate(timeyear = year(timestamp),
                     timehour = hour(timestamp)) %>%
  group_by(timehour) %>%
  summarize(n = n()) %>%
  arrange(-n)

reviews_by_hour <- table(hour(movielens$timestamp))
names(which.max(reviews_by_hour))

movielens %>% filter(timestamp == year(2000))
