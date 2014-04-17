#install.packages("quantmod")
library("quantmod")
#Script to download prices from yahoo
#and Save the prices to a RData file
#The tickers will be loaded from a csv file

#Script Parameters
tickerlist <- "companylist.csv"  #CSV containing tickers on rows
savefilename <- "stockdata.RData" #The file to save the data in
startDate = as.Date("2005-01-13") #Specify what date to get the prices from
maxretryattempts <- 5 #If there is an error downloading a price how many times to retry

#Load the list of ticker symbols from a csv, each row contains a ticker

stocksLst <- read.csv("companylist.csv", header = F, stringsAsFactors = F)
stockData <- new.env() #Make a new environment for quantmod to store data in
nrstocks = length(stocksLst[,1]) #The number of stocks to download

#Download all the stock data
for (i in 1:nrstocks){
  for(t in 1:maxretryattempts){
    
    tryCatch(
{
  #This is the statement to Try
  #Check to see if the variables exists
  #NEAT TRICK ON HOW TO TURN A STRING INTO A VARIABLE
  #SEE  http://www.r-bloggers.com/converting-a-string-to-a-variable-name-on-the-fly-and-vice-versa-in-r/
  if(!is.null(eval(parse(text=paste("stockData$",stocksLst[i,1],sep=""))))){
    #The variable exists so dont need to download data for this stock
    #So lets break out of the retry loop and process the next stock
    #cat("No need to retry")
    break
  }
  
  #The stock wasnt previously downloaded so lets attempt to download it
  cat("(",i,"/",nrstocks,") ","Downloading ", stocksLst[i,1] , "\t\t Attempt: ", t , "/", maxretryattempts,"\n")
  getSymbols(stocksLst[i,1], env = stockData, src = "yahoo", from = startDate)
}
#Specify the catch function, and the finally function
, error = function(e) print(e))
  }
}


#Lets save the stock data to mysql.
#Connection to mysql.
con <- dbConnect(MySQL(),user="root", password="root", dbname="stockdata", host="localhost")
for (tick in nrstocks) {
  print(tick)
  df <- get(stocksLst[tick,1], pos=stockData)  # get data from stockData environment
  df1=setNames(df,c("Open","High","Low","Close","Volume","Adjusted"))
  #dbwriteTable(con, name="stocknew",value=as.data.frame(df), field.types=list(dte="date", open="double(20,10)",high="double(20,10)",low="double(20,10)",Close="double(20,10)",volume="double(20,10)",Adjusted="double(20,10)"),row.names=FALSE,append=TRUE)
  print(head(df1))
  dbWriteTable(con, name='stocksnew', value=as.data.frame(df1),append=TRUE,row.names=FALSE)  
 
}