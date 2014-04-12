shinyUI(pageWithSidebar(
  headerPanel("Stock Status"),
  
  sidebarPanel(
    
    
    selectInput(inputId = "stocks_infy",
                label = h4("Select Symbol"),
                choices = c("Infosys (INFY) ")
    ),
    
    dateRangeInput("dates",p(strong("Date range")), start="2002-4-3",
                   end=as.character(Sys.Date())), 
    
    selectInput(inputId = "chart_type",
                label = h5("Chart type"),
                choices = c("Candlestick" = "candlesticks",
                            "Matchstick" = "matchsticks",
                            "Bar" = "bars",
                            "Line" = "line")
    ),
    
    wellPanel(
      p(strong("Date range (back from present)")),
      sliderInput(inputId = "time_num",
                  label = "Time number",
                  min = 1, max = 24, step = 1, value = 6),
      
      selectInput(inputId = "time_unit",
                  label = "Time unit",
                  choices = c("Days" = "days",
                              "Weeks" = "weeks",
                              "Months" = "months",
                              "Years" = "years"),
                  selected = "Days")
    ),
    
    checkboxInput(inputId = "log_y", label = "log y axis", value = FALSE)
  ),
  
  mainPanel(
    conditionalPanel(condition = "input.stocks_infy",
                     
                     div(plotOutput(outputId = "plot_infy")))
    
    
  )
))