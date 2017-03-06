library("dplyr")
library("ggplot2")
library("shiny")

#first, filter user_location for rows that only have state names as location
alabama.tweets <- all.tweets %>% 
  filter(user_location == "Alabama")

alaska.tweets <- all.tweets %>% 
  filter(user_location == "Alaska")

arizona.tweets <- all.tweets %>% 
  filter(user_location == "Arizona")

arkansas.tweets <- all.tweets %>% 
  filter(user_location == "Arkansas")

california.tweets <- all.tweets %>% 
  filter(user_location == "California")

colorado.tweets <- all.tweets %>% 
  filter(user_location == "Colorado")

connecticut.tweets <- all.tweets %>% 
  filter(user_location == "Connecticut")

delaware.tweets <- all.tweets %>% 
  filter(user_location == "Delaware")

florida.tweets <- all.tweets %>% 
  filter(user_location == "Florida")

georgia.tweets <- all.tweets %>% 
  filter(user_location == "Georgia")

hawaii.tweets <- all.tweets %>% 
  filter(user_location == "Hawaii")

idaho.tweets <- all.tweets %>% 
  filter(user_location == "Idaho")

illinois.tweets <- all.tweets %>% 
  filter(user_location == "Illinois")

indiana.tweets <- all.tweets %>% 
  filter(user_location == "Indiana")

iowa.tweets <- all.tweets %>% 
  filter(user_location == "Iowa")

kansas.tweets <- all.tweets %>% 
  filter(user_location == "Kansas")

kentucky.tweets <- all.tweets %>% 
  filter(user_location == "Kentucky")

louisiana.tweets <- all.tweets %>% 
  filter(user_location == "Louisiana")

maine.tweets <- all.tweets %>% 
  filter(user_location == "Maine")

maryland.tweets <- all.tweets %>% 
  filter(user_location == "Maryland")

massachusetts.tweets <- all.tweets %>% 
  filter(user_location == "Massachusetts")

michigan.tweets <- all.tweets %>% 
  filter(user_location == "Michigan")

minnesota.tweets <- all.tweets %>% 
  filter(user_location == "Minnesota")

mississippi.tweets <- all.tweets %>% 
  filter(user_location == "Mississippi")

missouri.tweets <- all.tweets %>% 
  filter(user_location == "Missouri")

montana.tweets <- all.tweets %>% 
  filter(user_location == "Montana")

nebraska.tweets <- all.tweets %>% 
  filter(user_location == "Nebraska")

nevada.tweets <- all.tweets %>% 
  filter(user_location == "Nevada")

new.hampshire.tweets <- all.tweets %>% 
  filter(user_location == "New Hampshire")

new.jersey.tweets <- all.tweets %>% 
  filter(user_location == "New Jersey")

new.mexico.tweets <- all.tweets %>% 
  filter(user_location == "New Mexico")

new.york.tweets <- all.tweets %>% 
  filter(user_location == "New York")

north.carolina.tweets <- all.tweets %>% 
  filter(user_location == "North Carolina")

south.carolina.tweets <- all.tweets %>% 
  filter(user_location == "South Carolina")

north.dakota.tweets <- all.tweets %>% 
  filter(user_location == "North Dakota")

south.dakota.tweets <- all.tweets %>% 
  filter(user_location == "South Dakota")

ohio.tweets <- all.tweets %>% 
  filter(user_location == "Ohio")

oklahoma.tweets <- all.tweets %>% 
  filter(user_location == "Oklahoma")

oregon.tweets <- all.tweets %>% 
  filter(user_location == "Oregon")

pennsylvania.tweets <- all.tweets %>% 
  filter(user_location == "Pennsylvania")

rhode.island.tweets <- all.tweets %>% 
  filter(user_location == "Rhode Island")

tennessee.tweets <- all.tweets %>% 
  filter(user_location == "Tennessee")

texas.tweets <- all.tweets %>% 
  filter(user_location == "Texas")

utah.tweets <- all.tweets %>% 
  filter(user_location == "Utah")

vermont.tweets <- all.tweets %>% 
  filter(user_location == "Vermont")

virginia.tweets <- all.tweets %>% 
  filter(user_location == "Virginia")

west.virginia.tweets <- all.tweets %>% 
  filter(user_location == "West Virginia")

washington.tweets <- all.tweets %>% 
  filter(user_location == "Washington")

wisconsin.tweets <- all.tweets %>% 
  filter(user_location == "Wisconsin")

wyoming.tweets <- all.tweets %>% 
  filter(user_location == "Wyoming")

all.states.tweets <- rbind(alabama.tweets, alaska.tweets, arizona.tweets, arkansas.tweets, california.tweets, colorado.tweets, connecticut.tweets, delaware.tweets, florida.tweets, georgia.tweets, hawaii.tweets, idaho.tweets, illinois.tweets, indiana.tweets, iowa.tweets, kansas.tweets, kentucky.tweets, louisiana.tweets, maine.tweets, maryland.tweets, massachussetts.tweets, michigan.tweets, minnesota.tweets, mississippi.tweets, missouri.tweets, montana.tweets, nebraska.tweets, nevada.tweets, new.hampshire.tweets, new.jersey.tweets, new.mexico.tweets, new.york.tweets, north.carolina.tweets, south.carolina.tweets, north.dakota.tweets, south.dakota.tweets, ohio.tweets, oklahoma.tweets, oregon.tweets, pennsylvania.tweets, rhode.island.tweets, tennessee.tweets, texas.tweets, utah.tweets, vermont.tweets, virginia.tweets, west.virginia.tweets, washington.tweets, wisconsin.tweets, wyoming.tweets)
write.csv(all.states.tweets, "data/states.tweets.csv")

#second, if text contains 'Trump'/'Hillary', add column 'Candidate' with either a 1 or a 2
filtered.tweets <- mutate(all.states.tweets, Candidate = "-")

DetermineCandidate <- function(tweets, row){
  tweet.text <- tweets$text[row]
  if(grepl("Trump", tweet.text) & !grepl("Clinton", tweet.text)){
    tweets$Candidate[row] <- "Trump"
  }else if(grepl("Clinton", tweet.text) & !grepl("Trump", tweet.text)){
    tweets$Candidate[row] <- "Clinton"
  }
  return(tweets)
}

for(i in 1:nrow(filtered.tweets)){
  filtered.tweets <- DetermineCandidate(filtered.tweets, i)
}

filtered.tweets <- filter(filtered.tweets, Candidate != "-")

#third, group by Candidate column, then group by user_location, then summarise and find n()
trump.tweets <- filter(filtered.tweets, Candidate == "Trump")
clinton.tweets <- filter(filtered.tweets, Candidate == "Clinton")

trump.location <- group_by(trump.tweets, user_location) %>% 
  summarise(
    frequency = n()
  )
clinton.location <- group_by(clinton.tweets, user_location) %>% 
  summarise(
    frequency = n()
  )

#fourth, merge with us map data
combined <- sort(union(levels(usa.map$region), levels(trump.location$user_location)))
n <- left_join(mutate(usa.map, region = factor(region, levels = combined)),
               mutate(trump.location, user_location = factor(user_location, levels = combined)), by = c("region" = "user_location"))

t.data.map <- left_join(usa.map, trump.location, by = c("region" = "user_location"))
c.data.map <- left_join(usa.map, clinton.location, by = c("region" = "user_location"))

#fifth, cut to create different groups?


#sixth, create visualization
ggplot(data = t.data.map) + 
  geom_polygon(aes(x = long, y = lat, group = group, fill = t.frequency)) +
  coord_quickmap() +
  scale_fill_distiller(name="???", palette = "Set2", na.value = "grey50") +
  labs(title="Trump")

ggplot(data = c.data.map) + 
  geom_polygon(aes(x = long, y = lat, group = group, fill = c.frequency)) +
  coord_quickmap() +
  scale_fill_distiller(name="???", palette = "Set2", na.value = "grey50") +
  labs(title="Clinton")

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