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
             
             #Creates a mainPanel that contains all plots and tables
             mainPanel(
               
               #Creates a tab panel separating each plot and table
               tabsetPanel(
                 
                 #Creates tab containing a map plot named 'Tweets about Trump per State Map'; includes click for interaction and interactive information; inlcudes textual description of map
                 tabPanel('Tweets about Trump per State Map', 
                          p("The following visualization displays a United States map, that explains the number of tweets mentioning ", em("Donald Trump"), " per state. On the right side of the state map, one can find a legend, which displays the color that corresponds with a specific range of tweets. By comparing the color of each state with the various colors displayed in the legend, one can identify the range each state falls in to. This visualization also has an interactive feature: by ", em("hovering"), " over a state, one can discover the ", strong("name of the state"), ", as well as the ", strong("range"), " the state falls in to."),
                          plotlyOutput('trump.map', height = "550px",width = "1000px")), 
                 
                 #Creates tab containing a table named 'Tweets about Trump per State Table'; includes textual description
                 tabPanel('Tweets about Trump per State Table', 
                          p("The following table displays the number of tweets mentioning", em("Donald Trump"), "per state. From the table, one can find that the state with the most tweets is ", strong("Texas"), " with ", strong("652"), " tweets, and the state with the least tweets is ", strong("North Dakota"), " with only ", strong("1"), " tweet. One can also use the 'Search' bar to find the data on a specific state, or find the state that corresponds with a specific number of tweets."),
                          dataTableOutput('t.per.state.table')),
                 
                 #Creates tab containing a map plot named 'Tweets about Clinton per State Map'; includes click for interaction and interactive information; inlcudes textual description of map
                 tabPanel('Tweets about Clinton per State Map', 
                          p("The following visualization displays a United States map, that explains the number of tweets mentioning ", em("Hillary Clinton"), " per state. On the right side of the state map, one can find a legend, which displays the color that corresponds with a specific range of tweets. By comparing the color of each state with the various colors displayed in the legend, one can identify the range each state falls in to. States that have zero tweets are colored grey. This visualization also has an interactive feature: by ", em("hovering"), " over a state, one can discover the ", strong("name of the state"), ", as well as the ", strong("range"), " the state falls in to."),
                          plotlyOutput('clinton.map', height = "550px",width = "1000px")), 
                 
                 #Creates tab containing a table named 'Tweets about Clinton per State Table'; includes textual description
                 tabPanel('Tweets about Clinton per State Table', 
                          p("The following table displays the number of tweets mentioning", em("Hillary Clinton"), "per state. From the table, one can find that the state with the most tweets is ", strong("Texas"), " with ", strong("111"), " tweets, and the states with the least tweets are ", strong("North Dakota"), " and ", strong("Nebraska"), " with each having ", strong("0"), " tweets. One can also use the 'Search' bar to find the data on a specific state, or find the state that corresponds with a specific number of tweets."),
                          dataTableOutput('c.per.state.table')),
                 
                 #Creates tab containing a picture and analysis comparing the two map visualizations named 'Analysis'
                 tabPanel('Analysis',
                          p("By comparing the two map visualizations, one can see that the states that tweeted more frequently about ", em("Donald Trump"), " tended to have much fewer tweets mentioning ", em("Hillary Clinton"), " and vice versa. For example, states around the middle of the country (i.e. Oklahoma, Nebraska), have a large number of tweets mentioning ", em("Donald Trump"), " however these states have a much smaller number of tweets mentioning ", em("Hillary Clinton"), ". These results reflect the outcome of the 2016 Presidential Election, as the states in the middle of the nation had a majority vote for ", strong("Donald Trump"), " while the states on the East and West Coast had a majority vote for ", strong("Hillary Clinton"), "."),
                          htmlOutput('image'))
               )
             )
  )
)

#Creates the UI
shinyUI(my.ui)