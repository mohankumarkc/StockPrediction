shinyUI(pageWithSidebar(
  # Application title
  headerPanel("Stock Prediction"),
  
  
  # Left hand side panel
  sidebarPanel(
    wellPanel(
      p(strong("Stock Symbols")),
      uiOutput("distStock")
      
     ),
 
  
  selectInput(inputId = "chart_type",
              label = "Chart Type",
              choices = c("Candlestick" = "candlesticks",
                          "Matchstick" = "matchsticks",
                          "Bar" = "bars",
                          "Line" = "line")
  ),
  
  wellPanel(
    p(strong("Date range (back from present)")),
    sliderInput(inputId = "time_num",
                label = "Time Number",
                min = 1, max = 24, step = 1, value = 6),
    
    selectInput(inputId = "time_unit",
                label = "Time Unit",
                choices = c("Day" = "day",
                            "Weeks" = "weeks",
                            "Months" = "months",
                            "Years" = "years"),
                selected = "day")
  )),
  
  # Main panel (on the right hand side)
  
  mainPanel(plotOutput("plotSymbol"))
  ))

  