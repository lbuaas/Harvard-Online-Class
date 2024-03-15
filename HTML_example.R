library(rvest)
url <- "https://web.archive.org/web/20181024132313/http://www.stevetheump.com/Payrolls.htm"
h <- read_html(url)
nodes <- html_nodes(h, "table")
html_text(nodes[[8]])
html_table(nodes[[8]])

html_table(nodes[1:4])
html_table(nodes[19:21])

tab_1 <- html_table(nodes[[10]])
tab_2 <- html_table(nodes[[19]])
tab_1 <- tab_1[-1, -1]
tab_2 <- tab_2[-1,]
col_names <- c("Team", "Payroll", "Average")
names(tab_1) <-  col_names
names(tab_2) <- col_names
full_join(tab_1, tab_2, by = "Team")
