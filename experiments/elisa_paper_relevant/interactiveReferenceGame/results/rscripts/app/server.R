library(dplyr)
library(ggplot2)
library(bootstrap)
library(lme4)
library(tidyr)
library(shiny)

setwd("/Users/elisakreiss/Documents/Stanford/overinformativeness/experiments/elisa_paper_relevant/interactiveReferenceGame/results/rscripts/app")
source("helpers.r")
theme_set(theme_bw(18))
# runApp("rscripts/app")

# wrong file.. need one with actual results
# empiric = read.table(file="data/empiricalReferenceProbs.csv",sep=",", header=T,check.names = FALSE)
# head(empiric)
# df = read.table(file="data/visualizationPredictives.csv",sep=",", header=T, quote="")
# typ = read.csv(file='data/meantyp_short.csv',sep=',',header=T,quote="")
# typ$target = paste(typ$Color,typ$Item, sep = '_')
# typ = typ[c('Typicality','target')]
# df = merge(df,typ,by='target')
# df = merge(df,empiric,by=c('target','uttType','condition'))
# print(head(df))
# new_df = select(df, condition, alpha, colorCost, typeCost, lengthWeight, typWeight, uttType, modelPrediction, Typicality, empiricProb)
# write.csv(new_df,file='data/allData.csv', row.names = FALSE)
df = read.table(file="data/allDataPredictives.csv",sep=",", header=T,check.names = FALSE)

shinyServer(
  function(input, output) {
    dat <- reactive({
      test <- df[df$alpha == input$alpha & df$colorCost == input$colorcost & df$typeCost == input$typecost & df$lengthWeight == input$lengthWeight & df$typWeight == input$typWeight,]
   })
    
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
