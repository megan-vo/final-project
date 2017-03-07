# Adding libraries 
library(ggplot2)
library(tm)
library(SnowballC)
library(wordcloud)
library(RColorBrewer)
library(shinythemes)
library(plotly)
library(dplyr)

# Creates the UI
ui = fluidPage(
  # Selects UI theme
  theme = shinytheme("united"),
  # Creates NavBar layout
  navbarPage(
    "Trump's Tweets",
    tabPanel("Word Analysis",
             # Creates side panel 
             sidebarPanel(
               # Min Freq Slider Widget
               sliderInput("freq",
                           "Minimum Frequency",
                           min = 50,  max = 1000, value = 100),
               # Max words Slider widget
               sliderInput("max",
                           "Maximum Number of Words",
                           min = 1,  max = 300,  value = 100)
             ),
    
    # Creates Main Panel
    mainPanel(
      tabsetPanel(
        # Creates Word Cloud Tab
        tabPanel("Word Cloud",
                 h3('Trump\'s Tweets Word Frequency Cloud'),
                 p('The purpose of this section is to look at the',
                 em("word choice"), 'and the', em('frequency'), 
                 'of that word choice with regards to over', strong('7,000'), 'of Donald Trump\'s', 
                 strong('tweets.'),
                 'This is displayed by a', em('word cloud,'), ' 
                 the words are colorized for visual diferentiation and
                 will display as larger if they are more frequently used. By 
                 looking at the word cloud c'),
                 p('', strong('Functionalities:'), 'You are able to 
                   filter for the minimum amount of times a word appears in set of tweets 
                   as well as filter for the maximum amount of words in the cloud via the
                   widgets on the side.'),
                 plotOutput("plot.cloud", width = "100%"),
                 p(strong("Observations:"), "By looking at the word cloud it is easy to see that the largest and most frequent word by far
                   is well, Trump. This is due to amount of times Trump quoted a tweet with his own name in it. This goes to show that 
                   our President must be", em("very "), " concerned with his public perception. It also shows that his word choice is
                   usually rather blunt and abrasive, one the requires a good amount of imagination to take any relevant or coherent meaning from it."),
                 p('The data set for both the cloud and the plot was derived from - https://www.crowdbabble.com/blog/the-11-best-tweets-of-all-time-by-donald-trump/')
        ),
        # Creates Frequency Plot Tab
        tabPanel("Frequency Plot",
                 h3("Trump\'s Tweets Word Frequency Bar Plot"),
                 p('The purpose of this section is too look at the most frequnently 
                   occuring words in Trump\'s tweets and their frequency.'),
                 p('', strong('Functionalities:'), 'You are able to 
                   hover over each bar of the graph to get specific information.'),
                 plotlyOutput("graph"),
                 p(strong("Observations:"), "By looking at the word cloud it is easy to see that the largest and most frequent word by far
                   is well, Trump. This is due to amount of times Trump quoted a tweet with his own name in it. This goes to show that 
                   our President must be", em("very "), " concerned with his public perception. It also shows that his word choice is
                   usually rather blunt and abrasive, one the requires a good amount of imagination to take any relevant or coherent meaning from it.")
                 )
        
      )
     )
    )
  )
  
  
)

# Calls UI
shinyUI(ui)