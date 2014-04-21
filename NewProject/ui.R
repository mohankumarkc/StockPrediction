# Set the working directory and list all csv files inside
# Define UI for dataset viewer application
shinyUI(pageWithSidebar(
  # Application title
  headerPanel("Stock Prediction"),
  
  
  # Left hand side panel
  sidebarPanel(
    wellPanel(
      p(strong("Stock Symbols")),
      uiOutput("distStock")
      
    )),
  
  # Main panel (on the right hand side)
  
  mainPanel(
    verbatimTextOutput("summary"),
    
    tableOutput("table")
  )
  
  ))

  