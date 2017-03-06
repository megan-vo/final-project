# Adding libraries and data set
library(ggplot2)
library(dplyr)
library(tm)
library(SnowballC)
library(wordcloud)
library(RColorBrewer)


data <- read.csv("data/Crowdbabble_Social-Media-Analytics_Twitter-Download_Donald-Trump_7375-Tweets.csv")

corpus <- Corpus(VectorSource(data$Tweet_Text))


getTermMatrix <- memoise(function(book) {
  corpus <- tm_map(corpus, removePunctuation) 
  corpus <- tm_map(corpus, removeNumbers)
  corpus <- tm_map(corpus, tolower) 
  corpus <- tm_map(corpus, function(x) iconv(x, to='UTF-8-MAC', sub='byte'))
  corpus <- tm_map(corpus, removeWords, stopwords(kind = "en"))   
  corpus <- tm_map(corpus, removeWords, c("will", "thank", "realdonaldtrump", "amp",
                                          "just", "people", "get", "now", "like", "new",
                                          "back", "dont", "much"))  
  corpus <- tm_map(corpus, stripWhitespace) 
  
  
  myDTM = TermDocumentMatrix(corpus,
                             control = list(minWordLength = 1))
  
  m = as.matrix(myDTM)
  
  sort(rowSums(m), decreasing = TRUE)
})

# Creates server function
my.server <- function(input, output) {
  
  terms <- reactive({
    getTermMatrix(input$corpus)
  })
  
  wordcloud_rep <- repeatable(wordcloud)
  
  output$plot <- renderPlot({
    v <- terms()
    wordcloud_rep(names(v), v, scale=c(8,0.5),
                  min.freq = input$freq, max.words=input$max,
                  colors=brewer.pal(8, "Dark2"))
  })
  
}

# Calls the Server
shinyServer(my.server)
