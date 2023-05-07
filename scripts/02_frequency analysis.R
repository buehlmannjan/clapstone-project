###################################################################
# Clapstone Project
# Jan Bühlmann
###################################################################

## FREQUENCY ANALYSIS

# Load necessary libraries
library(ggplot2)
library(lubridate)


# Calculate the frequency of articles by month
articles$month <- floor_date(articles$web_publication_date, "month")
monthly_counts <- as.data.frame(table(articles$month))


# Plot the distribution of publication dates
plot_1 <- ggplot(monthly_counts, aes(x = Var1, y = Freq)) +
  geom_col() +
  labs(x = "Publication Month", y = "Frequency", title = "Distribution of Articles Publication Dates") +
  theme_minimal()

print(monthly_counts)

# save plot
ggsave(here::here("figs", "plot 1_dist articles.png"), plot_1)
