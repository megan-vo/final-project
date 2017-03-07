# Adding libraries and data set
library(ggplot2)
library(tm)
library(SnowballC)
library(wordcloud)
library(RColorBrewer)
library(shinythemes)
library(plotly)
library(dplyr)
data <- read.csv("data/Crowdbabble_Social-Media-Analytics_Twitter-Download_Donald-Trump_7375-Tweets.csv")

# Filtering data for tweet text
corpus <- Corpus(VectorSource(data$Tweet_Text))

# Text Processing to isolate text 
corpus <- tm_map(corpus, removePunctuation) 
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, tolower) 
corpus <- tm_map(corpus, function(x) iconv(x, to='UTF-8-MAC', sub='byte'))
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


# Creates server function
my.server <- function(input, output) {
  
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
  
}

# Calls the Server
shinyServer(my.server)