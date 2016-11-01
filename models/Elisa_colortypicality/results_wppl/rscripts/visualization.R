library(lme4)
library(ggplot2)
library(dplyr)
library(reshape2)
library(magrittr)
library(tidyr)
theme_set(theme_bw())

# setwd("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/Elisa_colortypicality/")
setwd("/Users/elisakreiss/Documents/stanford/study/overinformativeness/models/Elisa_colortypicality/")

# load empirical pilot means
emp = read.csv(file="results_wppl/data/model_output.csv")[1,]
emp = emp %>%
  gather(condition,probability,-type)
emp$probability = emp$probability/100

######### PLOT SPEAKER #########

d = read.table(paste("results_wppl/data/speaker_exploration.csv",sep=""),sep=",")
d = read.table(paste("results_wppl/data/speaker_exploration_coloronly.csv",sep=""),sep=",")
head(d)
colnames(d) = c("alpha","lengthWeight","by", "bb", "cy", "cb", "ay", "ab", "cost_color","cost_type","condition","utterance","probability")
str(d)
d$ActualColorMentioned = as.factor(ifelse((d$utterance == "yellow_banana" & d$condition %in% c("color_competitor_overinformative_typical", "informative_typical", "overinformative_typical") | d$utterance == "blue_banana" & d$condition %in% c("color_competitor_overinformative_atypical", "informative_atypical", "overinformative_atypical")),T,F))

# alpha variation

tmp = d[d$lengthWeight == 5 & d$cost_color == 1 & d$cost_type == 1,]
nrow(tmp)
tmp$type = "model"

str(tmp)
str(emp)
toplot = merge(emp,tmp,all=T,by=c("condition","type","probability"))
toplot
nrow(toplot)
toplot = toplot[(toplot$ActualColorMentioned == T | toplot$type == "data"),]
nrow(toplot)
toplot$Condition = factor(x=toplot$condition,levels=c("informative_atypical", "informative_typical", "overinformative_atypical", "overinformative_typical", "color_competitor_overinformative_atypical", "color_competitor_overinformative_typical"))
toplot$AlphaType  = paste(toplot$alpha,toplot$type)

ggplot(toplot, aes(x=Condition,y=probability,color=AlphaType, group=AlphaType)) +
  geom_point() +
  geom_line() +
  theme(axis.text.x = element_text(angle=45,hjust=1,vjust=1))
ggsave("results_wppl/graphs/alpha_variation.png", height=6)
ggsave("results_wppl/graphs/alpha_variation_coloronly.png", height=6)
ggsave("results_wppl/graphs/alpha_variation_weighted_coloronly.png", height=6)

# color cost variation

tmp = d[d$alpha == 10 & d$lengthWeight == 5 & d$cost_type == 1,]
nrow(tmp)
tmp$type = "model"

str(tmp)
str(emp)
toplot = merge(emp,tmp,all=T,by=c("condition","type","probability"))
toplot
nrow(toplot)
toplot = toplot[(toplot$ActualColorMentioned == T | toplot$type == "data"),]
nrow(toplot)
toplot$Condition = factor(x=toplot$condition,levels=c("informative_atypical", "informative_typical", "overinformative_atypical", "overinformative_typical", "color_competitor_overinformative_atypical", "color_competitor_overinformative_typical"))
toplot$ColorCostType  = paste(toplot$cost_color,toplot$type)

ggplot(toplot, aes(x=Condition,y=probability,color=ColorCostType, group=ColorCostType)) +
  geom_point() +
  geom_line() +
  theme(axis.text.x = element_text(angle=45,hjust=1,vjust=1))
ggsave("results_wppl/graphs/cost_color_variation.png", height=6)
ggsave("results_wppl/graphs/cost_color_variation_coloronly.png", height=6)
ggsave("results_wppl/graphs/cost_color_variation_weighted_coloronly.png", height=6)

# type cost variation

tmp = d[d$alpha == 10 & d$lengthWeight == 5 & d$cost_color == 1,]
nrow(tmp)
tmp$type = "model"

str(tmp)
str(emp)
toplot = merge(emp,tmp,all=T,by=c("condition","type","probability"))
toplot
nrow(toplot)
toplot = toplot[(toplot$ActualColorMentioned == T | toplot$type == "data"),]
nrow(toplot)
toplot$Condition = factor(x=toplot$condition,levels=c("informative_atypical", "informative_typical", "overinformative_atypical", "overinformative_typical", "color_competitor_overinformative_atypical", "color_competitor_overinformative_typical"))
toplot$TypeCostType  = paste(toplot$cost_type,toplot$type)

ggplot(toplot, aes(x=Condition,y=probability,color=TypeCostType, group=TypeCostType)) +
  geom_point() +
  geom_line() +
  theme(axis.text.x = element_text(angle=45,hjust=1,vjust=1))
ggsave("results_wppl/graphs/cost_type_variation.png", height=6)
ggsave("results_wppl/graphs/cost_type_variation_coloronly.png", height=6)
ggsave("results_wppl/graphs/cost_type_variation_weighted_coloronly.png", height=6)


