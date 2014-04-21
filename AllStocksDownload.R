library(TTR)
library(quantmod)
library(RMySQL)
# Download all stock symbols for NASDAQ
cat("Fetching all tickers\n")

all.symbols <- stockSymbols(c("NASDAQ"),sort.by=c("MarketCap","Symbol"),quiet=TRUE)

# Get 10 symbols from the list.
biggest.symbols <- tail(all.symbols,n=10)

# Taking columns Symbol Name and LastSale
clean.symbols <- subset(biggest.symbols, select = c("Symbol","Name","LastSale"))

# Download data

cat("Starting download for ",nrow(biggest.symbols)," tickers \n")

for (i in 1:nrow(clean.symbols)){
  symbol <- clean.symbols[i,]$Symbol
  cat("Downloading",symbol)
  
  try (getSymbols(symbol, verbose=FALSE, warnings=FALSE, from='2005-01-01'))
  
  if(!exists(symbol)){
    cat(", error - did not download (likely due to rate limiting\n")
  }
  else {
    cat("\n")
  }
}

# Save data to MySQL
#MySQL connection with user and password as root. dbname is stockdata.
con <- dbConnect(MySQL(),user="root", password="root", dbname="stockdata", host="localhost")

# Loop through each symbol

for (i in 1:nrow(clean.symbols)){
  symbol <- clean.symbols[i,]$Symbol
  #dfAllStocks is a dataframe containing symbol, date, and the stock data.
  #coredata function is to strip off date and index and take only the data
  dfAllStocks = data.frame(symbol,Date=index(get(symbol)), coredata(get(symbol),""))
  #declare the column names, first is symbol assigns corresponding symbols.
  dfColumnNames=setNames(dfAllStocks,c("symbol","Date","Open","High","Low","Close","Volume","Adjusted"))
  cat("Storing",symbol,"\n")
  #storing all stock data to database.
  dbWriteTable(con, name='allstocks', value=as.data.frame(dfColumnNames), row.names=FALSE,append=TRUE)
}
cat("Stocks with symbols download and saved in MySQL")