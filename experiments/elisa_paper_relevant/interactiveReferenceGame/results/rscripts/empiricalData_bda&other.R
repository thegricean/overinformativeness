library(dplyr)
library(ggplot2)
library(bootstrap)
library(lme4)
library(tidyr)

theme_set(theme_bw(18))
setwd("/Users/elisakreiss/Documents/Stanford/overinformativeness/experiments/elisa_paper_relevant/interactiveReferenceGame/results")
source("rscripts/helpers.r")

d = read.table(file="data/results.csv",sep="\t", header=T, quote="")
d[d$listenerMessages != "",c("listenerMessages","speakerMessages")]
# exclude NA referential expressions 
d = d[!(is.na(d$refExp)),]

# first figure out how often target was chosen
table(d$context,d$targetStatusClickedObj)
# exclude trials with distractor choices
d = droplevels(d[d$targetStatusClickedObj == "target",])
# exclude participants that were not paid because they didn't finish it
d = droplevels(d[!(d$gameid == "6444-b" | d$gameid == "4924-4"), ])
# exclude tabu players
d = droplevels(d[!(d$gameid == "1544-1" | d$gameid == "4885-8" | d$gameid == "8360-7" | d$gameid == "4624-5" | d$gameid == "5738-a" | d$gameid == "8931-5" | d$gameid == "8116-a" | d$gameid == "6180-c" | d$gameid == "1638-6" | d$gameid == "6836-b"), ])

# get meantypicalities from previous study
typ = read.csv(file="/Users/elisakreiss/Documents/Stanford/overinformativeness/experiments/elisa_paper_relevant/norming_comp_object/results/data/meantypicalities.csv")
typ = typ[as.character(typ$Item) == as.character(typ$utterance),]
row.names(typ) = paste(typ$Color,typ$Item)

production = d
# rename pink items to purple
production$clickedColor = ifelse(as.character(production$clickedColor) == 'pink', 'purple', as.character(production$clickedColor))
production$nameClickedObj = ifelse(as.character(production$nameClickedObj) == 'tomato_pink', 'tomato_purple', ifelse(as.character(production$nameClickedObj) == 'carrot_pink', 'carrot_purple', as.character(production$nameClickedObj)))

production$NormedTypicality = typ[paste(production$clickedColor,production$clickedType),]$Typicality
production$binaryTypicality = as.factor(ifelse(production$NormedTypicality > .5, "typical", "atypical"))

# utterance analysis / categorization
# clean responses
production$CleanedResponse = gsub("(^| )([bB]ananna|[Bb]annna|[Bb]anna|[Bb]annana|[Bb]anan|[Bb]ananaa|ban|bana|banada|nana|bannan|babanana|B)($| )"," banana",as.character(production$refExp))
production$CleanedResponse = gsub("(^| )([Cc]arot|[Cc]arrrot|[Cc]arrott|car|carrpt|carrote|carr)($| )"," carrot",as.character(production$CleanedResponse))
production$CleanedResponse = gsub("(^| )([Pp]earr|pea)$"," pear",as.character(production$CleanedResponse))
production$CleanedResponse = gsub("(^| )([Tt]omaot|tokm|tmatoe|tamato|toato|tom|[Tt]omatoe|tomamt|tomtato|toamoat|mato|totomato|tomatop)($| )"," tomato",as.character(production$CleanedResponse))
production$CleanedResponse = gsub("(^| )([Aa]ppe|appple|APPLE|appl|app|apale|aple|ap)($| )"," apple",as.character(production$CleanedResponse))
production$CleanedResponse = gsub("(^| )([Pp]eper|pepp|peppre|pep|bell|jalapeno|jalpaeno|eppper|jalpaeno?)($| )"," pepper",as.character(production$CleanedResponse))
production$CleanedResponse = gsub("(^| )([Aa]vacado|avodado|avacdo|[Aa]vacadfo|avo|avacoda|avo|advocado|avavcado|avacodo|guacamole|gaucamole|guacolome|advacado|avacado,|avacado\\\\)($| )"," avocado",as.character(production$CleanedResponse))
# categorize responses
production$ColorMentioned = ifelse(grepl("green|purple|white|black|brown|purple|violet|yellow|gold|orange|prange|silver|blue|blu|pink|red|purlpe|pruple|puyrple|purplke|yllow|grean|dark|purp|yel|gree|gfeen|bllack|blakc|grey|neon|gray|blck|blu|blac|lavender|ornage|pinkish|^or ", production$refExp, ignore.case = TRUE), T, F)
production$ItemMentioned = ifelse(grepl("apple|banana|carrot|tomato|pear|pepper|avocado|jalpaeno?", production$CleanedResponse, ignore.case = TRUE), T, F)
production$CatMentioned = ifelse(grepl("fruit|fru7t|veg|veggi|veggie|vegetable", production$CleanedResponse, ignore.case = TRUE), T, F)
production$NegationMentioned = ifelse(grepl("not|isnt|arent|isn't|aren't|non", production$CleanedResponse, ignore.case = TRUE), T, F)
production$ColorModifierMentioned = ifelse(grepl("normal|abnormal|healthy|dying|natural|regular|funky|rotten|noraml|norm", production$CleanedResponse, ignore.case = TRUE), T, F)
production$DescriptionMentioned = ifelse(grepl("like|round|sauce|long|rough|grass|doc|bunnies|bunny|same|stem|inside|ground|with|smile|monkey|sphere", production$CleanedResponse, ignore.case = TRUE), T, F)
production$Other = ifelse(production$CatMentioned | production$NegationMentioned | production$ColorModifierMentioned | production$DescriptionMentioned, T, F)

# summarize utterance types
production$UtteranceType = as.factor(
  ifelse(production$ItemMentioned & production$ColorMentioned & !production$Other, "color_and_type", 
         ifelse(production$ColorMentioned & !production$ItemMentioned & !production$Other, "color", 
                ifelse(production$ItemMentioned & !production$ColorMentioned & !production$Other, "type", 
                       "OTHER"))))

production$Color = ifelse(production$UtteranceType == "color",1,0)
production$ColorAndType = ifelse(production$UtteranceType == "color_and_type",1,0)
production$Type = ifelse(production$UtteranceType == "type",1,0)
# production$Other = ifelse(production$UtteranceType == "OTHER",1,0)
production$Item = production$clickedType
production$Half = ifelse(production$roundNum < 21,1,2)

# add "real" distractors
dists = read.csv("data/dist_lexicon.csv")
row.names(dists) = dists$target
production$dDist1 = grepl("distractor_",production$alt1Name)
production$dDist2 = grepl("distractor_",production$alt2Name)
production$Dist1 = as.character(production$alt1Name)
production$Dist2 = as.character(production$alt2Name)
production[production$dDist1,]$Dist1 = as.character(dists[as.character(production[production$dDist1,]$nameClickedObj),]$distractor)
production[production$dDist2,]$Dist2 = as.character(dists[as.character(production[production$dDist2,]$nameClickedObj),]$distractor)

production$Dist1Color = sapply(strsplit(as.character(production$Dist1),"_"), "[", 2)
production$Dist1Type = sapply(strsplit(as.character(production$Dist1),"_"), "[", 1)
production$Dist2Color = sapply(strsplit(as.character(production$Dist2),"_"), "[", 2)
production$Dist2Type = sapply(strsplit(as.character(production$Dist2),"_"), "[", 1)

####
####
####

# create utterances for bda
production$UttforBDA = "other"
production[production$Color == 1,]$UttforBDA = as.character(production[production$Color == 1,]$clickedColor)
production[production$Type == 1,]$UttforBDA = as.character(production[production$Type == 1,]$clickedType)
production[production$ColorAndType == 1,]$UttforBDA = paste(as.character(production[production$ColorAndType == 1,]$clickedColor),as.character(production[production$ColorAndType == 1,]$clickedType),sep="_")

production$Informative = as.factor(ifelse(production$context %in% c("informative","informative-cc"),"informative","overinformative"))
production$CC = as.factor(ifelse(production$context %in% c("informative-cc","overinformative-cc"),"cc","no-cc"))


# plot utterance choice proportions by typicality - find banana
agr = production %>%
  select(Color,Type,ColorAndType,Other,NormedTypicality,context,nameClickedObj) %>%
  gather(Utterance,Mentioned,-context,-NormedTypicality,-nameClickedObj) %>%
  group_by(Utterance,context,NormedTypicality,nameClickedObj) %>%
  summarise(Probability=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)
agr$YMin = agr$Probability - agr$ci.low
agr$YMax = agr$Probability + agr$ci.high
# change order of Utterance column
agr$Utterance <- as.character(agr$Utterance)
agr$Utterance <- factor(agr$Utterance, levels=c("Type", "Color", "ColorAndType", "Other"))
# change context names to have nicer facet labels 
levels(agr$context) = c("informative","informative\nwith color competitor", "overinformative", "overinformative\nwith color competitor")
ggplot(agr, aes(x=NormedTypicality,y=Probability,color=Utterance,label=nameClickedObj)) +
  geom_point(size=.5) +
  geom_smooth(method="lm",size=.6) +
  #geom_errorbar(aes(ymin=YMin,ymax=YMax),width=.25) +
  facet_wrap(~context) +
  scale_color_discrete(name="Utterance",
                       breaks=c("Type", "Color", "ColorAndType", "Other"),
                       labels=c("Only Type", "Only Color", "Color + Type", "Other")) +
  theme(axis.title=element_text(size=14,colour="#757575")) +
  theme(axis.text.x=element_text(size=10,colour="#757575")) +
  theme(axis.text.y=element_text(size=10,colour="#757575")) +
  theme(axis.ticks=element_line(size=.25,colour="#757575"), axis.ticks.length=unit(.75,"mm")) +
  theme(strip.text.x=element_text(size=12,colour="#757575")) +
  theme(legend.title=element_text(size=14,color="#757575")) +
  theme(legend.text=element_text(size=11,colour="#757575")) +
  theme(strip.background=element_rect(colour="#939393",fill="white")) +
  theme(panel.background=element_rect(colour="#939393"))
# get banana values
agr[agr$context=="informative\nwith color competitor" & agr$Utterance=="ColorAndType" & agr$nameClickedObj=="banana_yellow",c("NormedTypicality","Probability")]

# create csv file with results
production$target = paste(production$clickedColor, production$clickedType, sep="_")
production$condition = production$context
agr = production %>%
  select(Color,Type,ColorAndType,Other,NormedTypicality,condition,target) %>%
  gather(uttType,Mentioned,-condition,-NormedTypicality,-target) %>%
  group_by(uttType,condition,NormedTypicality,target) %>%
  summarise(empiricProb=mean(Mentioned),ci.low=ci.low(Mentioned),ci.high=ci.high(Mentioned))
agr = as.data.frame(agr)

levels(agr$condition) = c("informative","informative-cc", "overinformative", "overinformative-cc")
agr$uttType = ifelse(agr$uttType == "Color", "colorOnly", ifelse(agr$uttType == "Type", "typeOnly", ifelse(agr$uttType == "ColorAndType", "colorType","other")))

write.csv(agr,file='rscripts/app/data/empiricalReferenceProbs.csv', row.names = FALSE)

###########
### BDA ###
###########

# write unique conditions for bda
p_no_other = droplevels(production[production$UttforBDA != "other",])
nrow(p_no_other)

p_no_other$DistractorCombo = as.factor(ifelse(as.character(p_no_other$Dist1) < as.character(p_no_other$Dist2), paste(p_no_other$Dist1, p_no_other$Dist2), paste(p_no_other$Dist2, p_no_other$Dist1)))

nrow(unique(p_no_other[,c("nameClickedObj","DistractorCombo")]))
p_no_other$BDADist1 = sapply(strsplit(as.character(p_no_other$DistractorCombo)," "), "[", 1)
p_no_other$BDADist2 = sapply(strsplit(as.character(p_no_other$DistractorCombo)," "), "[", 2)
p_no_other$BDADist1Color = sapply(strsplit(as.character(p_no_other$BDADist1),"_"), "[", 2)
p_no_other$BDADist1Type = sapply(strsplit(as.character(p_no_other$BDADist1),"_"), "[", 1)
p_no_other$BDADist2Color = sapply(strsplit(as.character(p_no_other$BDADist2),"_"), "[", 2)
p_no_other$BDADist2Type = sapply(strsplit(as.character(p_no_other$BDADist2),"_"), "[", 1)


write.table(unique(p_no_other[,c("context","clickedColor","clickedType","BDADist1Color","BDADist1Type","BDADist2Color","BDADist2Type")]),file="/Users/elisakreiss/Documents/Stanford/overinformativeness/models/unified/bdaInput/unique_conditions_typicality_purple.csv",sep=",",col.names=F,row.names=F,quote=F)

# write data for bda
write.table(p_no_other[,c("context","clickedColor","clickedType","BDADist1Color","BDADist1Type","BDADist2Color","BDADist2Type","UttforBDA")],file="/Users/elisakreiss/Documents/Stanford/overinformativeness/models/unified/bdaInput/bda_data_typicality_purple.csv",sep=",",col.names=F,row.names=F,quote=F)

# Analysis
# Exclude all "other" utterances
an = droplevels(production[production$UttforBDA != "other",])
nrow(an)

centered = cbind(an,myCenter(an[,c("NormedTypicality","Informative","CC")]))
# ColorOrType is the same as ColorMentioned
centered$ColorOrType = centered$ColorAndType | centered$Color

# Informative is a negative value, Overinformative is a positive value
# CC is negative, nonCC is positive
m = glmer(ColorOrType ~ cNormedTypicality + cInformative + cCC + cNormedTypicality : cInformative + cNormedTypicality:cCC + (1|gameid) + (1|Item), data = centered, family="binomial")
summary(m)
ranef(m)

m.1 = glmer(ColorOrType ~ cNormedTypicality + cInformative + cCC + (1|gameid) + (1|Item), data = centered, family="binomial")
summary(m.1)
ranef(m.1)

m.2 = glmer(ColorOrType ~ cNormedTypicality + cInformative + cCC + cNormedTypicality : cInformative + (1|gameid) + (1|Item), data = centered, family="binomial")
summary(m.2)
ranef(m.2)

anova(m.1,m)






# Overinf only
an = droplevels(production[production$UttforBDA != "other",])
an = droplevels(an[an$Informative == 'overinformative',])
nrow(an)

centered = cbind(an,myCenter(an[,c("NormedTypicality","Informative","CC")]))
# ColorOrType is the same as ColorMentioned
centered$ColorOrType = centered$ColorAndType | centered$Color

m.1 = glmer(ColorOrType ~ cNormedTypicality + cCC + (1|gameid) + (1|Item), data = centered, family="binomial")
summary(m.1)
ranef(m.1)

# Inf only
an = droplevels(production[production$UttforBDA != "other",])
an = droplevels(an[an$Informative == 'informative',])
nrow(an)

centered = cbind(an,myCenter(an[,c("NormedTypicality","Informative","CC")]))
# ColorOrType is the same as ColorMentioned
centered$ColorOrType = centered$ColorAndType | centered$Color

m.1 = glmer(ColorOrType ~ cNormedTypicality + cCC + (1|gameid) + (1|Item), data = centered, family="binomial")
summary(m.1)
ranef(m.1)




###

# empirical length
library(jsonlite)
new_prod = production[production$UtteranceType=='color_and_type' | production$UtteranceType=='color' | production$UtteranceType=='type',]
new_prod$target = paste(new_prod$clickedColor,new_prod$clickedType,sep="_")
new_prod$utterance = ifelse(new_prod$UtteranceType=='color_and_type',new_prod$target,ifelse(new_prod$UtteranceType=='color',as.character(new_prod$clickedColor),as.character(new_prod$clickedType)))
new_prod$refExp = as.character(new_prod$refExp)
new_prod$empLength = nchar(new_prod$refExp)
blub = new_prod %>%
  select(refExp,empLength,utterance) %>%
  group_by(utterance) %>%
  summarise(length = mean(empLength))
blub = as.data.frame(select(blub,utterance,length))
sink("empLength.json")
myjson = toJSON(blub, pretty = TRUE)
cat(myjson)
sink()
