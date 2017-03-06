library("dplyr")
library("ggplot2")
library("shiny")

my.ui <- fluidPage(
  sidebarLayout(
    
    # Side panel contains interactive widgets
    sidebarPanel(
      checkboxGroupInput('polarity.data', label = 'Polarity of Tweets by Candidate',
                         choices = c("Trump", "Clinton", "Bernie"), selected = "Clinton"), 
      
      sliderInput('polarity.range', label = 'Polarity Range', min = -1, 
                  max = 1, value = c(-1, 1), step = 0.1),
      
      checkboxInput('stacked', label = "View Stacked Histogram"),
      
      #actionButton('generate.tweet', label = "Tweets & Polarity About Candidate(s)", 
                   #icon = icon("retweet", lib = "font-awesome")),
      
      textInput("image_url",
                label = 'Paste Image URL',
                value = "http://placehold.it/300x300"),
      
      actionButton('generate.march.tweet', label = "Compare #MAGA & #WomensMarch",
                   icon = icon("retweet", lib = "font-awesome"))
    ),
    
    mainPanel(
      tabsetPanel(type = "tabs",
                  tabPanel("Polarity of Tweets",
                           h3("Viewing Polarity of Tweets Mentioning Candidates"),
                           h5(strong("Polarizing Party Politics: A Look into Polarity Data of Tweets")),
                           p("The purpose of this section is to look at the 'polarity' score given by
                             Vik Paruchuri's data set to tweets", strong(" about "), "three 2016 Presidential candidates: Bernie Sanders,
                             Donald Trump, and Hillary Clinton. Tweets with a polarity of", strong( ' -1 ' ), "theoretically
                             indicates strong negativity while tweets with a polarity of", strong( ' 1 ' ), "indicates strong
                             positivity."),
                           
                           p(strong("Functionalities: "), "You are able to view polarity by mentioning of ", strong("candidate(s)"), " through the", 
                             em(" checkboxes "), "on the sidebar. You can also view a certain", strong(" range "), 
                             "of polarity by using the", em(" slider input."), "To generate a tweet about that candidate
                             with the polarity score, hit the ", strong("Tweets & Polarity "), "button. You may also drag
                             and zoom in to the data by: "),
                           
                           p("1. ", strong("Dragging "), "an area of the box."),
                           p("2. ", strong("Double clicking "), "on the area to zoom in"),
                           p("3. ", strong("Double clicking again"), " to zoom out"),
                           
                           p(strong( em("* A note about polarity * ") ), "Polarity measures the sentiment of the tweet
                             by looking at keywords and associating them with select sentiments such as:
                             positive, negative, anger, sadness, disgust, trust, etc. Polarity scores came
                             with the data set we used."),
                           
                           plotOutput('polarity.plot', dblclick = "polar_dblclick",
                                      brush = brushOpts(
                                        id = "polar_brush",
                                        resetOnNew = TRUE)),
                           p(strong("Analysis: ") ),
                           verbatimTextOutput("polar.info")),
                  
                  
                  tabPanel("Extra: MAGA and the Women's March Tweets",
                           h3("Comparing #MAGA and #WomensMarch"),
                           h5("Did We Really Make America Great Again?"),
                           p("In this extra", em("bonus section "), "you can compare a sample of",
                             strong("#MAGA and #WomensMarch "), "tweets side-by-side from Jan. 20th & 21st. It's more of 
                             a little qualitative look into Twitter data related to Trump and the Women's March."),
                           
                           p("Go ahead - hit the", strong( em("'Compare' ")), "button. A random tweet from each 
                             hashtag will pop up along with a randomly generated photo (separate from the tweets)
                             from the Women's March. Next, ", strong( em("copy and paste ") ), "the url. While we do want
                             to warn that", em(" viewer discretion is advised, "), "we also want you to have fun
                             perusing through!", em(" - Love the Creative Group")),
                           
                           p("Data derived from: Wendy He's #MAGA and #WomensMarch Data set: ",
                             em(a("https://data.world/wendyhe/tweets-on-womensmarch-and-maga"))),
                           
                           verbatimTextOutput('maga.march.tweet'),
                           htmlOutput("image"))
      )
      
    )
    
  ) 
)

shinyUI(my.ui)