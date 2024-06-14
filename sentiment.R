install.packages('ggplot2')
install.packages('dplyr')
install.packages('tidytext')
install.packages('gsheet')
install.packages('wordcloud2')
install.packages('sentimentr')
install.packages('lubridate')
install.packages('readr')


library(ggplot2)
library(dplyr)
library(tidytext)
library(gsheet)
library(wordcloud2)
library(sentimentr)
library(lubridate)
library(readr)

survey <- gsheet::gsheet2tbl('https://docs.google.com/spreadsheets/d/1W9eGIihIHppys3LZe5FNbUuaIi_tfdscIq521lidRBU/edit?usp=sharing')

# look at first few rows

head(survey)
names(survey)

# create new variable named date_time

survey_new <- survey %>% 
  mutate(date_time = mdy_hms(Timestamp))

View( survey_new )

# visualize date_time variable
    ### Come back to this...
table(survey$Timestamp)

# create an object called sentiments

sentiments <- get_sentiments('bing')

# explore the sentiments object

nrow(sentiments)
ncol(sentiments)
head(sentiments) # Unit of observation: word (character/string)

# create an object words

words <- survey %>%
  dplyr::select(first_name,
                feeling_num,
                feeling) %>%
  unnest_tokens(word, feeling)

# explore words

nrow(words)
ncol(words)
head(words)
View(words)

# create a dataframe word_freg, conformant with the expectation of wordcloud,
# showing how frquently each word appeared in our feelings.

word_freg <- words %>% group_by(word) %>% tally() 

wordcloud2(data = word_freg, size = 1, minSize = 0, gridSize =  0,
           fontFamily = 'Segoe UI', fontWeight = 'bold',
           color = 'random-dark', backgroundColor = "white",
           minRotation = -pi/4, maxRotation = pi/4, shuffle = TRUE,
           rotateRatio = 0.4, shape = 'circle', ellipticity = 0.65,
           widgetsize = NULL, figPath = NULL, hoverFunction = NULL)
# create an object named sw
sw <- read_csv('https://raw.githubusercontent.com/databrew/intro-to-data-science/main/data/stopwords.csv')

head(sw)
nrow(sw)

# remove from word_freg any row where the word appears in sw

word_freg <- word_freg %>% 
  filter(!word %in% sw$word)

View(word_freg)

wordcloud2(word_freg)

# make an object with top most used 10 words
top_10 <- word_freg %>% arrange(desc(n)) %>% 
  head(10)

View(top_10)

# create a bar chart showing n of times the top 10 words were used

ggplot( top_10, aes(x= word, y=n)) +
  geom_col()

# join word_freg with sentiments

sentiment_freg <- left_join(word_freg, sentiments, by = 'word')

View(sentiment_freg)

# create an object with n of - and + words used for each person

pos_and_neg <- left_join(words, sentiment_freg, by = 'word')

View(pos_and_neg)

pos_and_neg %>% group_by(first_name)

pos_and_neg %>%  group_by(first_name) %>% 
  group_by(sentiment) 

table(pos_and_neg$first_name, pos_and_neg$sentiment)
