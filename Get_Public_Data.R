

require(httr)
require(jsonlite)
require(ggplot2)

states_daily.url <- "https://covidtracking.com/api/states/daily"
us_daily.url <- "https://covidtracking.com/api/us/daily"

states_daily <- GET(states_daily.url)
states_daily.text <- content(states_daily, "text")
states_daily.json <- fromJSON(states_daily.text, flatten = TRUE)
states_daily.df <- as.data.frame(states_daily.json)
states_daily.df <- states_daily.df %>% select(-one_of("hash"))

states_daily.df$date <- lubridate::ymd(states_daily.df$date)
states_daily.df$dateChecked <- states_daily.df$dateChecked %>% stringr::str_sub(start = 1, end = 10)
states_daily.df$dateChecked <- lubridate::ymd(states_daily.df$dateChecked)

## plot CA vs. IA
states_daily.df %>% 
  filter(state == c("CA")) %>%
  ggplot(aes(positive, positiveIncrease)) + 
  geom_smooth(model = glm, color = "red") +
  geom_point(color = "red") +
  geom_smooth(data = states_daily.df %>% filter(state == "IA"),
              aes(positive, positiveIncrease),
              model = glm,
              color = "blue") +
  geom_point(data = states_daily.df %>% filter(state == "IA"), color = "blue") +
  theme_dark() +
  scale_x_continuous(trans = 'log10') +
  scale_y_continuous(trans = 'log10') +
  labs(title ="IA Blue, CA Red", x = "Postive Cases", y = "Increase")

states_daily.df %>% 
  filter(state == c("NY")) %>%
  ggplot(aes(positive, positiveIncrease)) + 
  geom_smooth(model = glm, color = "red") +
  geom_point(color = "red") +
  geom_smooth(data = states_daily.df %>% filter(state == "IA"),
              aes(positive, positiveIncrease),
              model = glm,
              color = "blue") +
  geom_point(data = states_daily.df %>% filter(state == "IA"), color = "blue") +
  theme_dark() +
  scale_x_continuous(trans = 'log10') +
  scale_y_continuous(trans = 'log10') +
  labs(title ="IA Blue, NY Red", x = "Postive Cases", y = "Increase")
  



