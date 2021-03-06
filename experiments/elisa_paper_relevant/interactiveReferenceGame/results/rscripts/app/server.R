library(dplyr)
library(ggplot2)
library(bootstrap)
# library(lme4)
library(tidyr)
library(shiny)
library(shinyjs)
library(tidyverse)

theme_set(theme_bw(18))
# runApp("rscripts/app")

# df <- read.table(file="data/completeDataPredictives.csv", sep=",", header=T, check.names = FALSE)
# df <- read.table(file="data/nonoiseDataPredictives.csv", sep=",", header=T, check.names = FALSE)
# df <- read_csv(file="data/nonoiseDataPredictives.csv")
# df <- read_csv(file="data/completeDataPredictives_nopink.csv", guess_max = 500000)

# fastest
df <- read_csv(file="data/completeDataPredictives.csv", guess_max = 500000)
# df <- df[df$condition == 'informative' | df$condition == 'informative-cc',]

# head(df)

shinyServer(
  function(input, output, session) {
    
    observeEvent(input$reset, {
      updateSelectInput(session, "noise", selected = 1)
      updateSliderInput(session, "alpha", value = 10)
      updateSliderInput(session, "colorcost", value = 0)
      updateSliderInput(session, "typecost", value = -1.5)
      updateSliderInput(session, "lengthWeight", value = 0.5)
      updateSliderInput(session, "typWeight", value = 6)
      updateSliderInput(session, "noiseRate", value = 0.5)
    })
    
    dat <- reactive({
      if (input$noise == 1)
        # Can also set the label and select items
        test <- df[df$alpha == input$alpha & df$colorCost == input$colorcost & df$typeCost == input$typecost & df$lengthWeight == input$lengthWeight & df$typWeight == input$typWeight & df$noise == input$noise,]
      else
        test <- df[df$alpha == input$alpha & df$colorCost == input$colorcost & df$typeCost == input$typecost & df$lengthWeight == input$lengthWeight & df$typWeight == input$typWeight & df$noise == input$noise & df$noiseRate == input$noiseRate,]
   })
    
    hide("loading_page")
    shinyjs::show("ready")

    output$plot2<-renderPlot({
      ggplot(dat(), aes(x=Typicality,y=modelPrediction,color=uttType)) +
        geom_point(size=1) +
        geom_smooth(method="lm",size=1.3) +
        #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
        facet_wrap(~condition) +
        coord_cartesian(ylim=c(0,1)) +
        # ylim(0,1) +
        #green, turquoise, red
        scale_color_manual(name="Utterance",
                           breaks=c("typeOnly", "colorOnly", "colorType"),
                           labels=c("Only Type", "Only Color", "Color + Type"),
                           values=c("#799938", "#5bc2b7", "#ef6666")) +
        theme(axis.title=element_text(size=14,colour="#757575")) +
        theme(axis.title=element_text(size=14,colour="#757575")) +
        theme(axis.text.x=element_text(size=10,colour="#757575")) +
        theme(axis.text.y=element_text(size=10,colour="#757575")) +
        theme(axis.ticks=element_line(size=.25,colour="#757575"), axis.ticks.length=unit(.75,"mm")) +
        theme(strip.text.x=element_text(size=18,colour="#757575")) +
        theme(legend.position="top",legend.box="horizontal") +
        theme(legend.title=element_text(size=15,color="#757575")) +
        theme(legend.text=element_text(size=12,colour="#757575")) +
        theme(strip.background=element_rect(colour="#939393",fill="white")) +
        theme(panel.background=element_rect(colour="#939393"))
    },height = 400,width = 550)

    output$plot3 <- renderPlot({
      ggplot(dat(), aes(x=modelPrediction,y=empiricProb)) +
        geom_point() +
        geom_abline() +
        coord_cartesian(ylim=c(0,1)) +
        coord_cartesian(xlim=c(0,1)) +
        theme(legend.position="bottom", aspect.ratio = 1) +
        geom_smooth(method="lm",size=1.3)
    })

    output$corr <- reactive({
      full_data <- dat()
      text <- paste("Correlation coefficient for all data: ", round(cor.test(full_data$empiricProb,full_data$modelPrediction)$estimate,4)*100,"% (",nrow(full_data)," data points )")
    })

    output$corr2 <- reactive({
      inThreshold <- dat()[dat()$modelPrediction <= .99 & dat()$modelPrediction >= .01,]
      text <- paste("Correlation coefficient in boundaries 1% - 99% in modelPrediction: ", round(cor.test(inThreshold$empiricProb,inThreshold$modelPrediction)$estimate,4)*100,"% (",nrow(inThreshold)," data points )")
    })
  }
)
