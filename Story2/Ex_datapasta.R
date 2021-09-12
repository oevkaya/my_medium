# Necessary packages

install.packages("datapasta")
library(datapasta)

# For data wrangling, table and figures
library(tidyverse)
library(ggplot2)
library(DT)


# Example 1 ---------------------------------------------------------------


# About data extracting from html etc. from wikipedia address;
# https://en.wikipedia.org/wiki/List_of_largest_companies_by_revenue

# After copying the table and paste here as data.frame 
# with the datapasta magic from addin !

largcomp <- data.frame(
  stringsAsFactors = FALSE,
                V1 = c(1L,2L,3L,4L,5L,6L,7L,8L,
                       9L,10L,11L,12L,13L,14L,15L,16L,17L,18L,19L,
                       20L,21L,22L,23L,24L,25L,26L,27L,28L,29L,30L,31L,
                       32L,33L,34L,35L,36L,37L,38L,39L,40L,41L,42L,
                       43L,44L,45L,46L,47L,48L,49L,50L),
                V2 = c("Walmart","State Grid",
                       "Amazon","China National Petroleum","Sinopec Group","Apple",
                       "CVS Health","UnitedHealth","Toyota","Volkswagen",
                       "Berkshire Hathaway","McKesson",
                       "China State Construction","Saudi Aramco","Samsung Electronics",
                       "Ping An Insurance","AmerisourceBergen","BP","Royal Dutch Shell",
                       "ICBC","Alphabet","Foxconn","ExxonMobil","Daimler",
                       "China Construction Bank","AT&T","Microsoft","Costco",
                       "Cigna","Agricultural Bank of China","Cardinal Health",
                       "Trafigura","China Life Insurance","Glencore",
                       "China Railway Engineering Corporation","Walgreens Boots Alliance",
                       "Exor","Allianz","Bank of China","Kroger",
                       "Home Depot","China Railway Construction","JPMorgan Chase",
                       "Huawei","Verizon","AXA","Ford","Honda","General Motors",
                       "Anthem"),
                V3 = c("Retail","Electricity",
                       "Retail, Information Technology","Oil and gas","Oil and gas",
                       "Electronics","Healthcare","Healthcare","Automotive",
                       "Automotive","Financials","Healthcare","Construction",
                       "Oil and gas","Electronics","Financials",
                       "Healthcare","Oil and gas","Oil and gas","Financials",
                       "Information technology","Electronics","Oil and gas",
                       "Automotive","Financials","Telecommunications",
                       "Information technology","Retail","Healthcare","Financials",
                       "Healthcare","Commodities","Insurance","Commodities",
                       "Construction","Retail","Holding company","Financials",
                       "Financials","Retail","Retail","Construction","Financials",
                       "Electronics","Telecommunications","Financials",
                       "Automotive","Automotive","Automotive","Healthcare"),
                V4 = c("Increase $559,151",
                       "Increase $386,618","Increase $386,064","Decrease $283,958",
                       "Decrease $283,728","Increase $274,515","Increase $268,706",
                       "Increase $257,141","Decrease $256,722",
                       "Decrease $253,965","Increase $254,510","Increase $238,228",
                       "Increase $234,425","Decrease $229,766","Increase $200,734",
                       "Increase $191,509","Increase $189,894",
                       "Decrease $183,500","Decrease $183,195","Increase $182,794",
                       "Increase $182,527","Increase $181,945","Decrease $181,502",
                       "Decrease $175,827","Increase $172,000","Decrease $171,760",
                       "Increase $168,090","Increase $166,761",
                       "Increase $160,401","Increase $153,885","Increase $152,922",
                       "Decrease $146,994","Increase $144,589","Decrease $142,338",
                       "Increase $141,384","Increase $139,537",
                       "Decrease $136,186","Increase $136,173","Decrease $134,046",
                       "Increase $132,498","Increase $132,110","Increase $131,992",
                       "Decrease $129,503","Increase $129,184","Decrease $128,292",
                       "Decrease $128,011","Decrease $127,144",
                       "Decrease $124,241","Decrease $122,485","Increase $121,867"),
                V5 = c("$13,600","$5,580","$21,331",
                       "$4,575","$6,205","$57,411","$7,179","$15,403",
                       "$21,180","$10,104","$42,521","-$4,539","$3,578",
                       "$49,287","$22,116","$20,739","-$3,409","-$20,305",
                       "-$21,680","$45,783","$40,269","$3,457","-$22,440","$4,133",
                       "$39,283","-$5,176","$61,270","$4,002","$8,458",
                       "$31,293","-$3,696","$1,699","$4,648","-$1,903",
                       "$1,639","$456","-$34","$7,756","$27,952","$2,585",
                       "$12,870","$1,486","$29,131","$9,362","$17,801","$3,605",
                       "-$1,279","$6,202","$6,427","$4,572"),
                V6 = c(2300000,896360,1335000,
                       1242245,553833,147000,256500,330000,366283,662575,
                       360000,67500,356864,79800,267937,362035,21500,68100,
                       87000,439787,144056,878429,72000,288481,373814,
                       230760,181000,214500,72963,462592,48000,8619,183417,
                       87822,308483,450000,263284,150269,309084,465000,
                       504800,364632,260110,197000,135500,96595,186000,211374,
                       155000,83400),
                V7 = c("United States United States",
                       "China China","United States United States",
                       "China China","China China","United States United States",
                       "United States United States","United States United States",
                       "Japan Japan","Germany Germany",
                       "United States United States","United States United States","China China",
                       "Saudi Arabia Saudi Arabia","South Korea South Korea",
                       "China China","United States United States",
                       "United Kingdom United Kingdom","Netherlands Netherlands","China China",
                       "United States United States","Taiwan Taiwan",
                       "United States United States","Germany Germany","China China",
                       "United States United States",
                       "United States United States","United States United States",
                       "United States United States","China China","United States United States",
                       "Singapore Singapore","China China",
                       "Switzerland Switzerland","China China","United States United States",
                       "Netherlands Netherlands","Germany Germany","China China",
                       "United States United States",
                       "United States United States","China China","United States United States",
                       "China China","United States United States","France France",
                       "United States United States","Japan Japan",
                       "United States United States","United States United States"),
                V8 = c("[4]","[5]","[6]","[7]",
                       "[8]","[9]","[10]","[11]","[12]","[13]","[14]","[15]",
                       "[16]","[17]","[18]","[19]","[20]","[21]","[22]",
                       "[23]","[24]","[25]","[26]","[27]","[28]","[29]",
                       "[30]","[31]","[32]","[33]","[34]","[35]","[36]",
                       "[37]","[38]","[39]","[40]","[41]","[42]","[2]",
                       "[2]","[2]","[43]","[44]","[45]","[46]","[47]","[48]",
                       "[49]","[2]")
)

# Some data wrangling to clean
# column names first 
colnames(largcomp) <- c("Rank",	"Name",	"Industry",	"Revenue",	"Profit",	"Employees",
                        "Headquarters",	"Ref")

# cleaning the Profit column to use it 
largcomp$Profit <-  as.numeric(gsub("\\,", "", 
  gsub("\\$", "", largcomp$Profit)))

# as tbl format
large_comp_tbl <- largcomp %>% tbl_df()

# getting a fancy table for mean of Profit for each industry 
DT::datatable( large_comp_tbl %>% 
  select(Name, Industry, Profit, Employees) %>% 
  group_by(Industry) %>% 
  summarise(mean(Profit)) ) 

# Find the largest company with top employees 
Empl <- large_comp_tbl %>% 
  select(Name, Industry, Profit, Employees) %>% 
  group_by(Industry) %>%
  summarise(sum(Employees))

colnames(Empl)[2] <- c("TotalEmply")

Empl %>% 
  ggplot(aes(y=Industry, x = TotalEmply, fill = Industry)) +  
  geom_bar(stat = "identity", show.legend = F) + 
  theme_bw()


# Turkey Covid Data by Province -------------------------------------------

# After copying the values from https://covid19.saglik.gov.tr/ and pasting as tribble
# by the datapasta magic 

CovidTR <- tibble::tribble(
          ~Il.Adi,  ~Sayi,
          "Adana",   9833,
       "Adiyaman",  18215,
          "Afyon",  21495,
           "Agri",  20301,
        "Aksaray",  42458,
         "Amasya",  10343,
         "Ankara",  24261,
        "Antalya",   4140,
        "Ardahan",  15911,
         "Artvin",  20059,
          "Aydin",   3959,
      "Balikesir",   6587,
         "Bartin",  14122,
         "Batman",  32082,
        "Bayburt",  50787,
        "Bilecik",  16277,
         "Bingöl",  31551,
         "Bitlis",  22878,
           "Bolu",  25762,
         "Burdur",   7451,
          "Bursa",   7399,
      "Çanakkale",   5983,
        "Çankiri",  14031,
          "Çorum",  20995,
        "Denizli",   7695,
     "Diyarbakir",  21032,
          "Düzce",  18323,
         "Edirne",   7259,
         "Elazig",  39254,
       "Erzincan",  21328,
        "Erzurum",  23435,
      "Eskisehir",  26608,
      "Gaziantep",  21303,
        "Giresun",  19611,
      "Gümüshane",  32674,
        "Hakkari",  12762,
          "Hatay",  13566,
          "Igdir",  13263,
        "Isparta",   8426,
       "Istanbul",  15695,
          "Izmir",   4558,
  "Kahramanmaras",  21084,
        "Karabük",  22946,
        "Karaman",  36914,
           "Kars",  15232,
      "Kastamonu",  20883,
        "Kayseri",  41387,
      "Kirikkale",  26300,
     "Kirklareli",   5557,
       "Kirsehir",  23494,
          "Kilis",  25842,
        "Kocaeli",  16397,
          "Konya",  40284,
        "Kütahya",  22629,
        "Malatya",  26831,
         "Manisa",   6969,
         "Mardin",  24125,
         "Mersin",   6983,
          "Mugla",   4027,
            "Mus",  29967,
       "Nevsehir",  26987,
          "Nigde",  26210,
           "Ordu",  16640,
       "Osmaniye",  15167,
           "Rize",  65310,
        "Sakarya",  24419,
         "Samsun",  17757,
          "Siirt",  11780,
          "Sinop",  20142,
          "Sivas",  31358,
      "Sanliurfa",  27056,
         "Sirnak",   8684,
       "Tekirdag",  10591,
          "Tokat",  18968,
        "Trabzon",  39291,
        "Tunceli",  15340,
           "Usak",   9149,
            "Van",   6612,
         "Yalova",   9455,
         "Yozgat",  30709,
      "Zonguldak",  18403
  )

class(CovidTR$Sayi) # numeric so no problem

# Some dplyr to visualize
# Choosing the largest cases for provinces, top 10 names

Top10 <- CovidTR %>% top_n(10, Sayi)

# To see those provinces
Top10 %>% select(Il.Adi)

# visualization for top 10 

Top10 %>% 
  ggplot(aes(y=Il.Adi, x = Sayi, fill = Il.Adi)) +  
  geom_bar(stat = "identity", show.legend = F) + 
  xlab("Vaka Sayisi (100 binde)") + ylab("İller") + 
  theme(plot.title = element_text(face = "bold")) + 
  theme_bw()


# Further read ------------------------------------------------------------

# https://github.com/MilesMcBain/datapasta

