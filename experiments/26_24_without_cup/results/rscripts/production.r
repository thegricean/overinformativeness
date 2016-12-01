library(dplyr)
library(ggplot2)
library(bootstrap)
library(lme4)
library(tidyr)

theme_set(theme_bw(18))
setwd("/Users/titlis/cogsci/projects/stanford/projects/overinformativeness/experiments/26_24_without_cup/results")
setwd("/Users/elisakreiss/Documents/stanford/study/overinformativeness/experiments/26_24_without_cup/results")
source("rscripts/helpers.r")

d = read.table(file="data/results.csv",sep="\t", header=T, quote="")
nrow(d)
head(d)
unique(d$listenerMessages)
d[d$listenerMessages != "",c("listenerMessages","speakerMessages")]
summary(d)
d = d[!d$speakerMessages == "",]
head(d)
nrow(d)

# look at turker comments
comments = read.table(file="data/overinf.csv",sep=",", header=T, quote="")

unique(comments$comments)

ggplot(comments, aes(ratePartner)) +
  stat_count()

ggplot(comments, aes(thinksHuman)) +
  stat_count()

ggplot(comments, aes(nativeEnglish)) +
  stat_count()

ggplot(comments, aes(totalLength)) +
  geom_histogram()

# first figure out how often target was chosen -- exclude trials where it wasn't?
table(d$context,d$targetStatusClickedObj)

# exclude NA referential experssions 
d = d[!(is.na(d$refExp)),]

# exclude trials with distractor choices
d = droplevels(d[d$targetStatusClickedObj == "target",])
# exclude participants that were not paid because they didn't finish it
d = droplevels(d[!(d$gameid == "6444-b" | d$gameid == "4924-4"), ])
# exclude tabu players
d = droplevels(d[!(d$gameid == "1544-1" | d$gameid == "4885-8" | d$gameid == "8360-7" | d$gameid == "4624-5" | d$gameid == "5738-a" | d$gameid == "8931-5" | d$gameid == "8116-a" | d$gameid == "6180-c" | d$gameid == "1638-6" | d$gameid == "6836-b"), ])
nrow(d)

# how many unique pairs?
length(levels(d$gameid)) 

table(d$context,d$typeMentioned)
table(d$context,d$colorMentioned)

typ = read.table(file="../../25_object_norming/results/data/meantypicalities.csv",sep=",",header=T)
typ = typ[as.character(typ$Item) == as.character(typ$utterance),]
row.names(typ) = paste(typ$Color,typ$Item)
head(typ)
nrow(typ)


production = d
production$NormedTypicality = typ[paste(production$clickedColor,production$clickedType),]$Typicality
production$binaryTypicality = as.factor(ifelse(production$NormedTypicality > .5, "typical", "atypical"))
#production <- production[,colSums(is.na(production))<nrow(production)]
production$ColorMentioned = ifelse(grepl("green|purple|white|black|brown|purple|violet|yellow|gold|orange|prange|silver|blue|blu|pink|red|purlpe|pruple|puyrple|purplke|yllow|grean|dark|purp|yel|gree|gfeen|bllack|blakc|grey|neon|gray|blck|blu|blac|lavender|ornage|pinkish|re", production$refExp, ignore.case = TRUE), T, F)
production$CleanedResponse = gsub("([bB]ananna|[Bb]annna|[Bb]anna|[Bb]annana|[Bb]anan|[Bb]ananaa|ban|bana|banada|nana|bannan|babanana|B)$","banana",as.character(production$refExp))
production$CleanedResponse = gsub("([Cc]arot|[Cc]arrrot|[Cc]arrott|car|carrpt|carrote)$","carrot",as.character(production$CleanedResponse))
production$CleanedResponse = gsub("([Pp]earr|pea)$","pear",as.character(production$CleanedResponse))
production$CleanedResponse = gsub("([Tt]omaot|tokm|tmatoe|tamato|toato|tom|[Tt]omatoe|tomamt|tomtato|toamoat|mato|totomato|tomatop)$","tomato",as.character(production$CleanedResponse))
production$CleanedResponse = gsub("([Aa]ppe|APPLE|appl|app|apale|aple|ap)$","apple",as.character(production$CleanedResponse))
production$CleanedResponse = gsub("([Pp]eper|pepp|peppre|pep|bell|jalapeno|jalpaeno|eppper)$","pepper",as.character(production$CleanedResponse))
production$CleanedResponse = gsub("([Aa]vacado|avodado|avacdo|[Aa]vacadfo|avo|avacoda|avo|advocado|avavcado|avacodo|guacamole|gaucamole|guacolome|advacado)$","avocado",as.character(production$CleanedResponse))
production$ItemMentioned = ifelse(grepl("apple|banana|carrot|tomato|pear|pepper|avocado", production$CleanedResponse, ignore.case = TRUE), T, F)
production$CatMentioned = ifelse(grepl("fruit|fru7t|veg|veggi|veggie|vegetable", production$CleanedResponse, ignore.case = TRUE), T, F)
production$NegationMentioned = ifelse(grepl("not|isnt|arent|isn't|aren't", production$CleanedResponse, ignore.case = TRUE), T, F)
production$ColorModifierMentioned = ifelse(grepl("normal|abnormal|healthy|dying|natural|regular|funky|rotten", production$CleanedResponse, ignore.case = TRUE), T, F)
production$DescriptionMentioned = ifelse(grepl("like|round|long|rough|grass|doc|bunnies|bunny|same|stem|ground|with|smile|monkey|sphere", production$CleanedResponse, ignore.case = TRUE), T, F)

prop.table(table(production$ColorMentioned,production$ItemMentioned))

production[!production$ColorMentioned & !production$ItemMentioned,c("CleanedResponse","context","gameid")]
production[production$ColorMentioned & !production$ItemMentioned,c("CleanedResponse","context","gameid")]

production$UtteranceType = as.factor(ifelse(production$ItemMentioned & production$ColorMentioned & !production$NegationMentioned & !production$CatMentioned & !production$DescriptionMentioned & !production$ColorModifierMentioned, "color_and_type", ifelse(production$ColorMentioned & !production$CatMentioned & !production$ItemMentioned & !production$NegationMentioned & !production$DescriptionMentioned & !production$ColorModifierMentioned, "color", ifelse(production$ItemMentioned & !production$ColorMentioned & !production$CatMentioned & !production$NegationMentioned & !production$DescriptionMentioned & !production$ColorModifierMentioned, "type", ifelse(!production$ItemMentioned & !production$ColorMentioned & production$CatMentioned & !production$NegationMentioned  & !production$Description & !production$ColorModifierMentioned, "cat", ifelse(!production$ItemMentioned & production$ColorMentioned & production$CatMentioned & !production$NegationMentioned & !production$DescriptionMentioned & !production$ColorModifierMentioned, "color_and_cat",ifelse(production$NegationMentioned, "negation", ifelse(production$DescriptionMentioned, "description", ifelse(production$ColorModifierMentioned, "color_modifier", "OTHER")))))))))

production[production$UtteranceType == "OTHER",c("gameid","refExp","context")]
table(production[production$UtteranceType == "OTHER",]$gameid) 

production$Color = ifelse(production$UtteranceType == "color",1,0)
production$ColorAndType = ifelse(production$UtteranceType == "color_and_type",1,0)
production$Type = ifelse(production$UtteranceType == "type",1,0)
production$ColorAndCat = ifelse(production$UtteranceType == "color_and_cat",1,0)
production$Cat = ifelse(production$UtteranceType == "cat",1,0)
production$Neg = ifelse(production$UtteranceType == "negation",1,0)
production$Description = ifelse(production$UtteranceType == "description",1,0)
production$ColorModifier = ifelse(production$UtteranceType == "color_modifier",1,0)
production$Other = ifelse(production$UtteranceType == "OTHER",1,0)
production$Item = production$clickedType
production$Half = ifelse(production$roundNum < 21,1,2)



# plot histogram of mentioned features by context
agr = production %>%
  select(ColorMentioned,ItemMentioned,context) %>%
  gather(Feature,Mentioned,-context)
agr$Feature = gsub("Mentioned","",as.character(agr$Feature))
agr = droplevels(subset(agr,Mentioned == "TRUE"))
head(agr)

ggplot(agr, aes(x=Feature)) +
  stat_count() +
  facet_wrap(~context)
ggsave("graphs/mentioned_features_by_context.png",width=8,height=3.5)

# plot utterance choice proportions with error bars
agr = production %>%
  select(Color,Type,ColorAndType,ColorAndCat,Cat,Neg,Description,ColorModifier,Other,context) %>%
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
ggsave("graphs/mentioned_features_by_context_other.png",width=10,height=3.5)

# plot utterance choice proportions by typicality
agr = production %>%
  select(Color,Type,ColorAndType,Neg,ColorAndCat,Description,ColorModifier,Other,binaryTypicality,context) %>%
  gather(Utterance,Mentioned,-context,-binaryTypicality) %>%
  group_by(Utterance,context,binaryTypicality) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high

ggplot(agr, aes(x=binaryTypicality,y=Probability,color=Utterance,group=Utterance)) +
  geom_point() +
  geom_line() +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~context)
ggsave("graphs/utterance_by_binarytyp.png",width=10,height=6.5)

# plot utterance choice proportions by typicality
agr = production %>%
  select(Color,Type,ColorAndType,Neg,ColorAndCat,Description,ColorModifier,Other,NormedTypicality,context) %>%
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
ggsave("graphs/utterance_by_conttyp.png",width=12,height=9)


# by subject
agr = production %>%
  group_by(binaryContext,binaryTypicality,gameid) %>%
  summarise(PropColorMentioned=mean(ColorAndType),ci.low=ci.low(ColorAndType),ci.high=ci.high(ColorAndType))
agr = as.data.frame(agr)
agr$YMin = agr$PropColorMentioned - agr$ci.low
agr$YMax = agr$PropColorMentioned + agr$ci.high

ggplot(agr, aes(x=binaryTypicality,y=PropColorMentioned,color=binaryContext)) +
  geom_point() +
  geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~gameid)
ggsave("graphs/distribution_effect_production_bysubject.png",width=20,height=30)


# plot utterance choice proportions by typicality
agr = production %>%
  select(Color,Type,ColorAndType,Neg,ColorAndCat,Description,ColorModifier,Other,binaryTypicality,context,Half) %>%
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
ggsave("graphs/utterance_by_binarytyp_byhalf.png",width=10,height=6.5)


production$Informative = as.factor(ifelse(production$context %in% c("informative","informative-cc"),"informative","overinformative"))
production$CC = as.factor(ifelse(production$context %in% c("informative-cc","overinformative-cc"),"cc","no-cc"))

centered = cbind(production,myCenter(production[,c("NormedTypicality","Informative","CC")]))
m = glmer(ColorMentioned ~ cNormedTypicality + cInformative + cCC + cNormedTypicality : cInformative + cNormedTypicality:cCC + (1|gameid) + (1|Item), data = centered, family="binomial")
summary(m)
ranef(m)

m = glmer(ColorMentioned ~ cNormedTypicality + cInformative  + (1|gameid) , data = centered, family="binomial")
summary(m)
ranef(m)
