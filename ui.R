# Adding libraries and data set
library(ggplot2)
library(tm)
library(SnowballC)
library(wordcloud)
library(RColorBrewer)
library(shinythemes)
library(plotly)

# WHERE TO ADD THAT + THEME_MINMAL()??
# WHY ISNT TEXT FORMATTING WORKING

# Defines a new 'my.ui' variable with a 'fluidPage' layout to respond to changing data
my.ui <- fluidPage(  
  
  # Selects UI theme
  theme = shinytheme("united"), 
  
  # Creates NavBar layout
  navbarPage(
    "Navbar",
    
    # Creates a tab panel in navbar  
    tabPanel("Popularity of Tweets", 
        
        # Creates Main Panel
        mainPanel(
          
          # Inserts plot into main panel
          h3(strong("Compare Number of Retweets and Favorites for Clinton and Trump")),
          p('The purpose of this plot is to look at the', strong("number of retweets"), "and the", 
            strong("number of favorites"), "Hillary Clinton and Donald Trump received for their tweets. 
            The plot includes tweets from", em("January 2016 through September 2016"), "prior to the
            presidential election. To see the exact numbers and the candidate with whom the tweet is 
            associated with,", em("hover your mouse over a specific point.")),
          plotlyOutput("tweets.plot"),
          width = 10
      )
    ),
    
    # Creates another tab panel in navbar      
    tabPanel("Tweet Summary Statisctics", 
        
        # Inserts tables, headers, and descriptions into new tab  
        h3(strong("Summary Statistics for Clinton and Trump Tweets")),
        p("The table below shows summary statistics with regards to tweets from Donald Trump and Hillary 
          Clinton. Data includes the total, maximum, and minimum number of favorites and retweets each 
          candidate got along with the average number of retweets and favorites received. "),
        tableOutput("tweet.stats.table"), 
        
        h3(strong("Specific Tweets")),
        p("The tables below shows the specific tweets from Donald Trummp and Hillary CLinton's twitter handles 
          that received the maximum and minimum number of favorites and retweets. You'll notice that in both cases, 
          the tweets that received the most amount of retweets also received the most number of favorites."),
        tableOutput("clinton.table"), 
        tableOutput("trump.table")
             
        
      )
    )
  )
   
  
  # Creates a new 'shinyUI()' to be used in the 'shinyApp()'
  shinyUI(my.ui)