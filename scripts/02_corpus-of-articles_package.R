###################################################################
# Class Exercise 2
# Jan Bühlmann, Sascha Eng & Ursulina Kölbener
###################################################################

# 1. install and load packages ----
# install.packages("httr")
# install.packages("jsonlite")
# install.packages("devtools") 
# install.packages("tm")
# yeyinstall.packages("stringr")
# install.packages("ggplot2")

library(httr)
library(jsonlite)
library(tidyverse)
library(devtools)
library(ggplot2)
library(lubridate)

# install.packages("devtools")
# devtools::install_github("evanodell/guardianapi")
library(guardianapi)

# 2. save personal API key ----
api_key <- rstudioapi::askForPassword('Enter your API key:')
options(gu.API.key = api_key)

# make sure the key is not pushed to github

# 3. define the search function for The Guardian API ----
articles <- gu_content(query = "openAI OR chatGPT", from_date = "2018-12-01",
                            to_date = "2023-04-17")

print(articles)
head(articles)
colnames(articles)

# 4. simplify dataframe
df_articles <- articles %>%
  filter(type == "article") %>% # remove liveblogs
  select(id, section_name, web_publication_date, web_title, headline, byline, pillar_name, body_text, wordcount)

# save dataframe
data.table::fwrite(df_articles, here::here("data", "df_articles.csv"))


# 5. Display the structure of the dataset ----
str(articles)

# a) Generate summary statistics for numeric columns
summary(articles)

# 5. Preprocessing
## a. Clean the text data.

# Define the cleaning function
clean_text <- function(text) {
  library(stringr)
  library(tm)
  
  cleaned_text <- str_replace_all(text, "<[^>]*>", "") # Remove HTML tags
  cleaned_text <- gsub("[^[:alnum:]///' ]", "", cleaned_text) # Remove special characters
  return(cleaned_text)
}

# Print the column names of the dataset
colnames(chatgpt)


# Apply the cleaning function to the bodytext column
chatgpt$body_text_cleaned <- clean_text(chatgpt$body_text)

## b. Tokenize the words.

# Load necessary libraries
library(tidytext)
library(dplyr)

# Tokenize the words
chatgpt_tidy <- chatgpt %>%
  unnest_tokens(word, bodytext_cleaned)

## c. Remove stopwords.

# Load the stopwords
data("stop_words")

# Remove stopwords
chatgpt_tidy <- chatgpt_tidy %>%
  anti_join(stop_words)

## d. Count the frequency of words.

word_counts <- chatgpt_tidy %>%
  count(word, sort = TRUE)

## e. Visualize the most frequent words.

# Plot the top 10 most frequent words
word_counts %>%
  top_n(10) %>%
  ggplot(aes(x = reorder(word, n), y = n)) +
  geom_col() +
  coord_flip() +
  labs(x = "Words", y = "Frequency", title = "Top 10 Most Frequent Words") +
  theme_minimal()



# 6. Assuming chatgpt_sentiment has a date column named 'date'
library(lubridate)

# Calculate daily average sentiment


# install.packages("syuzhet")
library(syuzhet)

# Calculate sentiment scores
chatgpt_sentiment <- chatgpt %>%
  select(web_publication_date, body_text_cleaned) %>%
  mutate(sentiment = get_sentiment(body_text_cleaned, method = "nrc")) %>%
  mutate(date = floor_date(web_publication_date, "day")) %>%
  group_by(date) %>%
  summarize(avg_sentiment = mean(sentiment))

ggplot(chatgpt_sentiment, aes(x = date, y = avg_sentiment)) +
  geom_line() +
  labs(x = "Date", y = "Average Sentiment", title = "Daily Average Sentiment of Articles") +
  theme_minimal()
