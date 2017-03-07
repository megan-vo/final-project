# Adding libraries and data set
library(ggplot2)
library(tm)
library(SnowballC)
library(wordcloud)
library(RColorBrewer)
library(shinythemes)
library(plotly)

# Reads in 'trump-clinton-tweets.csv' file and stores into data frame 'candidate.tweets'
candidate.tweets <- read.csv("data/trump-clinton-tweets.csv")

# Adds 'canidate' column to dataframe based on the Twitter handle
candidate.tweets$candidate[candidate.tweets$handle == "HillaryClinton"] <- "Hillary Clinton"
candidate.tweets$candidate[candidate.tweets$handle=="realDonaldTrump"] <- "Donald Trump"

# Defines a server function for the app, taking in input and output
my.server <- function(input, output) {
 
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
  
  
}

# Creates 'shinyServer()' to be used by 'shinyApp()'
shinyServer(my.server)


