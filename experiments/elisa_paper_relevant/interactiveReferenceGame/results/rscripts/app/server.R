library(dplyr)
library(ggplot2)
library(bootstrap)
library(lme4)
library(tidyr)
library(shiny)

setwd("/Users/elisakreiss/Documents/Stanford/overinformativeness/experiments/elisa_paper_relevant/interactiveReferenceGame/results/rscripts/app")
source("helpers.r")
# runApp("rscripts/app")

# df = read.table(file="data/trialCSV.csv",sep=";", header=T, quote="")
df = read.table(file="data/visualizationPredictives.csv",sep=",", header=T, quote="")
typ = read.csv(file='data/meantyp_short.csv',sep=',',header=T,quote="")
typ$target = paste(typ$Color,typ$Item, sep = '_')
typ = typ[c('Typicality','target')]
df = merge(df,typ,by='target')
# print(df)

shinyServer(
  function(input, output) {
    dat <- reactive({
      test <- df[df$alpha == input$alpha & df$colorCost == input$colorcost & df$typeCost == input$typecost & df$lengthWeight == input$lengthWeight & df$typWeight == input$typWeight,]
      # print(test)
   })
    output$plot2<-renderPlot({
      ggplot(dat(), aes(x=Typicality,y=modelPrediction,color=uttType)) +
        geom_point(size=.5) +
        geom_smooth(method="lm",size=.6) +
        #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
        facet_wrap(~condition) +
        scale_color_manual(values=c("green", "turquoise", "red")) +
        theme(axis.title=element_text(size=14,colour="#757575")) +
        theme(axis.text.x=element_text(size=10,colour="#757575")) +
        theme(axis.text.y=element_text(size=10,colour="#757575")) +
        theme(axis.ticks=element_line(size=.25,colour="#757575"), axis.ticks.length=unit(.75,"mm")) +
        theme(strip.text.x=element_text(size=12,colour="#757575")) +
        theme(legend.title=element_text(size=14,color="#757575")) +
        theme(legend.text=element_text(size=11,colour="#757575")) +
        theme(strip.background=element_rect(colour="#939393",fill="white")) +
        theme(panel.background=element_rect(colour="#939393"))
    },height = 400,width = 600)
  }
)
