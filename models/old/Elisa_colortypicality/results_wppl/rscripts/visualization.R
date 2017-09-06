library(lme4)
library(ggplot2)
library(dplyr)
library(reshape2)
library(magrittr)
library(tidyr)
theme_set(theme_bw())

# setwd("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/models/Elisa_colortypicality/")
setwd("/Users/elisakreiss/Documents/stanford/study/overinformativeness/models/Elisa_colortypicality/")

######### PLOT SPEAKER #########

# d = read.table(paste("results_wppl/data/speaker_exploration_coloronly.csv",sep=""),sep=",")
d = read.table(paste("results_wppl/data/speaker_exploration.csv",sep=""),sep=",")
head(d)
colnames(d) = c("alpha","lengthWeight","color_only_cost","cost_color","cost_type","condition","target","utterance","probability")
str(d)
nrow(d)
d$target = gsub(",","_",d$target)
# d$ActualColorMentioned = as.factor(ifelse((d$utterance == "yellow_banana" & d$condition %in% c("color_competitor_overinformative_typical", "informative_typical", "overinformative_typical") | d$utterance == "blue_banana" & d$condition %in% c("color_competitor_overinformative_atypical", "informative_atypical", "overinformative_atypical")),T,F))
d$ActualColorAndTypeMentioned = ifelse(ifelse(d$utterance==d$target,T,F) & grepl("_",d$utterance),T,F)
d$ID = seq(1,nrow(d))

d = d %>%
  group_by(ID) %>%
  mutate(TargetUtterance = grepl(utterance,target))
d = as.data.frame(d)

colors = c("yellow","orange","red","pink","green","blue","brown","black")
d$ActualColorOnlyMentioned = ifelse(d$TargetUtterance & (d$utterance %in% colors),T,F)
types = c("apple","avocado","banana","carrot","pepper","pear","tomato")
d$ActualTypeOnlyMentioned = ifelse(d$TargetUtterance & (d$utterance %in% types),T,F)


typ = read.table(file="../../experiments/25_object_norming/results/data/meantypicalities.csv",sep=",",header=T)
typ = typ[as.character(typ$Item) == as.character(typ$utterance),]
row.names(typ) = paste(typ$Color,"_",typ$Item,sep="")
head(typ)
nrow(typ)
d$NormedTypicality = typ[paste(d$target),]$Typicality
head(d)





tmp = d[d$alpha == 5 & d$lengthWeight == 5 & d$cost_color == 1 & d$cost_type == 1 & d$color_only_cost == 1,]
tmp = droplevels(tmp[tmp$ActualTypeOnlyMentioned | tmp$ActualColorOnlyMentioned | tmp$ActualColorAndTypeMentioned,])
tmp$Utterance = as.factor(ifelse(tmp$ActualColorOnlyMentioned,"Color",ifelse(tmp$ActualTypeOnlyMentioned,"Type","ColorAndType")))

ggplot(tmp, aes(x=NormedTypicality,y=probability,color=Utterance)) +
  geom_point() +
  geom_smooth(method="lm") +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~condition)
ggsave("results_wppl/graphs/alpha5_length5_costColor1_costType1_colorOnlyCost1.png",width=12,height=9)


tmp = d[d$alpha == 20 & d$lengthWeight == 5 & d$cost_color == 1 & d$cost_type == 1 & d$color_only_cost == 1,]
tmp = droplevels(tmp[tmp$ActualTypeOnlyMentioned | tmp$ActualColorOnlyMentioned | tmp$ActualColorAndTypeMentioned,])
tmp$Utterance = as.factor(ifelse(tmp$ActualColorOnlyMentioned,"Color",ifelse(tmp$ActualTypeOnlyMentioned,"Type","ColorAndType")))

ggplot(tmp, aes(x=NormedTypicality,y=probability,color=Utterance)) +
  geom_point() +
  geom_smooth(method="lm") +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~condition)
ggsave("results_wppl/graphs/alpha20_length5_costColor1_costType1_colorOnlyCost1.png",width=12,height=9)


tmp = d[d$alpha == 30 & d$lengthWeight == 5 & d$cost_color == 1 & d$cost_type == 1 & d$color_only_cost == 1,]
tmp = droplevels(tmp[tmp$ActualTypeOnlyMentioned | tmp$ActualColorOnlyMentioned | tmp$ActualColorAndTypeMentioned,])
tmp$Utterance = as.factor(ifelse(tmp$ActualColorOnlyMentioned,"Color",ifelse(tmp$ActualTypeOnlyMentioned,"Type","ColorAndType")))

ggplot(tmp, aes(x=NormedTypicality,y=probability,color=Utterance)) +
  geom_point() +
  geom_smooth(method="lm") +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~condition)
ggsave("results_wppl/graphs/alpha30_length5_costColor1_costType1_colorOnlyCost1.png",width=12,height=9)


tmp = d[d$alpha == 40 & d$lengthWeight == 5 & d$cost_color == 1 & d$cost_type == 1 & d$color_only_cost == 1,]
tmp = droplevels(tmp[tmp$ActualTypeOnlyMentioned | tmp$ActualColorOnlyMentioned | tmp$ActualColorAndTypeMentioned,])
tmp$Utterance = as.factor(ifelse(tmp$ActualColorOnlyMentioned,"Color",ifelse(tmp$ActualTypeOnlyMentioned,"Type","ColorAndType")))

ggplot(tmp, aes(x=NormedTypicality,y=probability,color=Utterance)) +
  geom_point() +
  geom_smooth(method="lm") +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~condition)
ggsave("results_wppl/graphs/alpha40_length5_costColor1_costType1_colorOnlyCost1.png",width=12,height=9)


tmp = d[d$alpha == 50 & d$lengthWeight == 5 & d$cost_color == 1 & d$cost_type == 1 & d$color_only_cost == 1,]
tmp = droplevels(tmp[tmp$ActualTypeOnlyMentioned | tmp$ActualColorOnlyMentioned | tmp$ActualColorAndTypeMentioned,])
tmp$Utterance = as.factor(ifelse(tmp$ActualColorOnlyMentioned,"Color",ifelse(tmp$ActualTypeOnlyMentioned,"Type","ColorAndType")))

ggplot(tmp, aes(x=NormedTypicality,y=probability,color=Utterance)) +
  geom_point() +
  geom_smooth(method="lm") +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~condition)
ggsave("results_wppl/graphs/alpha50_length5_costColor1_costType1_colorOnlyCost1.png",width=12,height=9)


tmp = d[d$alpha == 20 & d$lengthWeight == 5 & d$cost_color == .5 & d$cost_type == 1 & d$color_only_cost == 1,]
tmp = droplevels(tmp[tmp$ActualTypeOnlyMentioned | tmp$ActualColorOnlyMentioned | tmp$ActualColorAndTypeMentioned,])
tmp$Utterance = as.factor(ifelse(tmp$ActualColorOnlyMentioned,"Color",ifelse(tmp$ActualTypeOnlyMentioned,"Type","ColorAndType")))

ggplot(tmp, aes(x=NormedTypicality,y=probability,color=Utterance)) +
  geom_point() +
  geom_smooth(method="lm") +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~condition)
ggsave("results_wppl/graphs/alpha20_length5_costColor05_costType1_colorOnlyCost1.png",width=12,height=9)


tmp = d[d$alpha == 20 & d$lengthWeight == 5 & d$cost_color == 2 & d$cost_type == 1 & d$color_only_cost == 1,]
tmp = droplevels(tmp[tmp$ActualTypeOnlyMentioned | tmp$ActualColorOnlyMentioned | tmp$ActualColorAndTypeMentioned,])
tmp$Utterance = as.factor(ifelse(tmp$ActualColorOnlyMentioned,"Color",ifelse(tmp$ActualTypeOnlyMentioned,"Type","ColorAndType")))

ggplot(tmp, aes(x=NormedTypicality,y=probability,color=Utterance)) +
  geom_point() +
  geom_smooth(method="lm") +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~condition)
ggsave("results_wppl/graphs/alpha20_length5_costColor2_costType1_colorOnlyCost1.png",width=12,height=9)


tmp = d[d$alpha == 20 & d$lengthWeight == 5 & d$cost_color == 1 & d$cost_type == .5 & d$color_only_cost == 1,]
tmp = droplevels(tmp[tmp$ActualTypeOnlyMentioned | tmp$ActualColorOnlyMentioned | tmp$ActualColorAndTypeMentioned,])
tmp$Utterance = as.factor(ifelse(tmp$ActualColorOnlyMentioned,"Color",ifelse(tmp$ActualTypeOnlyMentioned,"Type","ColorAndType")))

ggplot(tmp, aes(x=NormedTypicality,y=probability,color=Utterance)) +
  geom_point() +
  geom_smooth(method="lm") +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~condition)
ggsave("results_wppl/graphs/alpha20_length5_costColor1_costType05_colorOnlyCost1.png",width=12,height=9)


tmp = d[d$alpha == 20 & d$lengthWeight == 5 & d$cost_color == 1 & d$cost_type == 1 & d$color_only_cost == 0,]
tmp = droplevels(tmp[tmp$ActualTypeOnlyMentioned | tmp$ActualColorOnlyMentioned | tmp$ActualColorAndTypeMentioned,])
tmp$Utterance = as.factor(ifelse(tmp$ActualColorOnlyMentioned,"Color",ifelse(tmp$ActualTypeOnlyMentioned,"Type","ColorAndType")))

ggplot(tmp, aes(x=NormedTypicality,y=probability,color=Utterance)) +
  geom_point() +
  geom_smooth(method="lm") +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~condition)
ggsave("results_wppl/graphs/alpha20_length5_costColor1_costType1_colorOnlyCost0.png",width=12,height=9)


tmp = d[d$alpha == 20 & d$lengthWeight == 5 & d$cost_color == 1 & d$cost_type == 1 & d$color_only_cost == .5,]
tmp = droplevels(tmp[tmp$ActualTypeOnlyMentioned | tmp$ActualColorOnlyMentioned | tmp$ActualColorAndTypeMentioned,])
tmp$Utterance = as.factor(ifelse(tmp$ActualColorOnlyMentioned,"Color",ifelse(tmp$ActualTypeOnlyMentioned,"Type","ColorAndType")))

ggplot(tmp, aes(x=NormedTypicality,y=probability,color=Utterance)) +
  geom_point() +
  geom_smooth(method="lm") +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~condition)
ggsave("results_wppl/graphs/alpha20_length5_costColor1_costType1_colorOnlyCost05.png",width=12,height=9)


tmp = d[d$alpha == 20 & d$lengthWeight == 5 & d$cost_color == 1 & d$cost_type == 1 & d$color_only_cost == 2,]
tmp = droplevels(tmp[tmp$ActualTypeOnlyMentioned | tmp$ActualColorOnlyMentioned | tmp$ActualColorAndTypeMentioned,])
tmp$Utterance = as.factor(ifelse(tmp$ActualColorOnlyMentioned,"Color",ifelse(tmp$ActualTypeOnlyMentioned,"Type","ColorAndType")))

ggplot(tmp, aes(x=NormedTypicality,y=probability,color=Utterance)) +
  geom_point() +
  geom_smooth(method="lm") +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~condition)
ggsave("results_wppl/graphs/alpha20_length5_costColor1_costType1_colorOnlyCost2.png",width=12,height=9)



####

tmp = d[d$alpha == 30 & d$lengthWeight == 5 & d$cost_color == .5 & d$cost_type == 1 & d$color_only_cost == 1,]
tmp = droplevels(tmp[tmp$ActualTypeOnlyMentioned | tmp$ActualColorOnlyMentioned | tmp$ActualColorAndTypeMentioned,])
tmp$Utterance = as.factor(ifelse(tmp$ActualColorOnlyMentioned,"Color",ifelse(tmp$ActualTypeOnlyMentioned,"Type","ColorAndType")))

ggplot(tmp, aes(x=NormedTypicality,y=probability,color=Utterance)) +
  geom_point() +
  geom_smooth(method="lm") +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~condition)
ggsave("results_wppl/graphs/alpha30_length5_costColor05_costType1_colorOnlyCost1.png",width=12,height=9)


tmp = d[d$alpha == 30 & d$lengthWeight == 5 & d$cost_color == 2 & d$cost_type == 1 & d$color_only_cost == 1,]
tmp = droplevels(tmp[tmp$ActualTypeOnlyMentioned | tmp$ActualColorOnlyMentioned | tmp$ActualColorAndTypeMentioned,])
tmp$Utterance = as.factor(ifelse(tmp$ActualColorOnlyMentioned,"Color",ifelse(tmp$ActualTypeOnlyMentioned,"Type","ColorAndType")))

ggplot(tmp, aes(x=NormedTypicality,y=probability,color=Utterance)) +
  geom_point() +
  geom_smooth(method="lm") +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~condition)
ggsave("results_wppl/graphs/alpha30_length5_costColor2_costType1_colorOnlyCost1.png",width=12,height=9)


tmp = d[d$alpha == 20 & d$lengthWeight == 5 & d$cost_color == 1 & d$cost_type == .5 & d$color_only_cost == 1,]
tmp = droplevels(tmp[tmp$ActualTypeOnlyMentioned | tmp$ActualColorOnlyMentioned | tmp$ActualColorAndTypeMentioned,])
tmp$Utterance = as.factor(ifelse(tmp$ActualColorOnlyMentioned,"Color",ifelse(tmp$ActualTypeOnlyMentioned,"Type","ColorAndType")))

ggplot(tmp, aes(x=NormedTypicality,y=probability,color=Utterance)) +
  geom_point() +
  geom_smooth(method="lm") +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~condition)
ggsave("results_wppl/graphs/alpha20_length5_costColor1_costType05_colorOnlyCost1.png",width=12,height=9)


tmp = d[d$alpha == 30 & d$lengthWeight == 5 & d$cost_color == 1 & d$cost_type == 1 & d$color_only_cost == 0,]
tmp = droplevels(tmp[tmp$ActualTypeOnlyMentioned | tmp$ActualColorOnlyMentioned | tmp$ActualColorAndTypeMentioned,])
tmp$Utterance = as.factor(ifelse(tmp$ActualColorOnlyMentioned,"Color",ifelse(tmp$ActualTypeOnlyMentioned,"Type","ColorAndType")))

ggplot(tmp, aes(x=NormedTypicality,y=probability,color=Utterance)) +
  geom_point() +
  geom_smooth(method="lm") +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~condition)
ggsave("results_wppl/graphs/alpha30_length5_costColor1_costType1_colorOnlyCost0.png",width=12,height=9)


tmp = d[d$alpha == 30 & d$lengthWeight == 5 & d$cost_color == 1 & d$cost_type == 1 & d$color_only_cost == .5,]
tmp = droplevels(tmp[tmp$ActualTypeOnlyMentioned | tmp$ActualColorOnlyMentioned | tmp$ActualColorAndTypeMentioned,])
tmp$Utterance = as.factor(ifelse(tmp$ActualColorOnlyMentioned,"Color",ifelse(tmp$ActualTypeOnlyMentioned,"Type","ColorAndType")))

ggplot(tmp, aes(x=NormedTypicality,y=probability,color=Utterance)) +
  geom_point() +
  geom_smooth(method="lm") +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~condition)
ggsave("results_wppl/graphs/alpha30_length5_costColor1_costType1_colorOnlyCost05.png",width=12,height=9)


tmp = d[d$alpha == 30 & d$lengthWeight == 5 & d$cost_color == 1 & d$cost_type == 1 & d$color_only_cost == 2,]
tmp = droplevels(tmp[tmp$ActualTypeOnlyMentioned | tmp$ActualColorOnlyMentioned | tmp$ActualColorAndTypeMentioned,])
tmp$Utterance = as.factor(ifelse(tmp$ActualColorOnlyMentioned,"Color",ifelse(tmp$ActualTypeOnlyMentioned,"Type","ColorAndType")))

ggplot(tmp, aes(x=NormedTypicality,y=probability,color=Utterance)) +
  geom_point() +
  geom_smooth(method="lm") +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~condition)
ggsave("results_wppl/graphs/alpha30_length5_costColor1_costType1_colorOnlyCost2.png",width=12,height=9)

















# # alpha variation for color and type mention
# 
# tmp = d[d$lengthWeight == 5 & d$cost_color == 1 & d$cost_type == 1,]
# nrow(tmp)
# tmp$type = "model"
# 
# str(tmp)
# str(emp)
# toplot = merge(emp,tmp,all=T,by=c("condition","type","probability"))
# toplot
# nrow(toplot)
# toplot = toplot[(toplot$ActualColorAndTypeMentioned == T | toplot$type == "data"),]
# nrow(toplot)
# toplot$Condition = factor(x=toplot$condition,levels=c("informative_atypical", "informative_midtypical", "informative_typical", "overinformative_atypical", "overinformative_midtypical", "overinformative_typical", "color_competitor_overinformative_atypical", "color_competitor_overinformative_midtypical", "color_competitor_overinformative_typical", "color_competitor_informative_atypical", "color_competitor_informative_midtypical", "color_competitor_informative_typical"))
# toplot$AlphaType  = paste(toplot$alpha,toplot$type)
# 
# ggplot(toplot, aes(x=Condition,y=probability,color=AlphaType, group=AlphaType)) +
#   geom_point() +
#   geom_line() +
#   theme(axis.text.x = element_text(angle=45,hjust=1,vjust=1))
# ggsave("results_wppl/graphs/alpha_variation.png", height=6)
# 
# # color cost variation for color and type mention
# 
# tmp = d[d$alpha == 10 & d$lengthWeight == 5 & d$cost_type == 1,]
# nrow(tmp)
# tmp$type = "model"
# 
# str(tmp)
# str(emp)
# toplot = merge(emp,tmp,all=T,by=c("condition","type","probability"))
# toplot
# nrow(toplot)
# toplot = toplot[(toplot$ActualColorAndTypeMentioned == T | toplot$type == "data"),]
# nrow(toplot)
# toplot$Condition = factor(x=toplot$condition,levels=c("informative_atypical", "informative_midtypical", "informative_typical", "overinformative_atypical", "overinformative_midtypical", "overinformative_typical", "color_competitor_overinformative_atypical", "color_competitor_overinformative_midtypical", "color_competitor_overinformative_typical", "color_competitor_informative_atypical", "color_competitor_informative_midtypical", "color_competitor_informative_typical"))
# toplot$ColorCostType  = paste(toplot$cost_color,toplot$type)
# 
# ggplot(toplot, aes(x=Condition,y=probability,color=ColorCostType, group=ColorCostType)) +
#   geom_point() +
#   geom_line() +
#   theme(axis.text.x = element_text(angle=45,hjust=1,vjust=1))
# ggsave("results_wppl/graphs/cost_color_variation.png", height=6)
# 
# # type cost variation for color and type mention
# 
# tmp = d[d$alpha == 10 & d$lengthWeight == 5 & d$cost_color == 1,]
# nrow(tmp)
# tmp$type = "model"
# 
# str(tmp)
# str(emp)
# toplot = merge(emp,tmp,all=T,by=c("condition","type","probability"))
# toplot
# nrow(toplot)
# toplot = toplot[(toplot$ActualColorAndTypeMentioned == T | toplot$type == "data"),]
# nrow(toplot)
# toplot$Condition = factor(x=toplot$condition,levels=c("informative_atypical", "informative_midtypical", "informative_typical", "overinformative_atypical", "overinformative_midtypical", "overinformative_typical", "color_competitor_overinformative_atypical", "color_competitor_overinformative_midtypical", "color_competitor_overinformative_typical", "color_competitor_informative_atypical", "color_competitor_informative_midtypical", "color_competitor_informative_typical"))
# toplot$TypeCostType  = paste(toplot$cost_type,toplot$type)
# 
# ggplot(toplot, aes(x=Condition,y=probability,color=TypeCostType, group=TypeCostType)) +
#   geom_point() +
#   geom_line() +
#   theme(axis.text.x = element_text(angle=45,hjust=1,vjust=1))
# ggsave("results_wppl/graphs/cost_type_variation.png", height=6)
# 
# 
# 
# 
# 
# # alpha variation for type-only mention
# 
# tmp = d[d$lengthWeight == 5 & d$cost_color == 1 & d$cost_type == 1,]
# nrow(tmp)
# tmp$type = "model"
# 
# str(tmp)
# str(emp)
# toplot = merge(emp,tmp,all=T,by=c("condition","type","probability"))
# toplot
# nrow(toplot)
# toplot = toplot[(toplot$ActualTypeOnlyMentioned == T | toplot$type == "data"),]
# nrow(toplot)
# toplot$Condition = factor(x=toplot$condition,levels=c("informative_atypical", "informative_midtypical", "informative_typical", "overinformative_atypical", "overinformative_midtypical", "overinformative_typical", "color_competitor_overinformative_atypical", "color_competitor_overinformative_midtypical", "color_competitor_overinformative_typical", "color_competitor_informative_atypical", "color_competitor_informative_midtypical", "color_competitor_informative_typical"))
# toplot$AlphaType  = paste(toplot$alpha,toplot$type)
# 
# ggplot(toplot, aes(x=Condition,y=probability,color=AlphaType, group=AlphaType)) +
#   geom_point() +
#   geom_line() +
#   theme(axis.text.x = element_text(angle=45,hjust=1,vjust=1))
# ggsave("results_wppl/graphs/alpha_variation.png", height=6)
# 
# # color cost variation for type-only mention
# 
# tmp = d[d$alpha == 10 & d$lengthWeight == 5 & d$cost_type == 1,]
# nrow(tmp)
# tmp$type = "model"
# 
# str(tmp)
# str(emp)
# toplot = merge(emp,tmp,all=T,by=c("condition","type","probability"))
# toplot
# nrow(toplot)
# toplot = toplot[(toplot$ActualTypeOnlyMentioned == T | toplot$type == "data"),]
# nrow(toplot)
# toplot$Condition = factor(x=toplot$condition,levels=c("informative_atypical", "informative_midtypical", "informative_typical", "overinformative_atypical", "overinformative_midtypical", "overinformative_typical", "color_competitor_overinformative_atypical", "color_competitor_overinformative_midtypical", "color_competitor_overinformative_typical", "color_competitor_informative_atypical", "color_competitor_informative_midtypical", "color_competitor_informative_typical"))
# toplot$ColorCostType  = paste(toplot$cost_color,toplot$type)
# 
# ggplot(toplot, aes(x=Condition,y=probability,color=ColorCostType, group=ColorCostType)) +
#   geom_point() +
#   geom_line() +
#   theme(axis.text.x = element_text(angle=45,hjust=1,vjust=1))
# ggsave("results_wppl/graphs/cost_color_variation.png", height=6)
# 
# # type cost variation for type-only mention
# 
# tmp = d[d$alpha == 10 & d$lengthWeight == 5 & d$cost_color == 1,]
# nrow(tmp)
# tmp$type = "model"
# 
# str(tmp)
# str(emp)
# toplot = merge(emp,tmp,all=T,by=c("condition","type","probability"))
# toplot
# nrow(toplot)
# toplot = toplot[(toplot$ActualTypeOnlyMentioned == T | toplot$type == "data"),]
# nrow(toplot)
# toplot$Condition = factor(x=toplot$condition,levels=c("informative_atypical", "informative_midtypical", "informative_typical", "overinformative_atypical", "overinformative_midtypical", "overinformative_typical", "color_competitor_overinformative_atypical", "color_competitor_overinformative_midtypical", "color_competitor_overinformative_typical", "color_competitor_informative_atypical", "color_competitor_informative_midtypical", "color_competitor_informative_typical"))
# toplot$TypeCostType  = paste(toplot$cost_type,toplot$type)
# 
# ggplot(toplot, aes(x=Condition,y=probability,color=TypeCostType, group=TypeCostType)) +
#   geom_point() +
#   geom_line() +
#   theme(axis.text.x = element_text(angle=45,hjust=1,vjust=1))
# ggsave("results_wppl/graphs/cost_type_variation.png", height=6)
# 
# 
# 
# 
# 
# 
# # alpha variation for color-only mention
# 
# tmp = d[d$lengthWeight == 5 & d$cost_color == 1 & d$cost_type == 1,]
# nrow(tmp)
# tmp$type = "model"
# 
# str(tmp)
# str(emp)
# toplot = merge(emp,tmp,all=T,by=c("condition","type","probability"))
# toplot
# nrow(toplot)
# toplot = toplot[(toplot$ActualColorOnlyMentioned == T | toplot$type == "data"),]
# nrow(toplot)
# toplot$Condition = factor(x=toplot$condition,levels=c("informative_atypical", "informative_midtypical", "informative_typical", "overinformative_atypical", "overinformative_midtypical", "overinformative_typical", "color_competitor_overinformative_atypical", "color_competitor_overinformative_midtypical", "color_competitor_overinformative_typical", "color_competitor_informative_atypical", "color_competitor_informative_midtypical", "color_competitor_informative_typical"))
# toplot$AlphaType  = paste(toplot$alpha,toplot$type)
# 
# ggplot(toplot, aes(x=Condition,y=probability,color=AlphaType, group=AlphaType)) +
#   geom_point() +
#   geom_line() +
#   theme(axis.text.x = element_text(angle=45,hjust=1,vjust=1))
# ggsave("results_wppl/graphs/alpha_variation.png", height=6)
# 
# # color cost variation for color-only mention
# 
# tmp = d[d$alpha == 10 & d$lengthWeight == 5 & d$cost_type == 1,]
# nrow(tmp)
# tmp$type = "model"
# 
# str(tmp)
# str(emp)
# toplot = merge(emp,tmp,all=T,by=c("condition","type","probability"))
# toplot
# nrow(toplot)
# toplot = toplot[(toplot$ActualColorOnlyMentioned == T | toplot$type == "data"),]
# nrow(toplot)
# toplot$Condition = factor(x=toplot$condition,levels=c("informative_atypical", "informative_midtypical", "informative_typical", "overinformative_atypical", "overinformative_midtypical", "overinformative_typical", "color_competitor_overinformative_atypical", "color_competitor_overinformative_midtypical", "color_competitor_overinformative_typical", "color_competitor_informative_atypical", "color_competitor_informative_midtypical", "color_competitor_informative_typical"))
# toplot$ColorCostType  = paste(toplot$cost_color,toplot$type)
# 
# ggplot(toplot, aes(x=Condition,y=probability,color=ColorCostType, group=ColorCostType)) +
#   geom_point() +
#   geom_line() +
#   theme(axis.text.x = element_text(angle=45,hjust=1,vjust=1))
# ggsave("results_wppl/graphs/cost_color_variation.png", height=6)
# 
# # type cost variation for color-only mention
# 
# tmp = d[d$alpha == 10 & d$lengthWeight == 5 & d$cost_color == 1,]
# nrow(tmp)
# tmp$type = "model"
# 
# str(tmp)
# str(emp)
# toplot = merge(emp,tmp,all=T,by=c("condition","type","probability"))
# toplot
# nrow(toplot)
# toplot = toplot[(toplot$ActualColorOnlyMentioned == T | toplot$type == "data"),]
# nrow(toplot)
# toplot$Condition = factor(x=toplot$condition,levels=c("informative_atypical", "informative_midtypical", "informative_typical", "overinformative_atypical", "overinformative_midtypical", "overinformative_typical", "color_competitor_overinformative_atypical", "color_competitor_overinformative_midtypical", "color_competitor_overinformative_typical", "color_competitor_informative_atypical", "color_competitor_informative_midtypical", "color_competitor_informative_typical"))
# toplot$TypeCostType  = paste(toplot$cost_type,toplot$type)
# 
# ggplot(toplot, aes(x=Condition,y=probability,color=TypeCostType, group=TypeCostType)) +
#   geom_point() +
#   geom_line() +
#   theme(axis.text.x = element_text(angle=45,hjust=1,vjust=1))
# ggsave("results_wppl/graphs/cost_type_variation.png", height=6)