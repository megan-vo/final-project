library("dplyr")
library("ggplot2")
library("shiny")

###############
# Data Frames #
###############

sample.polarity <- read.csv("data/sample.polarity.tweets.csv", stringsAsFactors = F)


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
  
  output$polar.info <- renderPrint({ 
    info <- ""
    if(input$generate.tweet) {
      data <- polarity.candidate() %>%
        select(text, polarity, Candidate) %>% 
        sample_n(1)
      info <- cat(data$Candidate, data$text, data$polarity, sep = "\n")
    }
    return(info)
  })
}

shinyServer(my.server)