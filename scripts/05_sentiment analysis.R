###################################################################
# Class Exercise 2
# Jan Bühlmann, Sascha Eng & Ursulina Kölbener
###################################################################

## SENTIMENT ANALYSIS

# 1. Preprocessing ----

# install.packages("syuzhet")
library(syuzhet)

# Load necessary libraries
library(tidytext)
library(dplyr)
library(stringr)
library(tm)
library(lubridate)

## a. Clean the text data.

# Define the cleaning function
clean_text <- function(text) {
  cleaned_text <- str_replace_all(text, "<[^>]*>", "") # Remove HTML tags
  cleaned_text <- gsub("[^[:alnum:]///' ]", "", cleaned_text) # Remove special characters
  return(cleaned_text)
}

# Print the column names of the dataset
colnames(articles)

# Apply the cleaning function to the bodytext column
articles$body_text_cleaned <- clean_text(articles$body_text)

## b. Tokenize the words.

# Tokenize the words
chatgpt_tidy <- articles %>%
  unnest_tokens(word, body_text_cleaned)

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
plot_2 <- word_counts %>%
  top_n(10) %>%
  ggplot(aes(x = reorder(word, n), y = n)) +
  geom_col() +
  coord_flip() +
  labs(x = "Words", y = "Frequency", title = "Top 10 Most Frequent Words") +
  theme_minimal()

# save plot
ggsave(here::here("figs", "plot 2_top 10 words.png"), plot_2)

# 2. Calculate daily average sentiment ----
# Assuming chatgpt_sentiment has a date column named 'date'

# Calculate sentiment scores
chatgpt_sentiment <- articles %>%
  select(web_publication_date, body_text_cleaned) %>%
  mutate(sentiment = get_sentiment(body_text_cleaned, method = "nrc")) %>%
  mutate(date = floor_date(web_publication_date, "day")) %>%
  group_by(date) %>%
  summarize(avg_sentiment = mean(sentiment))

plot_3 <- ggplot(chatgpt_sentiment, aes(x = date, y = avg_sentiment)) +
  geom_line() +
  labs(x = "Date", y = "Average Sentiment", title = "Daily Average Sentiment of Articles") +
  theme_minimal()

# save plot
ggsave(here::here("figs", "plot 3_avg sentiment.png"), plot_3)
