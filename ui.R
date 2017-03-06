library("dplyr")
library("ggplot2")
library("shiny")

all.tweets <- read.csv("data/tweets.csv")

my.ui <- fluidPage(
  
  titlePanel("'President' Trump lol lol lol lol lol lol"),
  
  sidebarLayout(
    
    sidebarPanel(
      #checkboxGroupInput('candidates', label = "Choose Candidates", choices = c("Donald Trump", "Hilary Clinton", "Bernie Sanders"))
      
    ),
    
    mainPanel(
      tabsetPanel(type = "tabs",
        tabPanel('Plot', plotOutput('plot', click = 'click.key'))
      )
    )
  )
)

shinyUI(my.ui)