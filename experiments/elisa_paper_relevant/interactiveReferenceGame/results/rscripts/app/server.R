library(dplyr)
library(ggplot2)
library(bootstrap)
library(lme4)
library(tidyr)
library(shiny)

setwd("/Users/elisakreiss/Documents/Stanford/overinformativeness/experiments/elisa_paper_relevant/interactiveReferenceGame/results")
source("rscripts/helpers.r")
# runApp("rscripts/app")

d = read.table(file="../../../../models/10_bda_comparison/bdaOutput/MAPnegcostPredictives.csv",sep=",", header=T, quote="")
typ = read.csv(file="/Users/elisakreiss/Documents/Stanford/overinformativeness/experiments/elisa_paper_relevant/norming_comp_object/results/data/meantypicalities.csv")
typ = typ[as.character(typ$Item) == as.character(typ$utterance),]
row.names(typ) = paste(typ$Color,typ$Item)


shinyServer(
  function(input, output) {
    output$map <- renderPlot({
      data <- switch(input$var, 
                     "Percent White" = counties$white,
                     "Percent Black" = counties$black,
                     "Percent Hispanic" = counties$hispanic,
                     "Percent Asian" = counties$asian)
      
      color <- switch(input$var, 
                      "Percent White" = "black",
                      "Percent Black" = "darkgreen",
                      "Percent Hispanic" = "darkorange",
                      "Percent Asian" = "darkviolet")
      
      legend <- switch(input$var, 
                       "Percent White" = "% White",
                       "Percent Black" = "% Black",
                       "Percent Hispanic" = "% Hispanic",
                       "Percent Asian" = "% Asian")
      
      percent_map(var = data, 
                  color = color, 
                  legend.title = legend, 
                  max = input$range[2], 
                  min = input$range[1])
    })
  }
)