library(dplyr)
library(ggplot2)
library(bootstrap)
library(lme4)

theme_set(theme_bw(18))
# set working directory 
setwd("/Users/elisakreiss/Documents/stanford/study/overinformativeness/experiments/15_prod_calibr_dtyp_cleverDaxy/results")
# setwd("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/experiments/15_prod_calibr_dtyp_cleverDaxy/results")
source("rscripts/helpers.r")

# import data
d = read.table(file="data/norming.csv",sep=",", header=T)#, quote="")
# get first 6 rows for each column
head(d)
# get number of rows (total)
nrow(d)
summary(d)
totalnrow = nrow(d)
# (slides are programmed to start with 2, so we have to correct for this)
d$Trial = d$slide_number_in_experiment - 1
# number of unique participants
length(unique(d$workerid))

# read in typicality norming file
typ = read.table(file="../../11_color_norming/results/data/meantypicalities.csv",sep=",",header=T)
# rows are not numbered but get names of structure "blue apple"
row.names(typ) = paste(typ$Color,typ$Item)
head(typ)

# look at turker comments
unique(d$comments)

# reaction time (in some weird measurement...?)
ggplot(d, aes(rt)) +
  geom_histogram() +
  scale_x_continuous(limits=c(0,15000))

ggplot(d, aes(log(rt))) +
  geom_histogram() 

# overview on reaction time in minutes
summary(d$Answer.time_in_minutes)
ggplot(d, aes(Answer.time_in_minutes)) +
  geom_histogram()

# gender
ggplot(d, aes(gender)) +
  stat_count()

# assessment how people liked the study - what is the difference to enjoyment?
ggplot(d, aes(asses)) +
  stat_count()

# age
ggplot(d, aes(age)) +
  geom_histogram()
table(d$age)

# education
ggplot(d, aes(education)) +
  stat_count()

# language
ggplot(d, aes(language)) +
  stat_count()

# enjoyment
ggplot(d, aes(enjoyment)) +
  stat_count()

# process typicality data
# store typicality data in nice way in typicality variable (filter na rows,...)
typicality = droplevels(d[!is.na(d$position_in_exposure),])
typicality <- typicality[,colSums(is.na(typicality))<nrow(typicality)] #???
typicality$NormedTypicality = typ[paste(typicality$color,typicality$item),]$Typicality
typicality$binaryTypicality = as.factor(ifelse(typicality$NormedTypicality > .5, "typical", "atypical"))

summary(typicality)
typicality$response = as.numeric(as.character(typicality$response))
table(typicality$item,typicality$binaryTypicality)

head(typicality)
# %>% means "take the result from this and add it to next operation"
# agr = summarise(group_by(typicality,item,color,binaryTypicality),MeanTypicality = mean(response),ci.low=ci.low(response),ci.high=ci.high(response))
# creates "collection of factors?" with columns: item, color, binaryTypicality, ci.low, ci.high
agr = typicality %>%
  group_by(item,color,binaryTypicality) %>%
  summarise(MeanTypicality = mean(response),ci.low=ci.low(response),ci.high=ci.high(response))
agr = as.data.frame(agr)
# add columns YMin and YMax
agr$YMin = agr$MeanTypicality - agr$ci.low
agr$YMax = agr$MeanTypicality + agr$ci.high

# plot mean typicality by item
# data, aes: aesthetics of plot (what goes on axes, and other things (see docs))
ggplot(agr, aes(x=item,y=MeanTypicality,color=color)) +
  geom_point() +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) 
ggsave("graphs/meantypicality_byitem.png")
# ggsave("graphs/meantypicality_byitem.pdf")

table(typicality$item,typicality$binaryTypicality)

# process production data
production = droplevels(d[is.na(d$position_in_exposure),])
# exclude orange because of ambiguity issues
production = production[production$target_item != "orange",]
# add corresponding typicalities from norming study
production$NormedTypicality = typ[paste(production$target_color,production$target_item),]$Typicality
production$binaryTypicality = as.factor(ifelse(production$NormedTypicality > .5, "typical", "atypical"))
production <- production[,colSums(is.na(production))<nrow(production)]
# clean response (correct misspellings) and add those to the 2 new columns ColorMentioned and ItemMentioned
production$CleanedResponse = gsub("[Tt]ellow","yellow",as.character(production$response))
production$ColorMentioned = ifelse(grepl("green|purple|white|black|brown|purple|violet|yellow|gold|orange|silver|blue|pink|red", production$CleanedResponse, ignore.case = TRUE), T, F)
production$CleanedResponse = gsub("([bB]ananna|[Bb]annna|[Bb]anna|[Bb]annana|[Bb]anan)","banana",as.character(production$CleanedResponse))
production$CleanedResponse = gsub("[Cc]arot","carrot",as.character(production$CleanedResponse))
production$CleanedResponse = gsub("([Tt]omaot|tmatoe|tamato)","tomato",as.character(production$CleanedResponse))
production$CleanedResponse = gsub("[Aa]ppe","apple",as.character(production$CleanedResponse))
production$ItemMentioned = ifelse(grepl("apple|banana|orange|carrot|tomato|pear", production$CleanedResponse, ignore.case = TRUE), T, F)
# distribution of color mention (y axis) and item mention (x axis) in production
# another 15% where color is mentioned but not type -- this seems to be just 3 subject who are being contrarian
prop.table(table(production$ColorMentioned,production$ItemMentioned))

# look at cases where neither color not item was mentioned
# production[!production$ColorMentioned & !production$ItemMentioned,]$response
# look at cases where color was, but item wasn't mentioned
production[production$ColorMentioned & !production$ItemMentioned,c("response")]
# number of color but not item mention looking at item and typicality
table(production[production$ColorMentioned & !production$ItemMentioned,]$target_item,production[production$ColorMentioned & !production$ItemMentioned,]$binaryTypicality)
# subjects that named color but not item
table(production[production$ColorMentioned & !production$ItemMentioned,]$target_item,production[production$ColorMentioned & !production$ItemMentioned,]$workerid)

#exclude cases where locative modifiers were used
#production = droplevels(production[!(!production$ColorMentioned & !production$ItemMentioned),])

# create data set for plot
agr = production %>%
  group_by(condition,binaryTypicality) %>%
  summarise(PropColorMentioned=mean(ColorMentioned),ci.low=ci.low(ColorMentioned),ci.high=ci.high(ColorMentioned))
agr = as.data.frame(agr)
agr$YMin = agr$PropColorMentioned - agr$ci.low
agr$YMax = agr$PropColorMentioned + agr$ci.high

# plot number of color mention against binary typicality for informative and overinformative condition
ggplot(agr, aes(x=binaryTypicality,y=PropColorMentioned,color=condition)) +
  geom_point() +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25)
ggsave("graphs/png/excl_orange_distribution_effect_production.png",height=3.5)
# ggsave("graphs/distribution_effect_production.pdf",height=3.5)

# only color mention
production$OnlyColorMentioned = ifelse(production$ColorMentioned & !production$ItemMentioned,T,F)
agr = production %>%
  group_by(condition,binaryTypicality) %>%
  summarise(PropOnlyColorMentioned=mean(OnlyColorMentioned),ci.low=ci.low(OnlyColorMentioned),ci.high=ci.high(OnlyColorMentioned))
agr = as.data.frame(agr)
agr$YMin = agr$PropOnlyColorMentioned - agr$ci.low
agr$YMax = agr$PropOnlyColorMentioned + agr$ci.high

ggplot(agr, aes(x=binaryTypicality,y=PropOnlyColorMentioned,color=condition)) +
  geom_point() +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25)
ggsave("graphs/png/excl_orange_distribution_colorOnly_production.png",height=3.5)
# ggsave("graphs/distribution_color_production.pdf",height=3.5)


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
ggsave("graphs/png/excl_orange_distribution_effect_production_byitemmention.png",height=3)
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
ggsave("graphs/png/excl_orange_production_byitem.png",height=3)

