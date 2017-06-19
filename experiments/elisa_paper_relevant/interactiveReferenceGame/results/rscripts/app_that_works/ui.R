library(shiny)
library(shinyjs)

shinyUI(fluidPage(
  titlePanel("Overinformativeness Model Visualizations"),
  sidebarLayout(
    sidebarPanel(
      h4("Parameters"),
      
      helpText("Set parameters"),

      sliderInput("alpha",
                  label = "Alpha:",
                  min = 0, max = 18, value = 18, step = 2),

      sliderInput("colorcost",
                  label = "Cost for mentioning color:",
                  min = -3, max = 3, value = 0, step = 1.5),

      sliderInput("typecost",
                  label = "Cost for mentioning type:",
                  min = -3, max = 3, value = -1.5, step = 1.5),

      sliderInput("lengthWeight",
                  label = "LengthWeight:",
                  min = 0, max = 1, value = 0, step = 0.25),

      sliderInput("typWeight",
                  label = "TypicalityWeight",
                  min = 0, max = 10, value = 6, step = 2)
    ),

    mainPanel(
      useShinyjs(),
      div(
        id = "loading_page",
        # h3("Loading...", align="center"),
        tags$img(src="load_data.gif",height=200, align="middle")
      ),
      hidden(
        div(
          id = "ready",
          tabsetPanel(
            tabPanel("Plot",
              plotOutput("plot2"),
              img(src='utterance_by_conttyp_poster.png', height = 400)),
            tabPanel("Compare", plotOutput("plot3"), textOutput("corr"), textOutput("corr2"))
          )
        )
      )
    )
  )
))
