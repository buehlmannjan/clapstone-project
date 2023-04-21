###################################################################
# Class Exercise 2
# Jan Bühlmann, Sascha Eng & Ursulina Kölbener
###################################################################

## TEXT ANALYTICS

# 1. preparations ----
# install.packages("quanteda")
library(quanteda)

# load dataframe
data.table::fread(df_articles, here::here("data", "df_articles.csv"))
