# Adding libraries and data set
library(ggplot2)
library(tm)
library(SnowballC)
library(wordcloud)
library(RColorBrewer)
library(shinythemes)
library(plotly)
library(dplyr)


my.ui <- fluidPage(
  theme = shinythemes::shinytheme("united"),
  navbarPage("Navbar",
             

             # Navbar1
             tabPanel("Foo"
                      
             ),
             
             # Navbar2
             tabPanel("Bar"
                      
             ),
             
             # Navbar3
             tabPanel("Baz"
                      
             ),
             
    # Navigation bar to polarity of tweets data        
    tabPanel("Tweets Polarity",
                 
                 # Sets header of page and introductory paragraph   
                 h3("Viewing Polarity of Tweets Mentioning Candidates"),
                 h5(strong("Polarizing Party Politics: A Look into Polarity Data of Tweets")),
             
                 p("The purpose of this section is to look at the 'polarity' score given by
                   Vik Paruchuri's data set to tweets", strong(" about "), "three 2016 Presidential candidates: Bernie Sanders,
                   Donald Trump, and Hillary Clinton. Tweets with a polarity of", strong( ' -1 ' ), "theoretically
                   indicates strong negativity while tweets with a polarity of", strong( ' 1 ' ), "indicates strong
                   positivity."),
                 p("The link to the data set: ", a("https://www.dataquest.io/blog/matplotlib-tutorial/")),
             
                 # Details functionalities of plot
                 p(strong("Functionalities: "), "You are able to view polarity by mentioning of ", strong("candidate(s)"), " through the", 
                   em(" checkboxes "), "below. You can also view a certain", strong(" range "), 
                   "of polarity by using the", em(" slider input "), " as well change the type of histogram. You may also drag
                   and zoom in to the data by: "),
                 
                 p("1. ", strong("Dragging and selecting"), "an area of the plot."),
                 p("2. ", strong("Double clicking "), "on the area to zoom in"),
                 p("3. ", strong("Double clicking again"), " to zoom out"),
                 
                 # Note about polarity/sentiment measurements
                 p(strong( em("* A note about polarity * ") ), "Polarity measures the sentiment of the tweet
                   by looking at keywords and associating them with select sentiments such as:
                   positive, negative, anger, sadness, disgust, trust, etc. Polarity scores came
                   with the data set we used."),
                 
                 # Actually plots out plot and allows user to double click, drag, and zoom
                 h4("Polarity Tweets About Candidates"),
                 plotOutput('polarity.plot', dblclick = "polar_dblclick",
                            brush = brushOpts(
                              id = "polar_brush",
                              resetOnNew = TRUE)),
                 verbatimTextOutput("polar.info"),
             
           # Splits widgets into three columns
           fluidRow(
               # Allows user to view polarity by candidate selection with checkbox input
               column(3,
                      checkboxGroupInput('polarity.data', label = 'Polarity of Tweets by Candidate',
                                         choices = c("Trump", "Clinton", "Bernie"), 
                                         selected = c("Trump", "Clinton", "Bernie"))
               ),
               
               # Allows user to view polarity by range with slider input
               column(5,
                      sliderInput('polarity.range', label = 'Polarity Range', min = -1, 
                                  max = 1, value = c(-1, 1), step = 0.1)
               ),
               
               # Allows user to view histogram stacked or dodged with checkbox
               column(3,
                      checkboxInput('stacked', label = "View Stacked Histogram")
           )
               
      ),
      
      # Prints reactive analysis based on data user is viewing
      p(strong("Analysis: "), "The data set we are working with contains 1050 tweets (around 350 about each
        candidate). ", textOutput("polarity.analysis") )
    ),
    
    # Navbar to Bonus page
    tabPanel("Bonus: #MAGA, #WomensMarch",
      
      # Title and description of bonus page examining MAGA and Women's March tweets
      tabPanel("Extra: MAGA and the Women's March Tweets",
               h3("Comparing #MAGA and #WomensMarch"),
               h5(strong( "Did We Really Make America Great Again?") ),
               p("In this extra", em("bonus section "), "you can compare a sample of",
                 strong("#MAGA and #WomensMarch "), "tweets side-by-side from Jan. 20th & 21st. It's more of 
                 a little qualitative look into Twitter data related to Trump and the Women's March."),
               
               # Instructions of page and how to view tweets/img
               p("Go ahead - hit the", strong( em("'Compare' ")), "button. A random tweet from each 
                 hashtag will pop up. If you hit the", strong( em (" 'Generate' ")), " button, it will generate a 
                 random photo from the Women's March twitter data set (which is separate from the tweets). While we 
                 do want to warn that", strong(em(" viewer discretion is advised, ")), "we also want you to have fun
                 perusing through!", em(" - Love the Creative Group")),
               
               p("Data derived from: Wendy He's #MAGA and #WomensMarch data set: ",
                 em(a("https://data.world/wendyhe/tweets-on-womensmarch-and-maga"))),
      
                                      
     # Widgets for the bonus section tweets and images                   
     fluidRow(
       
       # Adds action button to generate tweets
       column(6,
              actionButton('generate.march.tweet', label = "Compare #MAGA & #WM Tweets", width = 300,
                           icon = icon("retweet", lib = "font-awesome"), class = "btn-primary"),
              
              # Generates random tweets into shiny page
              verbatimTextOutput('maga.march.tweet'),
              
              # Adds copy/paste img url option below tweets action button and to side of image
              fluidRow(
                column(9, 
                       h4(strong("Check Out Some of Our Favorite Images: ")),
                       p("We've selected some of our favorite random pictures from the data set
                         for your viewing pleasure. Just ", strong(em("copy and paste")), " any of 
                         the following urls below."),
                       
                       # Outputs the selected url favorites
                       htmlOutput("url.text"),
                       p("Just remember that once you are done viewing, please",
                         strong( em( " delete the url ") ), "from the input.
                         Happy clicking!"),
                       
                       # Text input widget for url
                       textInput("image_url",
                                 label = 'Paste Image URL',
                                 value = "http://placehold.it/300x300"))
                )
              ),
       
       # Generates image in right column
       column(5,
              
              # Makes generating action button for images at random
              actionButton('generate.img', label = "Generate Random Image from Women's March", width = 400,
                           icon = icon("retweet", lib = "font-awesome"), class = "btn-secondary"),
              
              # Outputs image and image url
              htmlOutput("image"),
              verbatimTextOutput("url"))
       )
     
      )
    )
  )
)  

# Make UI from my.ui
shinyUI(my.ui)