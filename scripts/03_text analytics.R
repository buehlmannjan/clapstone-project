###################################################################
# Class Exercise 2
# Jan Bühlmann, Sascha Eng & Ursulina Kölbener
###################################################################

## TEXT ANALYTICS

# 1. preparations ----
install.packages("quanteda")

library(quanteda)

# load dataframe
df_articles <- data.table::fread(here::here("data", "df_articles.csv"))

# create unique document names
docnames <- paste(df_articles$id, seq_along(df_articles$id), sep = "_")

# 2. create a corpus wit the main texts ----
corp_main <- corpus(df_articles$body_text, docnames = docnames)

