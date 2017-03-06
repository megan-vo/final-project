library("dplyr")
library("ggplot2")
library("shiny")

#first, filter user_location for rows that only have state names as location
filtered.tweets <- all.tweets %>% 
  #fix this ughoooooo
  filter(user_location == "California")

#second, if text contains 'Trump'/'Hillary', add column 'Candidate' with either a 1 or a 2
filtered.tweets <- mutate(filtered.tweets, Candidate = "-")

DetermineCandidate <- function(tweets, row){
  tweet.text <- tweets$text[row]
  if(grepl("Trump", tweet.text)){
    tweets$Candidate[row] <- "Trump"
  }else if(grepl("Clinton", tweet.text)){
    tweets$Candidate[row] <- "Clinton"
  }
  return(tweets)
}

for(i in 1:nrow(filtered.tweets)){
  filtered.tweets <- DetermineCandidate(filtered.tweets, i)
}

filtered.tweets <- filter(filtered.tweets, Candidate != "-")

#third, group by Candidate column, then group by user_location, then summarise and find n()
candidates <- group_by(filtered.tweets, Candidate) #%>% 
cand.location <- group_by(candidates, user_location) %>% 
  summarise(
    frequency = n()
  )

trump.tweets <- filter(filtered.tweets, Candidate == "Trump")
clinton.tweets <- filter(filtered.tweets, Candidate == "Clinton")

trump.location <- group_by(trump.tweets, user_location)

#fourth, merge with us map data
data.map <- left_join(usa.map, cand.location, by = c("region" = "user_location"))

#fifth, cut to create different groups?


#sixth, create visualization
my.server <- function(input, output){
  filtered <- reactive({
    #copy all the stuff from above here
    
  })


  output$plot <- renderPlot({
    usa.map <- map_data("state")

    ggplot(data = data.map) + 
      geom_polygon(aes(x = long, y = lat, group = group, fill = frequency)) +
      facet_wrap(~Candidate) +
      coord_quickmap() +
      scale_fill_distiller(name="???", palette = "Set2", na.value = "grey50") +
      labs(title="lol lol lol")
    
  })
  
}

shinyServer(my.server)