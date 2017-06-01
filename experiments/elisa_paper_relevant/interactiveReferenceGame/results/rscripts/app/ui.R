shinyUI(fluidPage(
  titlePanel("Overinformativeness Model Visualizations"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("overinformativeness model visualizations"),
      
      sliderInput("alpha",
                  label = "Alpha:",
                  min = 0, max = 18, value = 6, step = 2),
      
      sliderInput("colorcost",
                  label = "Cost for mentioning color:",
                  min = -3, max = 3, value = 0, step = 1.5),
      
      sliderInput("typecost",
                  label = "Cost for mentioning type:",
                  min = -3, max = 3, value = 0, step = 1.5),
      
      sliderInput("lengthWeight",
                  label = "LengthWeight:",
                  min = 0, max = 1, value = 0, step = 0.25),
      
      sliderInput("typWeight",
                  label = "TypWeight",
                  min = 0, max = 10, value = 0, step = 2)
    ),
    
    mainPanel(plotOutput("plot2"))
  )
))

# shinyUI(fluidPage(
#   titlePanel("Overinformativeness Model Visualizations"),
# 
#   sidebarLayout(
#     sidebarPanel(
#       helpText("overinformativeness model visualizations"),
# 
#       sliderInput("alpha",
#                   label = "Alpha:",
#                   min = 0, max = 18, value = 6, step = 2),
# 
#       sliderInput("colorcost",
#                   label = "Cost for mentioning color:",
#                   min = -3, max = 3, value = 0, step = 1.5),
# 
#       sliderInput("typecost",
#                   label = "Cost for mentioning type:",
#                   min = -3, max = 3, value = 0, step = 1.5),
# 
#       sliderInput("lengthWeight",
#                   label = "LengthWeight:",
#                   min = 0, max = 1, value = 0, step = 0.25),
# 
#       sliderInput("typWeight",
#                   label = "TypWeight",
#                   min = 0, max = 10, value = 0, step = 2)
#       ),
# 
#     mainPanel(plotOutput("plot2"))
#   )
# ))

