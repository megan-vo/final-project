# Adding libraries and data set
library(ggplot2)
library(shiny)
library(tm)
library(SnowballC)
library(wordcloud)
library(RColorBrewer)
library(shinythemes)
library(plotly)
library(dplyr)

###############
# Data Frames #
###############

# Set up data frame of 1050 tweets about candidates 
sample.polarity <- read.csv("data/sample.polarity.tweets.csv", stringsAsFactors = F)

# Set up data frames with random samples of #MAGA, #WomensMarch, and Women's March images
maga <- read.csv("data/MAGAtweets.csv", stringsAsFactors = F) %>% 
  sample_n(300)
w.march <- read.csv("data/womensmarchtweets.csv", stringsAsFactors = F) %>% 
  sample_n(300)
march.photos <- read.csv("data/womensmarchphotos.csv", stringsAsFactors = F) %>% 
  sample_n(300)

# Reads in 'trump-clinton-tweets.csv' file and stores into data frame 'candidate.tweets'
candidate.tweets <- read.csv("data/trump-clinton-tweets.csv")

# Adds 'canidate' column to dataframe based on the Twitter handle
candidate.tweets$candidate[candidate.tweets$handle == "HillaryClinton"] <- "Hillary Clinton"
candidate.tweets$candidate[candidate.tweets$handle=="realDonaldTrump"] <- "Donald Trump"

# Reads in data set for word analysis
data <- read.csv("data/Crowdbabble_Social-Media-Analytics_Twitter-Download_Donald-Trump_7375-Tweets.csv")

# Filtering data for tweet text
corpus <- Corpus(VectorSource(data$Tweet_Text))

# Text Processing to isolate text
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, tolower)
corpus <- tm_map(corpus, function(x) iconv(x, 'UTF-8', 'ASCII'))
corpus <- tm_map(corpus, removeWords, stopwords(kind = "en"))
corpus <- tm_map(corpus, stripWhitespace)
corpus <- tm_map(corpus, tolower) 
corpus <- tm_map(corpus, function(x) iconv(x, 'UTF-8', "ASCII"))
corpus <- tm_map(corpus, removeWords, stopwords(kind = "en")) 
corpus <- tm_map(corpus, stripWhitespace) 
corpus <- tm_map(corpus, removeWords, c("will", "thank", "realdonaldtrump", "amp",
                                        "just", "people", "get", "now", "like", "new",
                                        "back", "dont", "much"))
# THIS IS FOR THE FREQ PLOT
# Creates document term matrix
dtm <- DocumentTermMatrix(corpus)
# Organize terms by their frequency
freq <- colSums(as.matrix(dtm))
# This will identify all terms that appear frequently in a data frame
wf <- data.frame(word=names(freq), freq=freq)

#Loads data sets for analysis from data folder
t.data.map <- read.csv("data/trump.state.map.csv")
c.data.map <- read.csv("data/clinton.state.map.csv")
trump.location <- read.csv("data/trump.state.freq.csv")
clinton.location <- read.csv("data/clinton.state.freq.csv")

#Takes out unnecessary column in both trump.location csv and clinton.location csv
trump.location$X <- NULL
clinton.location$X <- NULL

#Renames the names of the trump.location and clinton.location columns to make them more readable
colnames(trump.location) <- c("State", "Number of Tweets")
colnames(clinton.location) <- c("State", "Number of Tweets")

##########
# Server #
##########

# Defines server function
my.server <- function(input, output) {
  
  #############
  # Polarity  #
  #############
  
  # Creates reactive function that takes in user input and changes polarity tweets data frame to view
  polarity.candidate <- reactive({
    data <- sample.polarity
    
    # If the user checks one, two, or three checkboxes, filters according to who they checked
    if (length(input$polarity.data) == 1) {
      data <- filter(data, Candidate == input$polarity.data)
    } else if (length(input$polarity.data) == 2) {
      data <- filter(data, Candidate == input$polarity.data[1]) 
      data.other <- filter(sample.polarity, Candidate == input$polarity.data[2])
      data <- rbind(data, data.other)
    } 
    
    # Filters based on range of slider input
    data <- filter(data, polarity > input$polarity.range[1] & polarity < input$polarity.range[2])
    return(data)
  })
  
  # Resets x and y bounds based on user zoom in/out
  ranges <- reactiveValues(x = NULL, y = NULL)
  
  # Creates polarity plot
  output$polarity.plot <- renderPlot({
    
    # Creates histogram of polarity based on reactive data
    plot <- ggplot(polarity.candidate(), aes(polarity, fill = Candidate)) +
      geom_histogram(position = "dodge", binwidth = 0.1) +
      scale_fill_brewer(direction = -1) + 
      theme_minimal() +
      coord_cartesian(xlim = ranges$x, ylim = ranges$y) # reset axes of plot based on zoom in/out
    
    # Change the positioning of the histogram to stacked if user indicates
    if(input$stacked) {
      plot <- plot + geom_histogram(position = "stack")
    }
    
    return(plot)
  })
  
  # Interactivity of plot using double clicks and brushes
  observeEvent(input$polar_dblclick, {
    brush <- input$polar_brush
    
    # Set the plot's axes and zoom in if the user selects an area and double clicks
    if(!is.null(brush)) {
      ranges$x <- c(brush$xmin, brush$xmax)
      ranges$y <- c(brush$ymin, brush$ymax)
      
      # If the user double clicks again, zoom out
    } else {
      ranges$x <- NULL
      ranges$y <- NULL
    }
  })
  
  # Generate analysis of polarity tweets based on data user is viewing 
  output$polarity.analysis <- renderText({
    data <- polarity.candidate()
    
    # Grab the number of rows, max and min polarity, and the candidates those tweets are mentioning
    rows <- nrow(data)
    max <- max(data$polarity)
    max.candidate <- filter(data, polarity == max) %>% select(Candidate)
    max.candidate <- unique(max.candidate$Candidate)
    
    # If there is more than one candidate with the max, print custom message
    if (length(max.candidate) == 3) {
      max.candidate <- "Bernie, Clinton, and Trump"
    } else if (length(max.candidate) == 2) {
      max.candidate <- paste(max.candidate[1], "and", max.candidate[2])
    } 
    
    # Find the min polarity and candidate
    min <- min(data$polarity)
    min.candidate <- filter(data, polarity == min) %>% select(Candidate)
    min.candidate <- unique(min.candidate$Candidate)
    
    # If multiple candidates have same min polarity, print custom message
    if (length(min.candidate) == 3) {
      min.candidate <- "Bernie, Clinton, and Trump"
    } else if (length(min.candidate) == 2) {
      min.candidate <- paste(min.candidate[1], "and", min.candidate[2])
    }
    
    # Find total average polarity of data
    avg <- data %>% 
      summarize(avg = mean(data$polarity))
    
    # Find summary statistics of sample 350 of each candidate
    summary <- sample.polarity %>% 
      group_by(Candidate) %>% 
      summarize(mean = mean(polarity))
    
    
    # Analysis of data based on reactive data
    analysis <- paste0("You are currently viewing ", rows, " tweets of 1050. The most positive score is ",
                       round(max, 2), ", which mentions the candidate(s) ", max.candidate, ". The most negative score is 
                       ", round(min, 2), ", and it is about the candidate(s) ", min.candidate, ". The current average
                       polarity is ", round(avg, 1), ". We notice overall that most of the tweets had a score
                       of or around 0. It is important to note that the data and the derivative means of the data
                       are probably not perfect, and there are possible errors in the sentiment analysis.
                       In this data set, however, tweets mentioning Bernie had the highest average polarity score of ", 
                       round(summary$mean[1], 2), ". Tweets mentioning Trump had the next highest polarity average of ",
                       round(summary$mean[3], 2), " with tweets about Clinton having an average score of ", round(summary$mean[2],
                                                                                                                  2),
                       ". We would have to do further statistical analysis to see if the differences are actually
                       significant enough to say that Bernie tweeters on average had more positive things to say,
                       and that tweeters mentioning Trump had more positive sentiments than tweets about Hillary. It
                       does not seem like there is much variance in the average polarity of tweets about each candidate,
                       as each had a distribution including very negative, neutral, and positive tweets. This could be
                       indicative of our especially divisive election year and reflective of our diverse sentiments
                       as a nation about our candidates (or at least within the Twitter connected population).")
    return(analysis)
  })
  
  #########
  # Bonus #
  #########
  
  # Generate a new image url if action button is clicked
  img.url <- reactive({
    if (input$generate.img) {
      march.image <- march.photos %>% 
        sample_n(1) #grab one image
      return(march.image)
    }
  })
  
  # Generate random tweets
  output$maga.march.tweet <- renderPrint({
    
    # If user presses action button, generate new random tweet from sample
    if(input$generate.march.tweet) {
      tweet.maga <- maga %>% 
        sample_n(1)
      tweet.march <- w.march %>% 
        sample_n(1)
      
      # Format text of tweets
      tweet.maga <- paste("#MAGA: ", tweet.maga$text)
      tweet.march <- paste("#WomensMarch: ", tweet.march$text)
      cat(tweet.maga, tweet.march, sep = "\n\n")
    }
    
  })
  
  # Generates new image based on either button or copy/paste url
  output$image <- renderUI({
    
    # If user chooses to hit action button, generate new random image
    if(input$image_url == "http://placehold.it/300x300" || input$image_url == "") {
      tags$img(src = img.url()$image, width = 400, height = 400) 
      
      # If user chooses to copy paste, generates chosen url image
    } else {
      tags$img(src = input$image_url, width = 400, height = 400)
    }
  })
  
  # Prints out image URL to shiny page
  output$url <- renderPrint({
    cat("URL: ", img.url()$image)
  })
  
  # List out favorite image urls
  output$url.text <- renderUI({
    list <- tags$ul(
      tags$li("http://pbs.twimg.com/media/C2u4QQvWEAAqLpM.jpg"),
      tags$li("http://pbs.twimg.com/media/C2u5J4aW8AEQcZW.jpg"),
      tags$li("http://pbs.twimg.com/media/C2u1HdaUAAAfNUR.jpg"),
      tags$li("http://pbs.twimg.com/media/C2u2tJ3UcAAKqdn.jpg")
    )
    HTML(paste("", list, ""), sep = "</br>") # separate the list from the paragraph text with break line
  })
  
  ####################
  # Retweets & Faves #
  ####################
  # Creates two separate data tables holding just Clinton's tweets and just Trump's tweets
  clinton.tweets <- filter(candidate.tweets, handle == "HillaryClinton")
  trump.tweets <- filter (candidate.tweets, handle == "realDonaldTrump")
  
  # Defines function that takes in a data frame of one of the candidate's tweets and finds sumary statistics
  findSummaryStats <- function(candidate.data) {
    
    retweet.sum  <- round(sum(candidate.data$retweet_count))
    favorite.sum <- round(sum(candidate.data$favorite_count))
    max.retweets <- round(max(candidate.data$retweet_count))
    min.retweets <- round(min(candidate.data$retweet_count))
    max.favorites <- round(max(candidate.data$favorite_count))
    min.favorites <- round(min(candidate.data$favorite_count))
    avg.retweets <- round(mean(candidate.data$retweet_count))
    avg.favorites <- round(mean(candidate.data$favorite_count))
    
    stats <- c(retweet.sum, favorite.sum, max.retweets, min.retweets, max.favorites, min.favorites, avg.retweets, avg.favorites)
    return(stats)
    
  }
  
  
  # Finds summary statistics for each candidate's tweets using 'findSummaryStats' functon
  clinton.stats <- findSummaryStats(clinton.tweets)
  trump.stats <- findSummaryStats(trump.tweets)
  
  # Creates a data table of the summary stats of tweets from both Clinton and Trump
  summary.stats.table <- data.frame(clinton.stats, trump.stats)
  
  # Adds row names to the data table
  row.names(summary.stats.table) <- c("Retweet Sum", "Favorites Sum", "Maxmimum Number of Retweets", "Minimum Number of Retweets", "Maximum Number of Favorites", "Minimum Number of Favorites", "Average Number of Retweets", "Average Number of Favorites") 
  
  # Renames the columns into more readable titles
  colnames(summary.stats.table) <- c("Hillary Clinton", "Donald Trump")
  
  # Defines function 'findTweets' that takes in a data frame of one candidate's tweets and finds the specific tweets withthe max and min favorites and retweets
  findTweets <- function(candidate.data) {
    candidate.retweet.max <- max(candidate.data$retweet_count) 
    retweet.max.filtered <- filter(candidate.data, retweet_count == candidate.retweet.max)
    max.retweet.text <- retweet.max.filtered[, 'text']
    
    candidate.retweet.min <- min(candidate.data$retweet_count) 
    retweet.min.filtered <- filter(candidate.data, retweet_count == candidate.retweet.min)
    min.retweet.text <- retweet.min.filtered[, 'text']
    
    candidate.favorite.max <- max(candidate.data$favorite_count) 
    favorite.max.filtered <- filter(candidate.data, favorite_count == candidate.favorite.max)
    max.favorite.text <- favorite.max.filtered[, 'text']
    
    candidate.favorite.min <- min(candidate.data$favorite_count) 
    favorite.min.filtered <- filter(candidate.data, favorite_count == candidate.favorite.min)
    min.favorite.text <- favorite.min.filtered[, 'text']
    
    max.min.tweets <- data.frame(max.retweet.text, min.retweet.text, max.favorite.text, min.favorite.text)
    return(max.min.tweets)
    
  }
  
  # Finds tweets for Clinton
  clinton.max.min <- findTweets(clinton.tweets) 
  
  # Adds row name to table
  row.names(clinton.max.min) <- c("Hillary Clinton")
  
  # Renames columns into more readable titles
  colnames(clinton.max.min) <- c("Tweet with Most Retweets", "Tweet with Least Retweets", "Tweet with Most Favorites", "Tweet with Least Favorites")
  
  # Finds tweets for Trump
  trump.max.min <- findTweets(trump.tweets)
  
  # Adds row name to table
  row.names(trump.max.min) <- c("Donald Trump")
  
  # Renames columns into more readable titles
  colnames(trump.max.min) <- c("Tweet with Most Retweets", "Tweet with Least Retweets", "Tweet with Most Favorites", "Tweet with Least Favorites")
  
  clinton.trump.tweets <- rbind(clinton.max.min, trump.max.min) 
  
  
  # Renders a ggplot with data from the 'candidate.tweets' file with number of retweets on x-axis, number of favorites on y-axis, and the color based on the candidate
  output$tweets.plot <- renderPlotly({ 
    
    p <- ggplot(data = candidate.tweets, mapping = aes(x = retweet_count, y = favorite_count, color = candidate)) +
      
      geom_point(alpha = 0.4, size = 4) +
      
      xlim(0, 50000) +
      
      ylim(0, 100000) +
      
      labs(title = "Clinton vs. Trump: Retweets and Favorites",
           x = "Retweets",
           y = "Favorites") +
      
      scale_colour_manual("", 
                          breaks = c("Donald Trump", "Hillary Clinton"),
                          values = c("red", "blue")) +
      
      theme_light(base_size=14) 
    
  })
  
  # Renders a data frame that consists of all the information regarding summary statistics of tweets form both Clinton and Trump
  output$tweet.stats.table <- renderTable({
    
    data.frame(summary.stats.table)
    
    
  },
  
  include.rownames = TRUE
  
  )
  
  # Renders data frame holding just the specific tweets with max and min number of retweets and favorites for Clinton and Trump
  output$clinton.trump.table <- renderTable({
    
    data.frame(clinton.trump.tweets)
    
    
  },
  
  include.rownames = TRUE
  
  )
  
  #################
  # Word Analysis #
  #################
  # Creates Reactive variable for the wordcloud
  terms <- reactive({
    myDTM = TermDocumentMatrix(corpus, control = list(minWordLength = 1))
    m = as.matrix(myDTM)
    sort(rowSums(m), decreasing = TRUE)
  })

  # Make the wordcloud drawing predictable during a session
  wordcloud_rep <- repeatable(wordcloud)

  # Creates Output for Word Cloud
  output$plot.cloud <- renderPlot({
    v <- terms()
    wordcloud_rep(names(v), v, scale=c(6,0.5),
                  min.freq = input$freq, max.words=input$max,
                  colors=brewer.pal(8, "Dark2"))
  })

  # Creates output for Frequency Plot
  output$graph <- renderPlotly({
    p <- ggplot(subset(wf, freq>350), aes(word, freq))
    p <- p + geom_bar(stat="identity")
    p <- p + theme(axis.text.x=element_text(angle=45, hjust=1))
    p <- p + labs(x = "Word(s)", y = "Frequency")
    p
  })

  #################
  # Map of Tweets #
  #################
  #Creates a map of the United States displaying the range of the number of tweets about Donald Trump per state
  output$trump.map <- renderPlotly({
    
    #Creates ggplot map
    p <- ggplot(data = t.data.map) + 
      geom_polygon(aes(x = long, y = lat, group = group, fill = frequency, text = region)) +
      coord_quickmap() +
      scale_fill_brewer(name = "Range of Tweets", palette = "OrRd") +
      theme_minimal()
    
    #Uses plotly to add interaction to map
    p <- ggplotly(p)
    
    #Returns map
    return(p)
  })
  
  #Returns a table displaying the information shown on the Donald Trump map; Contains two columns - a State column and a number of tweets column
  output$t.per.state.table <- renderDataTable({
    return(trump.location)
  })
  
  #Creates a map of the United States displaying the range of the number of tweets about Hillary Clinton per state
  output$clinton.map <- renderPlotly({
    
    #Creates ggplot map
    p <- ggplot(data = c.data.map) + 
      geom_polygon(aes(x = long, y = lat, group = group, fill = frequency, text = region)) +
      coord_quickmap() +
      scale_fill_brewer(name = "Range of Tweets", palette = "PuBu") +
      theme_minimal()
    
    #Uses plotly to add interaction to map
    p <- ggplotly(p)
    
    #Returns map
    return(p)
  })
  
  #Returns a table displaying the information shown on the Hillary Clinton map; Contains two columns - a State column and a number of tweets column
  output$c.per.state.table <- renderDataTable({
    return(clinton.location)
  })
  
  #Prints out an image displaying Hillary Clinton and Donald Trump
  output$t.c.image <- renderUI({
    tags$img(src = "http://media.nbcsandiego.com/images/clinton-trump-split-funny.jpg ", width = 800, height = 450)
  })
  
  ###############
  # Home Images #
  ###############
  output$home.image <- renderUI({
    tags$img(src = "https://www.cardschat.com/news/wp-content/uploads/2016/05/clinton-vs-trump-1.jpg",
             width = 500, height = 300)
  })
  
  output$aneesha <- renderUI({
    tags$img(src = "https://scontent.xx.fbcdn.net/v/t31.0-8/15195931_1342470159106100_7777921903677895156_o.jpg?oh=9da1fdeed29bc150bdc9cc4516b166d6&oe=5973AB1D",
             width = 200, height = 200)  
  })
  
  output$sahana <- renderUI({
    tags$img(src = "https://scontent.xx.fbcdn.net/v/t1.0-0/p526x296/17022153_10208931030939488_4816631109457856095_n.jpg?oh=c2591e8da97c30d8174cadec99a12988&oe=5930CF26",
             width = 200, height = 200)
  })
  
}

# Creates server 
shinyServer(my.server)