library(shiny)

function(input, output, session) {
        
        library(tidyverse)
        library(magrittr)
        library(R.utils)
        library(sbo)
        
        #Loading in the saved model predtable
        load("modelPredTable.rda")
        
        #Retrieving the model from the predtable
        model <- sbo_predictor(modelPredTable)
        
        
        user_input <- reactive({
                input$phrase
        })

        word_prediction1 <- reactive({
                predict(model, user_input())[1]
        }) 
                 
        output$word1 <- renderText({
                if(input$button >= 1){
                        input$button
                        isolate(word_prediction1())
                }
        })
        
        word_prediction2 <- reactive({
                predict(model, user_input())[2]
        }) 
        
        output$word2 <- renderText({
                if(input$button >= 1){
                        input$button
                        isolate(word_prediction2())
                }
        })
        
        word_prediction3 <- reactive({
                predict(model, user_input())[3]
        }) 
        
        output$word3 <- renderText({
                if(input$button >= 1){
                        input$button
                        isolate(word_prediction3())
                }
        })
        


}
