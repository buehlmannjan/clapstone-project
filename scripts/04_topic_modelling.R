# Load additional required libraries
install.packages('topicmodels')
install.packages('plotly')
library(topicmodels)
library(plotly)

# 1. Topic modeling
## a. Apply LDA 
### Prepare the data for topic modeling by removing stopwords and words containing only digits:
chatgpt_tidy <- chatgpt_tidy %>%
  anti_join(stop_words) %>%
  filter(!str_detect(word, "^\\d+$")) # Remove words containing only digits

# Create a Document-Term Matrix
### Create a Document-Term Matrix (DTM), which is a matrix that shows 
### the frequency of terms in each document:
dtm <- chatgpt_tidy %>%
  count(id, word) %>%
  cast_dtm(document = id, term = word, value = n)

# Fit the LDA model
### Fit an LDA (Latent Dirichlet Allocation) model to the DTM. This model 
### helps to identify the underlying topics in the text data:
lda_model <- LDA(dtm, k = 5, control = list(seed = 1234))

# Get the top terms for each topic
### Extract the top terms for each topic from the LDA model:
topic_terms <- tidy(lda_model, matrix = "beta")

# Find the main topic for each document
### Find the main topic for each document using the gamma matrix 
### of the LDA model:
document_topics <- tidy(lda_model, matrix = "gamma") %>%
  group_by(document) %>%
  top_n(1, wt = gamma) %>%
  ungroup()

# Calculate sentiment scores for each document
chatgpt_sentiment <- chatgpt %>%
  select(id, web_publication_date, bodytext_cleaned) %>%
  mutate(sentiment = get_sentiment(bodytext_cleaned, method = "nrc")) %>%
  mutate(date = floor_date(web_publication_date, "day")) %>%
  group_by(id, date) %>%
  summarize(avg_sentiment = mean(sentiment), .groups = "drop")


# Merge the main topics with sentiment scores
chatgpt_sentiment_topics <- chatgpt_sentiment %>%
  inner_join(document_topics, by = c("id" = "document"))

# Calculate average sentiment by topic
sentiment_by_topic <- chatgpt_sentiment_topics %>%
  group_by(topic) %>%
  summarize(avg_sentiment = mean(avg_sentiment))

sentiment_by_topic

# Create a bar plot of average sentiment by topic
sentiment_plot <- ggplot(sentiment_by_topic, aes(x = factor(topic), y = avg_sentiment, fill = factor(topic))) +
  geom_bar(stat = "identity", color = "black") +
  labs(x = "Topic", y = "Average Sentiment", title = "Sentiment by Topic") +
  scale_fill_discrete(name = "Topics") +
  theme_minimal()

# Display the plot
print(sentiment_plot)

# Optionally, save the plot to a file
ggsave("sentiment_by_topic_plot.png", sentiment_plot, width = 7, height = 5, dpi = 300)


# Arrange the top terms for each topic:
top_topic_terms <- topic_terms %>%
  group_by(topic) %>%
  top_n(5, beta) %>%
  ungroup() %>%
  arrange(topic, -beta)

#Display the top terms for each topic in a readable format:
top_topic_terms <- topic_terms %>%
  group_by(topic) %>%
  top_n(5, beta) %>%
  ungroup() %>%
  arrange(topic, -beta)

topic_term_table <- top_topic_terms %>%
  group_by(topic) %>%
  mutate(rank = row_number()) %>%
  ungroup() %>%
  pivot_wider(names_from = rank, values_from = term) %>%
  select(topic, `1`, `2`, `3`, `4`, `5`)

print(topic_term_table)

ggsave(here::here("figs", "plot 4_topic_term_table.png"), topic_term_table)


## https://www.theguardian.com/technology/2023/apr/06/australian-mayor-prepares-worlds-first-defamation-lawsuit-over-chatgpt-content
