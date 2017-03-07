library("dplyr")
library("ggplot2")
library("shiny")
library("plotly")

# Defines a new 'my.ui' variable with a 'fluidPage' layout to respond to changing data
my.ui <- fluidPage(  
  
  # Creates a 'titlePanel' with a bold title and sets browser title
  titlePanel(strong("Clinton vs. Trump: Whose Tweets are More Popular?")),  
  
  # Layout the page in two columns
  sidebarLayout(   
    
    # Specifies content for the 'sidebarPanel'
    sidebarPanel( 
      
      p("this is my description")
      

    ),
      
      # Specifies content for main column  
      mainPanel( 
        
        # Creates tabs for user to view different forms of data either in scatter plot or table format
        tabsetPanel(type = "tabs", 
                    tabPanel("Plot", plotlyOutput("tweets.plot")),
                    tabPanel("Table", tableOutput("tweets.table"))

        )
      )
    )
  )
  
  # Creates a new 'shinyUI()' to be used in the 'shinyApp()'
  shinyUI(my.ui)