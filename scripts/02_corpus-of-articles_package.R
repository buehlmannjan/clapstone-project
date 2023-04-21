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

# Display the structure of the dataset
str(articles)

# 5. Summary statistics ----
# Generate summary statistics for numeric columns
summary(articles)

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
