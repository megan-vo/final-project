library("dplyr")
library("ggplot2")
library("shiny")

candidate.tweets <- read.csv("data/trump-clinton-tweets.csv")


my.server <- function(input, output) {
  
  plot.filtered <- reactive({
    data <- candidate.tweets %>%
      select(handle, retweet_count, favorite_count) %>%
      filter(handle == input$twitter.handle)
    
    return(data)
  })
  
  table.filtered <- reactive({
    data <- candidate.tweets %>%
      filter(handle == input$twitter.handle) %>%
      summarise("Retweets Sum" = sum(retweet_count),
                "Favorites Sum" = sum(favorite_count))
  })
  
  
  # HOW TO SPECIFY THE COLOR FOR DONALD AND HILLARY POINTS
  output$plot <- renderPlot({ 
     p <- ggplot(data = plot.filtered(), mapping = aes(x = retweet_count, y = favorite_count, color = handle)) +
       
       geom_point(alpha = 0.4, size = 4) +
       
       xlim(0, 45000) +
       
       ylim(0, 87500) +
       
       labs(title = "Twitter Retweets and Favorites: Trump vs. Clinton",
            x = "Retweets",
            y = "Favorites")

     return(p)
     
  })


  output$table <- renderTable({
    
    data.frame(table.filtered())
    
  })
  

  
  output$plot_key_info <- renderPrint({

    return(input$hover_key)
  })


}

shinyServer(my.server)
