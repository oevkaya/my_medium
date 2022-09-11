
# Loading necessary packages ----------------------------------------------

#install.packages("dplyr")
#install.packages("kableExtra")

library(dplyr)
library(kableExtra)


# Loading Data ------------------------------------------------------------

df <- dplyr::starwars

head(df)

# To make it simpler
df_attack <- df %>% 
  filter(films == "The Force Awakens")


# Create Latex table  -----------------------------------------------------

# Without ant modification 
kableExtra::kable(df_attack, "latex", booktabs = T)

# Some modification 
kableExtra::kable(df, "latex", booktabs = T) %>% 
  kableExtra::column_spec(2:3, width = "5cm")

# Alternative to kable with extra modification

df_attack %>%
  kableExtra::kbl(caption="Starwars Movie Characters",
      format="latex",
      align="r") %>% # about alignment of the cell
kableExtra::kable_minimal(full_width = F,  
                html_font = "Source Sans Pro")




