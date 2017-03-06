library("dplyr")
library("ggplot2")
library("shiny")

# Defines a new 'my.ui' variable with a 'fluidPage' layout to respond to changing data
my.ui <- fluidPage(  
  
  # Creates a 'titlePanel' with a bold title and sets browser title
  titlePanel(strong("Clinton vs. Trump: Whose Tweets are More Popular?")),  
  
  # Layout the page in two columns
  sidebarLayout(   
    
    # Specifies content for the 'sidebarPanel'
    sidebarPanel( 
      
      # Defines 'checkboxGroupInput' widget for user to decide what species to look at
      checkboxGroupInput("twitter.handle", label = "Select Twitter Handle:", choices = levels(candidate.tweets$handle), selected = candidate.tweets$handle)

    ),
      
      # Specifies content for main column  
      mainPanel( 
        
        # Creates tabs for user to view different forms of data either in scatter plot or table format
        tabsetPanel(type = "tabs", 
                    tabPanel("Plot", plotOutput("plot", hover = hoverOpts(id = "hover_key")), verbatimTextOutput("plot_key_info")),
                    tabPanel("Table", tableOutput("table"))
        )
      )
    )
  )
  
  # Creates a new 'shinyUI()' to be used in the 'shinyApp()'
  shinyUI(my.ui)