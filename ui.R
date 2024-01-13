library(shiny)
library(shinyWidgets)
library(shinythemes)
library(bslib)
library(shinydashboard)

fluidPage(
        theme = shinytheme("flatly"),
        navbarPage(title = " "),
        titlePanel(h1("NLP Predictive Text App", align = "center")),
        br(),
        sidebarPanel(
                box(title = "Contact Info & Links",
                    status = "primary",
                    width = "100%",
                    solidHeader = TRUE,
                    h5("App created by:"),
                    h4("Kenen Corea"),
                    HTML("<a href='https://github.com/kenenc'>Github</a>"),
                    br(),
                    HTML("<a href='https://www.linkedin.com/in/kenenc/'>LinkedIn</a>"))
        ),
        mainPanel(
                shinyWidgets::useShinydashboard(),
                box(title = "App Info",
                    status = "primary",
                    width = "100%",
                    collapsible = TRUE,
                    collapsed = TRUE,
                    solidHeader = TRUE,
                    h4("Motive/Background", align = "center"),
                    p("This NLP (Natural Language Processing) text prediction app was built as part of the final capstone project for
                    the ten-course Data Science Specialization offered by John Hopkins University. As the final project, students were
                    challenged to delve into an unfamiliar area of data science that was not previously taught in any of the courses
                    prior. As stated in the instructions for the assignment on Coursera:"),
                    p(em("\"You will use all of the skills you have 
                    learned during the Data Science Specialization in this course, but you'll notice that we are tackling a brand new 
                    application: analysis of text data and natural language processing. This choice is on purpose. As a practicing data 
                    scientist you will be frequently confronted with new data types and problems. A big part of the fun and challenge of 
                    being a data scientist is figuring out how to work with these new data types to build data products people love.\"")),
                    p("Overall, I had a great (and challenging) time diving into the world of NLP in order to fully learn the nuances
                    and main challenges/steps in order to create a working text processing algorithm. All in all, it took me around three weeks 
                    of on-and-off work to fully complete this project, starting from having zero baseline knowledge of NLP."),
                    h4("The Data", align = "center"),
                    p(tagList("The data used to train this model was sourced from a corpus called HC Corpora, provided by the company SwiftKey.
                      This dataset contains plain text (.txt) files of lines scraped from three different sources: blog postings, the news, and
                      Twitter posts. All three of these datasets were sampled and used to varying degrees in order to train this model.",
                              HTML("<a href='https://rpubs.com/KenenC/Milestone'>Click here</a>"),
                              "to view the milestone report assignment for this project to see the exploratory analysis that was performed on the datasets.")),
                    h4("How It Works", align = "center"),
                    p("One of main, crucial components to creating a text prediction algorithm lies within the concept of n-grams. N-grams
                    essentially denote a number (n) of word pairs. For example, lets take the sentence: \"We should go to the beach\". In this case,
                    the 1-grams (aka unigrams) of the sentence would be: \"we\", \"should\", \"go\", \"to\", \"the\", \"beach\". The 2-grams (aka bigrams) 
                    would then be: \"we should\", \"should go\", \"go to\", \"to the\", \"the beach\" (notice the overlapping of words that captures each 
                    combination) and so on and so forth for each additional n-gram."),
                    p("The basis of these text prediction algorithms essentially revolve around taking a user input, and examining the last n-grams of it 
                    (in this case, I trained my model to use 5-grams, so the algorithm starts by checking the last five words of input). 
                    From there, the algorithm checks an entire dataframe full of the highest-order n-grams, looking for any exact matches of that particular phrase.
                    If there is a match, the algorithm will then return the highest probability word that follows the phrase (probabilities are determined
                    by the data used to train the model)."),
                    p(tagList("If the probability of a higher-order n-gram is zero (not present in the training data), the algorithm \"backs off\" to a lower-order n-gram. 
                      In other words, it uses the probability of a shorter sequence as an estimate for the missing higher-order probability. This concept describes
                      the idea of a backoff algorithm, and in this case, I opted to use a Stupid Backoff Algorithm from the",
                            HTML("<a href='https://cran.r-project.org/web/packages/sbo/index.html'>SBO package</a>.")))),
                box(title = "How To Use",
                    status = "primary",
                    solidHeader = TRUE,
                    width = "100%",
                    "Simply enter a short sentence that you would like to predict the next word of in the text box, and
                    click the button to generate the word(s). The app will then return the three most probable word predictions based on 
                    the last five words of input. Please note that the more complex/obscure of a sentence you 
                    enter, the less likely it is for the algorithm to correctly predict the next word."),
                textInput("phrase",
                          "Type a sentence that you wish to predict the next word of:",
                          placeholder = "I want to eat ice",
                          width = "100%"),
                actionButton("button",
                             "Click to generate next word",
                             width = "100%"),
                splitLayout(
                        cellWidths = c("33.3%", "33.3%", "33.3%"),
                        h4("Prediction 1:"),
                        h4("Prediction 2:"),
                        h4("Prediction 3:")
                ),
                splitLayout(
                        cellWidths = c("33.3%", "33.3%", "33.3%"),
                        box(textOutput("word1"),
                            status = "primary"),
                        box(textOutput("word2"),
                            status = "primary"),
                        box(textOutput("word3"),
                            status = "primary")
                ),
                box(status = "warning",
                    width = "100%",
                    strong("NOTE:"),
                    "This is a very basic, first-attempt implementation of a text prediction algorithm. Due to the scope
                    of this project (as well as the memory/computational limitations of a Shiny app and the tradeoffs between
                    app speed and model size), there is only so much accuracy that can be squeezed out of this particular model.")
        ) 
)
