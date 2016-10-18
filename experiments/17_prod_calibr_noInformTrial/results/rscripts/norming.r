library(dplyr)
library(ggplot2)
library(bootstrap)
library(lme4)

theme_set(theme_bw(18))
setwd("/Users/elisakreiss/Documents/stanford/study/overinformativeness/experiments/17_prod_calibr_noInformTrial/results")
# setwd("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/experiments/17_prod_calibr_noInformTrial/results")
source("rscripts/helpers.r")

d = read.table(file="data/norming.csv",sep=",", header=T)#, quote="")
head(d)
nrow(d)
summary(d)
totalnrow = nrow(d)
d$Trial = d$slide_number_in_experiment - 1
length(unique(d$workerid))

typ = read.table(file="../../11_color_norming/results/data/meantypicalities.csv",sep=",",header=T)
row.names(typ) = paste(typ$Color,typ$Item)
head(typ)

# look at turker comments
unique(d$comments)

ggplot(d, aes(rt)) +
  geom_histogram() +
  scale_x_continuous(limits=c(0,15000))

ggplot(d, aes(log(rt))) +
  geom_histogram() 

summary(d$Answer.time_in_minutes)
ggplot(d, aes(Answer.time_in_minutes)) +
  geom_histogram()

ggplot(d, aes(gender)) +
  stat_count()

ggplot(d, aes(asses)) +
  stat_count()

ggplot(d, aes(age)) +
  geom_histogram()
table(d$age)

ggplot(d, aes(education)) +
  stat_count()

ggplot(d, aes(language)) +
  stat_count()

ggplot(d, aes(enjoyment)) +
  stat_count()

# process production data
production = d
production$NormedTypicality = typ[paste(production$target_color,production$target_item),]$Typicality
production$binaryTypicality = as.factor(ifelse(production$NormedTypicality > .5, "typical", "atypical"))
production <- production[,colSums(is.na(production))<nrow(production)]
production$ColorMentioned = ifelse(grepl("green|purple|white|black|brown|purple|violet|yellow|gold|orange|silver|blue|pink|red", production$response, ignore.case = TRUE), T, F)
production$CleanedResponse = gsub("([bB]ananna|[Bb]annna|[Bb]anna|[Bb]annana|[Bb]anan)","banana",as.character(production$response))
production$CleanedResponse = gsub("[Cc]arot|[Cc]arrrot","carrot",as.character(production$CleanedResponse))
production$CleanedResponse = gsub("([Tt]omaot|tmatoe|tamato)","tomato",as.character(production$CleanedResponse))
production$CleanedResponse = gsub("[Aa]ppe","apple",as.character(production$CleanedResponse))
production$ItemMentioned = ifelse(grepl("apple|banana|orange|carrot|tomato|pear|pepper", production$CleanedResponse, ignore.case = TRUE), T, F)
prop.table(table(production$ColorMentioned,production$ItemMentioned))
# 1% cases of neither type nor color mention (eg, bad location modifiers like "the first one" or taboo-like reference to item like "long skinny vegetable")
production[!production$ColorMentioned & !production$ItemMentioned,]$response
production[!production$ColorMentioned & !production$ItemMentioned,]$target_item
production[!production$ColorMentioned & !production$ItemMentioned,]$target_color
# another 15% where color is mentioned but not type -- this seems to be just 3 subject who are being contrarian
production[production$ColorMentioned & !production$ItemMentioned,c("response")]
table(production[production$ColorMentioned & !production$ItemMentioned,]$target_item,production[production$ColorMentioned & !production$ItemMentioned,]$binaryTypicality)
table(production[production$ColorMentioned & !production$ItemMentioned,]$target_item,production[production$ColorMentioned & !production$ItemMentioned,]$workerid)

#exclude cases where locative modifiers were used
#production = droplevels(production[!(!production$ColorMentioned & !production$ItemMentioned),])

table(production$condition,production$binaryTypicality)
table(production$condition,production$binaryTypicality,production$target_item)
agr = production %>%
  group_by(condition,binaryTypicality) %>%
  summarise(PropColorMentioned=mean(ColorMentioned),ci.low=ci.low(ColorMentioned),ci.high=ci.high(ColorMentioned))
agr = as.data.frame(agr)
agr$YMin = agr$PropColorMentioned - agr$ci.low
agr$YMax = agr$PropColorMentioned + agr$ci.high

ggplot(agr, aes(x=binaryTypicality,y=PropColorMentioned,color=condition)) +
  geom_point() +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25)
ggsave("graphs/distribution_effect_production.png",height=3.5)
# ggsave("graphs/distribution_effect_production.pdf",height=3.5)

# by subject
agr = production %>%
  group_by(condition,binaryTypicality,workerid) %>%
  summarise(PropColorMentioned=mean(ColorMentioned),ci.low=ci.low(ColorMentioned),ci.high=ci.high(ColorMentioned))
agr = as.data.frame(agr)
agr$YMin = agr$PropColorMentioned - agr$ci.low
agr$YMax = agr$PropColorMentioned + agr$ci.high

ggplot(agr, aes(x=binaryTypicality,y=PropColorMentioned,color=condition)) +
  geom_point() +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~workerid)
ggsave("graphs/distribution_effect_production_bysubject.png",height=8.5)
# ggsave("graphs/distribution_effect_production.pdf",height=3.5)

# by trial
production$FirstTrial = ifelse(production$Trial == 3, "first","not-first")
agr = production %>%
  group_by(condition,binaryTypicality,FirstTrial) %>%
  summarise(PropColorMentioned=mean(ColorMentioned),ci.low=ci.low(ColorMentioned),ci.high=ci.high(ColorMentioned))
agr = as.data.frame(agr)
agr$YMin = agr$PropColorMentioned - agr$ci.low
agr$YMax = agr$PropColorMentioned + agr$ci.high

ggplot(agr, aes(x=binaryTypicality,y=PropColorMentioned,color=condition)) +
  geom_point() +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~FirstTrial)
ggsave("graphs/distribution_effect_production_byfirsttrial.png",height=8.5)
# ggsave("graphs/distribution_effect_production.pdf",height=3.5)


# condition on whether or not item was mentioned
table(production$condition,production$binaryTypicality)
agr = production %>%
  group_by(condition,binaryTypicality,ItemMentioned) %>%
  summarise(PropColorMentioned=mean(ColorMentioned),ci.low=ci.low(ColorMentioned),ci.high=ci.high(ColorMentioned))
agr = as.data.frame(agr)
agr$YMin = agr$PropColorMentioned - agr$ci.low
agr$YMax = agr$PropColorMentioned + agr$ci.high

ggplot(agr, aes(x=binaryTypicality,y=PropColorMentioned,color=condition)) +
  geom_point() +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(~ItemMentioned)
ggsave("graphs/distribution_effect_production_byitemmention.png",height=3)
# ggsave("graphs/distribution_effect_production_byitemmention.pdf",height=3)


agr = production %>%
  group_by(condition,target_item,NormedTypicality,ItemMentioned) %>%
  summarise(PropColorMentioned=mean(ColorMentioned),ci.low=ci.low(ColorMentioned),ci.high=ci.high(ColorMentioned))
agr = as.data.frame(agr)
agr$YMin = agr$PropColorMentioned - agr$ci.low
agr$YMax = agr$PropColorMentioned + agr$ci.high

ggplot(agr, aes(x=NormedTypicality,y=PropColorMentioned,color=target_item,linetype=condition,group=interaction(condition,target_item))) +
  geom_point() +
  geom_line() +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_grid(~ItemMentioned)
ggsave("graphs/production_byitem.png",height=3)
