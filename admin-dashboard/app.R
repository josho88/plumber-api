## ---------------------------
##
## Script name:
##
## Purpose of script: Create a simple we app that monitors the health of the API and shows how front ends can interact with the prediction endpoint
##
## Author: Josh Olney
##
## Date Created: 29/1/2022
##
## Email: josho88@hotmail.co.uk; induco.sols@gmail.com
##
## ---------------------------
##
## Notes:


# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

## ---------------------------


library(shiny)
library(httr)
library(tidyverse)


baseURL <- 'http://127.0.0.1/v1' # <-- address our API is running, locally

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Admin Dashboard"),

    # Sidebar with a slider input for number of bins 
    tagList(
        tabsetPanel(
            tabPanel(
                "API Status",
                h4('Status:'),
                uiOutput('health'),
                br(),
                h4('Version:'),
                uiOutput('version'),
                br(),
                h4('Session Info'),
                reactable::reactableOutput('session')
            ),
            tabPanel(
                "MPG Prediction",
                shiny::sliderInput('disp', 'Disp:', min = 0, max = 200, value = 30),
                h4("Predicted MPG:"),
                uiOutput('prediction')
            )
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$health <- renderUI({
        # ping the healthcheck endpoint every 2 seconds
        invalidateLater(2000)
        
        time <- Sys.time()
        res <- tryCatch({
            httr::GET(paste0(baseURL, '/health'))
        }, error = function(e){
            return(NULL) 
        })
        
        if(is.null(res)){
            i <- icon("thumbs-down")
            msg <- "Something went wrong, API appears to be down"
        } else if(res$status_code==200){
            i <- icon("thumbs-up")
            msg <- paste("The API is up and running!")
        } else {
            i <- icon("thumbs-down")
            msg <- "Something went wrong, API appears to be down"
        }
 
        return(tags$div(time, br(), i, msg))
    })
    
    output$version <- renderUI({

        version <- tryCatch({
            res <- httr::GET(paste0(baseURL, '/version')) %>% content()
            return(res$result)
        }, error = function(e){
            return("Unavailable") 
        })
        
        return(p(version))
    })
    
    output$session <- reactable::renderReactable({

        session <- tryCatch({
            res <- httr::GET(paste0(baseURL, '/session')) %>% content()
            res$result %>% bind_rows()
        }, error = function(e){
            return("Unavailable") 
        })
        
        reactable::reactable(session)
    })
    
    output$prediction <- renderUI({
        pred <- tryCatch({
            res <- httr::GET(paste0(baseURL, '/mpg_predict'), query = list(disp = input$disp)) %>% content()
            res$result
        }, error = function(e){
            return("Unavailable") 
        })
        
        h4(pred)
        
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
