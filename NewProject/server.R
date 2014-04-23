library(shiny)
library(RMySQL)
library(quantmod)
library(xts)
#To get the connection. Change database name accordingly.
con <- dbConnect(MySQL(),user="root", password="root", dbname="stockdata", host="localhost")

shinyServer(function(input, output) {
  #Selecting available stock symbols from the db table.  
  result1 <- dbSendQuery(con, "select distinct(symbol) from allstocks;")
  data <- fetch(result1, n=-1)

  #showing all the stock symbols in the dropdown.
  output$distStock <- renderUI({
      
    selectInput(inputId = "StockSymbols",
                label = "Please Select",
                choices = data$symbol,
                selected = "CSCO")
  })
  
output$plotSymbol <- renderPlot({
  #showSelectedSymbol <- input$StockSymbols
  #print(showSelectedSymbol)

  #Query to retrieve the data for the selected stock symbol from the dropdown. 
  query1 <- reactive({paste("SELECT Date, Open, High, Low, Close, Volume FROM allstocks WHERE symbol='",input$StockSymbols,"';",sep="")})
  result2 <- reactive({dbGetQuery(con,query1())})
  print(head(result2()))
  PDS <- xts(result2()[,-1],order.by=as.POSIXct(result2()[,1]))
  print(head(PDS))


  chartSeries(PDS, name=input$StockSymbols, theme = "white", 
              type = input$chart_type, 
              subset    = paste("last", input$time_num, input$time_unit),              
              log.scale = FALSE
              )
})

  
})
