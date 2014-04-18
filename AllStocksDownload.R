library(TTR)
library(quantmod)
library(RMySQL)
# Download all stocks for NASDAQ

cat("Fetching all tickers\n")

all.symbols <- stockSymbols(c("NASDAQ"),sort.by=c("MarketCap","Symbol"),quiet=TRUE)
# Get 10 biggest by market cap

biggest.symbols <- tail(all.symbols,n=10)

# Cleanup

clean.symbols <- subset(biggest.symbols, select = c("Symbol","Name","LastSale"))
#head(all.symbols)
#head(clean.symbols)
#clean.symbols
row.names(clean.symbols) <- NULL

# Download data

cat("Starting download for ",nrow(biggest.symbols)," tickers \n")

for (i in 1:nrow(clean.symbols)){
  symbol <- clean.symbols[i,]$Symbol
  cat("Downloading",symbol)
  
  try (getSymbols(symbol, verbose=FALSE, warnings=FALSE, from='2005-01-01'))
  
  if(!exists(symbol)){
    # print(symbol)
    cat(", error - did not download (likely due to rate limiting\n")
    #    clean.symbols <- clean.symbols$symbol <- NULL
    # print(clean.symbols)
    #print(clean.symbols$symbol)
  }
  else {
    cat("\n")
  }
#  Sys.sleep(2)
}
# Save data to MySQL



  con <- dbConnect(MySQL(),user="root", password="root", dbname="stock", host="localhost")



# Loop through each symbol

for (i in 1:nrow(clean.symbols)){
  symbol <- clean.symbols[i,]$Symbol
  df = data.frame(symbol,Date=index(get(symbol)), coredata(get(symbol),""))
  df1=setNames(df,c("symbol","Date","Open","High","Low","Close","Volume","Adjusted"))
  cat("Storing",symbol,"\n")
  
  dbWriteTable(con, name='allstocks', value=as.data.frame(df1), row.names=FALSE,append=TRUE)
  
}