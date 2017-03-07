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

#Defines new UI variable for application named my.ui
my.ui <- fluidPage(
  
  #Sets theme for shiny app as 'united'
  theme = shinythemes::shinytheme("united"),
  
  #Creates page with navigation bar
  navbarPage("Comparing Number of Tweets Mentioning Presidential Candidates per State",
    
    #Creates tab containing a map plot named 'Tweets about Trump per State Map'; includes click for interaction and interactive information; inlcudes textual description of map
    tabPanel('Tweets about Trump per State Map', 
             plotlyOutput('trump.map', height = "550px",width = "1000px"), 
             textOutput('plot1.description')),
    
    #Creates tab containing a table named 'Tweets about Trump per State Table'; includes textual description
    tabPanel('Tweets about Trump per State Table', 
             dataTableOutput('t.per.state.table'), 
             textOutput('table1.description')),
    
    #Creates tab containing a map plot named 'Tweets about Clinton per State Map'; includes click for interaction and interactive information; inlcudes textual description of map
    tabPanel('Tweets about Clinton per State Map', 
             plotlyOutput('clinton.map', height = "550px",width = "1000px"), 
             textOutput('plot2.description')),
    
    #Creates tab containing a table named 'Tweets about Clinton per State Table'; includes textual description
    tabPanel('Tweets about Clinton per State Table', 
             dataTableOutput('c.per.state.table'), 
             textOutput('table2.description'))
  )
)

#Creates the UI
shinyUI(my.ui)