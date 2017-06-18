# Trump's Twitter Tussle


### Project Overview
The strong personalities of Hillary Clinton and Donald Trump caused a lot of stir on social media, especially Twitter, so we decided to analyze certain aspects of their own tweets, as well as tweets directed towards them. Using data collected from various Twitter .csv files, we used a Shiny app as the method to display our analyses. Our target audiences are the general public, specifically individuals interested in politics, as well as election forecasters, since they would have a heightened interest in different methods to predict election outcomes. We hope our data provides insight to our audiences about how Twitter data can explain certain election trends.

*A note about this version of our project: We have ommited the Word Cloud portion due to memory constraints with Shiny Apps. The code can still be viewed in the ui.R and server.R files though commented out*

### Project Breakdown
Our project is broken up into four parts, with one additional *bonus* part.

1. Popularity of Tweets: This section compares the favorites and retweets of each candidate's tweets between January and September 2016.

2. Word Analysis: This section focuses on Donald Trump's tweets, specifically looking at his word choice, and the frequency of his most common words.

3. Map of Tweets about Candidates: This section analyzes the number of tweets mentioning either Donald Trump or Hillary Clinton per state in the United States on the day May 10, 2016.

4. Tweets Polarity: This section examines the polarity of tweets mentioning either Donald Trump, Hillary Clinton, or Bernie Sanders, with polarity being given a rating between -1 (strong negativity) and 1 (strong positivity). The tweets were scraped from May 10, 2016.

5. *Bonus - #MAGA vs #WomensMarch: This bonus section compares samples of tweets containing the hashtag #MAGA versus tweets containing the hashtag #WomensMarch immediately following Donald Trump's presidential inauguration. This section also generates random images from the Women's March.*
