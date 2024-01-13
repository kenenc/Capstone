library(tidyverse)
library(magrittr)
library(R.utils)
library(sbo)

#Reading in the datasets and badWords file
twitCon <- file("projData/final/en_US/en_US.twitter.txt", "r")
suppressWarnings(twit <- readLines(twitCon))
close(twitCon)
        
newsCon <- file("projData/final/en_US/en_US.news.txt", "r")
news <- readLines(newsCon)
close(newsCon)
        
blogsCon <- file("projData/final/en_US/en_US.blogs.txt", "r")
blogs <- readLines(blogsCon)
close(blogsCon)

wordsCon <- file("projData/badwords.txt", "r")
badWords <- readLines(wordsCon, warn = FALSE)
close(wordsCon)

rm(twitCon, newsCon, blogsCon, wordsCon)


# Taking samples of lines from each dataset, then merging them all into one 100k line training set
blogs40k <- sample(blogs, size = 40000)
news40k <- sample(news, size = 40000)
twit20k <- sample(twit, size = 20000)
train100k <- c(blogs40k, news40k, twit20k) #Creating training set
rm(blogs, news, twit, blogs40k, news40k, twit20k)


###########################################################
### Building Stupid Back-Off algorithm with SBO package ###
###########################################################

stop_words <- stopwords::stopwords("en")

#Creating the model using a predtable to store it out of memory
modelPredTable <- sbo_predtable(object = train100k,
                                N = 5, #Predicts up to 5-grams
                                dict = target ~ 1, #Targets the entire training set
                                .preprocess = sbo::preprocess, #Preprocesses data
                                EOS = ".?!:;", #End of Sentence tokens 
                                lambda = 0.4, #Standard lambda parameter
                                L = 3L, #Predicts top 3 words
                                #Filters selected words
                                filtered = c("<UNK>", "<EOS>", "the", "to", "and", stop_words, badWords))

#Saving our model predtable to the main directory as an rda object
save(modelPredTable, file = "modelPredTable.rda")
