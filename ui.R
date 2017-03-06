library("dplyr")
library("ggplot2")
library("shiny")

my.ui <- fluidPage(
  sidebarLayout(
    
    # Side panel contains interactive widgets
    sidebarPanel(
      checkboxGroupInput('polarity.data', label = 'Polarity of Tweets by Candidate',
                         choices = c("Trump", "Clinton", "Bernie"), selected = "Clinton"), 
      
      sliderInput('polarity.range', label = 'Polarity Range', min = -1, 
                  max = 1, value = c(-1, 1), step = 0.1),
      
      actionButton('generate.tweet', label = "Random Tweet About Candidate(s)", 
                   icon = icon("retweet", lib = "font-awesome"))
    ),
    
    mainPanel(
      plotOutput('polarity.plot', dblclick = "polar_dblclick",
                 brush = brushOpts(
                   id = "polar_brush",
                   resetOnNew = TRUE)),
                 verbatimTextOutput("polar.info")
    )
    
  )
)

shinyUI(my.ui)