# Set the working directory and list all csv files inside
# Define UI for dataset viewer application
shinyUI(pageWithSidebar(
  # Application title
  headerPanel("Welcome lazy student! You're currently using the program
              'What Nicolas's teacher wants' "),
  
  
  # Left hand side panel
  sidebarPanel(
    wellPanel(
      p(strong("Stock Prediction")),
      uiOutput("distStock")
      
    )),
  
  #         submitButton("Update View"),
  #        br(),
  # Button to import data
  # Simple texts
  
  
  # Main panel (on the right hand side)
  
  mainPanel(
    verbatimTextOutput("summary"),
    
    tableOutput("table")
  )
  
  # Numerical summary of the dataset,
  # coming from the function output$summary in server.R
  
  # Graphic
  # coming from the function output$boxplots in server.R
  ))

