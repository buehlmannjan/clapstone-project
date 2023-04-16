###################################################################
# Class Exercise 2
# Sascha Eng & Ursulina Kölbener & Jan Bühlmann
###################################################################

# 1. install and load packages ----
# install.packages("httr")
# install.packages("jsonlite")

library(httr)
library(jsonlite)
library(tidyverse)

# 2. save personal API key ----
api_key <- rstudioapi::askForPassword()
# make sure the key is not pushed to github