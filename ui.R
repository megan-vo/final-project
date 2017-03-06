library(ggplot2)
library(dplyr)
library(tm)
library(SnowballC)
library(wordcloud)
library(RColorBrewer)

#Creating UI
my.ui <- fluidPage(
  
  # Application title
  titlePanel("Word Cloud"),
  
  sidebarLayout(
    # Sidebar with a slider and selection inputs
    sidebarPanel(
      
      sliderInput("freq",
                  "Minimum Frequency:",
                  min = 50,  max = 1000, value = 100),
      sliderInput("max",
                  "Maximum Number of Words:",
                  min = 1,  max = 300,  value = 100)
    ),
    
    # Show Word Cloud
    mainPanel(
      plotOutput("plot", width = "100%")
    )
  )
  
)

# Calls UI
shinyUI(my.ui)