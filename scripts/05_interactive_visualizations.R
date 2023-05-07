# 2. Author and section analysis
## a. Compare sentiment scores across different authors and sections
sentiment_by_author_section <- chatgpt %>%
  select(author = byline, section_name, web_publication_date, bodytext_cleaned) %>%
  mutate(sentiment = get_sentiment(bodytext_cleaned, method = "nrc")) %>%
  group_by(author, section_name) %>%
  summarize(avg_sentiment = mean(sentiment))

# 3. Visualization
## a. Create interactive visualizations using plotly
# 3.1 Interactive line plot of daily average sentiment

plot_daily_sentiment <- ggplot(chatgpt_sentiment, aes(x = date, y = avg_sentiment)) +
  geom_line() +
  labs(x = "Date", y = "Average Sentiment", title = "Daily Average Sentiment of Articles") +
  theme_minimal()

# Convert the ggplot object to a plotly object
plotly_daily_sentiment <- ggplotly(plot_daily_sentiment)

# Display the interactive plot
plotly_daily_sentiment

# 3.2 Interactive bar plot of average sentiment by topic:
plot_sentiment_by_topic <- ggplot(sentiment_by_topic, aes(x = reorder(factor(topic), avg_sentiment), y = avg_sentiment)) +
  geom_col() +
  labs(x = "Topic", y = "Average Sentiment", title = "Average Sentiment by Topic") +
  theme_minimal()

plotly_sentiment_by_topic <- ggplotly(plot_sentiment_by_topic)
plotly_sentiment_by_topic

# 3.3 Interactive bar plot of average sentiment by author:
top_authors <- sentiment_by_author_section %>%
  top_n(10, wt = avg_sentiment)

plot_sentiment_by_author <- ggplot(top_authors, aes(x = reorder(author, avg_sentiment), y = avg_sentiment)) +
  geom_col() +
  labs(x = "Author", y = "Average Sentiment", title = "Average Sentiment by Author") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

plotly_sentiment_by_author <- ggplotly(plot_sentiment_by_author)
plotly_sentiment_by_author


# 3.4 Sentiment by section
plot_sentiment_by_section <- ggplot(sentiment_by_author_section, aes(x = reorder(section_name, avg_sentiment), y = avg_sentiment)) +
  geom_col() +
  labs(x = "Section", y = "Average Sentiment", title = "Average Sentiment by Section") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

plotly_sentiment_by_section <- ggplotly(plot_sentiment_by_section)
plotly_sentiment_by_section

# 3.5 Sentiment by date
plot_sentiment_by_date <- ggplot(chatgpt_sentiment, aes(x = date, y = avg_sentiment)) +
  geom_point(alpha = 0.5) +
  labs(x = "Publication Date", y = "Sentiment Score", title = "Sentiment Scores by Publication Date") +
  theme_minimal()

plotly_sentiment_by_date <- ggplotly(plot_sentiment_by_date)
plotly_sentiment_by_date
