###################################################################
# Class Exercise 2
# Jan Bühlmann, Sascha Eng & Ursulina Kölbener
###################################################################

## FREQUENCY ANALYSIS

# Load necessary libraries
library(ggplot2)
library(lubridate)


# Calculate the frequency of articles by month
articles$month <- floor_date(articles$web_publication_date, "month")
monthly_counts <- as.data.frame(table(articles$month))


# Plot the distribution of publication dates
ggplot(monthly_counts, aes(x = Var1, y = Freq)) +
  geom_col() +
  labs(x = "Publication Month", y = "Frequency", title = "Distribution of Article Publication Dates") +
  theme_minimal()

print(monthly_counts)