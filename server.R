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

sample.polarity <- read.csv("data/sample.polarity.tweets.csv", stringsAsFactors = F)
maga <- read.csv("data/MAGAtweets.csv", stringsAsFactors = F) %>% 
  sample_n(300)
w.march <- read.csv("data/womensmarchtweets.csv", stringsAsFactors = F) %>% 
  sample_n(300)
march.photos <- read.csv("data/womensmarchphotos.csv", stringsAsFactors = F) %>% 
  sample_n(300)

# Defines server function
my.server <- function(input, output) {
  
  polarity.candidate <- reactive({
    data <- sample.polarity
    if (length(input$polarity.data) == 1) {
      data <- filter(data, Candidate == input$polarity.data)
    } else if (length(input$polarity.data) == 2) {
      data <- filter(data, Candidate == input$polarity.data[1]) 
      data.other <- filter(sample.polarity, Candidate == input$polarity.data[2])
      data <- rbind(data, data.other)
    } 
    data <- filter(data, polarity > input$polarity.range[1] & polarity < input$polarity.range[2])
    return(data)
  })
  
  ranges <- reactiveValues(x = NULL, y = NULL)
  
  output$polarity.plot <- renderPlot({
    plot <- ggplot(polarity.candidate(), aes(polarity, fill = Candidate)) +
      geom_histogram(position = "dodge", binwidth = 0.1) +
      scale_fill_brewer(direction = -1) + 
      theme_minimal() +
      coord_cartesian(xlim = ranges$x, ylim = ranges$y) 
    
    if(input$stacked) {
      plot <- plot + geom_histogram(position = "stack")
    }
    
    return(plot)
  })
  
  observeEvent(input$polar_dblclick, {
    brush <- input$polar_brush
    if(!is.null(brush)) {
      ranges$x <- c(brush$xmin, brush$xmax)
      ranges$y <- c(brush$ymin, brush$ymax)
    } else {
      ranges$x <- NULL
      ranges$y <- NULL
    }
  })
  
  output$polarity.analysis <- renderText({
    data <- polarity.candidate()

    rows <- nrow(data)
    max <- max(data$polarity)
    max.candidate <- filter(data, polarity == max) 
    max.candidate <- unique(max.candidate$Candidate)
    if (length(max.candidate) == 3) {
      max.candidate <- "Bernie, Clinton, and Trump"
    } else if (length(max.candidate) == 2) {
      max.candidate <- max.candidate[1] + " and " + max.candidate[2]
    } 
    
    min <- min(data$polarity)
    min.candidate <- filter(data, polarity == min) 
    min.candidate <- unique(min.candidate$Candidate)
    
    if (length(min.candidate) == 3) {
      min.candidate <- "Bernie, Clinton, and Trump"
    } else if (length(min.candidate) == 2) {
      min.candidate <- min.candidate[1] + " and " + min.candidate[2]
    }
    
    avg <- data %>% 
      summarize(avg = mean(data$polarity))
    
    summary <- sample.polarity %>% 
      group_by(Candidate) %>% 
      summarize(mean = mean(polarity))
    
    
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
                      and that tweeters mentioning Trump had more positive sentiments than tweets about Hillary.")
    return(analysis)
  })

  img.url <- reactive({
    if (input$generate.img) {
      march.image <- march.photos %>% 
        sample_n(1)
      return(march.image)
    }
  })
  
  output$maga.march.tweet <- renderPrint({
    
    if(input$generate.march.tweet) {
      tweet.maga <- maga %>% 
        sample_n(1)
      tweet.march <- w.march %>% 
        sample_n(1)

      tweet.maga <- paste("#MAGA: ", tweet.maga$text)
      tweet.march <- paste("#WomensMarch: ", tweet.march$text)
      cat(tweet.maga, tweet.march, sep = "\n\n")
    }
    
  })
  
  output$image <- renderUI({
    if(input$image_url == "http://placehold.it/300x300" || input$image_url == "") {
      tags$img(src = img.url()$image, width = 400, height = 400) 
    } else {
      tags$img(src = input$image_url, width = 400, height = 400)
    }
  })
  
  output$url <- renderPrint({
    cat("URL: ", img.url()$image)
  })
  
  output$url.text <- renderUI({
    list <- tags$ul(
      tags$li("http://pbs.twimg.com/media/C2u4QQvWEAAqLpM.jpg"),
      tags$li("http://pbs.twimg.com/media/C2u5J4aW8AEQcZW.jpg"),
      tags$li("http://pbs.twimg.com/media/C2u2yWRVQAAXTMx.jpg"),
      tags$li("http://pbs.twimg.com/media/C2u1HdaUAAAfNUR.jpg")
    )
    HTML(paste("", list, ""), sep = "</br>")
  })
}

shinyServer(my.server)