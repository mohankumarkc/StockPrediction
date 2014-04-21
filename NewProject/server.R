library(shiny)
library(RMySQL)
con <- dbConnect(MySQL(),user="root", password="root", dbname="stockdata", host="localhost")

shinyServer(function(input, output) {
  # query1<-reactive({"select distinct(symbol) from allstocks"})
  
  #    username <- input$uname
  
  #result1 <- reactive({dbGetQuery(con,query1())})
  
  result1 <- dbSendQuery(con, "select distinct(symbol) from allstocks;")
  data <- fetch(result1, n=-1)
  #print(as.list(data))
  
  output$distStock <- renderUI({
    
    selectInput(inputId = "StockSymbols",
                label = "Please Select",
                choices = data$symbol,
                selected = "CSCO")
  })
  
  # Create an environment for storing data
  
  
  # Make a chart for a symbol, with the settings from the inputs
  make_chart <- function(data) {
    # symbol_data <- data
    
    
    chartSeries(lsStockSymbol,
                # name      = data,
                type      = input$chart_type,
                subset    = paste("last", input$time_num, input$time_unit),
                log.scale = input$log_y,
                theme     = "white")
  }
  
  output$plot_employee1 <- renderPlot({ make_chart("select_employee1") })
  
  
})
  
