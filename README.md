# NLP Predictive Text App
## Background/Motive
This repository contains the code used in the analysis, model building, and Shiny app of my capstone project submission from the ten-course Data Science Specialization 
offered by John Hopkins University. [Click here](https://kenen.shinyapps.io/predictionApp/) to try the app yourself! **There is an entire "app info" section that goes more in depth regarding the specifics of the app.
To avoid redundancy, this README will not cover the specifics of this project.** Additionally, the milestone report (linked under the "analysis_code.r" section below) also provides more context and information surrounding
the project.

## Files
-  **analysis_code.r:** Contains the code used to perform the exploratory analysis on the corpuses of text as part of the milestone report assignment. [Click here](https://rpubs.com/KenenC/Milestone) to actually view
  the Rpubs report/analysis itself.
- **model_code.r:** Contains the code used to create and save the SBO (Stupid Backoff) algorithm/model out of memory as an .rda object. The Shiny app's server can then simply read in the saved model and provide very responsive
  predictions (~0.013 seconds)
- **ui.r:** Contains the Shiny app's UI code.
- **server.r:** Contains the Shiny app's server code.
