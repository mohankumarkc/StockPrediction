# Goal: download adjusted price data for selected security, convert to returns, and write to output file

library(quantmod)
library(tseries)
library(zoo)
library(RMySQL)
# Load security data from Yahoo! Finance
historical_prices<- get.hist.quote(instrument = "INFY.NS",quote=c("Open", "High", "Low", "Close" ,"Volume"), start="2002-4-3",end="3-04-2014", provider="yahoo")
historical_prices

head(historical_prices)

getwd()
# Load the data in data frame

prices<-data.frame(historical_prices)
prices
#Storing data in mysql 
con <- dbConnect(MySQL(),user="root", password="root", dbname="stock", host="localhost")

dbListTables(con)
dbWriteTable(con, name='stocks_infy', value=prices)

# retrieving data from mysql
rs = dbSendQuery(con, "select * from stocks_infy")
# fetching data
data = fetch(rs, n=-1)
on.exit(dbDisconnect(con)) #safely colse database connection on application



# Download data for a stock if needed, and return the data
require_symbol <- function(data, envir = parent.frame())
{
  if (is.null(envir[[data]]))
  {
    envir[[data]] <- getSymbols(data, auto.assign = FALSE)
  }
  
  envir[[data]]
}


shinyServer(function(input, output) {
  
  # Create an environment for storing data
  symbol_env <- new.env()
  
  # Make a chart for a symbol, with the settings from the inputs
  make_chart <- function(data) {
    symbol_data <- require_symbol(data, symbol_env)
    
    chartSeries(symbol_data,
                name      = data,
                type      = input$chart_type,
                subset    = paste("last", input$time_num, input$time_unit),
                log.scale = input$log_y,
                theme     = "black")
  }
  
  output$plot_infy <- renderPlot({ make_chart("INFY") })
  
})