library(lme4)
library(ggplot2)
library(dplyr)
library(reshape2)
library(magrittr)
# library(tidyr)
theme_set(theme_bw())

# setwd("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/Elisa_colortypicality/")
setwd("/Users/elisakreiss/Documents/stanford/study/overinformativeness/models/Elisa_colortypicality/")

######### PLOT LISTENER #########

dlistener = read.table(paste("results_wppl/data/listener_exploration.csv",sep=""),sep=",")

# fix headers:
colnames(dlistener) = c("alpha","lengthWeight","by", "bb", "cy", "cb", "ay", "ab", "cost_color","cost_type","condition","utterance","object","probability")
head(dlistener)
summary(dlistener)
dlistener$InfoCond = as.factor(ifelse(dlistener$condition %in% c("informative_typical","informative_atypical"),"informative",ifelse(dlistener$condition %in% c("overinformative_atypical","overinformative_typical"),"overinformative","overinformative-cc")))
dlistener$Typicality = as.factor(ifelse(dlistener$condition %in% c("informative_typical","overinformative_typical","color_competitor_overinformative_typical"),"typical","atypical"))
dlistener$IntendedTarget = as.factor(ifelse(dlistener$Typicality == "typical", "yellow,banana","blue,banana"))
dlistener$TargetObject = as.character(dlistener$object) == as.character(dlistener$IntendedTarget)

# bananatestplot = dlistener[dlistener$utterance %in% c("banana","yellow_banana"),]
# summary(bananatestplot)
# nrow(bananatestplot)

# bananatestplot = unique(bananatestplot[,c("u_banana_o_yellow_banana","u_banana_o_blue_banana","u_cup_o_yellow_cup","u_cup_o_blue_cup","u_yellow_banana_o_yellow_banana","u_blue_banana_o_blue_banana","u_yellow_cup_o_yellow_cup","u_blue_cup_o_blue_cup","u_apple_o_yellow_apple","u_apple_o_blue_apple","u_yellow_apple_o_yellow_apple","u_blue_apple_o_blue_apple","cost_color","cost_type","utterance","object","probability")])
# head(bananatestplot)

tmp = dlistener[dlistener$alpha == 10 & dlistener$lengthWeight == 5 & dlistener$cost_type == 1 & dlistener$cost_color == 1,] %>%
  group_by(TargetObject,Typicality,utterance,InfoCond) %>%
  summarise(probability=sum(probability)) %>%
  filter(TargetObject)
nrow(tmp)
summary(tmp)

ggplot(tmp,aes(x=utterance,y=probability,color=Typicality,group=Typicality)) +
  geom_point() +
  geom_line() +
  facet_wrap(~InfoCond) +
  scale_color_manual(values=c("blue","gold")) +
  theme(axis.text.x = element_text(angle=45,hjust=1,vjust=1))

# heatmap
ggplot(bananatestplot,aes(x=u_banana_o_yellow_banana,y=u_banana_o_blue_banana,color=probability)) +
  geom_point(size=8,shape=15) +
  scale_colour_gradientn(colors=rev(rainbow(4,start=0,end=4/6)),name="Probability\nof object") +
  xlab("Typicality of 'banana' for yellow banana") +
  ylab("Typicality of 'banana' for blue banana") +
  facet_grid(utterance~object) 




