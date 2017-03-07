library(ggplot2) 
library(tm) 
library(SnowballC) 
library(wordcloud) 
library(RColorBrewer) 
library(shinythemes) 
library(plotly) 
library(dplyr)

t.data.map <- read.csv("data/trump.state.map.csv")
c.data.map <- read.csv("data/clinton.state.map.csv")
trump.location <- read.csv("data/trump.state.freq.csv")
clinton.location <- read.csv("data/clinton.state.freq.csv")

trump.location$X <- NULL
clinton.location$X <- NULL

colnames(trump.location) <- c("State", "Number of Tweets")
colnames(clinton.location) <- c("State", "Number of Tweets")

my.server <- function(input, output){
  output$trump.map <- renderPlot({
    p <- ggplot(data = t.data.map) + 
      geom_polygon(aes(x = long, y = lat, group = group, fill = frequency)) +
      coord_quickmap() +
      #scale_fill_distiller(name="???", palette = "Set2", na.value = "grey50") +
      labs(title="Trump")
    p
  })
  
  output$trump.info <- renderPrint({
    return(input$click.key1)
  })
  
  output$t.per.state.table <- renderDataTable({
    return(trump.location)
  })
  
  output$clinton.map <- renderPlot({
    
    p <- ggplot(data = c.data.map) + 
      geom_polygon(aes(x = long, y = lat, group = group, fill = frequency)) +
      coord_quickmap() +
      #scale_fill_distiller(name="???", palette = "Set2", na.value = "grey50") +
      labs(title="Clinton")
    
    p
  })
  
  output$clinton.info <- renderPrint({
    return(input$click.key2)
  })
  
  output$c.per.state.table <- renderDataTable({
    return(clinton.location)
  })
  
}

shinyServer(my.server)