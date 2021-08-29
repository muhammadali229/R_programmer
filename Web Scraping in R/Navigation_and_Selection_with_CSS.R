library(rvest)
library(xml2)
library(tidyr)
languages_raw_html <- "
<html> 
  <body> 
    <div>Python is perfect for programming.</div>
    <p>Still, R might be better suited for data analysis.</p>
    <small>(And has prettier charts, too.)</small>
  </body> 
</html>
"
# Read in the HTML
languages_html <- read_html(languages_raw_html)
# Select the div and p tags and print their text
languages_html %>%
  html_nodes("div,p") %>%
  html_text()
############################################################
structured_html <- "
<html>
  <body>
    <div id = 'first'>
      <h1 class = 'big'>Joe Biden</h1>
      <p class = 'first blue'>Democrat</p>
      <p class = 'second blue'>Male</p>
    </div>
    <div id = 'second'>...</div>
    <div id = 'third'>
      <h1 class = 'big'>Donald Trump</h1>
      <p class = 'first red'>Republican</p>
      <p class = 'second red'>Male</p>
    </div>
  </body>
</html>
"
structured_html <- read_html(structured_html)
# Select the first div
structured_html %>%
  html_nodes("#first")
############################################################
nested_html <- "
<html>
  <body>
    <div>
      <p class = 'text'>A sophisticated text [...]</p>
      <p class = 'text'>Another paragraph following [...]</p>
      <p class = 'text'>Author: T.G.</p>
    </div>
    <p>Copyright: DC</p>
  </body>
</html>
"
nested_html <- read_html(nested_html)
# Select the last child of each p group
nested_html %>%
  html_nodes("p:last-child")
# This time for real: Select only the last node of the p's wrapped by the div
nested_html %>%
  html_nodes("p:last-child.text")
############################################################
languages_html <- "
<ul id = 'languages'>
    <li>SQL</li>
    <ul>    
      <li>Databases</li>
      <li>Query Language</li>
    </ul>
    <li>R</li>
    <ul>
      <li>Collection</li>
      <li>Analysis</li>
      <li>Visualization</li>
    </ul>
    <li>Python</li>
  </ul>
"
languages_html <- read_html(languages_html)
# Extract the text of all list elements
languages_html %>% 
  html_nodes("li") %>% 
  html_text()
# Extract only the text of the computer languages (without the sub lists)
languages_html %>% 
  html_nodes('ul#languages > li') %>% 
  html_text()
############################################################
complicated_html <- '
  <html>
  <body>
    <div class="first section">
      A text with a <a href="#">link</a>.
</div>
  <div class="second section">
  Some text with <a href="#">another link</a>.
<div class="first paragraph">Some text.</div>
  <div class="second paragraph">Some more text.
<div>...</div>
  </div>
  </div>
  </body>
  </html>
'
complicated_html <- read_html(complicated_html)
# Select the three divs with a simple selector
complicated_html %>%
  html_nodes('div div')
############################################################
code_html <- "
<html> 
<body> 
  <h2 class = 'first'>First example:</h2>
  <code>some = code(2)</code>
  <span>will compile to...</span>
  <code>some = more_code()</code>
  <h2 class = 'second'>Second example:</h2>
  <code>another = code(3)</code>
  <span>will compile to...</span>
  <code>another = more_code()</code>
</body> 
</html>
"
code_html <- read_html(code_html)
# Select only the first code element in the second example
code_html %>% 
  html_nodes('h2.second + code')
# Select all code elements in the second example
code_html %>% 
  html_nodes('h2.second ~ code')
############################################################