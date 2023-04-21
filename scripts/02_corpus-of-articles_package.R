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
