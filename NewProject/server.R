library(shiny)
library(RMySQL)
con <- dbConnect(MySQL(),user="root", password="root", dbname="stockdata", host="localhost")

shinyServer(function(input, output) {
  # query1<-reactive({"select distinct(symbol) from allstocks"})
  
  #    username <- input$uname
  
  #result1 <- reactive({dbGetQuery(con,query1())})
  
  result1 <- dbSendQuery(con, "select distinct(symbol) from allstocks;")
  data <- fetch(result1, n=-1)
  print(as.list(data))
  #stocksymbols <- fetch(result1, n = -1)
  
  #output$table <-renderTable({result1()})
  
  output$distStock <- renderUI({
    
    selectInput(inputId = "StockSymbols",
                label = "Stock Symbols",
                choices = data$symbol,
                selected = "CSCO")
  })
  
})