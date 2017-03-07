# Adding libraries and data set
library(ggplot2)
library(tm)
library(SnowballC)
library(wordcloud)
library(RColorBrewer)
library(shinythemes)
library(plotly)



# fix navbar format
# add theme
# add comments

candidate.tweets <- read.csv("data/trump-clinton-tweets.csv")
candidate.tweets$candidate9[candidate.tweets$handle == "HillaryClinton"] <- "Hillary Clinton"
candidate.tweets$candidate[candidate.tweets$handle=="realDonaldTrump"] <- "Donald Trump"


my.server <- function(input, output) {
 
  
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
  
  clinton.max.min <- findTweets(clinton.tweets) 
  row.names(clinton.max.min) <- c("Hillary Clinton")
  colnames(clinton.max.min) <- c("Tweet with Most Retweets", "Tweet with Least Retweets", "Tweet with Most Favorites", "Tweet with Least Favorites")

  trump.max.min <- findTweets(trump.tweets)
  row.names(trump.max.min) <- c("Donald Trump")
  colnames(trump.max.min) <- c("Tweet with Most Retweets", "Tweet with Least Retweets", "Tweet with Most Favorites", "Tweet with Least Favorites")

  


  output$tweets.plot <- renderPlotly({ 
    
    p <- ggplot(data = candidate.tweets, mapping = aes(x = retweet_count, y = favorite_count, color = candidate)) +
    
      geom_point(alpha = 0.4, size = 4) +
      
      xlim(0, 50000) +
      
      ylim(0, 100000) +
      
      labs(title = "Twitter Retweets and Favorites: Trump vs. Clinton",
           x = "Retweets",
           y = "Favorites") +
      
      scale_colour_manual("", 
                          breaks = c("Donald Trump", "Hillary Clinton"),
                          values = c("red", "blue")) +
    
      theme_light(base_size=14) 
      
  })
  

  output$tweet.stats.table <- renderTable({
    
    data.frame(summary.stats.table)
    
    
  },
  
  include.rownames = TRUE
  
  )
  
  output$clinton.table <- renderTable({
    
    data.frame(clinton.max.min)
    
    
  },
  
  include.rownames = TRUE
  
  )
  
  output$trump.table <- renderTable({
    
    data.frame(trump.max.min)
    
    
  },
  
  include.rownames = TRUE
  
  )
  
}

shinyServer(my.server)


