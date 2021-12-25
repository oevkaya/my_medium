# Visualization of Missing data 

# The use of naniar package

install.packages("naniar")
library(naniar)

# For data set, look at mosaicData package

library(mosaicData)

# The HELP study was a clinical trial for adult 
# inpatients recruited from a detoxification unit
data(HELPrct)


# Other functions for first insight  --------------------------------------

summary(HELPrct)

str(HELPrct)

library(skimr)
skimr::skim(HELPrct)


# naniar ------------------------------------------------------------------

# # Look at the missingness in the variables
miss_var_summary(HELPrct)

# Note: Provide a summary for each variable of the number, percent missings, 
# and cumulative sum of missings of the order of the variables. 
# By default, it orders by the most missings in each variable.

# OR 
# miss_var_table(HELPrct)

# The function vis_miss provides a summary of whether the data is missing or not. 
# It also provides the amount of missings in each columns
vis_miss(HELPrct)

# Alternatively, 

library(visdat)
vis_dat(HELPrct)



# Exploring missingness relationships -------------------------------------

# With tye syntax of ggplot2
# We have integer based variables here
unique(HELPrct$e2b)
unique(HELPrct$anysubstatus)

# Classical ggplot output 
ggplot(HELPrct, 
       aes(x = e2b, 
           y = anysubstatus)) + 
  geom_point()

# Change geom_point by geom_miss_point()
ggplot(HELPrct, 
       aes(x = e2b, 
           y = anysubstatus)) + 
  geom_miss_point()


# If we have no NA values
ggplot(HELPrct, 
       aes(x = i1, 
           y = i2)) + 
  geom_miss_point()


# With faceting
ggplot(HELPrct, 
       aes(x = e2b, 
           y = anysubstatus)) + 
  geom_miss_point() + 
  facet_wrap(~sex)


# In a different way:
gg_miss_var(HELPrct)



# shadow ------------------------------------------------------------------

# The shadow matrix is the same dimension as the data, 
# and consists of binary indicators of missingness of data values, 
# where missing is represented as “NA”, and not missing is represented as “!NA”, 
# and variable names are kep the same, with the added suffix “_NA" to the variables

as_shadow(HELPrct)

# In a nabular format for visualization

nabular(HELPrct)



# Summary for NAs ---------------------------------------------------------

# naniar also provides handy helpers for calculating the number, 
# proportion, and percentage of missing and complete observations:

n_miss(HELPrct)

n_complete(HELPrct)

prop_miss(HELPrct)

prop_complete(HELPrct)

pct_miss(HELPrct)

pct_complete(HELPrct)



# Visualising imputed values ----------------------------------------

install.packages("simputation")
library(simputation)

library(dplyr)

# Impute by CART based model with all other variables 
imp_data <- impute_cart(HELPrct, drugrisk ~ .)

# Now there is no NA anymore
summary(imp_data$drugrisk)
n_miss(imp_data$drugrisk)

# To visualize, after imputing with impute_lm() 
# drugrisk is imputed by mcs data below

HELPrct_shadow <- bind_shadow(HELPrct)

imp_lm_data <- HELPrct_shadow %>%
  as.data.frame() %>% 
  impute_lm(drugrisk ~ mcs)

# No NA here !
summary(imp_lm_data$drugrisk)

HELPrct_shadow %>%
  as.data.frame() %>% 
  impute_lm(drugrisk ~ mcs) %>%
  ggplot(aes(x = mcs,
             y = drugrisk,
             colour = drugrisk_NA)) + 
  geom_point()


# References --------------------------------------------------------------


# https://cran.r-project.org/web/packages/naniar/index.html

# https://cran.r-project.org/web/packages/mosaicData/mosaicData.pdf

# https://cran.r-project.org/web/packages/visdat/vignettes/using_visdat.html

# https://cran.r-project.org/web/packages/naniar/vignettes/getting-started-w-naniar.html

# https://cran.r-project.org/web/views/MissingData.html

# https://cran.r-project.org/web/packages/simputation/index.html

# https://www.youtube.com/watch?v=eux3NzJR8O0
