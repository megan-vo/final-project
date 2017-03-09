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
    "Trump's Twitter Tussle",
    
    # Create drop down navbar menu for 'Home', 'about', and 'data sets'
    navbarMenu("Home",
               tabPanel("Home",
                        h3(strong("Let's Tweet Politics")),
                        h4("Background and Overall Analysis: "),
                        p("This past election year has been many things: significant, tumultuous, unprecedented - all depending on how you see it. From a technological standpoint,
                          this election has been uniquely marked by widespread", strong(" social media "), 
                          "use about politics, not just from those concerned with politics but from the candidates themselves."),
                        p("Trump’s online presence has been especially combative and", em(" present "), " — for lack of a better word — and it is with this in mind that we took interest
                          in looking at some Twitter data to analyze aspects of what people and the
                          candidates had to say on social media. We hope that this will be of interest to the general public,
                          specifically individuals intrigued with politics and social media. It also may be an area of exploration for election forecasters
                          looking at how social media affects or explains trends in politics."),
                        p("In our core project sections, you will find information about", strong(" Trump and Clinton’s favorites and retweets, grammar analysis of Trump’s tweets, US maps of tweets mentioning both Clinton and 
                          Trump, and polarity of tweets mentioning presidential candidates."), 
                          " In addition, we have a", strong(" bonus "), "section that looks at #MAGA (Make America Great Again) and #WomensMarch tweets for a more qualitative look into political viewpoints on social media."),
                        p("We found that Trump’s tweets from January 2016 to September 2016 were", em(" more popular "), "than Clinton’s tweets in terms of favorites and retweets. 
                          This could be due to word choice of each candidate’s tweets, and when we look at Trump’s grammar frequency, we do see that it is marked by abrasive and blunt 
                          language. If you take into account Twitter’s inherent ‘DNA’ marked by bursts of", strong( em( " short, 140-characters,") ), " it may be that attention-grabbing, 
                          quick posts are the tweets that capture the most attention. It brings into question whether social media platforms actually foster political conversation or 
                          verge on short bits of loud mess (or both)."),
                        p("We also decided to look at the polarity of tweets", em(" about "), "these candidates and found that the three presidential candidates we looked at for this section 
                          (Sanders, Clinton, and Trump) had distributions of very positive, neutral, and very negative tweets. We mapped out where these tweets were coming from and found out 
                          that states that tweeted more about Trump were less likely to tweet about Hillary and vice versa. This reflects the outcome of the 2016 Presidential Election, which 
                          is interesting because our data is a snapshot of one day’s worth of Twitter scraping in May 2016."),
                        p("Some of what we look at is meant to be tongue-in-cheek, and we aimed to present information in a way that was both interesting and fun to view. There are many more 
                          questions to explore about the", strong(" nature of social media and its role in politics, "), "and our analysis only scratches the surface. There’s a lot more data 
                          out there to be looked at regarding this topic, and it will be interesting to see how social media and politics will continue to evolve in the future. 
                          After all, who says it's only the younger generations that are addicted to social media?"),
                        htmlOutput('home.image')
                        
               ),
               
               # "About" drop down tab
               tabPanel("About",
                        h3(strong("Get To Know Us!")),
                        p("We are a group of students at the University of Washington passionate about
                          technology and data. We had a lot of fun working on this project for our Informatics class and hope you 
                          enjoy perusing through."),
                        
                        # Create two columns for bios
                        fluidRow(
                          column(6,
                                 h5(strong("Aneesha Nanda")),
                                 htmlOutput('aneesha'),
                                 p("Aneesha Nanda is a sophomore at the University of Washington, intending to study both Informatics and Public Health. 
                                   A fun fact about Aneesha is that she is a part of the Bollywood dance team on campus."),
                                 h5(strong("Megan Bui")),
                                 
                                 # Add picture
                                 img(src='megan.png', width = 200, height = 200),
                                 p("Megan Bui is a sophomore at the University of Washington studying Computer Science and Sociology. 
                                   A fun fact about Megan is that she is a part of a band with some of her fellow CSE 14x TAs.")
                          ),
                          column(6,
                                 h5(strong("Alex Alspaugh")),
                                 
                                 # Add picture
                                 img(src='alexpic.png', width = 200, height = 200),
                                 p("Alex Alspaugh is a freshman at the University of Washington intending to study Informatics.
                                   He plans to focus on human computer interaction and user centered design, and a fun fact about Alex
                                   is that he enjoys photography as a hobby."),
                                 h5(strong("Sahana Vishwanath")),
                                 htmlOutput('sahana'),
                                 p("Sahana Vishwanath is a sophomore at the University of Washington, intending to study Informatics with a concentration in Data Science. 
                                   A fun fact about Sahana is that she has been trained in multiple Indian dance forms.")
                          )
                        )

               ),
               
               # Add data sets tab to drop down menu.
               tabPanel("Data Sets",
                        h3("List of Data Sets We Used"),
                        p("Trump vs. Clinton Tweets' Faves and Retweets: ", a("https://www.kaggle.com/benhamner/clinton-trump-tweets")),
                        p("Tweets about Candidates for Map and Polarity: ", a("https://www.dataquest.io/blog/matplotlib-tutorial/")),
                        p("Trump Tweets for Word Analysis: ", a("https://www.crowdbabble.com/blog/the-11-best-tweets-of-all-time-by-donald-trump/")),
                        p("#MAGA & #WomensMarch Tweets/Images: ", a("https://data.world/wendyhe/tweets-on-womensmarch-and-maga"))
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
                         tabPanel("Tweet Summary Statistics Table and Analysis", 
                                  
                                  # Inserts tables, headers, and descriptions into new tab  
                                  h3(strong("Summary Statistics for Clinton and Trump Tweets")),
                                  
                                  p("The table below shows", em("summary statistics"), "with regards to tweets from Donald Trump and Hillary 
                                    Clinton. Data includes the total, maximum, and minimum number of favorites and retweets each 
                                    candidate got, along with the average number of retweets and favorites received. "),
                                  
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
                                  
                                  p("The table below shows the", em("specific tweets"), "from Donald Trummp and Hillary Clinton's twitter handles 
                                    that received the maximum and minimum number of favorites and retweets."),
                                  
                                  br(),
                                  
                                  p(strong("Observations: ")),
                                  p("1. In both cases, the tweets that received the most amount of retweets also received the most number of favorites."),
                                  p("2. Tweets with the most favorites and retweets for both Trump and Clinton were aimed in a negative manner towards Clinton."), 
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
                            'This is displayed by a', em('word cloud '), ' 
                            in which the words are colorized for visual diferentiation and
                            will display as larger if they are more frequently used.'),
                          p('', strong('Functionalities:'), 'You are able to 
                            filter for the minimum amount of times a word appears in a set of tweets 
                            as well as filter for the maximum amount of words in the cloud via the
                            widgets on the side.'),
                          plotOutput("plot.cloud", width = "100%"),
                          p(strong("Observations:"), "By looking at the word cloud it is easy to see that the largest and most frequent word by far
                            is, well, Trump. This is due to the amount of times Trump quoted a tweet with his own name in it. This goes to show that 
                            our President must be", em("very "), " concerned with his public perception. It also shows that his word choice is
                            usually rather blunt and abrasive, one that requires a good amount of imagination to take any relevant or coherent meaning from it."),
                          p('The data set for both the cloud and the plot was derived from - https://www.crowdbabble.com/blog/the-11-best-tweets-of-all-time-by-donald-trump/')
                          ),
                 # Creates Frequency Plot Tab
                 tabPanel("Frequency Plot",
                          h3("Trump\'s Tweets Word Frequency Bar Plot"),
                          p('The purpose of this section is to look at the most frequently 
                            occuring words in Trump\'s tweets and their frequency.'),
                          p('', strong('Functionalities:'), 'You are able to 
                            hover over each bar of the graph to get specific information.'),
                          plotlyOutput("graph"),
                          p(strong("Observations:"), "By looking at the word cloud it is easy to see that the largest and most frequent word by far
                            is, well, Trump. This is due to the amount of times Trump quoted a tweet with his own name in it. This goes to show that 
                            our President must be", em("very "), " concerned with his public perception. It also shows that his word choice is
                            usually rather blunt and abrasive, one that requires a good amount of imagination to take any relevant or coherent meaning from it."),
                          p('The data set for both the cloud and the plot was derived from - https://www.crowdbabble.com/blog/the-11-best-tweets-of-all-time-by-donald-trump/')
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
                          p("The following visualization displays a United States map that explains the number of tweets per state mentioning ", em("Donald Trump"), ". On the right side of the state map, one can find a legend, which displays the color that corresponds with a specific range of tweets. By comparing the color of each state with the various colors displayed in the legend, one can identify the range each state falls into. This visualization also has an interactive feature: by ", em("hovering"), " over a state, one can discover the ", strong("name of the state"), ", as well as the ", strong("range"), " the state falls into."),
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
                          p("The following visualization displays a United States map that explains the number of tweets per state mentioning ", em("Hillary Clinton"), ". On the right side of the state map, one can find a legend, which displays the color that corresponds with a specific range of tweets. By comparing the color of each state with the various colors displayed in the legend, one can identify the range each state falls into. States that have zero tweets are colored grey. This visualization also has an interactive feature: by ", em("hovering"), " over a state, one can discover the ", strong("name of the state"), ", as well as the ", strong("range"), " the state falls into."),
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
                          p("By comparing the two map visualizations, one can see that the states that tweeted more frequently about ", em("Donald Trump"), " tended to have much fewer tweets mentioning ", 
                            em("Hillary Clinton"), " and vice versa. For example, states around the middle of the country (i.e. Oklahoma, Nebraska), have a large number of tweets mentioning ", em("Donald Trump"), " however these states have a much smaller number of tweets mentioning ", em("Hillary Clinton"), 
                            ". These results reflect the outcome of the 2016 Presidential Election, as the states in the middle of the nation had a majority vote for ", 
                            strong("Donald Trump"), " while the states on the East and West Coast had a majority vote for ", strong("Hillary Clinton"), ". The tweets
                            were scraped from May 10th, 2016 data."),
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
               positivity. The data were scraped from May 10th, 2016's tweets."),
             p("The link to the data set: ", a("https://www.dataquest.io/blog/matplotlib-tutorial/")),
             
             # Details functionalities of plot
             p(strong("Functionalities: "), "You are able to view polarity by mentioning of ", strong("candidate(s)"), " through the", 
               em(" checkboxes "), "below. You can also view a certain", strong(" range "), 
               "of polarity by using the", em(" slider input "), " as well as change the type of histogram. You may also drag
               and zoom into the data by: "),
             
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
                      p("In this extra", em("bonus section, "), "you can compare a sample of",
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