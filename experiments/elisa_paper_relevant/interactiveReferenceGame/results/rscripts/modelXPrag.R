library(dplyr)
library(ggplot2)
library(bootstrap)
library(lme4)
library(tidyr)

setwd("/Users/elisakreiss/Documents/Stanford/overinformativeness/experiments/elisa_paper_relevant/interactiveReferenceGame/results/rscripts/app_that_works")
source("helpers.R")
theme_set(theme_bw(18))
# runApp("rscripts/app")

df <- read.table(file="data/allDataPredictives.csv",sep=",", header=T,check.names = FALSE)

    
dat <- df[df$alpha == 10 & df$colorCost == 0 & df$typeCost == -1.5 & df$lengthWeight == 0.5 & df$typWeight == 6,]
    
# ggplot(dat, aes(x=Typicality,y=modelPrediction,color=uttType)) +
#   geom_point(size=1) +
#   geom_smooth(method="lm",size=1.3) +
#   #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
#   facet_wrap(~condition) +
#   coord_cartesian(ylim=c(0,1)) +
#   # ylim(0,1) +
#   #green, turquoise, red
#   scale_color_manual(name="Utterance",
#                      breaks=c("typeOnly", "colorOnly", "colorType"),
#                      labels=c("Only Type", "Only Color", "Color + Type"),
#                      values=c("#799938", "#5bc2b7", "#ef6666")) +
#   theme(axis.title=element_text(size=14,colour="#757575")) +
#   theme(axis.title=element_text(size=14,colour="#757575")) +
#   theme(axis.text.x=element_text(size=10,colour="#757575")) +
#   theme(axis.text.y=element_text(size=10,colour="#757575")) +
#   theme(axis.ticks=element_line(size=.25,colour="#757575"), axis.ticks.length=unit(.75,"mm")) +
#   theme(strip.text.x=element_text(size=18,colour="#757575")) +
#   theme(legend.position="top",legend.box="horizontal") +
#   theme(legend.title=element_text(size=15,color="#757575")) +
#   theme(legend.text=element_text(size=12,colour="#757575")) +
#   theme(strip.background=element_rect(colour="#939393",fill="white")) +
#   theme(panel.background=element_rect(colour="#939393"))
# ggsave("/Users/elisakreiss/Documents/Stanford/overinformativeness/experiments/elisa_paper_relevant/interactiveReferenceGame/results/graphs/model/posterXPrag.jpg",width=12,height=9)

ggplot(dat, aes(x=Typicality,y=modelPrediction,color=uttType)) +
  geom_point(size=2) +
  geom_smooth(method="lm",size=2.25) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~condition) +
  coord_cartesian(ylim=c(0,1)) +
  # ylim(0,1) +
  #green, turquoise, red
  scale_color_manual(name="Utterance",
                     breaks=c("typeOnly", "colorOnly", "colorType"),
                     labels=c("Only Type", "Only Color", "Color + Type"),
                     values=c("#799938", "#5bc2b7", "#ef6666")) +
  xlab("Typicality") +
  ylab("Predicted utterance proportion") +
  theme(axis.title=element_text(size=25,colour="#757575")) +
  theme(axis.text.x=element_text(size=20,colour="#757575")) +
  theme(axis.text.y=element_text(size=20,colour="#757575")) +
  theme(axis.ticks=element_line(size=.5,colour="#757575"), axis.ticks.length=unit(1,"mm")) +
  theme(strip.text.x=element_text(size=30,colour="#757575")) +
  theme(legend.position="top") +
  theme(legend.title=element_text(size=25,color="#757575")) +
  theme(legend.text=element_text(size=20,colour="#757575")) +
  theme(strip.background=element_rect(colour="#939393",fill="white")) +
  theme(panel.background=element_rect(colour="#939393"))
ggsave("/Users/elisakreiss/Documents/Stanford/overinformativeness/experiments/elisa_paper_relevant/interactiveReferenceGame/results/graphs/model/posterXPrag.jpg",width=12,height=9)

blue = 0.419
brown = 0.657
yellow = 0.979

dat[dat$condition=="overinformative-cc" & dat$uttType=="colorType" & dat$Typicality==yellow,c("modelPrediction")]

# Correlation plot
ggplot(dat, aes(x=modelPrediction,y=empiricProb)) +
  geom_point(aes(color=condition),size = 3) +
  theme(legend.title=element_text(size=25,color="#757575")) +
  theme(legend.text=element_text(size=20,colour="#757575")) +
  geom_abline() +
  xlab("Model predicted probability") +
  ylab("Empirical Probability") +
  theme(axis.title=element_text(size=25,colour="#757575")) +
  theme(axis.text.x=element_text(size=20,colour="#757575")) +
  theme(axis.text.y=element_text(size=20,colour="#757575")) +
  theme(axis.ticks=element_line(size=.5,colour="#757575"), axis.ticks.length=unit(1,"mm")) +
  coord_cartesian(ylim=c(0,1)) +
  coord_cartesian(xlim=c(0,1)) +
  theme(legend.position="right", aspect.ratio = 1) +
  geom_smooth(method="lm",size=3.25)
ggsave("/Users/elisakreiss/Documents/Stanford/overinformativeness/experiments/elisa_paper_relevant/interactiveReferenceGame/results/graphs/model/posterXPrag_corr.jpg",width=12,height=12)
