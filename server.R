library("dplyr")
library("ggplot2")
library("shiny")
library("plotly")

# figure out how to format the info displayed when hovered
# fix navbar format
# add theme
# add comments

candidate.tweets <- read.csv("data/trump-clinton-tweets.csv")
candidate.tweets$candidate9[candidate.tweets$handle == "HillaryClinton"] <- "Hillary Clinton"
candidate.tweets$candidate[candidate.tweets$handle=="realDonaldTrump"] <- "Donald Trump"


my.server <- function(input, output) {
 
  
  # FIND TWEET WITH MAX AND MIN

  clinton.tweets <- filter(candidate.tweets, handle == "HillaryClinton")
  trump.tweets <- filter (candidate.tweets, handle == "realDonaldTrump")

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


clinton.stats <- findSummaryStats(clinton.tweets)
trump.stats <- findSummaryStats(trump.tweets)

summary.stats.table <- data.frame(clinton.stats, trump.stats)
row.names(summary.stats.table) <- c("Retweet Sum", "Favorites Sum", "Maxmimum Number of Retweets", "Minimum Number of Retweets", "Maximum Number of Favorites", "Minimum Number of Favorites", "Average Number of Retweets", "Average Number of Favorites") 
colnames(summary.stats.table) <- c("Hillary Clinton", "Donald Trump")


  
  output$tweets.plot <- renderPlotly({ 
    
    p <- ggplot(data = candidate.tweets, mapping = aes(x = retweet_count, y = favorite_count, color = candidate)) +
    
      geom_point(alpha = 0.4, size = 4) +
      
      xlim(0, 45000) +
      
      ylim(0, 87500) +
      
      labs(title = "Twitter Retweets and Favorites: Trump vs. Clinton",
           x = "Retweets",
           y = "Favorites") +
      
      scale_colour_manual("", 
                          breaks = c("Donald Trump", "Hillary Clinton"),
                          values = c("red", "blue")) +
    
      theme_light(base_size=14) +
      
      theme(legend.position="top", legend.direction="horizontal")
    
    
  })
  

  output$tweets.table <- renderTable({
    
    data.frame(summary.stats.table)
    
    
  },
  
  include.rownames = TRUE
  
  )
  
}

shinyServer(my.server)


