shinyServer(function(input, output)
{
  
  output$distPlot <- renderPlot(
{ 
  dist <- rnorm(input$obs)
  hist(dist,col=c(1,2,3))
}
  )

}
)
