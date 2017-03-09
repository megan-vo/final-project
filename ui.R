# Adding libraries 
library(ggplot2)
library(shiny)
library(tm)
library(SnowballC)
library(wordcloud)
library(RColorBrewer)
library(shinythemes)
library(plotly)
library(dplyr)

# Defines a new 'my.ui' variable with a 'fluidPage' layout to respond to changing data
my.ui <- fluidPage(  
  
  # Selects UI theme
  theme = shinytheme("united"), 
  
  # Creates NavBar layout
  navbarPage(
    "Navbar",
    
    navbarMenu("Home",
               tabPanel("Home",
                        p("Our thesis goes here: ")
                        
                        ),
               tabPanel("About",
                        p("Who are we?")
                        )
    ),
               
    
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
                         tabPanel("Tweet Summary Statistics Table", 
                                  
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
                                  ),
    
    

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
    ),
    
    # Navbar3
    tabPanel("Map of Tweets about Candidates",
             #Creates a mainPanel that contains all plots and tables
             mainPanel(
               
               #Creates a tab panel separating each plot and table
               tabsetPanel(
                 
                 #Creates tab containing a map plot named 'Tweets about Trump per State Map'; includes click for interaction and interactive information; inlcudes textual description of map
                 tabPanel('Tweets about Trump State Map', 
                          h3("Analyzing Number of Tweets Mentioning Donald Trump per State"),
                          p("The following visualization displays a United States map, that explains the number of tweets mentioning ", em("Donald Trump"), " per state. On the right side of the state map, one can find a legend, which displays the color that corresponds with a specific range of tweets. By comparing the color of each state with the various colors displayed in the legend, one can identify the range each state falls in to. This visualization also has an interactive feature: by ", em("hovering"), " over a state, one can discover the ", strong("name of the state"), ", as well as the ", strong("range"), " the state falls in to."),
                          plotlyOutput('trump.map', height = "550px",width = "1000px"),
                          p("The information from the plot above comes from the following dataset: https://www.dataquest.io/blog/matplotlib-tutorial/.")), 
                 
                 #Creates tab containing a table named 'Tweets about Trump per State Table'; includes textual description
                 tabPanel('Tweets about Trump per State Table', 
                          h3("Number of Tweets Mentioning Donald Trump per State Data Table"),
                          p("The following table displays the number of tweets mentioning", em("Donald Trump"), "per state. From the table, one can find that the state with the most tweets is ", strong("Texas"), " with ", strong("652"), " tweets, and the state with the least tweets is ", strong("North Dakota"), " with only ", strong("1"), " tweet. One can also use the 'Search' bar to find the data on a specific state, or find the state that corresponds with a specific number of tweets."),
                          dataTableOutput('t.per.state.table')),
                 
                 #Creates tab containing a map plot named 'Tweets about Clinton per State Map'; includes click for interaction and interactive information; inlcudes textual description of map
                 tabPanel('Tweets about Clinton State Map', 
                          h3("Analyzing Number of Tweets Mentioning Hillary Clinton per State"),
                          p("The following visualization displays a United States map, that explains the number of tweets mentioning ", em("Hillary Clinton"), " per state. On the right side of the state map, one can find a legend, which displays the color that corresponds with a specific range of tweets. By comparing the color of each state with the various colors displayed in the legend, one can identify the range each state falls in to. States that have zero tweets are colored grey. This visualization also has an interactive feature: by ", em("hovering"), " over a state, one can discover the ", strong("name of the state"), ", as well as the ", strong("range"), " the state falls in to."),
                          plotlyOutput('clinton.map', height = "550px",width = "1000px"),
                          p("The information from the plot above comes from the following dataset: https://www.dataquest.io/blog/matplotlib-tutorial/.")), 
                 
                 #Creates tab containing a table named 'Tweets about Clinton per State Table'; includes textual description
                 tabPanel('Tweets about Clinton per State Table', 
                          h3("Number of Tweets Mentioning Hillary Clinton per State Data Table"),
                          p("The following table displays the number of tweets mentioning", em("Hillary Clinton"), "per state. From the table, one can find that the state with the most tweets is ", strong("Texas"), " with ", strong("111"), " tweets, and the states with the least tweets are ", strong("North Dakota"), " and ", strong("Nebraska"), " with each having ", strong("0"), " tweets. One can also use the 'Search' bar to find the data on a specific state, or find the state that corresponds with a specific number of tweets."),
                          dataTableOutput('c.per.state.table')),
                 
                 #Creates tab containing a picture and analysis comparing the two map visualizations named 'Analysis'
                 tabPanel('Analysis',
                          h3("Comparing Number of Tweets Mentioning Presidential Candidates per State"),
                          p("By comparing the two map visualizations, one can see that the states that tweeted more frequently about ", em("Donald Trump"), " tended to have much fewer tweets mentioning ", em("Hillary Clinton"), " and vice versa. For example, states around the middle of the country (i.e. Oklahoma, Nebraska), have a large number of tweets mentioning ", em("Donald Trump"), " however these states have a much smaller number of tweets mentioning ", em("Hillary Clinton"), ". These results reflect the outcome of the 2016 Presidential Election, as the states in the middle of the nation had a majority vote for ", strong("Donald Trump"), " while the states on the East and West Coast had a majority vote for ", strong("Hillary Clinton"), "."),
                          htmlOutput('t.c.image'),
                          p("This picture comes from the following source: http://media.nbcsandiego.com/images/clinton-trump-split-funny.jpg"))
               )
             )
             
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