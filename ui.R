library(shiny)
shinyUI(fluidPage(
  titlePanel("STOCK STATUS"),
  
  sidebarLayout(
    sidebarPanel(
      
      
      selectInput("var", 
                  label = "Stock Symbols",
                  choices = c("Accel Frontline Limited (AFL)",
                              "Aditya Birla Chemicals (India) Limited ( ABCIL)",
                              "Apollo Tyres Limited ( APOLLOTYRE)",
                              "Microsoft (MSFT)",
                              "Apple (AAPL)",
                              "IBM (IBM)",
                              "Google (GOOG)",
                              "Yahoo (YHOO)"),
                  selected = "Microsoft (MSFT)"),
      
      selectInput("duration", 
                  label = "Choose a duration to display",
                  choices = c("Days" = "days",
                              "Weeks" = "weeks",
                              "Months" = "months",
                              "Years" = "years"),
                  selected = "Days"),
      
      
      sliderInput("obs", 
                  "Number of observations:", 
                  min = 1,
                  max = 1000, 
                  value = 500)
    ),
    
    mainPanel(
      h3("Ploting of the  selected Stock Symbol"),
      plotOutput("distPlot")
      
    )
  )
))