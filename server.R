library(ggplot2) 
library(tm) 
library(SnowballC) 
library(wordcloud) 
library(RColorBrewer) 
library(shinythemes) 
library(plotly) 
library(dplyr)

#Loads data sets for analysis from data folder
t.data.map <- read.csv("data/trump.state.map.csv")
c.data.map <- read.csv("data/clinton.state.map.csv")
trump.location <- read.csv("data/trump.state.freq.csv")
clinton.location <- read.csv("data/clinton.state.freq.csv")

#Takes out unnecessary column in both trump.location csv and clinton.location csv
trump.location$X <- NULL
clinton.location$X <- NULL

#Renames the names of the trump.location and clinton.location columns to make them more readable
colnames(trump.location) <- c("State", "Number of Tweets")
colnames(clinton.location) <- c("State", "Number of Tweets")

#Defines a new server variable for application named my.server
my.server <- function(input, output){
  
  #Creates a map of the United States displaying the range of the number of tweets about Donald Trump per state
  output$trump.map <- renderPlotly({
    
    #Creates ggplot map
    p <- ggplot(data = t.data.map) + 
      geom_polygon(aes(x = long, y = lat, group = group, fill = frequency, text = region)) +
      coord_quickmap() +
      scale_fill_brewer(name = "Range of Tweets", palette = "OrRd")
    
    #Uses plotly to add interaction to map
    p <- ggplotly(p)
    
    #Returns map
    return(p)
  })
  
  #Returns a table displaying the information shown on the Donald Trump map; Contains two columns - a State column and a number of tweets column
  output$t.per.state.table <- renderDataTable({
    return(trump.location)
  })
  
  #Creates a map of the United States displaying the range of the number of tweets about Hillary Clinton per state
  output$clinton.map <- renderPlotly({
    
    #Creates ggplot map
    p <- ggplot(data = c.data.map) + 
      geom_polygon(aes(x = long, y = lat, group = group, fill = frequency, text = region)) +
      coord_quickmap() +
      scale_fill_brewer(name = "Range of Tweets", palette = "PuBu")
    
    #Uses plotly to add interaction to map
    p <- ggplotly(p)
    
    #Returns map
    return(p)
  })
  
  #Returns a table displaying the information shown on the Hillary Clinton map; Contains two columns - a State column and a number of tweets column
  output$c.per.state.table <- renderDataTable({
    return(clinton.location)
  })
  
  #Prints out an image displaying Hillary Clinton and Donald Trump
  output$image <- renderUI({
    tags$img(src = "http://media.nbcsandiego.com/images/clinton-trump-split-funny.jpg ", width = 800, height = 450)
  })
}

#Creates the server
shinyServer(my.server)