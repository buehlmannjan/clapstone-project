###################################################################
# Class Exercise 2
# Jan Bühlmann, Sascha Eng & Ursulina Kölbener
###################################################################

# 1. install and load packages ----
# install.packages("httr")
# install.packages("jsonlite")

library(httr)
library(jsonlite)
library(tidyverse)

# 2. save personal API key ----
api_key <- rstudioapi::askForPassword()
# add your key in the dialog
# make sure the key is not pushed to github

# 3. construct query URL ----
base_url <- "https://content.guardianapis.com/search?q="
searchterms <- "openAI OR chatGPT"

query_url <- paste0(base_url, URLencode(searchterms), "&api-key=", api_key)

# 4. GET requests to guardian.com ----
resp <- httr::GET(query_url)

# check status
http_status(resp)

# 5. parse JSON ----
articles <- fromJSON(httr::content(resp, as = "text"))

# inspect information
articles$response$results

# 6. create a dataframe ----
df_articles <- data.frame(title = articles$response$results$webTitle,
                          section = articles$response$results$sectionName,
                          url = articles$response$results$webUrl,
                          date = articles$response$results$webPublicationDate)
