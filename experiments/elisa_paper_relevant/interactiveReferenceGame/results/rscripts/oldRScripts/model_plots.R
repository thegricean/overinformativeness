library(dplyr)
library(ggplot2)
library(bootstrap)
library(lme4)
library(tidyr)

theme_set(theme_bw(18))
setwd("/Users/elisakreiss/Documents/Stanford/overinformativeness/experiments/elisa_paper_relevant/interactiveReferenceGame/results")
source("rscripts/helpers.r")

d = read.table(file="../../../../models/10_bda_comparison/bdaOutput/MAPnegcostPredictives.csv",sep=",", header=T, quote="")
nrow(d)
head(d)
summary(d)


# get meantypicalities from previous study
typ = read.csv(file="/Users/elisakreiss/Documents/Stanford/overinformativeness/experiments/elisa_paper_relevant/norming_comp_object/results/data/meantypicalities.csv")
typ = typ[as.character(typ$Item) == as.character(typ$utterance),]
row.names(typ) = paste(typ$Color,typ$Item)
head(typ)
nrow(typ)
summary(typ)

production = d
production$NormedTypicality = typ[paste(production$TargetColor,production$TargetType),]$MeanTypicality
production$binaryTypicality = as.factor(ifelse(production$NormedTypicality > .5, "typical", "atypical"))

#exclude non-target utterances
production = production[as.character(production$value) == as.character(production$TargetColor) | as.character(production$value) == as.character(production$TargetType) | (as.character(production$value) == paste(as.character(production$TargetColor),"_",as.character(production$TargetType),sep="")),]



#better/newer one
production$ColorMentioned = ifelse(grepl("green|pink|yellow|blue|black|orange|red|brown", production$value, ignore.case = TRUE), T, F)
production$ItemMentioned = ifelse(grepl("apple|banana|carrot|tomato|pear|pepper|avocado", production$value, ignore.case = TRUE), T, F)

production$UtteranceType = as.factor(ifelse(production$ItemMentioned & production$ColorMentioned, "color_and_type", ifelse(production$ColorMentioned & !production$ItemMentioned, "color", ifelse(production$ItemMentioned & !production$ColorMentioned, "type", "OTHER"))))

production$Color = ifelse(production$UtteranceType == "color",1,0)
production$ColorAndType = ifelse(production$UtteranceType == "color_and_type",1,0)
production$Type = ifelse(production$UtteranceType == "type",1,0)
production$Other = ifelse(production$UtteranceType == "OTHER",1,0)

production$Item = production$TargetType

# plot histogram of mentioned features by context
agr = production %>%
  select(ColorMentioned,ItemMentioned,condition) %>%
  gather(Feature,Mentioned,-condition)
agr$Feature = gsub("Mentioned","",as.character(agr$Feature))
agr = droplevels(subset(agr,Mentioned == "TRUE"))
head(agr)

ggplot(agr, aes(x=Feature)) +
  stat_count() +
  facet_wrap(~condition)
ggsave("graphs/model_mentioned_features_by_context.png",width=8,height=3.5)

# plot utterance choice proportions with error bars
agr = production %>%
  select(Color,Type,ColorAndType,Other,condition,prob) %>%
  gather(Utterance,Mentioned,-prob,-condition) %>%
  group_by(Utterance,condition) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high

# change order of Utterance column
agr$Utterance <- as.character(agr$Utterance)
agr$Utterance <- factor(agr$Utterance, levels=c("Type", "Color", "ColorAndType", "Other"))

# change context names to have nicer facet labels 
levels(agr$condition) = c("informative","informative\nwith color competitor", "overinformative", "overinformative\nwith color competitor")

ggplot(agr, aes(x=Utterance,y=Probability)) +
  geom_bar(stat="identity",width=.2,fill="orange",colour="orange") +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.15,colour="grey") +
  facet_wrap(~condition) +
  scale_x_discrete(labels=c("Only Type", "Only Color", "Color + Type", "Other")) +
  theme(axis.title=element_text(size=14,colour="#757575")) +
  theme(axis.text.x=element_text(angle=45,hjust=1,vjust=1,size=11,colour="#757575")) +
  theme(axis.text.y=element_text(size=10,colour="#757575")) +
  theme(axis.ticks=element_line(size=.25,colour="#757575"), axis.ticks.length=unit(.75,"mm")) +
  theme(strip.text.x=element_text(size=12,colour="#757575")) +
  theme(strip.background=element_rect(colour="#939393",fill="white")) +
  theme(panel.background=element_rect(colour="#939393"))
ggsave("graphs/model/mentioned_features_by_context_other.png",width=7,height=7)




agr = select(production,UtteranceType,binaryTypicality,condition,prob)
agr = group_by(agr,UtteranceType,condition,binaryTypicality) 

new = select(production,UtteranceType,binaryTypicality,condition)
new = unique(new)

new$summedProb = lapply(1:nrow(new),function(x) sum(agr[agr$UtteranceType == new$UtteranceType[x] & agr$binaryTypicality == new$binaryTypicality[x] & agr$condition == new$condition[x],c("prob")]))
new$numProbs = lapply(1:nrow(new), function(x) nrow(agr[agr$UtteranceType == new$UtteranceType[x] & agr$binaryTypicality == new$binaryTypicality[x] & agr$condition == new$condition[x],]))
new$probs = as.numeric(new$summedProb)/as.numeric(new$numProbs)



# change order of Utterance column
# new$UtteranceType <- as.character(new$UtteranceType)
# new$UtteranceType <- factor(new$UtteranceType, levels=c("Type", "Color", "ColorAndType", "Other"))

# change context names to have nicer facet labels 
levels(new$condition) = c("informative","informative\nwith color competitor", "overinformative", "overinformative\nwith color competitor")

ggplot(new, aes(x=binaryTypicality,y=probs,color=UtteranceType,group=UtteranceType)) +
  geom_point() +
  geom_line() +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~condition) +
  theme(axis.title=element_text(size=14,colour="#757575")) +
  theme(axis.text.x=element_text(size=11,colour="#757575")) +
  theme(axis.text.y=element_text(size=10,colour="#757575")) +
  scale_color_manual(values=c("green", "turquoise", "red")) +
  theme(axis.ticks=element_line(size=.25,colour="#757575"), axis.ticks.length=unit(.75,"mm")) +
  theme(strip.text.x=element_text(size=12,colour="#757575")) +
  theme(legend.title=element_text(size=14,color="#757575")) +
  theme(legend.text=element_text(size=11,colour="#757575")) +
  theme(strip.background=element_rect(colour="#939393",fill="white")) +
  theme(panel.background=element_rect(colour="#939393"))
ggsave("graphs/model/utterance_by_binarytyp.png",width=10,height=6.5)



# plot utterance choice proportions by typicality
agr = select(production,UtteranceType,NormedTypicality,condition,prob)
agr = group_by(agr,UtteranceType,condition,NormedTypicality) 

new = select(production,UtteranceType,NormedTypicality,condition)
new = unique(new)

new$summedProb = lapply(1:nrow(new),function(x) sum(agr[agr$UtteranceType == new$UtteranceType[x] & agr$NormedTypicality == new$NormedTypicality[x] & agr$condition == new$condition[x],c("prob")]))
new$numProbs = lapply(1:nrow(new), function(x) nrow(agr[agr$UtteranceType == new$UtteranceType[x] & agr$NormedTypicality == new$NormedTypicality[x] & agr$condition == new$condition[x],]))
new$probs = as.numeric(new$summedProb)/as.numeric(new$numProbs)

# change order of Utterance column
# agr$Utterance <- as.character(agr$Utterance)
# agr$Utterance <- factor(agr$Utterance, levels=c("Type", "Color", "ColorAndType", "Other"))

# change context names to have nicer facet labels 
levels(new$condition) = c("informative","informative\nwith color competitor", "overinformative", "overinformative\nwith color competitor")

ggplot(new, aes(x=NormedTypicality,y=probs,color=UtteranceType)) +
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
ggsave("graphs/model/utterance_by_conttyp_cut.png",width=12,height=9)

