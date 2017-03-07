# Adding libraries and data set
library(ggplot2)
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
}

# Creates server 
shinyServer(my.server)