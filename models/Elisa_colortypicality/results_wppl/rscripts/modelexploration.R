library(lme4)
library(ggplot2)
library(dplyr)
library(reshape2)
library(magrittr)
# library(tidyr)

# setwd("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/Elisa_colortypicality/")
setwd("/Users/elisakreiss/Documents/stanford/study/overinformativeness/models/Elisa_colortypicality/")

######### PLOT LISTENER #########

dlistener = read.table(paste("results_wppl/data/listener_exploration.csv",sep=""),sep=",")

# fix headers:
colnames(dlistener) = c("alpha","lengthWeight","u_banana_o_yellow_banana","u_banana_o_blue_banana","u_cup_o_yellow_cup","u_cup_o_blue_cup","u_yellow_banana_o_yellow_banana","u_blue_banana_o_blue_banana","u_yellow_cup_o_yellow_cup","u_blue_cup_o_blue_cup","u_apple_o_yellow_apple","u_apple_o_blue_apple","u_yellow_apple_o_yellow_apple","u_blue_apple_o_blue_apple","cost_color","cost_type","utterance","object","probability")
head(dlistener)
summary(dlistener)

bananatestplot = dlistener[dlistener$utterance %in% c("banana","yellow_banana"),]
summary(bananatestplot)
nrow(bananatestplot)

bananatestplot = unique(bananatestplot[,c("u_banana_o_yellow_banana","u_banana_o_blue_banana","u_cup_o_yellow_cup","u_cup_o_blue_cup","u_yellow_banana_o_yellow_banana","u_blue_banana_o_blue_banana","u_yellow_cup_o_yellow_cup","u_blue_cup_o_blue_cup","u_apple_o_yellow_apple","u_apple_o_blue_apple","u_yellow_apple_o_yellow_apple","u_blue_apple_o_blue_apple","cost_color","cost_type","utterance","object","probability")])
head(bananatestplot)

ggplot(bananatestplot,aes(x=object,y=probability,color=as.factor(u_banana_o_yellow_banana),group=interaction(u_banana_o_yellow_banana,u_yellow_banana_o_yellow_banana,u_blue_banana_o_blue_banana),shape=as.factor(u_blue_banana_o_blue_banana),linetype=as.factor(u_yellow_banana_o_yellow_banana))) +
  geom_point() +
  geom_line() +
  facet_grid(utterance~u_banana_o_blue_banana) +
  theme(axis.text.x = element_text(angle=45,hjust=1,vjust=1))
