# Installing and calling packages together

packages <- c("gt", "broom", "gtsummary")
# install.packages(c("gt", "gtsummary")) Open this line if it is necessary
lapply(packages, require, character.only = TRUE)

# Note: You can call in different ways for sure

# For data wrangling
require("dplyr")

# Consider an available data set 
# Borrow it from the package itself
data("gtcars")

# Some basic properties for the data with funModeling 
library(funModeling)

status(gtcars)
profiling_num(gtcars)

# To see some details
unique(gtcars$model)

# OR as tibble
gtcars %>% 
  select(model) %>% 
  unique()

# gt ----------------------------------------------------------------------
# Create a gt table based on preprocessed data

gtcars_gtable <- gtcars %>%
  filter(year == 2017) %>% # Choose only year 2017
  select(mfr, model, hp, ctry_origin) %>%
  gt() %>%
  tab_header(
    title = "Deluxie automobiles",
    subtitle = "Only year 2017"
  ) %>%
  tab_source_note(
    source_note = "Source: gt package"
  ) %>% 
  # Some change on column labels 
  # Markdown formatting (i.e. *italics* and **bold**, as well as <br> for a line break) 
  # are possible when the column label is wrapped in `md()`
  cols_label(
    mfr = md("**Manufacturer**"),
    model = "Model", 
    hp = "HP",
    ctry_origin = md("**Country**")
  )

# adding some color on it 
gtcars_gtable_colored <- gtcars_gtable %>% 
  data_color(
    columns = ctry_origin,
    colors = c("blue", "yellow", "red", "green")
  ) %>% 
  # adding footnote for the explanation of HP
tab_footnote(
  footnote = "HP shows the horse power",
   locations = cells_column_labels(columns = hp)
)

# Add more feature for formatting the output with tab_options
gtcars_final <- gtcars_gtable_colored %>% 
  tab_options(
    heading.background.color = "lightgray",
    heading.title.font.size = 20,
    heading.subtitle.font.size = 18, 
    heading.align = "right" # default is center
  )

# To save the table as png file
gtsave(gtcars_final, filename = "gtcars_table.png")

# Summarize for each country 
gtcars_gtable_mean <- gtcars %>%
  filter(year == 2017) %>% # Choose only year 2017
  select(mfr, model, hp, ctry_origin) %>%
  group_by(ctry_origin) %>% 
  summarise(avg_hp = mean(hp)) %>% 
  gt() %>% 
  tab_header(
    title = "Deluxie automobiles",
    subtitle = "Horse power mean for year 2017") %>% 
  cols_label(
    ctry_origin = md("**Country**")
  ) %>% 
  tab_source_note(
    source_note = "Data source: gt package") %>% 
  data_color(
    columns = ctry_origin,
    colors = c("blue", "yellow", "red", "green") ) %>% 
  tab_footnote(
    footnote = "avg_hp: Mean of horse power by country",
    locations = cells_column_labels(columns = avg_hp) ) %>% 
  tab_options(
    heading.background.color = "lightgray",
    heading.title.font.size = 20,
    heading.subtitle.font.size = 18, 
    heading.align = "center" # default is center
  )

# For further styling with gtExtras

# https://github.com/jthomasmock/gtExtras
  
# broom -------------------------------------------------------------------

# Focus on numeric columns
cars_num <- gtcars[, sapply(gtcars,class) == "numeric"]
as.data.frame(cars_num)
# Which variables for linear regression
library(Hmisc)
library(corrplot)

cars_corr <- rcorr(as.matrix(cars_num), type = c("pearson"))
# Some NAs apperad based on n so focus on variables where n = 47

corrplot(cars_corr$r, type = "upper", order = "hclust", 
         tl.col = "black", tl.srt = 45)

# Classical scatter plot
plot(cars_num[, c("hp", "trq")])
# Not so bad, lets take these two for lm

lm_fit <- lm(cars_num$trq ~ cars_num$hp, cars_num)
summary(lm_fit)

# with broom functionality
tidy(lm_fit)
glance(lm_fit)

augment(lm_fit, cars_num)
augment(lm_fit, interval = "confidence")

# For general information about broom

# https://broom.tidymodels.org/

# gtsummary ---------------------------------------------------------------

# Directly use lm_fit
tbl_regression(lm_fit)


# Alternatively
# we can build linear regression model via glm
m1 <- glm(cars_num$trq ~ cars_num$hp, cars_num, family = gaussian)

tbl_regression(m1)

# Customization a bit 

tbl_regression(lm_fit, 
  pvalue_fun = function(x) style_pvalue(x, digits = 2),
  estimate_fun = function(x) style_ratio(x, digits = 3)
) %>% 
  add_global_p() %>%
  add_significance_stars() %>% 
  add_glance_source_note() %>%
  bold_p(t = 0.10) %>%
  bold_labels() %>% 
  italicize_levels()

# For more read about gtSummary

# http://www.danieldsjoberg.com/gtsummary/index.html

# Further readings --------------------------------------------------------

# https://gt.rstudio.com/

# http://www.danieldsjoberg.com/gtsummary/articles/

# https://github.com/rladies/meetup-presentations_freiburg/tree/master/2021-09-15_GrammarofTables(gt)
