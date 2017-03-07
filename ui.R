# Adding libraries and data set
library(ggplot2)
library(tm)
library(SnowballC)
library(wordcloud)
library(RColorBrewer)
library(shinythemes)
library(plotly)

# WHERE TO ADD THAT + THEME_MINMAL()??
# ARE TABS WITHIN NAVBAR OK?
# WHY ISNT TEXT FORMATTING WORKING
# ADD DESCRIPTIONS TO TABLE
# ADD COMMENTS

# Defines a new 'my.ui' variable with a 'fluidPage' layout to respond to changing data
my.ui <- fluidPage(  
  
  # Selects UI theme
  theme = shinytheme("united"), 
  
  # Creates NavBar layout
  navbarPage(
    "Navbar",
      
    tabPanel("Tweet Popularity Analysis", 
        
        # Creates side panel
        sidebarPanel(
          
          # Adds Description  
          p("This plot shows the number of", strong("retweets (x-axis)"), "and the number of", strong("favorites (y-axis)"), "specific tweets received from the Twitter accounts of Donald Trump and Hillary Clinton. The tweets that are accounted for in this plot are from January 2016 through September 2016.", em("Hover over the plot to see the candidate, the exact number of retweets, and the exact number of favorites."))
      
      ),
        
        # Creates Main Panel
        mainPanel( 
          
          tabsetPanel(type = "tabs", 
                      tabPanel("Plot", plotlyOutput("tweets.plot")),
                      
                      tabPanel("Table", tableOutput("tweet.stats.table"), tableOutput("clinton.table"), tableOutput("trump.table"))
            
          )
      )
    )
  )
)
  
  
  
  # Creates a new 'shinyUI()' to be used in the 'shinyApp()'
  shinyUI(my.ui)