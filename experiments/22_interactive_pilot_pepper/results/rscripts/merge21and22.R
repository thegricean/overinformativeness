library(dplyr)
library(ggplot2)
library(bootstrap)
library(lme4)
library(tidyr)

theme_set(theme_bw(18))
setwd("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/experiments/22_interactive_pilot_pepper/results")
setwd("/Users/elisakreiss/Documents/stanford/study/overinformativeness/experiments/22_interactive_pilot_pepper/results")
source("rscripts/helpers.r")

d22 = read.csv(file="data/results-22.csv", header=T)
d21 = read.csv(file="../../21_interactive_pilot/results/data/results-21.csv", header=T)
nrow(d22)
nrow(d21)

production = merge(d21,d22,all=T)
nrow(production)
head(production)
summary(production)

# plot utterance choice proportions with error bars
agr = production %>%
  select(Color,Type,ColorAndType,ColorAndCat,Cat,Other,context) %>%
  gather(Utterance,Mentioned,-context) %>%
  group_by(Utterance,context) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high

ggplot(agr, aes(x=Utterance,y=Probability)) +
  geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~context) +
  theme(axis.text.x=element_text(angle=45,hjust=1,vjust=1))
ggsave("graphs/merged_mentioned_features_by_context_other.pdf",width=10,height=3.5)

# plot utterance choice proportions by typicality
agr = production %>%
  select(Color,Type,ColorAndType,Other,binaryTypicality,context) %>%
  gather(Utterance,Mentioned,-context,-binaryTypicality) %>%
  group_by(Utterance,context,binaryTypicality) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high

ggplot(agr, aes(x=binaryTypicality,y=Probability,color=Utterance,group=Utterance)) +
  geom_point() +
  geom_line() +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~context)
ggsave("graphs/merged_utterance_by_binarytyp.png",width=10,height=3.5)

# plot utterance choice proportions by typicality
agr = production %>%
  select(Color,Type,ColorAndType,Other,NormedTypicality,context) %>%
  gather(Utterance,Mentioned,-context,-NormedTypicality) %>%
  group_by(Utterance,context,NormedTypicality) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high

ggplot(agr, aes(x=NormedTypicality,y=Probability,color=Utterance)) +
  geom_point() +
  geom_smooth(method="lm") +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~context)
ggsave("graphs/merged_utterance_by_conttyp.png",width=10,height=3.5)

# plot utterance choice proportions by typicality with item labels
agr = production %>%
  select(Color,Type,ColorAndType,Other,NormedTypicality,context,nameClickedObj,Item) %>%
  gather(Utterance,Mentioned,-context,-NormedTypicality,-nameClickedObj,-Item) %>%
  group_by(Utterance,context,NormedTypicality,nameClickedObj,Item) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high

ggplot(agr, aes(x=NormedTypicality,y=Probability,color=Utterance)) +
  geom_point() +
  # geom_smooth(method="lm") +
  geom_text(aes(label=nameClickedObj,y=Probability+0.05)) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(context~Item)
ggsave("graphs/merged_utterance_by_conttyp.png",width=10,height=3.5)


# plot utterance choice proportions by typicality
agr = production %>%
  select(Color,Type,ColorAndType,Other,binaryTypicality,context,Half) %>%
  gather(Utterance,Mentioned,-context,-binaryTypicality,-Half) %>%
  group_by(Utterance,context,binaryTypicality,Half) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high

ggplot(agr, aes(x=binaryTypicality,y=Probability,color=Utterance,group=Utterance)) +
  geom_point() +
  geom_line() +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(Half~context)
ggsave("graphs/merged_utterance_by_binarytyp_byhalf.png",width=10,height=3.5)

# condition on whether or not item was mentioned
table(production$context,production$binaryTypicality)
agr = production %>%
  group_by(context,binaryTypicality,ItemMentioned) %>%
  summarise(PropColorMentioned=mean(ColorAndType),ci.low=ci.low(ColorAndType),ci.high=ci.high(ColorAndType))
agr = as.data.frame(agr)
agr$YMin = agr$PropColorMentioned - agr$ci.low
agr$YMax = agr$PropColorMentioned + agr$ci.high

ggplot(agr, aes(x=binaryTypicality,y=PropColorMentioned,color=context)) +
  geom_point() +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) 
ggsave("graphs/merged_distribution_effect_production_byitemmention.png",height=3)
# ggsave("graphs/png/distribution_effect_production_byitemmention.pdf",height=3)

agr = production %>%
  group_by(context,Item,NormedTypicality) %>%
  summarise(PropColorMentioned=mean(ColorAndType),ci.low=ci.low(ColorAndType),ci.high=ci.high(ColorAndType))
agr = as.data.frame(agr)
agr$YMin = agr$PropColorMentioned - agr$ci.low
agr$YMax = agr$PropColorMentioned + agr$ci.high

ggplot(agr, aes(x=NormedTypicality,y=PropColorMentioned,color=Item,linetype=context,group=interaction(context,Item))) +
  geom_point() +
  geom_smooth(method="lm") +
  ylim(c(0,1)) +
  # geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(~context)
ggsave("graphs/merged_production_byitem.png",height=3)




