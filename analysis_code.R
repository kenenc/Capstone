library(tidyverse)
library(magrittr)
library(R.utils)
library(tm)
library(tokenizers)
library(quanteda)
library(data.table)
library(gt)
library(gtExtras)


#Downloading data into a directory (projData)
if(!file.exists("projData")){dir.create("projData")}
trainURL <- "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"
download.file(trainURL, destfile = "projData/data.zip", method = "curl")
unzip("projData/data.zip")
unlink("projData/data.zip")

#Reading in data
con <- file("projData/final/en_US/en_US.twitter.txt", "r")
twit <- readLines(con)
con <- file("projData/final/en_US/en_US.news.txt", "r")
news <- readLines(con)
con <- file("projData/final/en_US/en_US.blogs.txt", "r")
blogs <- readLines(con)
close(con)

#Taking a 100,000 line sample of each dataset
twitSample <- sample(twit, size = 100000)
newsSample <- sample(news, size = 100000)
blogsSample <- sample(blogs, size = 100000)
rm(twit)
rm(news)
rm(blogs)


#######################################################################################
################# Task 1: Getting & Cleaning Data, Creating Tokenizer #################
#######################################################################################

# Tasks to accomplish:
#1. Tokenization - identifying appropriate tokens such as words, punctuation, and numbers; 
# Writing a function that takes a file as input and returns a tokenized version of it

#2. Profanity filtering - removing profanity and other words we do not want to predict

#Downloading file from Google Code Archive containing a list of common bad words
badWordsURL <- "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/badwordslist/badwords.txt"
download.file(badWordsURL, destfile = "projData/badwords.txt", method = "curl")
con <- file("projData/badwords.txt", "r")
badWords <- readLines(con, warn = FALSE) #Assigning the words to an object named badWords
close(con)


tokenizedFileOutput <- function(file, lowercase = TRUE) {
  
  con <- file(file, "r")
  data <- readLines(con)
  close(con)      
              
  if(lowercase){
     data <- str_to_lower(data) #Converts the text to lowercase by default    
  }
  
  con <- file("projData/badwords.txt", "r")
  badWords <- readLines(con, warn = FALSE)
  close(con)
    
  tokenize_words(data, stopwords = badWords) #Tokenizes on spaces (unigrams), keeps apostrophes, omits profanity
  
}


###########################################################################
#################### Task 2: Exploratory Data Analysis ####################
###########################################################################

# Tasks to accomplish:
#1. Exploratory analysis - perform a thorough exploratory analysis of the data, understanding 
# the distribution of words and relationship between the words in the corpora.

#2. Understand frequencies of words and word pairs - build figures and tables to understand 
# variation in the frequencies of words and word pairs in the data.

#Creating Top Unigrams Dataframe
blogsTopUnigrams <- tokenize_words(blogsSample) %>% 
                        unlist %>% 
                        data.frame() %>% 
                        rename(blogs_unigrams = 1) %>% 
                        group_by(blogs_unigrams) %>% 
                        summarise(count = n()) %>% 
                        arrange(desc(count)) %>%
                        mutate(percent_share = round(count/sum(count)*100, digits = 1)) %>%
                        head(10)

newsTopUnigrams <- tokenize_words(newsSample) %>% 
                        unlist %>% 
                        data.frame() %>% 
                        rename(news_unigrams = 1) %>% 
                        group_by(news_unigrams) %>% 
                        summarise(count = n()) %>% 
                        arrange(desc(count)) %>%
                        mutate(percent_share = round(count/sum(count)*100, digits = 1)) %>%
                        head(10)

twitTopUnigrams <- tokenize_words(twitSample) %>% 
                        unlist %>% 
                        data.frame() %>% 
                        rename(twit_unigrams = 1) %>% 
                        group_by(twit_unigrams) %>% 
                        summarise(count = n()) %>% 
                        arrange(desc(count)) %>%
                        mutate(percent_share = round(count/sum(count)*100, digits = 1)) %>%
                        head(10)

topUnigrams <- cbind(blogsTopUnigrams, newsTopUnigrams, twitTopUnigrams)
topUnigrams %<>% rename(count1 = 2, percent_share1 = 3, 
                       count2 = 5, percent_share2 = 6, 
                       count3 = 8, percent_share3 = 9)
rm(blogsTopUnigrams, newsTopUnigrams, twitTopUnigrams)


#Creating Top Bigrams Dataframe
blogsTopBigrams <- tokenize_ngrams(blogsSample, n = 2) %>%
                        unlist %>% 
                        data.frame() %>% 
                        rename(blogs_bigrams = 1) %>% 
                        group_by(blogs_bigrams) %>% 
                        summarise(count = n()) %>% 
                        arrange(desc(count)) %>%
                        mutate(percent_share = round(count/sum(count)*100, digits = 1)) %>%
                        head(10) 

newsTopBigrams <- tokenize_ngrams(newsSample, n = 2) %>%
                        unlist %>% 
                        data.frame() %>% 
                        rename(news_bigrams = 1) %>% 
                        group_by(news_bigrams) %>% 
                        summarise(count = n()) %>% 
                        arrange(desc(count)) %>%
                        mutate(percent_share = round(count/sum(count)*100, digits = 1)) %>%
                        head(10)

twitTopBigrams <- tokenize_ngrams(twitSample, n = 2) %>%
                        unlist %>% 
                        data.frame() %>% 
                        rename(twit_bigrams = 1) %>% 
                        group_by(twit_bigrams) %>% 
                        summarise(count = n()) %>% 
                        arrange(desc(count)) %>%
                        mutate(percent_share = round(count/sum(count)*100, digits = 1)) %>%
                        head(10)

topBigrams <- cbind(blogsTopBigrams, newsTopBigrams, twitTopBigrams)
topBigrams %<>% rename(count1 = 2, percent_share1 = 3, 
                       count2 = 5, percent_share2 = 6, 
                       count3 = 8, percent_share3 = 9)
rm(blogsTopBigrams, newsTopBigrams, twitTopBigrams)


#Creating Top Trigrams Dataframe
blogsTopTrigrams <- tokenize_ngrams(blogsSample, n = 3) %>%
                        unlist %>% 
                        data.frame() %>% 
                        rename(blogs_trigrams = 1) %>% 
                        drop_na() %>%
                        group_by(blogs_trigrams) %>% 
                        summarise(count = n()) %>% 
                        arrange(desc(count)) %>%
                        mutate(percent_share = round(count/sum(count)*100, digits = 1)) %>%
                        head(10) 

newsTopTrigrams <- tokenize_ngrams(newsSample, n = 3) %>%
                        unlist %>% 
                        data.frame() %>% 
                        rename(news_trigrams = 1) %>%
                        drop_na() %>%
                        group_by(news_trigrams) %>% 
                        summarise(count = n()) %>% 
                        arrange(desc(count)) %>%
                        mutate(percent_share = round(count/sum(count)*100, digits = 1)) %>%
                        head(10)

twitTopTrigrams <- tokenize_ngrams(twitSample, n = 3) %>%
                        unlist %>% 
                        data.frame() %>% 
                        rename(twit_trigrams = 1) %>%
                        drop_na() %>%
                        group_by(twit_trigrams) %>% 
                        summarise(count = n()) %>% 
                        arrange(desc(count)) %>%
                        mutate(percent_share = round(count/sum(count)*100, digits = 2)) %>%
                        head(10)

topTrigrams <- cbind(blogsTopTrigrams, newsTopTrigrams, twitTopTrigrams)
topTrigrams %<>% rename(count1 = 2, percent_share1 = 3, 
                       count2 = 5, percent_share2 = 6, 
                       count3 = 8, percent_share3 = 9)
rm(blogsTopTrigrams, newsTopTrigrams, twitTopTrigrams)


#Unigrams Chart
topUnigrams %>% gt() %>%
                tab_header(title = md("**Top Unigrams by Count: Blogs, News, & Twitter Datasets**"),
                           subtitle = md("**Using a random sample of n = 100,000 lines from each dataset**")) %>%
                tab_spanner(label = md("**Blogs**"),
                            columns = 1:3) %>%
                tab_spanner(label = md("**News**"),
                            columns = 4:6) %>%
                tab_spanner(label = md("**Twitter**"),
                            columns = 7:9) %>%
                cols_label(blogs_unigrams = md("**Unigram**"),
                           news_unigrams = md("**Unigram**"),
                           twit_unigrams = md("**Unigram**"),
                           count1 = md("**Count**"),
                           count2 = md("**Count**"),
                           count3 = md("**Count**"),
                           percent_share1 = md("**% Share**"),
                           percent_share2 = md("**% Share**"),
                           percent_share3 = md("**% Share**")) %>%
                fmt_percent(columns = c(3,6,9), 
                            scale_values = F, 
                            decimals = 1) %>%
                fmt_integer(columns = c(2,5,8)) %>%
                cols_align(align = "center",
                           columns = c(2,5,8)) %>%
                tab_style(style = cell_borders(sides = "right",
                                               weight = px(1.5)),
                          locations = cells_body(columns = c(3,6))) %>%
                gt_color_rows(columns = c(3,6,9),
                              palette = "ggsci::blue_material",
                              pal_type = "continuous",
                              domain = c(0,8))


#Bigrams Chart
topBigrams %>% gt() %>%
                tab_header(title = md("**Top Bigrams by Count: Blogs, News, & Twitter Datasets**"),
                           subtitle = md("**Using a random sample of n = 100,000 lines from each dataset**")) %>%
                tab_spanner(label = md("**Blogs**"),
                            columns = 1:3) %>%
                tab_spanner(label = md("**News**"),
                            columns = 4:6) %>%
                tab_spanner(label = md("**Twitter**"),
                            columns = 7:9) %>%
                cols_label(blogs_bigrams = md("**Bigram**"),
                           news_bigrams = md("**Bigram**"),
                           twit_bigrams = md("**Bigram**"),
                           count1 = md("**Count**"),
                           count2 = md("**Count**"),
                           count3 = md("**Count**"),
                           percent_share1 = md("**% Share**"),
                           percent_share2 = md("**% Share**"),
                           percent_share3 = md("**% Share**")) %>%
                fmt_percent(columns = c(3,6,9), 
                            scale_values = F, 
                            decimals = 1) %>%
                fmt_integer(columns = c(2,5,8)) %>%
                cols_align(align = "center",
                           columns = c(2,5,8)) %>%
                tab_style(style = cell_borders(sides = "right",
                                               weight = px(1.5)),
                          locations = cells_body(columns = c(3,6))) %>%
                gt_color_rows(columns = c(3,6,9),
                              palette = "ggsci::green_material",
                              pal_type = "continuous",
                              domain = c(0,1.5))


#Trigrams Chart
topTrigrams %>% gt() %>%
                tab_header(title = md("**Top Trigrams by Count: Blogs, News, & Twitter Datasets**"),
                           subtitle = md("**Using a random sample of n = 100,000 lines from each dataset**")) %>%
                tab_spanner(label = md("**Blogs**"),
                            columns = 1:3) %>%
                tab_spanner(label = md("**News**"),
                            columns = 4:6) %>%
                tab_spanner(label = md("**Twitter**"),
                            columns = 7:9) %>%
                cols_label(blogs_trigrams = md("**Bigram**"),
                           news_trigrams = md("**Bigram**"),
                           twit_trigrams = md("**Bigram**"),
                           count1 = md("**Count**"),
                           count2 = md("**Count**"),
                           count3 = md("**Count**"),
                           percent_share1 = md("**% Share**"),
                           percent_share2 = md("**% Share**"),
                           percent_share3 = md("**% Share**")) %>%
                fmt_percent(columns = c(3,6,9), 
                            scale_values = F, 
                            decimals = 1) %>%
                fmt_integer(columns = c(2,5,8)) %>%
                cols_align(align = "center",
                           columns = c(2,5,8)) %>%
                tab_style(style = cell_borders(sides = "right",
                                               weight = px(1.5)),
                          locations = cells_body(columns = c(3,6))) %>%
                gt_color_rows(columns = c(3,6,9),
                              palette = "ggsci::indigo_material",
                              pal_type = "continuous",
                              domain = c(0,1))