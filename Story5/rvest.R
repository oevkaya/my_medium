# Data collection via web scraping 

# Load {rvest} with the whole tidyverse
library(tidyverse)
library(magrittr)
library(rvest)
library(gt)

# Read HTML page with read_html()
link <- 'http://www.turkmath.org/beta/webdergiler.php'
# Create html document from an url
journals_TR <- read_html(link)

# Open the borsa_IST object
# Language is TR, we see the head and body part here
journals_TR
class(journals_TR)

# Regardless of how you get the HTML, you’ll need some way to identify 
# the elements that contain the data you care about. 
# rvest provides two options: CSS selectors and XPath expressions. 
# CSS selectors are simpler but still sufficiently powerful for most scraping tasks

# Reaching to the table !
Journal_List <-  journals_TR %>% 
    rvest::html_element(".table") %>% 
    rvest::html_table()
  
# More steps to format this table
attach(Journal_List)

SCI_List <- Journal_List %>% 
  # Rename first column
  rename(Index=1) %>% 
  # Filtering only TR Dizin
  filter(Index == "TR Dizin") %>% 
  # Among those, filter only SCI column is not empty
  filter(SCI == "ESCI" | SCI == "SCIexp")

# As a TAble

SCI_List %>% gt()

# Look at as a bar plot for two types: ESCI or SCIexp
SCI_List %>% 
  ggplot() + 
  aes(x = SCI) + geom_bar(fill="blue", color= "black")


# With SelectorGadget -----------------------------------------------------

# Inspect by SelectorGadget with
# TCMB Inflation data 
Inflation <- "https://www.tcmb.gov.tr/wps/wcm/connect/tr/tcmb+tr/main+menu/istatistikler/enflasyon+verileri"

Date <- Inflation %>% 
  read_html() %>% 
  html_nodes("td:nth-child(1)") %>% 
  html_text()

TUFE_yearly <- Inflation %>% 
  read_html() %>% 
  html_nodes("td:nth-child(2)") %>% 
  html_text()

TUFE_monthly <- Inflation %>% 
  read_html() %>% 
  html_nodes("td~ td+ td") %>% 
  html_text()

# Combine two datasets to create simple table 
Inf_df <- data.frame(Date, TUFE_monthly, TUFE_yearly, stringsAsFactors = F)

# Change the types a bit
Inf_df$TUFE_monthly <- as.numeric(Inf_df$TUFE_monthly)
Inf_df$TUFE_yearly <- as.numeric(Inf_df$TUFE_yearly)

# For date
Inf_df$Date <- rev(seq(as.Date("2005-1-1"), as.Date("2021-8-1"), by = "months"))

# # As a TAble
# Define the start and end dates for the data range
start_date <- min(Inf_df$Date)
end_date <- max(Inf_df$Date)

Inf_df %>% gt() %>% 
  tab_header(
    title = "Changes on TUFE (%)",
    subtitle = glue::glue("{start_date} to {end_date}")
  ) %>% 
  fmt_date(
    columns = Date,
    date_style = 6
  ) %>% 
  data_color(columns = c("TUFE_monthly"), colors = c("red")) %>% 
  data_color(columns = c("TUFE_yearly"), colors = c("blue"))


# As a line plot for monthly and yearly data
colors <- c("TUFE_monthly" = "red", "TUFE_yearly" = "blue")


Inf_df %>% 
  ggplot(aes(x = Date, y = TUFE_monthly)) +
  geom_line(aes(color = "TUFE_monthly"), size = 1) +
  geom_line(aes(y = TUFE_yearly, color = "TUFE_yearly"), color = "blue", size = 1.5) + 
  theme_bw() + 
  theme(axis.text.x=element_text(angle=60, hjust=1)) + 
  scale_color_manual(values = colors) + ylab("") +
  labs(title="TUFE rate changes for Turkey (%)",
       subtitle = glue::glue("{start_date} to {end_date}"),
       caption = " Source is www.tcmb.gov.tr", color="Rates")




