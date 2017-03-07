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
# Do I need to add analysis??

# Defines a new 'my.ui' variable with a 'fluidPage' layout to respond to changing data
my.ui <- fluidPage(  
  
  # Selects UI theme
  theme = shinytheme("united"), 
  
  # Creates NavBar layout
  navbarPage(
    "Navbar",
    
    # Creates a tab panel in navbar  
    tabPanel("Popularity of Tweets", 
             
      tabsetPanel(type = "tabs",
                  
        tabPanel("Tweet Popularity Plot",
          
         # Creates Main Panel
          mainPanel(
              
                  # Inserts plot into main panel with heading and description
                  h3(strong("Comparing the Number of Retweets and Favorites for Clinton and Trump")),
                  
                  p("The purpose of this plot is to look at the", strong("number of retweets"), "and the", 
                    strong("number of favorites"), "Hillary Clinton and Donald Trump received for their tweets. 
                    The plot includes tweets from", em("January 2016 through September 2016"), "prior to the
                    presidential election. To see the exact numbers and the candidate with whom the tweet is 
                    associated with,", em("hover your mouse over a specific point."),""),
                  
                  br(),
                  
                  plotlyOutput("tweets.plot"),
                  
                  br(),
                  
                  p("The information from the plot above comes from the following dataset: https://www.kaggle.com/benhamner/clinton-trump-tweets")
          )  
        ),
      
      # Creates another tab panel in navbar      
      tabPanel("Tweet Summary Statisctics Table", 
          
          # Inserts tables, headers, and descriptions into new tab  
          h3(strong("Summary Statistics for Clinton and Trump Tweets")),
          
          p("The table below shows", em("summary statistics"), "with regards to tweets from Donald Trump and Hillary 
            Clinton. Data includes the total, maximum, and minimum number of favorites and retweets each 
            candidate got along with the average number of retweets and favorites received. "),
          
          br(),
          
          p(strong("Observations: ")),
          p("1. Generally, Trump's tweets were more popular amongst the general public
                as he has a higher total sum of retweets and favorites and higher averages of retweets and favorites."),
          p("2. Clinton's tweet that received the maximum number of favorites was significantly higher 
                than Trump's tweet that received the maximum number of favorites."),
          p("3. Clinton's tweets that received the least number of favorites and retweets were also significantly lower
                than the least amount of favorites and retweets Trump received."),
          br(),
          
          tableOutput("tweet.stats.table"), 
          
          p(strong("Conclusion: "), " Worldwide, Trump's tweets from January 2016 to September 2016 were more popular than 
            Clinton's tweets. If anything, this just goes to show that Trump's tweets were more entertaining and abrasive 
            than Clinton's since we cannot know the exact motives people had for retweeting and favoriting Trump's tweets. 
            That being said, this sentiment is reflected in the outcome of the 2016 presidential election as his popularity 
            won him the presidency of the United States."),
          
          h3(strong("Specific Tweets")),
  
          p("The tables below shows the", em("specific tweets"), "from Donald Trummp and Hillary Clinton's twitter handles 
            that received the maximum and minimum number of favorites and retweets."),
          
          br(),
          
          p(strong("Observations: ")),
          p("1. In both cases, the tweets that received the most amount of retweets also received the most number of favorites."),
          p("2. Tweets with the most favorites and retweets for both Trump and Clinton were aimed in a negative manner towards."), 
          p("3. Ironically, the tweet with the least number of retweets for Clinton's account had to do with women's power which 
            could be seen as commentary on the world's opinion regarding women in authoratative positions."), 
  
          br(),
          
          tableOutput("clinton.trump.table"),
          
          br(),
          
          p("The information from the tables above comes from the following dataset: https://www.kaggle.com/benhamner/clinton-trump-tweets")
               
        )
      )
    )
  )
)
     
  
  # Creates a new 'shinyUI()' to be used in the 'shinyApp()'
  shinyUI(my.ui)