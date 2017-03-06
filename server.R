library("dplyr")
library("ggplot2")
library("shiny")

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
  
  #output$polar.info <- renderPrint({ 
   # if(input$generate.tweet) {
    #  data <- polarity.candidate() %>%
     #   select(text, polarity, Candidate) %>% 
      #  sample_n(1)
      #info <- cat(data$Candidate, data$text, data$polarity, sep = "\n")
  #  }
#  })
  
  output$maga.march.tweet <- renderPrint({
    
    if(input$generate.march.tweet) {
      tweet.maga <- maga %>% 
        sample_n(1)
      tweet.march <- w.march %>% 
        sample_n(1)
      march.image <- march.photos %>% 
        sample_n(1)
      tweet.maga <- paste("#MAGA: ", tweet.maga$text)
      tweet.march <- paste("#WomensMarch: ", tweet.march$text)
      march.image <- paste("Copy & Paste the Randomly Generated #WomensMarch Img Url To View: ",
                           march.image$image)
      cat(tweet.maga, tweet.march, march.image, sep = "\n\n")
    }
    
  })
  
  output$image <- renderUI({
    tags$img(src = input$image_url, width = 400, height = 400)
  })
}

shinyServer(my.server)