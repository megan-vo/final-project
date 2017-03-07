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

my.ui <- fluidPage(
  theme = shinythemes::shinytheme("united"),
  navbarPage("Comparing Number of Tweets per State between Donald Trump and Hillary Clinton Pre-Election",
    tabPanel('Tweets about Trump State Map', plotOutput('trump.map', click = 'click.key1'), textOutput('plo1t.description'), verbatimTextOutput('trump.info')),
    tabPanel('Tweets about Clinton State Map', plotOutput('clinton.map', click = 'click.key2'), textOutput('plot2.description'), verbatimTextOutput('clinton.info')),
    tabPanel('Tweets about Trump per State Table', dataTableOutput('t.per.state.table'), textOutput('table1.description')),
    tabPanel('Tweets about Clinton per State Table', dataTableOutput('c.per.state.table'), textOutput('table2.description'))
    
  )
)

shinyUI(my.ui)