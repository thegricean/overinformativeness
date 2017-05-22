shinyUI(fluidPage(
  titlePanel("Overinformativeness Model Visualizations"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("overinformativeness model visualizations"),
    
      sliderInput("alpha", 
                  label = "Alpha:",
                  min = 0, max = 30, value = 5, step = 5),
      
      sliderInput("colorcost", 
                  label = "Cost for mentioning color:",
                  min = 0, max = 30, value = 5, step = 0.1),
      
      sliderInput("typecost", 
                  label = "Cost for mentioning type:",
                  min = 0, max = 30, value = 5, step = 0.1)
      ),
    
    mainPanel(plotOutput("map"))
  )
))