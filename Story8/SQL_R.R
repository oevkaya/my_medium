
# SQLDF package -----------------------------------------------------------

install.packages("sqldf")
# asking to install blob and RSQLite as well  
library(sqldf)

# Some data set available
data(EuStockMarkets)
head(EuStockMarkets)

# Consider it as data frame
EuStock <- as.data.frame(EuStockMarkets)

# choosing only one stock 
sqldf('SELECT DAX FROM EuStock')

# choose also a subset 
sqldf('SELECT DAX FROM EuStock LIMIT 5')

# put a condition 
sqldf("SELECT * FROM EuStock WHERE DAX > 1620")

# Wild card to select all
sqldf('SELECT * FROM EuStock')
sqldf('SELECT * FROM EuStock LIMIT 5')

# Ordering 
sqldf('SELECT * FROM EuStock ORDER BY CAC ASC LIMIT 5')

# Aggregated data
sqldf("SELECT AVG(DAX) FROM EuStock")


# RSQLite -----------------------------------------------------------------


# RSQLite
# install.packages("RSQLite")
library(RSQLite)

# To create a new SQLite database
mydb <- dbConnect(RSQLite::SQLite(), "my-dbsql")
dbDisconnect(mydb)
unlink("my-dbsql")

# For a temporary database it can be used the following
# mydb <- dbConnect(RSQLite::SQLite(), "")
# dbDisconnect(mydb)

# Copying a data set into new database
mydb <- dbConnect(RSQLite::SQLite(), "my-dbsql")
dbWriteTable(mydb, "EuStock", EuStock)
dbListTables(mydb)

# Applying simple query with dbGetQuery():

dbGetQuery(mydb, 'SELECT * FROM mtcars LIMIT 5')
dbGetQuery(mydb, 'SELECT * FROM EuStock LIMIT 10')

# Some queries

dbGetQuery(mydb, "SELECT * FROM EuStock WHERE DAX > 1620 LIMIT 10")

# If you need to insert the value from a user into a query, don’t use paste()! 
# That makes it easy for a malicious attacker to insert SQL that might damage your 
# database or reveal sensitive information. Instead, use a parameterised query:

dbGetQuery(mydb, 'SELECT * FROM EuStock WHERE "DAX" > :x LIMIT 10', params = list(x = 1620))


# dbplyr ------------------------------------------------------------------


# Introduction to dbplyr
library(dplyr)
library(dbplyr)
con <- DBI::dbConnect(RSQLite::SQLite(), dbname = ":memory:")
# with :memory:, creating a temporary in-memory database.


# Copying data to con 
copy_to(con, EuStock, "EuStock",
        temporary = FALSE, 
        indexes = list("DAX", "SMI", "CAC", "FTSE") )

# Put a reference on it 
EuStock_db <- tbl(con, "EuStock")
EuStock_db 

# Some queries like dplyr syntax
EuStock_db %>% select(DAX)

EuStock_db %>% filter(DAX>1620) 

EuStock_db %>% 
  select(DAX, SMI) %>% 
  filter(DAX>1620) %>% 
  head()


# Some Sources for further reading / watch ----------------------------------------

# https://www.r-bloggers.com/2021/04/using-sql-for-r-data-frames-with-sqldf/

# https://dept.stat.lsa.umich.edu/~jerrick/courses/stat701/notes/sql.html

# https://rpubs.com/jah9kqn/sqldf_review

# https://www.red-gate.com/simple-talk/development/dotnet-development/sql-and-r/

# https://www.youtube.com/watch?v=Z5LPjh_EkJk

# https://github.com/fjodor/data-import-export/blob/main/Accessing-SQL.pdf

# https://cran.r-project.org/web/packages/dbplyr/vignettes/dbplyr.html
