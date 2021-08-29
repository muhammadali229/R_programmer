library(rvest)
library(xml2)
library(tidyr)
html_excerpt_raw <- '
<html> 
  <body> 
    <h1>Web scraping is cool</h1>
    <p>It involves writing code - be it R or Python.</p>
    <p><a href="https://datacamp.com">DataCamp</a> 
		has courses on it.</p>
  </body> 
</html>'
# Turn the raw excerpt into an HTML document R understands
html_excerpt <- read_html(html_excerpt_raw)
html_excerpt
# Print the HTML excerpt with the xml_structure() function
xml_structure(html_excerpt)
############################################################
list_raw_html <- "
  <html>
  <body>
    <ol>
      <li>Learn HTML</li>
      <li>Learn CSS</li>
      <li>Learn R</li>
      <li>Scrape everything!*</li>
    </ol>
    <small>*Do it responsibly!</small>
  </body>
</html>
"
# Read in the corresponding HTML string
list_html <- read_html(list_raw_html)
# Extract the ol node
ol_node <- list_html %>% 
  html_node('ol')
# Extract and print the nodeset of all the children of ol_node
ol_node %>%
  html_children()
############################################################
hyperlink_raw_html <- '
  <html>
  <body>
    <h3>Helpful links</h3>
    <ul>
      <li><a href="https://wikipedia.org">Wikipedia</a></li>
      <li><a href="https://dictionary.com">Dictionary</a></li>
      <li><a href="https://duckduckgo.com">Search Engine</a></li>
    </ul>
    <small>
      Compiled with help from <a href="https://google.com">Google</a>.
    </small>
  </body>
</html>
'
# Extract all the a nodes from the bulleted list
links <- hyperlink_raw_html %>% 
  read_html() %>%
  html_nodes('li a') # 'ul a' is also correct!
# Extract the needed values for the data frame
domain_value = links %>% html_attr("href")
name_value = links %>% html_text()
# Construct a data frame
link_df <- tibble(
  domain = domain_value,
  name = name_value
)
link_df
############################################################
mountains_html <- '
  <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
<html>
<head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8"></head>
<body> 
  <table id="clean">
<tr>
<th>Mountain</th>
      <th>Height [m]</th>
      <th>First ascent</th>
      <th>Country</th>
    </tr>
<tr>
<td>Mount Everest</td>
      <td>8848</td>
      <td>1953</td>
      <td>Nepal, China</td>
    </tr>
<tr>
<td>K2</td>
      <td>8611</td>
      <td>1954</td>
      <td>Pakistan, China</td>
    </tr>
<tr>
<td>Kanchenjunga</td>
      <td>8586</td>
      <td>1955</td>
      <td>Nepal, India</td>
    </tr>
</table>
<table id="dirty">
<tr>
<td>Mountain </td>
      <td>Height [m]</td>
      <td>First ascent</td>
      <td>Country</td>
    </tr>
<tr>
<td>Mount Everest</td>
      <td>8848</td>
      <td>1953</td>
    </tr>
<tr>
<td>K2</td>
      <td>8611</td>
      <td>1954</td>
      <td>Pakistan, China</td>
    </tr>
<tr>
<td>Kanchenjunga</td>
      <td>8586</td>
      <td>1955</td>
      <td>Nepal, India</td>
    </tr>
</table>
</body>
</html>
'
mountains_html <- read_html(mountains_html)
# Extract the "clean" table into a data frame 
mountains <- mountains_html %>% 
  html_node("table#clean") %>% 
  html_table()
mountains
# Extract the "dirty" table into a data frame
mountains <- mountains_html %>% 
  html_node("table#dirty") %>% 
  html_table(header = TRUE, fill = TRUE)
mountains
############################################################