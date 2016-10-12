library(dplyr)
library(ggplot2)
library(bootstrap)
library(lme4)

theme_set(theme_bw(18))
setwd("/Users/elisakreiss/Documents/stanford/study/overinformativeness/experiments/12_production_calibration/results")
# setwd("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/experiments/12_production_calibration/results")
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

# process typicality data
typicality = droplevels(d[!is.na(d$position_in_exposure),])
typicality <- typicality[,colSums(is.na(typicality))<nrow(typicality)]
typicality$NormedTypicality = typ[paste(typicality$color,typicality$item),]$Typicality
typicality$binaryTypicality = as.factor(ifelse(typicality$NormedTypicality > .5, "typical", "atypical"))

summary(production)
summary(typicality)
typicality$response = as.numeric(as.character(typicality$response))
table(typicality$item,typicality$proportion,typicality$binaryTypicality)

agr = typicality %>%
  group_by(item,color,binaryTypicality) %>%
  summarise(MeanTypicality = mean(response),ci.low=ci.low(response),ci.high=ci.high(response))
agr = as.data.frame(agr)
agr$YMin = agr$MeanTypicality - agr$ci.low
agr$YMax = agr$MeanTypicality + agr$ci.high

ggplot(agr, aes(x=item,y=MeanTypicality,color=color)) +
  geom_point() +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) 
ggsave("graphs/meantypicality_byitem.png")
# ggsave("graphs/meantypicality_byitem.pdf")

table(typicality$item,typicality$binaryTypicality)

# process production data
production = droplevels(d[is.na(d$position_in_exposure),])
production$NormedTypicality = typ[paste(production$target_color,production$target_item),]$Typicality
production$binaryTypicality = as.factor(ifelse(production$NormedTypicality > .5, "typical", "atypical"))
production <- production[,colSums(is.na(production))<nrow(production)]
production$ColorMentioned = ifelse(grepl("green|purple|white|black|brown|purple|violet|yellow|gold|orange|silver|blue|pink|red", production$response, ignore.case = TRUE), T, F)
production$CleanedResponse = gsub("([bB]ananna|[Bb]annna|[Bb]anna|[Bb]annana|[Bb]anan)","banana",as.character(production$response))
production$CleanedResponse = gsub("[Cc]arot","carrot",as.character(production$CleanedResponse))
production$CleanedResponse = gsub("([Tt]omaot|tmatoe)","tomato",as.character(production$CleanedResponse))
production$ItemMentioned = ifelse(grepl("apple|banana|orange|carrot|tomato|pear", production$CleanedResponse, ignore.case = TRUE), T, F)
prop.table(table(production$ColorMentioned,production$ItemMentioned))
# 1% cases of neither type nor color mention (eg, bad location modifiers like "the first one" or taboo-like reference to item like "long skinny vegetable")
production[!production$ColorMentioned & !production$ItemMentioned,]$response
# another 15% where color is mentioned but not type -- this seems to be just 3 subject who are being contrarian
production[production$ColorMentioned & !production$ItemMentioned,c("response")]
table(production[production$ColorMentioned & !production$ItemMentioned,]$target_item,production[production$ColorMentioned & !production$ItemMentioned,]$binaryTypicality)
table(production[production$ColorMentioned & !production$ItemMentioned,]$target_item,production[production$ColorMentioned & !production$ItemMentioned,]$workerid)

# read in the distribtion info 
untyp = unique(typicality[,c("item","color","workerid","proportion")])
row.names(untyp) = paste(untyp$color,untyp$item,untyp$workerid)
production$Proportion = untyp[paste(production$target_color,production$target_item,production$workerid),]$proportion
head(production)

#exclude cases where locative modifiers were used
production = droplevels(production[!(!production$ColorMentioned & !production$ItemMentioned),])

table(production$Proportion,production$condition,production$binaryTypicality)
table(production$Proportion,production$condition,production$binaryTypicality,production$target_item)
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

