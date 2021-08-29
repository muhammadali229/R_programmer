library(rvest)
library(xml2)
library(tidyr)
weather_html <- read_html("
                          <html>
  <body>
    <div id = 'first'>
      <h1 class = 'big'>Berlin Weather Station</h1>
      <p class = 'first'>Temperature: 20°C</p>
      <p class = 'second'>Humidity: 45%</p>
    </div>
    <div id = 'second'>...</div>
    <div id = 'third'>
      <p class = 'first'>Sunshine: 5hrs</p>
      <p class = 'second'>Precipitation: 0mm</p>
    </div>
  </body>
</html>
                          ")
# Select all p elements
weather_html %>%
  html_nodes(xpath = '//p')
# Select p elements with the second class
weather_html %>%
  html_nodes(xpath = "//p[@class='second']")
# Select p elements that are children of "#third"
weather_html %>%
  html_nodes(xpath = "//*[@id='third']/p")
# Select p elements with class "second" that are children of "#third"
weather_html %>%
  html_nodes(xpath = "//*[@id='third']/p[@class='second']")
############################################################
weather_html_2 <- read_html("
                            <html>
  <body>
    <div id = 'first'>
      <h1 class = 'big'>Berlin Weather Station</h1>
      <p class = 'first'>Temperature: 20°C</p>
      <p class = 'second'>Humidity: 45%</p>
    </div>
    <div id = 'second'>...</div>
    <div id = 'third'>
      <p class = 'first'>Sunshine: 5hrs</p>
      <p class = 'second'>Precipitation: 0mm</p>
      <p class = 'third'>Snowfall: 0mm</p>
    </div>
  </body>
</html>
                            ")
# Select all divs
weather_html %>% 
  html_nodes(xpath = "//div")
# Select all divs with p descendants
weather_html %>% 
  html_nodes(xpath = '//div[p]')
# Select all divs with p descendants having the "third" class
weather_html %>% 
  html_nodes(xpath = '//div[p[@class="third"]]')
############################################################
rules_html <- '
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
<html><body>
<div>
  <h2>Today\'s rules</h2>
  <p>Wear a mask</p>
  <p>Wash your hands</p>
</div>
<div>
  <h2>Tomorrow\'s rules</h2>
  <p>Wear a mask</p>
  <p>Wash your hands</p>
  <small>Bring hand sanitizer with you</small>
</div>
</body></html>
'
rules_html <- read_html(rules_html)
# Select the text of the second p in every div
rules_html %>% 
  html_nodes(xpath = "//div/p[position() = 2]") %>%
  html_text()
# Select every p except the second from every div
rules_html %>% 
  html_nodes(xpath = "//div/p[position() != 2]") %>%
  html_text()
# Select the text of the last three nodes of the second div
rules_html %>% 
  html_nodes(xpath = '//div[position() = 2]/*[position() >= 2]') %>%
  html_text()
############################################################
forecast_html <- read_html('
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
<html><body>
<div>
  <h1>Tomorrow</h1>
</div>
<div>
  <h2>Berlin</h2>
  <p>Temperature: 20<u>C</u></p>
  <p>Humidity: 50%</p>
</div>
<div>
  <h2>London</h2>
  <p>Temperature: 15<u>C</u></p>
</div>
<div>
  <h2>Zurich</h2>
  <p>Temperature: 22<u>C</u></p>
  <p>Humidity: 60%</p>
</div>
</body></html>
')
# Select only divs with one header and at least two paragraphs
forecast_html %>%
  html_nodes(xpath = '//div[count(h2) = 1 and count(p) >= 2]')
############################################################
roles_html <- read_html('
                        <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
<html>
<head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8"></head>
<body>
  <table>
<tr>
<th>Actor</th>
<th>Role</th>
</tr>
<tr>
<td class="actor">Jayden Carpenter</td>
<td class="role">
<em>Mickey Mouse</em> (Voice)</td>
</tr>
<tr>
<td class="actor">Meredith Diaz</td>
<td class="role">
<em>Minnie Mouse</em> (Choreography)</td>
</tr>
<tr>
<td class="actor">Louie Hendrix</td>
<td class="role">
<em>Donald Duck</em> (Voice)</td>
</tr>
</table>
</body>
</html>
                        ')
# Extract the data frame from the table using a known function from rvest
roles <- roles_html %>% 
  html_node(xpath = "//table") %>% 
  html_table()
# Print the contents of the role data frame
tibble(roles)
############################################################
# Extract the actors in the cells having class "actor"
actors <- roles_html %>% 
  html_nodes(xpath = '//table//td[@class = "actor"]') %>%
  html_text()
actors
# Extract the roles in the cells having class "role"
roles <- roles_html %>% 
  html_nodes(xpath = '//table//td[@class = "role"]/em') %>% 
  html_text()
roles

# Extract the functions using the appropriate XPATH function
functions <- roles_html %>% 
  html_nodes(xpath = '//table//td[@class = "role"]/text()') %>%
  html_text(trim = T)
functions
############################################################
# Create a new data frame from the extracted vectors
actors
roles
functions
cast <- tibble(
  Actor = actors, 
  Role = roles, 
  Function = functions[functions != ""])
cast
############################################################
programming_html <- read_html('
                              <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
<html>
<head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8"></head>
<body>
  <h3>The rules of programming</h3>
  <ol>
<li>Have <em>fun</em>.</li>
    <li>
<strong>Don\'t</strong> repeat yourself.</li>
                                <li>Think <em>twice</em> when naming variables.</li>
                                </ol>
                                </body>
                                </html>
                              ')
# Select all li elements
programming_html %>%
  html_nodes(xpath = '//li') %>%
  # Select all em elements within li elements that have "twice" as text
  html_nodes(xpath = 'em[text() = "twice"]') %>%
  # Wander up the tree to select the parent of the em 
  html_nodes(xpath = "..")
############################################################