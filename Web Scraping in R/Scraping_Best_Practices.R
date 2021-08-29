library(httr)
library(rvest)
library(purrr)
# Get the HTML document from Wikipedia
wikipedia_page <- read_html('https://en.wikipedia.org/wiki/Varigotti')
# Parse the document and extract the elevation from it
wikipedia_page %>% 
  html_nodes('table tr:nth-child(9) > td') %>% 
  html_text()
########################################################################
# Get the HTML document from Wikipedia using httr
wikipedia_response <- GET('https://en.wikipedia.org/wiki/Varigotti')
# Parse the response into an HTML doc
wikipedia_page <- content(wikipedia_response)
# Check the status code of the response
status_code(wikipedia_response)
# Extract the elevation with XPATH
wikipedia_page %>% 
  html_nodes(xpath = '//table//tr[position() = 9]/td') %>% 
  html_text()
########################################################################
response <- GET('https://en.wikipedia.org/wiki/Varigott')
# Print status code of inexistent page
status_code(response)
########################################################################
# Access https://httpbin.org/headers with httr
response <- GET("https://httpbin.org/headers")
# Print its content
content(response)
########################################################################
# Pass a custom user agent to a GET query to the mentioned URL
response <- GET("https://httpbin.org/user-agent", 
                user_agent("A request from a DataCamp course on scraping"))
# Print the response content
content(response)
# Globally set the user agent to "A request from a DataCamp course on scraping"
set_config(add_headers("User-Agent" = "A request from a DataCamp course on scraping"))
# Pass a custom user agent to a GET query to the mentioned URL
response <- GET("https://httpbin.org/user-agent")
# Print the response content
content(response)
########################################################################
throttled_read_html <- slowly(~ read_html("https://wikipedia.org"),
                              rate = rate_delay(0.5))
for(i in c(1, 2, 3)){
  throttled_read_html("https://google.com") %>% 
    html_node("title") %>% 
    html_text() %>%
    print()
}       
########################################################################
mountain_wiki_pages <- c(
  "https://en.wikipedia.org/w/index.php?title=Mount_Everest&oldid=958643874",
  "https://en.wikipedia.org/w/index.php?title=K2&oldid=956671989",           
  "https://en.wikipedia.org/w/index.php?title=Kangchenjunga&oldid=957008408"
)
# Define a throttled read_html() function with a delay of 0.5s
read_html_delayed <- slowly(read_html, 
                            rate = rate_delay(0.5))
# Construct a loop that goes over all page urls
for(page_url in mountain_wiki_pages){
  # Read in the html of each URL with a delay of 0.5s
  html <- read_html_delayed(page_url)
  # Extract the name of the peak and its coordinates
  peak <- html %>% 
    html_nodes("#firstHeading") %>% html_text()
  coords <- html %>% 
    html_nodes("#coordinates .geo-dms") %>% html_text()
  print(paste(peak, coords, sep = ": "))
}
########################################################################